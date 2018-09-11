module Decoder exposing (styleCode)

import Color
import Elm.Syntax.Declaration exposing (Declaration(..))
import Elm.Syntax.Exposing exposing (Exposing(..), TopLevelExpose(..))
import Elm.Syntax.Expression exposing (Expression(..), RecordSetter)
import Elm.Syntax.Infix exposing (InfixDirection(..))
import Elm.Syntax.Module exposing (Module(..))
import Elm.Syntax.Node exposing (Node(..))
import Elm.Syntax.Pattern
import Elm.Syntax.Range exposing (emptyRange)
import Elm.Syntax.TypeAnnotation exposing (TypeAnnotation(..))
import Json.Decode as D exposing (Decoder)
import Json.Encode
import String.Case exposing (toCamelCaseLower)
import Writer


node =
    Node emptyRange


wrapNodes =
    List.map node


styleCode : Decoder String
styleCode =
    D.map (file >> Writer.writeFile >> Writer.write) style


declarations styleDec =
    [ FunctionDeclaration
        { documentation = Nothing
        , signature =
            Just
                (node
                    { name = node "style"
                    , typeAnnotation = node (Typed (node ( [], "Style" )) [])
                    }
                )
        , declaration =
            node
                { name = node "style"
                , arguments = []
                , expression =
                    node <|
                        Application <|
                            wrapNodes
                                [ FunctionOrValue [] "Style"
                                , RecordExpr styleDec
                                ]
                }
        }
    ]


file styleDec =
    { moduleDefinition =
        node
            (NormalModule
                { moduleName = node [ "Style" ]
                , exposingList = node (Explicit [ node (FunctionExpose "style") ])
                }
            )
    , imports =
        [ node
            { moduleName = node [ "Mapbox", "Style" ]
            , moduleAlias = Just (node [ "Style" ])
            , exposingList = Just (Explicit [ node (TypeExpose { name = "Style", open = Just emptyRange }) ])
            }
        , node
            { moduleName = node [ "Mapbox", "Source" ]
            , moduleAlias = Just (node [ "Source" ])
            , exposingList = Nothing
            }
        , node
            { moduleName = node [ "Mapbox", "Layer" ]
            , moduleAlias = Just (node [ "Layer" ])
            , exposingList = Nothing
            }
        , node
            { moduleName = node [ "Mapbox", "Expression" ]
            , moduleAlias = Just (node [ "E" ])
            , exposingList = Just (Explicit [ node (FunctionExpose "str"), node (FunctionExpose "float"), node (FunctionExpose "int"), node (FunctionExpose "true"), node (FunctionExpose "false") ])
            }
        ]
    , declarations = List.map node (declarations styleDec)
    , comments = []
    }


style : Decoder (List (Node RecordSetter))
style =
    D.map5
        (\transition light layers sources misc ->
            [ node ( node "transition", transition )
            , node ( node "light", light )
            , node ( node "layers", layers )
            , node ( node "sources", sources )
            , node ( node "misc", misc )
            ]
        )
        (D.oneOf
            [ D.field "transition" decodeTransition
            , valueDecoder "Style" "defaultTransition"
            ]
        )
        (D.oneOf
            [ D.field "light" decodeLight
            , valueDecoder "Style" "defaultLight"
            ]
        )
        (D.field "layers" decodeLayers)
        (D.field "sources" decodeSources)
        decodeMisc


decodeTransition : Decoder (Node Expression)
decodeTransition =
    D.map2
        (\duration delay ->
            node
                (RecordExpr
                    [ node ( node "duration", node (Integer duration) )
                    , node ( node "delay", node (Integer delay) )
                    ]
                )
        )
        (D.oneOf [ D.field "duration" D.int, D.succeed 300 ])
        (D.oneOf [ D.field "delay" D.int, D.succeed 0 ])


decodeLight : Decoder (Node Expression)
decodeLight =
    valueDecoder "Style" "defaultLight"


addBogusRange index (Node _ v) =
    Node { start = { row = index, column = 0 }, end = { row = index + 1, column = 0 } } v


