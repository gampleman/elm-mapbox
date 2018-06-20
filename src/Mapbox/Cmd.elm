module Mapbox.Cmd exposing (..)

{-| This module has a bunch of essentially imperative commands for your map.

However, since a published library can't have ports in it, you will need to do some setup. The easiest way to do this is to copy paste the following code into your app:

    import Json.Decode exposing (Value)
    import Mapbox.Cmd as Cmd

    port elmMapboxOutgoing : Value -> Cmd msg

    port elmMapboxIncoming : (Cmd.Response -> msg) -> Sub msg

    mapId =
        {- this is whatever the `id` attribute on your map is -}
        "my-map"

    flyTo =
        Cmd.flyTo elmMapboxOutgoing mapId

-}

import Json.Encode as Encode exposing (Value)
import Mapbox.Element exposing (LngLat, Viewport)


type alias Outgoing msg =
    Value -> Cmd msg


type alias Id =
    String


encodePair encoder ( a, b ) =
    Encode.list [ encoder a, encoder b ]


fitBounds : Outgoing msg -> Id -> ( LngLat, LngLat ) -> Cmd msg
fitBounds prt id bounds =
    prt <|
        Encode.object
            [ ( "command", Encode.string "fitBounds" )
            , ( "target", Encode.string id )
            , ( "bounds", encodePair (encodePair Encode.float) bounds )
            ]



--
--
-- flyTo : Outgoing msg -> Id -> Viewport -> { curve : Float } -> Cmd msg
-- flyTo prt id desiredViewport options =
--     prt <|
--         Encode.object
--             [ ( "command", Encode.string "flyTo" )
--             , ( "target", Encode.string id )
--             ]
