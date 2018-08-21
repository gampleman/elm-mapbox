module LngLat exposing (LngLat, decodeFromObject, decodeFromPair, encodeAsObject, encodeAsPair, map, toString)

{-| Encodes geographic position.

@docs LngLat, encodeAsPair, encodeAsObject, decodeFromPair, decodeFromObject, map, toString

-}

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)


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
    Encode.list Encode.float [ lng, lat ]


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


toDMS : Float -> String -> String -> String
toDMS angle pos neg =
    let
        absAngle =
            abs angle

        degrees =
            truncate absAngle

        minutes =
            (absAngle - toFloat degrees) * 60

        seconds =
            (minutes - toFloat (truncate minutes)) * 60 |> round

        prefix =
            if angle > 0 then
                pos
            else
                neg
    in
    String.fromInt degrees ++ "° " ++ String.fromInt (truncate minutes) ++ "' " ++ String.fromInt seconds ++ "\"" ++ prefix


{-| Returns a text representation suitable for humans.
-}
toString : LngLat -> String
toString { lng, lat } =
    toDMS lat "N" "S" ++ " " ++ toDMS lng "E" "W"
