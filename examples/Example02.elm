module Example02 exposing (main)

import Browser
import Html exposing (div)
import Html.Attributes exposing (style)
import Mapbox.Element exposing (..)
import Outdoors


main =
    div [ style "height" "100vh" ]
        [ map [] Outdoors.style ]
