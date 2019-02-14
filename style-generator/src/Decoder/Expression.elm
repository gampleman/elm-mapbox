module Decoder.Expression exposing (decodeBool, expression)

import Color
import Decoder.Generic as Decode
import Decoder.Helpers exposing (todo)
import Json.Decode as D exposing (Decoder)
import Lib
import MyElm.Syntax exposing (Expression, call1, calln, float, int, list, pair, string)
import String.Case exposing (toCamelCaseLower)


expression =
    D.oneOf
        [ D.string |> D.map makeConstant
        , decodeBool
        , D.float |> D.map (float >> Lib.float)
        , D.int |> D.map (int >> Lib.int)
        , D.index 0 D.string |> D.andThen decodeExpression
        , D.index 0 D.int |> D.andThen (always (D.map (List.map int >> list >> Lib.floats) (D.list D.int)))
        , D.index 0 D.float |> D.andThen (always (D.map (List.map float >> list >> Lib.floats) (D.list D.float)))
        , todo
        ]


decodeLiteral =
    D.oneOf
        [ D.string |> D.map makeConstant
        , decodeBool
        , D.float |> D.map (float >> Lib.float)
        , D.int |> D.map (int >> Lib.int)
        , todo
        ]


makeConstant s =
    case s of
        "map" ->
            Lib.eValue "anchorMap"

        "viewport" ->
            Lib.eValue "anchorViewport"

        "auto" ->
            Lib.eValue "anchorAuto"

        "center" ->
            Lib.eValue "positionCenter"

        "left" ->
            Lib.eValue "positionLeft"

        "right" ->
            Lib.eValue "positionRight"

        "top" ->
            Lib.eValue "positionTop"

        "bottom" ->
            Lib.eValue "positionBottom"

        "topRight" ->
            Lib.eValue "positionTopRight"

        "topLeft" ->
            Lib.eValue "positionTopLeft"

        "bottomLeft" ->
            Lib.eValue "positionBottomLeft"

        "bottomRight" ->
            Lib.eValue "positionBottomRight"

        "none" ->
            Lib.eValue "textFitNone"

        "width" ->
            Lib.eValue "textFitWidth"

        "height" ->
            Lib.eValue "textFitHeight"

        "both" ->
            Lib.eValue "textFitBoth"

        "butt" ->
            Lib.eValue "lineCapButt"

        "round" ->
            Lib.eValue "lineCapRound"

        "square" ->
            Lib.eValue "lineCapSquare"

        "bevel" ->
            Lib.eValue "lineJoinBevel"

        "miter" ->
            Lib.eValue "lineJoinMiter"

        "point" ->
            Lib.eValue "symbolPlacementPoint"

        "line-center" ->
            Lib.eValue "symbolPlacementLineCenter"

        "line" ->
            Lib.eValue "symbolPlacementLine"

        "uppercase" ->
            Lib.eValue "textTransformUppercase"

        "lowercase" ->
            Lib.eValue "textTransformLowercase"

        "linear" ->
            Lib.eValue "rasterResamplingLinear"

        "nearest" ->
            Lib.eValue "rasterResamplingNearest"

        _ ->
            case Color.parse s of
                Ok { r, g, b, a } ->
                    calln (Lib.eName "rgba") [ int r, int g, int b, float a ]

                Err err ->
                    string s |> Lib.str