decodeLayers : Decoder (Node Expression)
decodeLayers =
    D.list decodeLayer
        |> D.map (\layers -> node (ListExpr (List.indexedMap addBogusRange layers)))


layerDecodeHelp t =
    D.map3 (\id source attrs -> call "Layer" t [ str id, str source, list attrs ]) (D.field "id" D.string) (D.field "source" D.string) decodeAttrs


decodeLayer : Decoder (Node Expression)
decodeLayer =
    D.field "type" D.string
        |> D.andThen
            (\t ->
                case t of
                    "background" ->
                        D.map2 (\id attrs -> call "Layer" "background" [ str id, list attrs ]) (D.field "id" D.string) decodeAttrs

                    "fill" ->
                        layerDecodeHelp "fill"

                    "symbol" ->
                        layerDecodeHelp "symbol"

                    "line" ->
                        layerDecodeHelp "line"

                    "raster" ->
                        layerDecodeHelp "raster"

                    "circle" ->
                        layerDecodeHelp "circle"

                    "fill-extrusion" ->
                        layerDecodeHelp "fillExtrusion"

                    "heatmap" ->
                        layerDecodeHelp "heatmap"

                    "hillshade" ->
                        layerDecodeHelp "hillshade"

                    other ->
                        D.fail ("Layer type " ++ t ++ " not supported")
            )


decodeAttrs : Decoder (List (Node Expression))
decodeAttrs =
    D.map3 (\top paint layout -> top ++ paint ++ layout) (D.keyValuePairs D.value) (D.field "paint" (D.keyValuePairs D.value)) (D.field "layout" (D.keyValuePairs D.value))
        |> D.andThen
            (List.filterMap
                (\( attrName, attrValue ) ->
                    case attrName of
                        "id" ->
                            Nothing

                        "type" ->
                            Nothing

                        "source" ->
                            Nothing

                        "paint" ->
                            Nothing

                        "layout" ->
                            Nothing

                        "source-layer" ->
                            decodeAttr "sourceLayer" (D.map str D.string) attrValue

                        "minzoom" ->
                            decodeAttr "minzoom" (D.map float D.float) attrValue

                        "maxzoom" ->
                            decodeAttr "maxzoom" (D.map float D.float) attrValue

                        "filter" ->
                            decodeAttr "filter" (D.oneOf [ decodeLegacyFilter, decodeValue ]) attrValue

                        other ->
                            decodeAttr (toCamelCaseLower attrName) decodeValue attrValue
                )
                >> combine
            )
        |> D.map (List.indexedMap addBogusRange)


decodeAttr : String -> Decoder (Node Expression) -> D.Value -> Maybe (Decoder (Node Expression))
decodeAttr attrName expressionNodeDecoder attrValue =
    Just
        (D.decodeValue expressionNodeDecoder attrValue
            |> resultToDecoder
            |> D.map (\v -> call "Layer" (toCamelCaseLower attrName) [ v ])
        )


resultToDecoder : Result D.Error a -> Decoder a
resultToDecoder res =
    case res of
        Ok a ->
            D.succeed a

        Err e ->
            D.fail (D.errorToString e)


decodeBool : Decoder (Node Expression)
decodeBool =
    D.bool
        |> D.map
            (\b ->
                if b then
                    evalue "true"
                else
                    evalue "false"
            )


decodeValue : Decoder (Node Expression)
decodeValue =
    D.oneOf
        [ D.string |> D.map makeConstant
        , decodeBool
        , D.float |> D.map (Floatable >> node >> ecall "float")
        , D.int |> D.map (Integer >> node >> ecall "int")
        , D.index 0 D.string |> D.andThen decodeExpression
        , todo
        ]
        |> D.map (ParenthesizedExpression >> node)


