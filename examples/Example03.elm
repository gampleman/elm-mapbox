module Example03 exposing (main)

import Browser
import Html exposing (div, text)
import Html.Attributes exposing (style)
import Html.Lazy exposing (lazy)
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
import Mapbox.Style as Style exposing (Style(..))


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Commands.elmMapboxIncoming MapCenter
        ]


type alias Model =
    { position : LngLat
    , zoom : Float
    , features : List Json.Encode.Value
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( { position = LngLat 0 0, zoom = 13.8, features = [] }, Cmd.none )


type Msg
    = Hover EventData
    | Click EventData
    | MapCenter Json.Encode.Value


update msg model =
    case msg of
        Hover { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }, Cmd.none )

        Click { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }, Commands.fitBounds "my-map" [ Opt.linear True, Opt.maxZoom 10 ] ( LngLat.map (\a -> a - 0.2) lngLat, LngLat.map (\a -> a + 0.2) lngLat ) )

        MapCenter e ->
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


showMap features =
    map
        [ maxZoom 150
        , onMouseMove Hover
        , onClick Click
        , id "my-map"
        , eventFeaturesLayers [ "changes" ]
        , hoveredFeatures features
        ]
        (Style
            { transition = Style.defaultTransition
            , light = Style.defaultLight
            , layers =
                (Map.layers
                    |> Layer.jsonList
                )
                    ++ [ Layer.fill "changes"
                            "changes"
                            [ Layer.fillOpacity (E.ifElse (E.toBool (E.featureState (str "hover"))) (float 0.9) (float 0.1))
                            ]
                       ]
            , sources =
                [ Source.vectorFromUrl "mapbox://mapbox.mapbox-streets-v6" "mapbox://mapbox.mapbox-streets-v6"
                , Source.vectorFromUrl "mapbox://mapbox.mapbox-terrain-v2" "mapbox://mapbox.mapbox-terrain-v2"
                , Source.vectorFromUrl "mapbox://mslee.0fc2f90a" "mapbox://mslee.0fc2f90a"
                , Source.geoJSONFromValue "changes" [] geojson
                ]
            , misc =
                [ Style.sprite "mapbox://sprites/engiadina/ck0dvc9zq0g2v1cmw9xg18pu7/0y2vnk8n60t1vz01wcpm3bpqa"
                , Style.glyphs "mapbox://fonts/engiadina/{fontstack}/{range}.pbf"
                , Style.name "Winter"
                , Style.defaultCenter <| LngLat 20.39789404164037 43.22523201923144
                , Style.defaultZoomLevel 13
                , Style.defaultBearing 0
                , Style.defaultPitch 0
                ]
            }
        )


view model =
    { title = "Mapbox Example"
    , body =
        [ css
        , div [ style "width" "100vw", style "height" "100vh" ]
            [ lazy showMap model.features
            , div [ style "position" "absolute", style "bottom" "20px", style "left" "20px" ] [ text (LngLat.toString model.position) ]
            ]
        ]
    }
