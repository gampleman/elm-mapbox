module Mapbox.Helpers exposing (..)

import Json.Encode as Encode exposing (Value)
import Mapbox.Expression exposing (Anchor(..))


encodeAnchor : Anchor -> Value
encodeAnchor v =
    case v of
        Viewport ->
            Encode.string "viewport"

        Map ->
            Encode.string "map"


encodePair encoder ( a, b ) =
    Encode.list encoder [ a, b ]