decodeExpression funName =
    case funName of
        "literal" ->
            D.index 1
                (D.oneOf
                    [ D.list D.string |> D.map (\strs -> calln (Lib.eName "strings") [ list (List.map string strs) ])
                    , D.list D.float |> D.map (\floats -> calln (Lib.eName "floats") [ list (List.map float floats) ])
                    ]
                )

        "match" ->
            D.oneOf
                [ D.index 2 D.string |> D.andThen (decodeMatch True)
                , D.index 2 D.float |> D.andThen (decodeMatch False)
                , D.index 2 (D.list D.string) |> D.andThen (decodeMatch True)
                , D.index 2 (D.list D.float) |> D.andThen (decodeMatch False)
                ]

        "exponential" ->
            D.map (\base -> calln (Lib.eName "Exponential") [ float base ]) (D.index 1 D.float)

        "interpolate" ->
            D.map3
                (\interpolation options input ->
                    Lib.pipelineCall "interpolate" (input :: interpolation :: options)
                )
                (D.index 1 expression)
                (Decode.tail D.value |> D.map (List.drop 2) |> D.andThen (organizeArgs (D.map float D.float) []))
                (D.index 2 expression)

        "step" ->
            D.map3
                (\inp def stps ->
                    Lib.pipelineCall "step" (inp :: def :: stps)
                )
                (D.index 1 expression)
                (D.index 2 expression)
                (Decode.tail D.value |> D.map (List.drop 2) |> D.andThen (organizeArgs (D.map float D.float) []))

        "case" ->
            D.map (calln (Lib.eName "conditionally"))
                (Decode.tail D.value |> D.andThen (organizeArgs expression []))

        _ ->
            let
                fallback =
                    Decode.tail expression
                        |> D.map
                            (\arguments ->
                                case funName of
                                    "==" ->
                                        Lib.pipelineCall "isEqual" arguments

                                    "!=" ->
                                        Lib.pipelineCall "notEqual" arguments

                                    "!has" ->
                                        Lib.todo "!has is not supported"

                                    "!in" ->
                                        Lib.todo "!in is not supported"

                                    "in" ->
                                        Lib.todo "in is not supported"

                                    ">=" ->
                                        Lib.pipelineCall "greaterThanOrEqual" arguments

                                    ">" ->
                                        Lib.pipelineCall "greaterThan" arguments

                                    "<=" ->
                                        Lib.pipelineCall "lessThanOrEqual" arguments

                                    "<" ->
                                        Lib.pipelineCall "lessThan" arguments

                                    "concat" ->
                                        Lib.pipelineMultiCall "append" arguments

                                    "linear" ->
                                        calln (Lib.eName "Linear") arguments

                                    "rgb" ->
                                        calln (Lib.eName "makeRGBColor") arguments

                                    "rgba" ->
                                        calln (Lib.eName "makeRGBAColor") arguments

                                    "to-rgba" ->
                                        calln (Lib.eName "rgbaChannels") arguments

                                    "-" ->
                                        Lib.pipelineMultiCall "minus" arguments

                                    "*" ->
                                        Lib.pipelineMultiCall "multiply" arguments

                                    "+" ->
                                        Lib.pipelineMultiCall "plus" arguments

                                    "/" ->
                                        Lib.pipelineMultiCall "divideBy" arguments

                                    "%" ->
                                        Lib.pipelineMultiCall "modBy" arguments

                                    "^" ->
                                        Lib.pipelineMultiCall "raiseBy" arguments

                                    "get" ->
                                        if List.length arguments == 1 then
                                            calln (Lib.eName "getProperty") arguments

                                        else
                                            calln (Lib.eName "get") arguments

                                    "all" ->
                                        call1 (Lib.eName "all") (MyElm.Syntax.list arguments)

                                    "any" ->
                                        call1 (Lib.eName "any") (MyElm.Syntax.list arguments)

                                    _ ->
                                        calln (Lib.eName (toCamelCaseLower funName)) arguments
                            )
            in
            if String.toLower funName /= funName then
                D.oneOf
                    [ D.map (\strs -> calln (Lib.eName "strings") [ list (List.map string strs) ]) <| D.list D.string
                    , fallback
                    ]

            else
                fallback


decodeBool =
    D.bool
        |> D.map
            (\b ->
                if b then
                    Lib.true

                else
                    Lib.false
            )


decodeMatch : Bool -> any -> Decoder Expression
decodeMatch isString _ =
    Decode.tail D.value
        |> D.andThen
            (\args ->
                case args of
                    [] ->
                        todo

                    head :: tail ->
                        D.map2
                            (\cond rest ->
                                Lib.pipelineCall
                                    (if isString then
                                        "matchesStr"

                                     else
                                        "matchesFloat"
                                    )
                                    (cond :: rest)
                            )
                            (Decode.subdecode expression head)
                            (organizeArgs
                                (if isString then
                                    D.map string D.string

                                 else
                                    D.map float D.float
                                )
                                []
                                (normalizeArgs tail)
                            )
            )


normalizeArgs args =
    case args of
        a :: b :: rest ->
            case D.decodeValue (D.list D.value) a of
                Err _ ->
                    a :: b :: rest

                Ok xs ->
                    List.concatMap (\x -> [ x, b ]) xs ++ normalizeArgs rest

        _ ->
            args


organizeArgs inpDec accu args =
    case args of
        [] ->
            Decode.combine [ D.map list (List.reverse accu |> Decode.combine) ]

        [ default ] ->
            Decode.combine [ D.map list (List.reverse accu |> Decode.combine), Decode.subdecode expression default ]

        a :: b :: rest ->
            let
                newAccu =
                    D.map2
                        pair
                        (Decode.subdecode inpDec a)
                        (Decode.subdecode expression b)
                        :: accu
            in
            organizeArgs inpDec newAccu rest
