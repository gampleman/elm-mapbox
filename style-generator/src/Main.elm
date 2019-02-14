port module Main exposing (main)

import Browser
import Decoder
import Element exposing (Element, centerY, fill, height, padding, px, rgb255, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes exposing (property, style)
import Html.Events
import Http
import Json.Decode
import Json.Encode exposing (Value)


port requestStyleUpgrade : String -> Cmd msg


port styleUpgradeComplete : (Value -> msg) -> Sub msg


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init () =
    ( { styleUrl = "https://api.mapbox.com/styles/v1/mapbox/outdoors-v9"
      , token = "pk.eyJ1IjoiYXN0cm9zYXQiLCJhIjoiY2o3YWtjNnJzMGR6ajM3b2FidmNwaDNsaSJ9.lwWi7kOiejlT0RbD7RxtmA"
      , style = Nothing
      , error = Nothing
      , code = Nothing
      }
    , Cmd.none
      -- , fetchStyle "https://api.mapbox.com/styles/v1/astrosat/cjl6ljcr80vwg2rmgep7t3dtl" "pk.eyJ1IjoiYXN0cm9zYXQiLCJhIjoiY2o3YWtjNnJzMGR6ajM3b2FidmNwaDNsaSJ9.lwWi7kOiejlT0RbD7RxtmA"
    )


type Msg
    = LoadedStyle (Result Http.Error String)
    | LoadStyle
    | StyleURLChanged String
    | TokenChanged String
    | StyleUpgradeCompleted Value


update msg model =
    case msg of
        LoadedStyle (Ok style) ->
            ( { model | style = Just style }, requestStyleUpgrade style )

        LoadedStyle (Err e) ->
            ( { model | error = Just (errorToString e) }, Cmd.none )

        LoadStyle ->
            ( model, fetchStyle model.styleUrl model.token )

        StyleURLChanged s ->
            ( { model | styleUrl = s }, Cmd.none )

        TokenChanged s ->
            ( { model | token = s }, Cmd.none )

        StyleUpgradeCompleted style ->
            ( { model
                | code =
                    case Json.Decode.decodeValue (Json.Decode.field "type" Json.Decode.string) style of
                        Ok "Ok" ->
                            Json.Decode.decodeValue (Json.Decode.field "result" Decoder.styleCode) style
                                |> Result.mapError Json.Decode.errorToString
                                |> Just

                        Ok "Err" ->
                            Json.Decode.decodeValue (Json.Decode.at [ "error", "message" ] Json.Decode.string) style
                                |> Result.withDefault "Something went wrong"
                                |> Err
                                |> Just

                        _ ->
                            Just (Err "Something went wrong")
              }
            , Cmd.none
            )


subscriptions l =
    styleUpgradeComplete StyleUpgradeCompleted


fetchStyle styleUrl token =
    String.replace "mapbox://styles/" "https://api.mapbox.com/styles/v1/" styleUrl
        ++ "?access_token="
        ++ token
        |> Http.getString
        |> Http.send LoadedStyle



-- UI


pad =
    20


body model =
    Element.layout [ width fill, height fill ] <|
        Element.column [ width fill, height fill, spacing pad ]
            [ Element.row [ width fill, height (px 60), Background.color (rgb255 238 238 238), padding pad, Border.color (rgb255 96 181 204), Border.widthEach { bottom = 2, left = 0, right = 0, top = 0 } ]
                [ Element.el [] <| Element.text "Mapbox to Elm Style Converter"
                , Element.link [ Font.color (rgb255 18 133 207), Element.alignRight ]
                    { url = "https://github.com/gampleman/elm-mapbox/tree/master/style-generator"
                    , label = text "GitHub"
                    }
                ]
            , Element.row [ width fill, height fill ]
                [ form [ height fill, width fill, spacing pad, padding pad ] model
                , results [ height fill, width fill ] model
                ]
            ]


form attrs model =
    Element.column attrs
        [ Element.el [] <| Element.text "Import style from Mapbox"
        , Input.text []
            { onChange = StyleURLChanged
            , placeholder = Nothing
            , label = Input.labelLeft [ centerY, width (px 100) ] <| Element.text "Style URL"
            , text = model.styleUrl
            }
        , Input.text []
            { onChange = TokenChanged
            , placeholder = Nothing
            , label = Input.labelLeft [ centerY, width (px 100) ] <| Element.text "Token"
            , text = model.token
            }
        , Input.button [ Background.color (rgb255 238 238 238), padding pad ] { onPress = Just LoadStyle, label = Element.text "Fetch style" }
        , Element.el [] <| Element.text "Or paste your style here:"
        , codeEditor
            { width = "100%"
            , height = "100%"
            , mode = "json"
            , code = model.style |> Maybe.withDefault ""
            , onChange = Just (Ok >> LoadedStyle)
            }
        ]


codeEditor : { width : String, height : String, mode : String, code : String, onChange : Maybe (String -> msg) } -> Element msg
codeEditor props =
    let
        handler =
            case props.onChange of
                Just tagger ->
                    Html.Events.on "editorChanged" <|
                        Json.Decode.map (Debug.log "change" >> tagger) <|
                            Json.Decode.at [ "detail" ]
                                Json.Decode.string

                Nothing ->
                    property "readonly" (Json.Encode.bool True)
    in
    Element.html <|
        Html.node "code-editor"
            [ props.code
                |> Json.Encode.string
                |> property "editorValue"
            , handler
            , property "mode" (Json.Encode.string "elm")
            , style "width" "50vw"
            , style "height" "100%"
            ]
            []


results attrs model =
    Element.el attrs <|
        case ( model.error, model.code ) of
            ( Just err, _ ) ->
                Element.paragraph [ Font.color (rgb255 207 7 19), padding pad ] [ Element.text err ]

            ( Nothing, Just (Err err) ) ->
                Element.paragraph [ Font.color (rgb255 207 7 19), padding pad ] [ Element.text err ]

            ( Nothing, Just (Ok srcCode) ) ->
                codeEditor
                    { width = "50vw"
                    , height = "100%"
                    , mode = "elm"
                    , code = srcCode
                    , onChange = Nothing
                    }

            ( Nothing, Nothing ) ->
                Element.column [ padding pad, spacing pad ]
                    [ Element.paragraph [] [ Element.text "This is a tool that helps you generate elm-mapbox styles from Mapbox Studio." ]
                    , Element.paragraph [] [ Element.text "In Studio, hit the share button. This will give you the style url and token. This tool will attempt to generate an elm-mapbox style for you. It is not perfect, but should give a nice head-start. Try to compile the file and see if you get any errors." ]
                    , Element.paragraph []
                        [ text "There are a few common limitations that are relatively easy to fix with some grepping. For example, "
                        , code "Layer.lineJoin E.lineCapRound"
                        , text " should be replaced by "
                        , code "Layer.lineJoin E.lineJoinRound"
                        , text ". Also "
                        , code "Layer.textField"
                        , text " is often followed by "
                        , code "E.toString"
                        , text ", but should instead be followed by "
                        , code "E.toFormattedText"
                        , text "."
                        ]
                    ]


code : String -> Element msg
code =
    Element.el [ Font.family [ Font.monospace ] ] << Element.text


errorToString : Http.Error -> String
errorToString err =
    case err of
        Http.BadUrl stringString ->
            "Invalid URL. Check the inputs to make sure that it is a valid https url or starts with mapbox://styles/"

        Http.Timeout ->
            "Request timed out. Try again later."

        Http.NetworkError ->
            "Network error. Are you online?"

        Http.BadStatus response ->
            case response.status.code of
                401 ->
                    "An authentication error occurred. Check your key and try again."

                404 ->
                    "Couldn't find that style"

                _ ->
                    response.status.message

        Http.BadPayload m _ ->
            m


view model =
    { title = "Style Generator"
    , body =
        [ body model ]
    }
