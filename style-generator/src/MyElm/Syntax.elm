module MyElm.Syntax exposing
    ( QualifiedName, local, valueName, typeName, constructorName
    , Expression, string, float, int, list, pair, triple, call0, call1, call2, call3, call4, calln, pipe, record
    , Type, type0, type1, type2, typen, recordType, functionType, pairType, tripleType, typeVar
    , Declaration, variable, fun1, customType, typeAlias
    , build, Exposing, opaque, withConstructors, exposeFn
    )

{-| This module is intended for autogenerating elm code with
relatively minimal fuss and without needing to do bookkeeping
about minor details like indentation, etc.

This is meant as the simple, convenient module that you
should get started with. It attempts to reduce boilerplate
to a minimum, but makes some opinionated choice about what
the results should look like. You can also use the Advanced
module if you want to make different choices.

The simplifcations made here are:

  - Helpers for naming things assume a particular import style.
  - Imports are generated for you automatically.
  - Custom types and type alaises generate their type variables implicitely.


### Naming things

@docs QualifiedName, local, valueName, typeName, constructorName


### Expressions

@docs Expression, string, float, int, list, pair, triple, call0, call1, call2, call3, call4, calln, pipe, record


### Type signatures

@docs Type, type0, type1, type2, typen, recordType, functionType, pairType, tripleType, typeVar


### Declarations

@docs Declaration, variable, fun1, customType, typeAlias


### Modules

@docs build, Exposing, opaque, withConstructors, exposeFn

-}

import MyElm.Stringify
import MyElm.Types exposing (..)
import Set


{-| The simplest thing you will need to do is keep track of what things in the program are called and where they come from.
-}
type alias QualifiedName =
    MyElm.Types.QualifiedName


{-| This is a value (i.e. variable or function, but not type or constructor) from a module whose path is the first argument.
-}
valueName : List String -> String -> QualifiedName
valueName modulePath name =
    FullyQualified modulePath (ValueOrType name)


{-| This is a type from a module whose path is the first argument.
-}
typeName : List String -> String -> QualifiedName
typeName modulePath name =
    Bare modulePath (ValueOrType name)


{-| This is a constructor for a type (the second argument) from a module whose path is the first argument.

    just =
        constructorName [ "Result" ] "Result" "Just"

-}
constructorName : List String -> String -> String -> QualifiedName
constructorName modulePath typeNm name =
    Bare modulePath (Constructor typeNm name)


{-| This is a variable local to the module you are generating.
-}
local : String -> QualifiedName
local name =
    Local (ValueOrType name)


isLocal : QualifiedName -> Bool
isLocal qualifiedName =
    case qualifiedName of
        Local _ ->
            True

        _ ->
            False


{-| Create a module and return it as a pretty printed string.
-}
build :
    { name : List String
    , exposes : List Exposing
    , doc : Maybe String
    , declarations : List Declaration
    }
    -> String
build m =
    Module
        { name = String.join "." m.name
        , exposes = m.exposes
        , doc = m.doc
        , imports = consolidateImports (extractImports m.declarations)
        , declarations = m.declarations
        }
        |> MyElm.Stringify.module2string


{-| What you would like to expose from a module.
-}
type alias Exposing =
    MyElm.Types.Exposing


{-| Expose a custom type, but leave the constructors hidden.
-}
opaque : String -> Exposing
opaque =
    TypeExposed


{-| Expose a custom type and all its constructors.
-}
withConstructors : String -> Exposing
withConstructors =
    TypeAndConstructors


{-| Expose a function or value.
-}
exposeFn : String -> Exposing
exposeFn =
    ValueExposed


{-| -}
type alias Declaration =
    MyElm.Types.Declaration


{-| This will do automatic type variable extraction for you in order of appearance in the type declaration.

So for example:

    customType "Foo"
        [ ( "Bar", TypeVariable "g" )
        , ( "Baz", TypeVariable "comparable" )
        ]

would generate the following code:

    type Foo g comparable
        = Bar g
        | Baz comparable

If you would like to control the order in which type variables appear, you can use the function in the "Advanced" module.

-}
customType : String -> List ( String, List Type ) -> Declaration
customType name variants =
    CustomType name (List.concatMap (Tuple.second >> List.concatMap extractVariables) variants |> unique) variants


{-| Declare a type alias. Also does automatic type variable extraction.
-}
typeAlias : String -> Type -> Declaration
typeAlias name type_ =
    TypeAlias name (extractVariables type_ |> unique) type_


unique : List comparable -> List comparable
unique =
    Set.fromList >> Set.toList


extractVariables : Type -> List String
extractVariables tp =
    case tp of
        NamedType _ typeList ->
            List.concatMap extractVariables typeList

        RecordType branches ->
            List.concatMap (Tuple.second >> extractVariables) branches

        FunctionType typeList ->
            List.concatMap extractVariables typeList

        TupleType typeList ->
            List.concatMap extractVariables typeList

        TypeVariable variable_ ->
            [ variable_ ]


