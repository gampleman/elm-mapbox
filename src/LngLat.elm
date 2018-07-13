module LngLat exposing (LngLat, encodeAsPair, encodeAsObject, decodeFromPair, decodeFromObject, map)

{-| Encodes geographic position.

@docs LngLat, encodeAsPair, encodeAsObject, decodeFromPair, decodeFromObject, map

-}

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder)


{-| A LngLat represents a geographic position.
-}
type alias LngLat =
    { lng : Float
    , lat : Float
    }


{-| Most implementations seem to encode these as a 2 member array.
-}
encodeAsPair : LngLat -> Value
encodeAsPair { lng, lat } =
    Encode.list [ Encode.float lng, Encode.float lat ]


{-| Most implementations seem to encode these as a 2 member array.
-}
decodeFromPair : Decoder LngLat
decodeFromPair =
    Decode.list Decode.float
        |> Decode.andThen
            (\l ->
                case l of
                    [ lng, lat ] ->
                        Decode.succeed (LngLat lng lat)

                    _ ->
                        Decode.fail "Doesn't apear to be a valid lng lat pair"
            )


{-| We can also encode as an `{lng: 32, lat: 435}` object.
-}
encodeAsObject : LngLat -> Value
encodeAsObject { lng, lat } =
    Encode.object [ ( "lng", Encode.float lng ), ( "lat", Encode.float lat ) ]


{-| We can also encode from an `{lng: 32, lat: 435}` object.
-}
decodeFromObject : Decoder LngLat
decodeFromObject =
    Decode.map2 LngLat (Decode.field "lng" Decode.float) (Decode.field "lat" Decode.float)


{-| -}
map : (Float -> Float) -> LngLat -> LngLat
map f { lng, lat } =
    { lng = f lng, lat = f lat }
