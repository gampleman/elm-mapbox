module Example02 exposing (main)

import Browser
import Html exposing (div)
import Html.Attributes
import Mapbox.Element exposing (..)
import Styles.SatelliteStreets exposing (style)


main =
    div [ Html.Attributes.style "height" "100vh" ]
        [ map [] style ]
