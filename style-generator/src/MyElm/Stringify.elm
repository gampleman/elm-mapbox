module MyElm.Stringify exposing (arg2string, declaration2string, expose2string, expression2string, module2string, needsBrackets, qualifiedName2string, type2str, type2string)

import MyElm.Types exposing (..)


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
            String.join "\n\n\n" <| List.map declaration2string declarations
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
            "type " ++ String.join " " (name :: variables) ++ "\n    = " ++ String.join "\n    | " (List.map (\( nm, args ) -> String.join " " (nm :: List.map (type2str True) args)) variants)

        TypeAlias name variables aliased ->
            "type alias " ++ String.join " " (name :: variables) ++ "\n    =" ++ type2string aliased

        Annotated name signature decl ->
            name ++ " : " ++ String.join " -> " (List.map type2string signature) ++ "\n" ++ declaration2string decl

        Variable name value ->
            name ++ " =\n    " ++ expression2string value

        FunctionDeclaration name argList expression ->
            name ++ " " ++ String.join " " (List.map arg2string argList) ++ " =\n    " ++ expression2string expression


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


expression2string : Expression -> String
expression2string expression =
    case expression of
        Call name args ->
            String.join " "
                (qualifiedName2string name
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
            "[" ++ String.join ", " (List.map expression2string expressions) ++ "]"

        Tuple expressions ->
            "(" ++ String.join ", " (List.map expression2string expressions) ++ ")"


needsBrackets : Expression -> Bool
needsBrackets expression =
    case expression of
        Call _ _ ->
            True

        _ ->
            False
