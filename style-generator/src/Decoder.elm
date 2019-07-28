module Decoder exposing (styleCode)

import Decoder.Expression as Decode
import Decoder.Generic as Decode
import Decoder.Helpers exposing (todo)
import Decoder.Legacy
import Json.Decode as D exposing (Decoder)
import Lib
import MyElm.Advanced as Advanced
import MyElm.Syntax exposing (..)
import String.Case exposing (toCamelCaseLower)


styleNs =
    [ "Mapbox", "Style" ]


layerNs =
    [ "Mapbox", "Layer" ]


sourceNs =
    [ "Mapbox", "Source" ]


styleName nm =
    Advanced.aliasedName
        { modulePath = styleNs
        , aliasName =
            "Style"
        , name = nm
        , typeName = Nothing
        }


layerName nm =
    Advanced.aliasedName
        { modulePath = layerNs
        , aliasName =
            "Layer"
        , name = nm
        , typeName = Nothing
        }


sourceName nm =
    Advanced.aliasedName
        { modulePath = layerNs
        , aliasName =
            "Source"
        , name = nm
        , typeName = Nothing
        }


styleCode : Decoder String
styleCode =
    D.map file style


declarations styleDec =
    [ variable "style" (type0 (typeName styleNs "Style")) (call1 (constructorName [ "Mapbox", "Style" ] "Style" "Style") (record styleDec)) ]


file styleDec =
    build
        { name = [ "Style" ]
        , exposes = [ exposeFn "style" ]
        , doc = Nothing
        , declarations = declarations styleDec
        }


style =
    D.map5
        (\transition light layers sources misc ->
            [ ( "transition", transition )
            , ( "light", light )
            , ( "layers", layers )
            , ( "sources", sources )
            , ( "misc", misc )
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


decodeTransition =
    D.map2
        (\duration delay ->
            record
                [ ( "duration", int duration )
                , ( "delay", int delay )
                ]
        )
        (D.oneOf [ D.field "duration" D.int, D.succeed 300 ])
        (D.oneOf [ D.field "delay" D.int, D.succeed 0 ])


decodeLight =
    valueDecoder "Style" "defaultLight"


decodeLayers =
    D.list decodeLayer
        |> D.map list


layerDecodeHelp t =
    D.map3 (\id source attrs -> call3 (layerName t) (string id) (string source) (list attrs)) (D.field "id" D.string) (D.field "source" D.string) decodeAttrs


decodeLayer =
    D.field "type" D.string
        |> D.andThen
            (\t ->
                case t of
                    "background" ->
                        D.map2 (\id attrs -> call2 (layerName "background") (string id) (list attrs)) (D.field "id" D.string) decodeAttrs

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


decodeAttrs =
    D.map3 (\top paint layout -> top ++ paint ++ layout) (D.keyValuePairs D.value) (Decode.withDefault [] (D.field "paint" (D.keyValuePairs D.value))) (Decode.withDefault [] (D.field "layout" (D.keyValuePairs D.value)))
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

                        "metadata" ->
                            Nothing

                        "source-layer" ->
                            decodeAttr "sourceLayer" (D.map string D.string) attrValue

                        "minzoom" ->
                            decodeAttr "minzoom" (D.map float D.float) attrValue

                        "maxzoom" ->
                            decodeAttr "maxzoom" (D.map float D.float) attrValue

                        "filter" ->
                            decodeAttr "filter" (D.oneOf [ Decoder.Legacy.filter, Decode.expression ]) attrValue

                        other ->
                            decodeAttr (toCamelCaseLower attrName) Decode.expression attrValue
                )
                >> Decode.combine
            )


decodeAttr attrName expressionNodeDecoder attrValue =
    Just
        (D.decodeValue expressionNodeDecoder attrValue
            |> Decode.resultToDecoder
            |> D.map (call1 (layerName (toCamelCaseLower attrName)))
        )


decodeSources =
    D.keyValuePairs decodeSource
        |> D.map (List.map (\( key, fn ) -> fn key))
        |> D.map list


decodeSource =
    D.field "type" D.string
        |> D.andThen
            (\t ->
                case t of
                    "vector" ->
                        D.oneOf
                            [ D.field "url" D.string
                                |> D.map
                                    (\url ->
                                        \id ->
                                            call2 (Advanced.aliasedName { modulePath = sourceNs, aliasName = "Source", name = "vectorFromUrl", typeName = Nothing })
                                                (string id)
                                                (string url)
                                    )
                            , D.map6
                                (\tiles bounds minzoom maxzoom attribution scheme ->
                                    \id ->
                                        call3 (Advanced.aliasedName { modulePath = sourceNs, aliasName = "Source", name = "vector", typeName = Nothing })
                                            (string id)
                                            (list (List.map string tiles))
                                            (list ([ bounds, minzoom, maxzoom, attribution, scheme ] |> List.filterMap identity))
                                )
                                (D.field "tiles" (D.list D.string))
                                (sourceField "bounds" "bounds" (D.list D.float) (\l -> List.map float l |> list))
                                (sourceField "minzoom" "minzoom" D.float float)
                                (sourceField "maxzoom" "maxzoom" D.float float)
                                (sourceField "attribution" "attribution" D.string string)
                                (sourceField "scheme" "scheme" D.string string)
                            ]

                    "raster" ->
                        D.map
                            (\url ->
                                \id ->
                                    call2 (Advanced.aliasedName { modulePath = sourceNs, aliasName = "Source", name = "rasterFromUrl", typeName = Nothing })
                                        (string id)
                                        (string url)
                            )
                            (D.field "url" D.string)

                    _ ->
                        D.succeed (\a -> Lib.todo ("type " ++ t ++ " not yet supported"))
            )


sourceField : String -> String -> Decoder a -> (a -> Expression) -> Decoder (Maybe Expression)
sourceField name elmName decoder toExpr =
    D.maybe (D.field name (D.map (\item -> call1 (sourceName elmName) (toExpr item)) decoder))


decodeMisc =
    D.map6 (\sprite glyphs name zoom bearing pitch -> [ sprite, glyphs, name, zoom, bearing, pitch ] |> List.filterMap identity |> list)
        (miscField "sprite" "sprite" D.string string)
        (miscField "glyphs" "glyphs" D.string string)
        (miscField "name" "name" D.string string)
        (miscField "zoom" "defaultZoomLevel" D.float float)
        (miscField "bearing" "defaultBearing" D.float float)
        (miscField "pitch" "defaultPitch" D.float float)


miscField : String -> String -> Decoder a -> (a -> Expression) -> Decoder (Maybe Expression)
miscField name elmName decoder toExpr =
    D.maybe (D.field name (D.map (\item -> call1 (styleName elmName) (toExpr item)) decoder))



-- (D.field "center" D.maybe (D.map (\sprite -> call1 (styleName "defaultCenter") (str sprite) )) D.string)
--


valueDecoder ns name =
    D.succeed (call0 (Advanced.aliasedName { modulePath = [ "Mapbox", ns ], aliasName = ns, name = name, typeName = Nothing }))
