module Decoder.Legacy exposing (filter)

import Decoder.Expression exposing (decodeBool)
import Decoder.Generic as Decode
import Decoder.Helpers exposing (todo)
import Json.Decode as D exposing (Decoder)
import Lib
import MyElm.Syntax exposing (Expression, calln, float, int, list, pair, string)


filter =
    let
        decodeProp =
            D.index 1 D.string
                |> D.map
                    (\prop ->
                        case prop of
                            "$type" ->
                                Lib.eValue "geometryType"

                            "$id" ->
                                Lib.eValue "id"

                            _ ->
                                calln (Lib.eName "getProperty") [ Lib.str (string prop) ]
                    )

        decodeVal =
            D.index 2 <|
                D.oneOf
                    [ D.map (string >> Lib.str) D.string
                    , D.map (float >> Lib.float) D.float
                    , decodeBool
                    ]

        decodeVals =
            D.list <|
                D.oneOf
                    [ D.map (string >> Lib.str) D.string
                    , D.map (float >> Lib.float) D.float
                    , decodeBool
                    ]

        operator name =
            D.map2 (\prop val -> Lib.pipelineCall name [ prop, val ]) decodeProp decodeVal
    in
    D.index 0 D.string
        |> D.andThen
            (\filt ->
                case filt of
                    "all" ->
                        Decode.tail filter |> D.map (\filters -> calln (Lib.eName "all") [ list filters ])

                    "any" ->
                        Decode.tail filter |> D.map (\filters -> calln (Lib.eName "any") [ list filters ])

                    "none" ->
                        Decode.tail filter |> D.map (\filters -> calln (Lib.eName "all") [ list (List.map (\f -> calln (Lib.eName "not") [ f ]) filters) ])

                    "has" ->
                        D.index 1 D.string |> D.map (\prop -> calln (Lib.eName "hasProperty") [ Lib.str (string prop) ])

                    "!has" ->
                        D.index 1 D.string |> D.map (\prop -> calln (Lib.eName "not") [ calln (Lib.eName "hasProperty") [ Lib.str (string prop) ] ])

                    "==" ->
                        operator "isEqual"

                    "!=" ->
                        operator "notEqual"

                    ">" ->
                        D.map (Debug.log ">") <| operator "greaterThan"

                    ">=" ->
                        operator "greaterThanOrEqual"

                    "<" ->
                        operator "lessThan"

                    "<=" ->
                        operator "lessThanOrEqual"

                    "in" ->
                        D.map2
                            (\prop values ->
                                List.drop 2 values
                                    |> List.map (\v -> Lib.pipelineCall "isEqual" [ prop, v ])
                                    |> list
                                    |> List.singleton
                                    |> calln (Lib.eName "any")
                            )
                            decodeProp
                            decodeVals

                    "!in" ->
                        D.map2
                            (\prop values ->
                                List.drop 2 values
                                    |> List.map (\v -> Lib.pipelineCall "notEqual" [ prop, v ])
                                    |> list
                                    |> List.singleton
                                    |> calln (Lib.eName "all")
                            )
                            decodeProp
                            decodeVals

                    _ ->
                        D.fail <| Debug.log "failed " "not actually a legacy filter"
            )
