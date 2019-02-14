module Decoder.Generic exposing (combine, pair, resultToDecoder, subdecode, tail, withDefault)

import Json.Decode as D exposing (Decoder)


withDefault : a -> Decoder a -> Decoder a
withDefault fallback decoder =
    D.oneOf
        [ decoder
        , D.succeed fallback
        ]


combine : List (Decoder a) -> Decoder (List a)
combine =
    List.foldr (D.map2 (::)) (D.succeed [])


subdecode : Decoder a -> D.Value -> Decoder a
subdecode d v =
    D.decodeValue d v |> resultToDecoder


tail : Decoder a -> Decoder (List a)
tail itemDecoder =
    D.list D.value
        |> D.andThen
            (\l ->
                case l of
                    [] ->
                        D.fail "Can't get tail of empty"

                    head :: t ->
                        List.map (subdecode itemDecoder) t |> combine
            )


pair : Decoder a -> Decoder b -> Decoder ( a, b )
pair aDecoder bDecoder =
    D.map2 Tuple.pair
        (D.index 0 aDecoder)
        (D.index 1 bDecoder)


resultToDecoder : Result D.Error a -> Decoder a
resultToDecoder res =
    case res of
        Ok a ->
            D.succeed a

        Err e ->
            D.fail (D.errorToString e)