{-| Declare a top level variable.
-}
variable : String -> Type -> Expression -> Declaration
variable name typeAnno expression =
    ValueDeclaration name [ typeAnno ] [] expression


{-| Declare a top level function with a single argument.

    fun1 "identity" (typeVar "a") (typeVar "a") "a" call0

would be turned into:

    identity : a -> a
    identity a =
        a

-}
fun1 : String -> Type -> Type -> String -> (QualifiedName -> Expression) -> Declaration
fun1 name fromTp toTp arg f =
    ValueDeclaration name [ fromTp, toTp ] [ Argument arg ] (f (local arg))


{-| The heart of an elm program are the expressions that implement the computations.
-}
type alias Expression =
    MyElm.Types.Expression


{-| Reference a variable by name.
-}
call0 : QualifiedName -> Expression
call0 name =
    Call name []


{-| Call a function with 1 argument.
-}
call1 : QualifiedName -> Expression -> Expression
call1 name arg =
    Call name [ arg ]


{-| Call a function with 2 arguments.
-}
call2 : QualifiedName -> Expression -> Expression -> Expression
call2 name arg1 arg2 =
    Call name [ arg1, arg2 ]


{-| Call a function with 3 arguments.
-}
call3 : QualifiedName -> Expression -> Expression -> Expression -> Expression
call3 name arg1 arg2 arg3 =
    Call name [ arg1, arg2, arg3 ]


{-| Call a function with 4 arguments.
-}
call4 : QualifiedName -> Expression -> Expression -> Expression -> Expression -> Expression
call4 name arg1 arg2 arg3 arg4 =
    Call name [ arg1, arg2, arg3, arg4 ]


{-| Call a function with any number of arguments.
-}
calln : QualifiedName -> List Expression -> Expression
calln name args =
    Call name args


{-| A convenience helper for construcing pipelines.

    string "foo"
        |> pipe (valueName [ "String" ] "concat") [ string "bar" ]

would generate:

    "foo"
        |> String.concat "bar"

This is just a helper for:

    pipe name args subject =
        call2 (valueName [ "Basics" ] "|>") subject (calln name args)

-}
pipe : QualifiedName -> List Expression -> Expression -> Expression
pipe name args subject =
    Call (valueName [ "Basics" ] "|>") [ subject, Call name args ]


{-| A string literal.
-}
string : String -> Expression
string s =
    Literal ("\"" ++ String.replace "\"" "\\\"" s ++ "\"")


{-| A float literal.
-}
float : Float -> Expression
float f =
    Literal (String.fromFloat f)


{-| An integer literal.
-}
int : Int -> Expression
int i =
    Literal (String.fromInt i)


{-| A list literal
-}
list : List Expression -> Expression
list =
    ListExpr


{-| A two-tuple literal
-}
pair : Expression -> Expression -> Expression
pair a b =
    Tuple [ a, b ]


{-| A three-tuple literal
-}
triple : Expression -> Expression -> Expression -> Expression
triple a b c =
    Tuple [ a, b, c ]


{-| A record literal expression.
-}
record : List ( String, Expression ) -> Expression
record =
    Record


{-| A representation of a type as in a type annotation context.
-}
type alias Type =
    MyElm.Types.Type


{-| A simple type, like `Int`.
-}
type0 : QualifiedName -> Type
type0 qualifiedName =
    NamedType qualifiedName []


{-| A type with one argument, like `List`.
-}
type1 : QualifiedName -> Type -> Type
type1 qualifiedName arg1 =
    NamedType qualifiedName [ arg1 ]


{-| A type with 2 arguments.
-}
type2 : QualifiedName -> Type -> Type -> Type
type2 qualifiedName arg1 arg2 =
    NamedType qualifiedName [ arg1, arg2 ]


{-| A type with many arguments.
-}
typen : QualifiedName -> List Type -> Type
typen qualifiedName args =
    NamedType qualifiedName args


{-| A record type.

For example we could model

    { foo = Int
    , bar = List String
    }

so:

    recordType
        [ ( "foo", type0 (typeName [ "Basics" ] "Int") )
        , ( "bar"
          , type1 (typeName [ "Basics" ] "List")
                (type0
                    (typeName [ "String" ] "String")
                )
          )
        ]

-}
recordType : List ( String, Type ) -> Type
recordType =
    RecordType


{-| A function type.
-}
functionType : List Type -> Type
functionType =
    FunctionType


{-| Pair type.
-}
pairType : Type -> Type -> Type
pairType a b =
    TupleType [ a, b ]


{-| -}
tripleType : Type -> Type -> Type -> Type
tripleType a b c =
    TupleType [ a, b, c ]


{-| A type variable.
-}
typeVar : String -> Type
typeVar =
    TypeVariable


