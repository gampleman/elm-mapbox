module Main exposing (main)

import Browser
import Decoder
import Html exposing (div, input, label, p, pre, text)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init () =
    ( { styleUrl = ""
      , token = ""
      , style = Nothing
      , error = Nothing
      }
    , Cmd.none
    )


type Msg
    = LoadedStyle (Result Http.Error String)
    | LoadStyle
    | StyleURLChanged String
    | TokenChanged String


update msg model =
    case msg of
        LoadedStyle (Ok style) ->
            ( { model | style = Just style }, Cmd.none )

        LoadedStyle (Err e) ->
            ( { model | error = Just (errorToString e) }, Cmd.none )

        LoadStyle ->
            ( model, fetchStyle model.styleUrl model.token )

        StyleURLChanged s ->
            ( { model | styleUrl = s }, Cmd.none )

        TokenChanged s ->
            ( { model | token = s }, Cmd.none )


subscriptions model =
    Sub.none


fetchStyle styleUrl token =
    String.replace "mapbox://styles/" "https://api.mapbox.com/styles/v1/" styleUrl
        ++ "?access_token="
        ++ token
        |> Http.getString
        |> Http.send LoadedStyle


form model =
    div []
        [ div []
            [ label [] [ text "Style URL:" ]
            , input [ type_ "text", value model.styleUrl, onInput StyleURLChanged ] []
            ]
        , div []
            [ label [] [ text "Token:" ]
            , input [ type_ "text", value model.token, onInput TokenChanged ] []
            ]
        , div [] [ input [ type_ "submit", value "Fetch", onClick LoadStyle ] [] ]
        ]


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


resultToString r =
    case r of
        Ok s ->
            s

        Err s ->
            s


view model =
    { title = "Style Generator"
    , body =
        [ form model
        , case ( model.error, model.style ) of
            ( Just err, _ ) ->
                p [ style "color" "red" ] [ text err ]

            ( Nothing, Just styl ) ->
                pre
                    []
                    [ Json.Decode.decodeString Decoder.styleCode styl
                        |> Result.mapError Json.Decode.errorToString
                        |> resultToString
                        |> text
                    ]

            ( Nothing, Nothing ) ->
                p [] [ text "This is a tool that helps you generate elm-mapbox styles from Mapbox Studio. In Studio, hit the share button. This will give you the above two pieces of information. Then hit fetch. This tool will attempt to generate an elm-mapbox style for you. It is not perfect, but should give a nice head-start. Run the output through elm-format, than fix any compiler warnings. Then fix any Debug.todo calls." ]
        ]
    }