makeConstant s =
    case s of
        "map" ->
            value "E" "anchorMap"

        "viewport" ->
            value "E" "anchorViewport"

        "auto" ->
            value "E" "anchorAuto"

        "center" ->
            value "E" "positionCenter"

        "left" ->
            value "E" "positionLeft"

        "right" ->
            value "E" "positionRight"

        "top" ->
            value "E" "positionTop"

        "bottom" ->
            value "E" "positionBottom"

        "topRight" ->
            value "E" "positionTopRight"

        "topLeft" ->
            value "E" "positionTopLeft"

        "bottomLeft" ->
            value "E" "positionBottomLeft"

        "bottomRight" ->
            value "E" "positionBottomRight"

        "none" ->
            value "E" "textFitNone"

        "width" ->
            value "E" "textFitWidth"

        "height" ->
            value "E" "textFitHeight"

        "both" ->
            value "E" "textFitBoth"

        "butt" ->
            value "E" "lineCapButt"

        "round" ->
            value "E" "lineCapRound"

        "square" ->
            value "E" "lineCapSquare"

        "bevel" ->
            value "E" "lineJoinBevel"

        "miter" ->
            value "E" "lineJoinMiter"

        "point" ->
            value "E" "symbolPlacementPoint"

        "line-center" ->
            value "E" "symbolPlacementLineCenter"

        "line" ->
            value "E" "symbolPlacementLine"

        "uppercase" ->
            value "E" "textTransformUppercase"

        "lowercase" ->
            value "E" "textTransformLowercase"

        "linear" ->
            value "E" "rasterResamplingLinear"

        "nearest" ->
            value "E" "rasterResamplingNearest"

        _ ->
            case Color.parse s of
                Ok { r, g, b, a } ->
                    call "E" "rgba" [ integer r, integer g, integer b, float a ]

                Err err ->
                    str s |> ecall "str"



-- legacy filter


decodeLegacyFilter : Decoder (Node Expression)
decodeLegacyFilter =
    let
        decodeProp =
            D.index 1 D.string
                |> D.map
                    (\prop ->
                        case prop of
                            "$type" ->
                                value "E" "geometryType"

                            "$id" ->
                                value "E" "id"

                            _ ->
                                call "E" "getProperty" [ ecall "str" (str prop) ]
                    )

        decodeVal =
            D.index 2 <|
                D.oneOf
                    [ D.map (str >> ecall "str") D.string
                    , D.map (float >> ecall "float") D.float
                    , decodeBool
                    ]

        decodeVals =
            D.list <|
                D.oneOf
                    [ D.map (str >> ecall "str") D.string
                    , D.map (float >> ecall "float") D.float
                    , decodeBool
                    ]
    in
    D.index 0 D.string
        |> D.andThen
            (\filter ->
                case filter of
                    "all" ->
                        decodeTail decodeLegacyFilter |> D.map (\filters -> call "E" "all" [ list filters ])

                    "any" ->
                        decodeTail decodeLegacyFilter |> D.map (\filters -> call "E" "any" [ list filters ])

                    "none" ->
                        decodeTail decodeLegacyFilter |> D.map (\filters -> call "E" "all" [ list (List.map (\f -> call "E" "not" [ f ]) filters) ])

                    "has" ->
                        D.index 1 D.string |> D.map (\prop -> call "E" "hasProperty" [ ecall "str" (str prop) ])

                    "!has" ->
                        D.index 1 D.string |> D.map (\prop -> call "E" "not" [ call "E" "hasProperty" [ ecall "str" (str prop) ] ])

                    "==" ->
                        D.map2 (\prop val -> pipelineCall "E" "isEqual" [ prop, val ]) decodeProp decodeVal

                    "!=" ->
                        D.map2 (\prop val -> pipelineCall "E" "notEqual" [ prop, val ]) decodeProp decodeVal

                    ">" ->
                        D.map2 (\prop val -> pipelineCall "E" "greaterThan" [ prop, val ]) decodeProp decodeVal

                    ">=" ->
                        D.map2 (\prop val -> pipelineCall "E" "greaterThanOrEqual" [ prop, val ]) decodeProp decodeVal

                    "<" ->
                        D.map2 (\prop val -> pipelineCall "E" "lessThan" [ prop, val ]) decodeProp decodeVal

                    "<=" ->
                        D.map2 (\prop val -> pipelineCall "E" "lessThanOrEqual" [ prop, val ]) decodeProp decodeVal

                    "in" ->
                        D.map2
                            (\prop values ->
                                List.drop 2 values
                                    |> List.map (\v -> pipelineCall "E" "isEqual" [ prop, v ])
                                    |> list
                                    |> List.singleton
                                    |> call "E" "any"
                            )
                            decodeProp
                            decodeVals

                    "!in" ->
                        D.map2
                            (\prop values ->
                                List.drop 2 values
                                    |> List.map (\v -> pipelineCall "E" "notEqual" [ prop, v ])
                                    |> list
                                    |> List.singleton
                                    |> call "E" "all"
                            )
                            decodeProp
                            decodeVals

                    _ ->
                        D.fail "not actually a legacy filter"
            )



