module MyElm.Stringify exposing (arg2string, declaration2string, expose2string, expression2string, module2string, needsBrackets, qualifiedName2string, type2str, type2string)

import MyElm.Types exposing (..)



-- indentation


indented : String -> String
indented s =
    s
        |> String.split "\n"
        |> String.join "\n    "
        |> String.append "    "


listLike : String -> String -> String -> List String -> String
listLike before sep after l =
    let
        shouldBeMultiline =
            List.any (\ln -> List.length (String.split "\n" ln) > 1) l || List.foldl (\ln s -> s + String.length ln) 0 l > 100
    in
    if shouldBeMultiline then
        "\n" ++ indented (before ++ " " ++ String.join ("\n" ++ sep) l ++ "\n" ++ after)

    else if after == "" && before == "" then
        String.join sep l

    else
        before ++ " " ++ String.join sep l ++ " " ++ after


bodyIndent : String -> String
bodyIndent str =
    if List.length (String.split "\n" str) > 1 then
        str

    else
        "\n    " ++ str


expose2string : Exposing -> String
expose2string expose =
    case expose of
        ValueExposed val ->
            val

        TypeExposed tp ->
            tp

        TypeAndConstructors tp ->
            tp ++ "(..)"


module2string : Module -> String
module2string (Module { name, exposes, doc, imports, declarations }) =
    let
        header =
            "module " ++ name ++ " exposing (" ++ String.join ", " (List.map expose2string exposes) ++ ")\n\n"

        docstr =
            case doc of
                Just d ->
                    "{-|" ++ d ++ "-}\n\n"

                Nothing ->
                    ""

        imps =
            String.join "\n" imports
                ++ (if List.length imports > 0 then
                        "\n\n\n"

                    else
                        ""
                   )

        decs =
            String.join "" <| List.map declaration2string declarations
    in
    header ++ docstr ++ imps ++ decs


type2str : Bool -> Type -> String
type2str needsBr tp =
    case tp of
        NamedType qualifiedName typeList ->
            if List.length typeList > 0 then
                if needsBr then
                    "(" ++ qualifiedName2string qualifiedName ++ " " ++ String.join " " (List.map (type2str True) typeList) ++ ")"

                else
                    qualifiedName2string qualifiedName ++ " " ++ String.join " " (List.map (type2str True) typeList)

            else
                qualifiedName2string qualifiedName

        RecordType branches ->
            "{ " ++ String.join ", " (List.map (\( name, typ ) -> name ++ " = " ++ type2str False typ) branches) ++ " }"

        FunctionType typeList ->
            let
                a =
                    String.join " -> " (List.map (type2str False) typeList)
            in
            if needsBr then
                "(" ++ a ++ ")"

            else
                a

        TupleType typeList ->
            "( " ++ String.join ",  " (List.map (type2str False) typeList) ++ " )"

        TypeVariable name ->
            name


type2string =
    type2str False


declaration2string : Declaration -> String
declaration2string declaration =
    case declaration of
        CustomType name variables variants ->
            "type " ++ String.join " " (name :: variables) ++ "\n    = " ++ String.join "\n    | " (List.map (\( nm, args ) -> String.join " " (nm :: List.map (type2str True) args)) variants) ++ "\n\n\n"

        TypeAlias name variables aliased ->
            "type alias " ++ String.join " " (name :: variables) ++ "\n    =" ++ type2string aliased ++ "\n\n\n"

        Comment str ->
            "{-|" ++ str ++ "}"

        ValueDeclaration name anno argList expression ->
            let
                decl =
                    name ++ " " ++ String.join " " (List.map arg2string argList) ++ " =" ++ bodyIndent (expression2string expression) ++ "\n\n\n"
            in
            case anno of
                [] ->
                    decl

                signature ->
                    name ++ " : " ++ String.join " -> " (List.map type2string signature) ++ "\n" ++ decl


arg2string : Argument -> String
arg2string argument =
    case argument of
        Argument a ->
            a


qualifiedName2string : QualifiedName -> String
qualifiedName2string qualifiedName =
    let
        identifierToStr id =
            case id of
                Constructor _ s ->
                    s

                ValueOrType s ->
                    s
    in
    case qualifiedName of
        Local ident ->
            identifierToStr ident

        FullyQualified modPath ident ->
            String.join "." modPath ++ "." ++ identifierToStr ident

        Aliased _ alias_ ident ->
            alias_ ++ "." ++ identifierToStr ident

        Bare _ ident ->
            identifierToStr ident


bracketify : Expression -> String
bracketify arg =
    if needsBrackets arg then
        "(" ++ expression2string arg ++ ")"

    else
        expression2string arg


isOperator : String -> Bool
isOperator op =
    case op of
        "++" ->
            True

        "-" ->
            True

        "+" ->
            True

        "*" ->
            True

        "/" ->
            True

        "//" ->
            True

        "^" ->
            True

        "|>" ->
            True

        "<|" ->
            True

        _ ->
            False


expression2string : Expression -> String
expression2string expression =
    case expression of
        Call name args ->
            let
                nameStr =
                    qualifiedName2string name
            in
            if isOperator nameStr then
                case args of
                    a :: b :: rest ->
                        case nameStr of
                            "|>" ->
                                listLike "" " |> " "" [ expression2string a, String.join " " (List.map expression2string (b :: rest)) ]

                            _ ->
                                expression2string a ++ " " ++ nameStr ++ " " ++ String.join " " (List.map expression2string (b :: rest))

                    _ ->
                        "(" ++ nameStr ++ ") " ++ String.join " " (List.map bracketify args)

            else
                String.join " "
                    (nameStr
                        :: List.map
                            (\arg ->
                                if needsBrackets arg then
                                    "(" ++ expression2string arg ++ ")"

                                else
                                    expression2string arg
                            )
                            args
                    )

        Literal lit ->
            lit

        ListExpr expressions ->
            listLike "[" ", " "]" (List.map expression2string expressions)

        Tuple expressions ->
            listLike "(" ", " ")" (List.map expression2string expressions)

        Record branches ->
            listLike "{" ", " "}" (List.map (\( name, branch ) -> name ++ " = " ++ expression2string branch) branches)


needsBrackets : Expression -> Bool
needsBrackets expression =
    case expression of
        Call _ [] ->
            False

        Call _ _ ->
            True

        _ ->
            False
