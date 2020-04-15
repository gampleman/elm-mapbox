port module Example04 exposing (main)

import Browser
import Html exposing (div, text)
import Html.Attributes exposing (style)
import Html.Lazy exposing (lazy2)
import Http
import Json.Decode
import Json.Encode
import LngLat exposing (LngLat)
import Map
import MapCommands
import Mapbox.Cmd.Option as Opt
import Mapbox.Element exposing (..)
import Mapbox.Expression as E exposing (false, float, int, str, true)
import Mapbox.Layer as Layer
import Mapbox.Source as Source
import Mapbox.Style as Style exposing (Style(..), StyleDef)


port elmMapboxIncoming : (Json.Encode.Value -> msg) -> Sub msg


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    elmMapboxIncoming MapCenter


type alias Model =
    { position : LngLat
    , zoom : Float
    , features : List Json.Encode.Value
    , jsonMap : Maybe StyleDef
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( { position = LngLat 0 0
      , zoom = 13.8
      , features = []
      , jsonMap = Nothing
      }
    , fetchStyle "mapbox://styles/yourstile/ck0dvc9zq0g2v1cmw9xg18pu7" "pk.eyJ1Ijoi..."
    )


type Msg
    = Hover EventData
    | Click EventData
    | MapCenter Json.Encode.Value
    | LoadedStyle (Result Http.Error String)


fetchStyle styleUrl token =
    String.replace "mapbox://styles/" "https://api.mapbox.com/styles/v1/" styleUrl
        ++ "?access_token="
        ++ token
        |> Http.getString
        |> Http.send LoadedStyle


update msg model =
    case msg of
        Hover { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }, Cmd.none )

        Click { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }, MapCommands.fitBounds [ Opt.linear True, Opt.maxZoom 10 ] ( LngLat.map (\a -> a - 0.2) lngLat, LngLat.map (\a -> a + 0.2) lngLat ) )

        MapCenter e ->
            ( model, Cmd.none )

        LoadedStyle (Ok style) ->
            ( { model
                | jsonMap =
                    case
                        ( Json.Decode.decodeString Style.decode style
                        , Json.Decode.decodeString Style.decodeMiscDef style
                        )
                    of
                        ( Ok mapbox, Ok misc ) ->
                            Just { mapbox | misc = Style.miscDefToList misc }

                        _ ->
                            Nothing
              }
            , Cmd.none
            )

        LoadedStyle (Err e) ->
            ( model, Cmd.none )


geojson : Json.Encode.Value
geojson =
    Json.Decode.decodeString Json.Decode.value """
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "id": 1,
      "properties": {
        "name": "Bermuda Triangle",
        "area": 1150180
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [-64.73, 32.31],
            [-80.19, 25.76],
            [-66.09, 18.43],
            [-64.73, 32.31]
          ]
        ]
      }
    }
  ]
}
""" |> Result.withDefault (Json.Encode.object [])


hoveredFeatures : List Json.Encode.Value -> MapboxAttr msg
hoveredFeatures =
    List.map (\feat -> ( feat, [ ( "hover", Json.Encode.bool True ) ] ))
        >> featureState


showMap mapbox features =
    case mapbox of
        Just style ->
            map
                [ maxZoom 150
                , onMouseMove Hover
                , onClick Click
                , id "my-map"
                , eventFeaturesLayers [ "changes" ]
                , hoveredFeatures features
                ]
                (Style
                    { style
                        | layers =
                            style.layers
                                ++ [ Layer.fill "changes"
                                        "changes"
                                        [ Layer.fillOpacity (E.ifElse (E.toBool (E.featureState (str "hover"))) (float 0.9) (float 0.1))
                                        ]
                                   ]
                        , sources =
                            style.sources
                                ++ [ Source.geoJSONFromValue "changes" [] geojson
                                   ]
                    }
                )

        Nothing ->
            Html.text "Nothing"


view model =
    { title = "Mapbox Example"
    , body =
        [ css
        , div [ style "width" "100vw", style "height" "100vh" ]
            [ lazy2 showMap model.jsonMap model.features
            , div [ style "position" "absolute", style "bottom" "20px", style "left" "20px" ] [ text (LngLat.toString model.position) ]
            ]
        ]
    }