-- Expressions


decodeTail : Decoder a -> Decoder (List a)
decodeTail itemDecoder =
    D.list D.value
        |> D.andThen
            (\l ->
                case l of
                    [] ->
                        D.fail "Can't get tail of empty"

                    head :: t ->
                        List.map (subdecode itemDecoder) t |> combine
            )


subdecode : Decoder a -> D.Value -> Decoder a
subdecode d v =
    D.decodeValue d v |> resultToDecoder


decodeMatch : Bool -> any -> Decoder (Node Expression)
decodeMatch isString _ =
    decodeTail D.value
        |> D.andThen
            (\args ->
                case args of
                    [] ->
                        todo

                    head :: tail ->
                        D.map2
                            (\cond rest ->
                                parens
                                    (node
                                        (OperatorApplication "|>"
                                            Right
                                            cond
                                            (call "E"
                                                (if isString then
                                                    "matchesStr"
                                                 else
                                                    "matchesFloat"
                                                )
                                                rest
                                            )
                                        )
                                    )
                            )
                            (subdecode decodeValue head)
                            (organizeArgs
                                (if isString then
                                    D.map str D.string
                                 else
                                    D.map float D.float
                                )
                                []
                                tail
                            )
            )


organizeArgs : Decoder (Node Expression) -> List (Decoder (Node Expression)) -> List D.Value -> Decoder (List (Node Expression))
organizeArgs inpDec accu args =
    case args of
        [] ->
            combine [ D.map list (List.reverse accu |> combine) ]

        [ default ] ->
            combine [ D.map list (List.reverse accu |> combine), subdecode decodeValue default ]

        a :: b :: rest ->
            let
                newAccu =
                    D.map2
                        (\inp out ->
                            parens (node (TupledExpression [ inp, out ]))
                        )
                        (subdecode inpDec a)
                        (subdecode decodeValue b)
                        :: accu
            in
            organizeArgs inpDec newAccu rest


