module MyElm.Types exposing (Argument(..), Declaration(..), Exposing(..), Expression(..), Ident(..), Module(..), QualifiedName(..), Type(..))


type Module
    = Module
        { name : String
        , exposes : List Exposing
        , doc : Maybe String
        , imports : List String
        , declarations : List Declaration
        }


type QualifiedName
    = Local Ident
    | FullyQualified (List String) Ident
    | Aliased (List String) String Ident
    | Bare (List String) Ident


type Ident
    = Constructor String String
    | ValueOrType String


type Exposing
    = ValueExposed String
    | TypeExposed String
    | TypeAndConstructors String


type Type
    = NamedType QualifiedName (List Type)
    | RecordType (List ( String, Type ))
    | FunctionType (List Type)
    | TupleType (List Type)
    | TypeVariable String


type Declaration
    = CustomType String (List String) (List ( String, List Type ))
    | TypeAlias String (List String) Type
    | Annotated String (List Type) Declaration
    | Variable String Expression
    | FunctionDeclaration String (List Argument) Expression


type Expression
    = Call QualifiedName (List Expression)
    | Literal String
    | ListExpr (List Expression)
    | Tuple (List Expression)


type Argument
    = Argument String