extractImports : List Declaration -> List QualifiedName
extractImports =
    List.concatMap
        (\dec ->
            case dec of
                CustomType _ _ variants ->
                    List.concatMap (\( _, args ) -> List.concatMap typeImports args) variants

                TypeAlias _ _ aliased ->
                    typeImports aliased

                Comment _ ->
                    []

                ValueDeclaration _ signature _ expression ->
                    List.concatMap typeImports signature ++ expressionImports expression
        )


typeImports : Type -> List QualifiedName
typeImports tp =
    case tp of
        NamedType qualifiedName args ->
            qualifiedName :: List.concatMap typeImports args

        RecordType rec ->
            List.concatMap (\( _, typ ) -> typeImports typ) rec

        FunctionType typeList ->
            List.concatMap typeImports typeList

        TupleType typeList ->
            List.concatMap typeImports typeList

        TypeVariable _ ->
            []


expressionImports : Expression -> List QualifiedName
expressionImports expression =
    case expression of
        Call qualifiedName expressionList ->
            qualifiedName :: List.concatMap expressionImports expressionList

        Literal _ ->
            []

        ListExpr expressionList ->
            List.concatMap expressionImports expressionList

        Tuple expressionList ->
            List.concatMap expressionImports expressionList

        Record branches ->
            List.concatMap (Tuple.second >> expressionImports) branches


consolidateImports : List QualifiedName -> List String
consolidateImports qualifiedNames =
    qualifiedNames
        |> List.filter removeDefaults
        |> List.map toTupleRep
        |> Set.fromList
        |> Set.toList
        |> List.sort
        |> consolidateTuples
        |> List.map
            (\( mod, al, imps ) ->
                let
                    name =
                        "import " ++ mod

                    alias_ =
                        if al == "" then
                            ""

                        else
                            " as " ++ al

                    exposingList =
                        if List.length imps > 0 then
                            " exposing (" ++ String.join ", " imps ++ ")"

                        else
                            ""
                in
                String.join "" [ name, alias_, exposingList ]
            )


consolidateTuples : List ( String, String, List String ) -> List ( String, String, List String )
consolidateTuples tuples =
    case tuples of
        ( xm, xa, xl ) :: ( ym, ya, yl ) :: rest ->
            if xm == ym && (xa == ya || xa == "" || ya == "") then
                consolidateTuples
                    (( xm
                     , if xa == "" then
                        ya

                       else
                        xa
                     , xl ++ yl
                     )
                        :: rest
                    )

            else
                ( xm, xa, xl ) :: consolidateTuples (( ym, ya, yl ) :: rest)

        x ->
            x


iden2str : Ident -> List String
iden2str ident =
    case ident of
        Constructor tpname _ ->
            [ tpname ++ "(..)" ]

        ValueOrType name ->
            [ name ]


toTupleRep : QualifiedName -> ( String, String, List String )
toTupleRep qualifiedName =
    case qualifiedName of
        Local _ ->
            ( "not-possible", "", [] )

        FullyQualified module_ id ->
            ( String.join "." module_, "", [] )

        Aliased module_ alias_ id ->
            ( String.join "." module_, alias_, [] )

        Bare module_ id ->
            ( String.join "." module_, "", iden2str id )


removeDefaults : QualifiedName -> Bool
removeDefaults qualifedName =
    case qualifedName of
        Local _ ->
            False

        FullyQualified module_ id ->
            case module_ of
                [ "Basics" ] ->
                    False

                [ "List" ] ->
                    False

                [ "Maybe" ] ->
                    False

                [ "Result" ] ->
                    False

                [ "String" ] ->
                    False

                [ "Char" ] ->
                    False

                [ "Tuple" ] ->
                    False

                [ "Debug" ] ->
                    False

                [ "Platform" ] ->
                    False

                _ ->
                    True

        Aliased module_ alias_ id ->
            case ( module_, alias_ ) of
                ( [ "Platform", "Cmd" ], "Cmd" ) ->
                    False

                ( [ "Platform", "Sub" ], "Sub" ) ->
                    False

                _ ->
                    True

        Bare module_ (Constructor tpname name) ->
            case ( module_, tpname ) of
                ( [ "Basics" ], _ ) ->
                    False

                ( [ "List" ], "List" ) ->
                    False

                ( [ "Maybe" ], "Maybe" ) ->
                    False

                ( [ "Result" ], "Result" ) ->
                    False

                _ ->
                    True

        Bare module_ (ValueOrType tpname) ->
            case ( module_, tpname ) of
                ( [ "Basics" ], _ ) ->
                    False

                ( [ "List" ], "List" ) ->
                    False

                ( [ "List" ], "::" ) ->
                    False

                ( [ "Maybe" ], "Maybe" ) ->
                    False

                ( [ "Result" ], "Result" ) ->
                    False

                ( [ "String" ], "String" ) ->
                    False

                ( [ "Char" ], "Char" ) ->
                    False

                ( [ "Platform" ], "Program" ) ->
                    False

                ( [ "Platform", "Cmd" ], "Cmd" ) ->
                    False

                ( [ "Platform", "Sub" ], "Sub" ) ->
                    False

                _ ->
                    True