decodeExpression : String -> Decoder (Node Expression)
decodeExpression funName =
    case funName of
        "literal" ->
            D.index 1
                (D.oneOf
                    [ D.list D.string |> D.map (\strs -> call "E" "strings" [ list (List.map str strs) ])
                    , D.list D.float |> D.map (\floats -> call "E" "floats" [ list (List.map float floats) ])
                    ]
                )

        "match" ->
            D.oneOf
                [ D.index 2 D.string |> D.andThen (decodeMatch True)
                , D.index 2 D.float |> D.andThen (decodeMatch False)
                ]

        "exponential" ->
            D.map (\base -> call "E" "Exponential" [ float base ]) (D.index 1 D.float)

        "interpolate" ->
            D.map3
                (\interpolation options input ->
                    pipelineCall "E" "interpolate" (input :: interpolation :: options)
                )
                (D.index 1 decodeValue)
                (decodeTail D.value |> D.map (List.drop 2) |> D.andThen (organizeArgs (D.map float D.float) []))
                (D.index 2 decodeValue)

        "step" ->
            D.map3
                (\inp def stps ->
                    pipelineCall "E" "step" (inp :: def :: stps)
                )
                (D.index 1 decodeValue)
                (D.index 2 decodeValue)
                (decodeTail D.value |> D.map (List.drop 2) |> D.andThen (organizeArgs (D.map float D.float) []))

        _ ->
            let
                fallback =
                    decodeTail decodeValue
                        |> D.map
                            (\arguments ->
                                case funName of
                                    "==" ->
                                        pipelineCall "E" "isEqual" arguments

                                    "!=" ->
                                        pipelineCall "E" "notEqual" arguments

                                    "!has" ->
                                        todoExpr "!has is not supported"

                                    "!in" ->
                                        todoExpr "!in is not supported"

                                    "in" ->
                                        todoExpr "in is not supported"

                                    ">=" ->
                                        pipelineCall "E" "greaterThanOrEqual" arguments

                                    "<=" ->
                                        pipelineCall "E" "lessThanOrEqual" arguments

                                    "concat" ->
                                        pipelineCall "E" "append" arguments

                                    "linear" ->
                                        call "E" "Linear" arguments

                                    "rgb" ->
                                        call "E" "makeRGBColor" arguments

                                    "rgba" ->
                                        call "E" "makeRGBAColor" arguments

                                    "to-rgba" ->
                                        call "E" "rgbaChannels" arguments

                                    "-" ->
                                        pipelineCall "E" "minus" arguments

                                    "*" ->
                                        pipelineCall "E" "multiply" arguments

                                    "+" ->
                                        pipelineCall "E" "plus" arguments

                                    "/" ->
                                        pipelineCall "E" "divideBy" arguments

                                    "%" ->
                                        pipelineCall "E" "modBy" arguments

                                    "^" ->
                                        pipelineCall "E" "raiseBy" arguments

                                    "get" ->
                                        if List.length arguments == 1 then
                                            call "E" "getProperty" arguments
                                        else
                                            call "E" "get" arguments

                                    _ ->
                                        call "E" (toCamelCaseLower funName) arguments
                            )
            in
            if String.toLower funName /= funName then
                D.oneOf
                    [ D.map (\strs -> call "E" "strings" [ list (List.map str strs) ]) <| D.list D.string
                    , fallback
                    ]
            else
                fallback


decodeSources : Decoder (Node Expression)
decodeSources =
    D.keyValuePairs decodeSource
        |> D.map (List.map (\( key, fn ) -> fn key))
        |> D.map (\sources -> node (ListExpr sources))


decodeSource : Decoder (String -> Node Expression)
decodeSource =
    D.field "type" D.string
        |> D.andThen
            (\t ->
                case t of
                    "vector" ->
                        D.field "url" D.string
                            |> D.map
                                (\url ->
                                    \id ->
                                        call "Source"
                                            "vectorFromUrl"
                                            [ str id
                                            , str url
                                            ]
                                )

                    _ ->
                        D.succeed (\a -> todoExpr ("type " ++ t ++ "not yet supported"))
            )


decodeMisc : Decoder (Node Expression)
decodeMisc =
    D.succeed (node (ListExpr []))


list l =
    node (ListExpr l)


str s =
    node (Literal s)


ecall name arg =
    parens (node (Application [ node (FunctionOrValue [] name), arg ]))


call ns name args =
    parens (node (Application (node (FunctionOrValue [ ns ] name) :: args)))


pipelineCall ns name args =
    case args of
        fst :: rest ->
            parens (node (OperatorApplication "|>" Left fst (call ns name rest)))

        _ ->
            todoExpr <| "Wrong number of arguments passed to " ++ ns ++ "." ++ name


value ns name =
    node (FunctionOrValue [ ns ] name)


evalue name =
    node (FunctionOrValue [] name)


integer =
    Integer >> node


float =
    Floatable >> node


parens =
    ParenthesizedExpression >> node


valueDecoder ns name =
    D.succeed (node (FunctionOrValue [ ns ] name))


todo : Decoder (Node Expression)
todo =
    D.map (\val -> todoExpr ("The expression " ++ Json.Encode.encode 0 val ++ " is not yet supported")) D.value


todoExpr msg =
    node (ParenthesizedExpression (call "Debug" "todo" [ str msg ]))


combine : List (Decoder a) -> Decoder (List a)
combine =
    List.foldr (D.map2 (::)) (D.succeed [])
