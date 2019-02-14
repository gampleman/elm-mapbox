module Lib exposing (bare, eName, eValue, expressionNs, false, float, floats, get, int, layerNs, pipelineCall, pipelineMultiCall, sourceNs, str, styleNs, todo, true, zoom)

import MyElm.Advanced as Advanced
import MyElm.Syntax as Elm exposing (Expression)


styleNs =
    [ "Mapbox", "Style" ]


layerNs =
    [ "Mapbox", "Layer" ]


expressionNs =
    [ "Mapbox", "Expression" ]


sourceNs =
    [ "Mapbox", "Source" ]


eName name =
    Advanced.aliasedName { modulePath = expressionNs, aliasName = "E", name = name, typeName = Nothing }


bare =
    Advanced.exposedName expressionNs


zoom : Expression
zoom =
    Elm.call0 (eName "zoom")


true : Expression
true =
    Elm.call0 (bare "true")


false : Expression
false =
    Elm.call0 (bare "false")


float : Expression -> Expression
float =
    Elm.call1 (bare "float")


floats : Expression -> Expression
floats =
    Elm.call1 (eName "floats")


int : Expression -> Expression
int =
    Elm.call1 (bare "int")


str : Expression -> Expression
str =
    Elm.call1 (bare "str")


eValue : String -> Expression
eValue =
    eName >> Elm.call0


get : Expression -> Expression
get =
    Elm.call1 (eName "get")


todo : String -> Expression
todo msg =
    Elm.call1 (Elm.valueName [ "Debug" ] "todo") (Elm.string msg)


pipelineCall : String -> List Expression -> Expression
pipelineCall name args =
    case args of
        fst :: rest ->
            Elm.call2 (Elm.local "|>")
                fst
                (Elm.calln (eName name) rest)

        _ ->
            todo <| "Wrong number of arguments passed to E." ++ name


pipelineMultiCall : String -> List Expression -> Expression
pipelineMultiCall name args =
    case args of
        fst :: rest ->
            List.map (Elm.call1 (eName name)) rest
                |> List.foldl (\a b -> Elm.call2 (Elm.local "|>") b a) fst

        _ ->
            todo <| "Wrong number of arguments passed to E." ++ name
