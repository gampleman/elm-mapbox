module Styles.Satellite exposing (style)

import Mapbox.Expression as E
import Mapbox.Layer as Layer
import Mapbox.Source as Source
import Mapbox.Style as Style exposing (Style(..))


style : Style
style =
    Style
        { transition = Style.defaultTransition
        , light = Style.defaultLight
        , layers =
            [ Layer.background "background" [ Layer.backgroundColor (E.rgba 4 7 14 1) ]
            , Layer.raster "satellite" "mapbox" [ Layer.sourceLayer "mapbox_satellite_full" ]
            ]
        , sources = [ Source.rasterFromUrl "mapbox" "mapbox://mapbox.satellite" ]
        , misc =
            [ Style.sprite "mapbox://sprites/mapbox/satellite-v9"
            , Style.glyphs "mapbox://fonts/mapbox/{fontstack}/{range}.pbf"
            , Style.name "Satellite"
            ]
        }
