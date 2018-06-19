module Light exposing (main)

import Html exposing (text, pre)
import Json.Encode
import Mapbox.Expression exposing (..)
import Mapbox.Layer as Layer
import Mapbox.Source as Source
import Mapbox.Style as Style


style =
    Style.encode
        { transition = Style.defaultTransition
        , light = Style.defaultLight
        , sources =
            [ Source.vectorFromUrl "composite" "mapbox://mapbox.mapbox-terrain-v2,mapbox.mapbox-streets-v7" ]
        , misc =
            [ Style.name "light"
            , Style.defaultCenter 20.39789404164037 43.22523201923144
            , Style.defaultZoomLevel 1.5967483759772743
            , Style.sprite "mapbox://sprites/seppotamminen/cjascxlb86kfe2rrvvtkd4ay1"
            , Style.glyphs "mapbox://fonts/seppotamminen/{fontstack}/{range}.pbf"
            ]
        , layers =
            [ Layer.background "background"
                [ getProperty (str "emotion")
                    |> matchesStr (rgba 55 22 32 1) [ ( "funny", rgba 20 200 20 1 ), ( "angry", rgba 200 20 20 1 ) ]
                    |> Layer.backgroundColor
                , zoom
                    |> interpolate Linear
                        [ ( 5, int 1 )
                        , ( 10, int 5 )
                        ]
                    |> Layer.circleRadius
                , makeRGBColor
                    -- red is higher when feature.properties.temperature is higher
                    (getProperty (str "temperature"))
                    -- green is always zero
                    (int 0)
                    -- blue is higher when feature.properties.temperature is lower
                    (getProperty (str "temperature") |> minus (int 100))
                    |> Layer.circleColor
                ]
            ]
        }


main =
    pre [] [ text <| Json.Encode.encode 2 style ]
