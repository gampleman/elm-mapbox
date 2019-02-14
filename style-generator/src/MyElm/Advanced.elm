module MyElm.Advanced exposing (aliasedName, exposedName, cheat)

{-| This module allows you to mess with some of the the little things at the cost of a more verbose API.

@docs aliasedName, exposedName, cheat

-}

import MyElm.Types exposing (Expression(..), Ident(..), QualifiedName(..))


{-| Specify a name using a module Alias. If it is a constructor, you must specify the type name as well.
-}
aliasedName :
    { modulePath : List String
    , aliasName : String
    , name : String
    , typeName : Maybe String
    }
    -> QualifiedName
aliasedName opts =
    case opts.typeName of
        Just tpn ->
            Aliased opts.modulePath opts.aliasName (Constructor tpn opts.name)

        Nothing ->
            Aliased opts.modulePath opts.aliasName (ValueOrType opts.name)


{-| Import a name and expose it.
-}
exposedName : List String -> String -> QualifiedName
exposedName modulePath name =
    Bare modulePath (ValueOrType name)


{-| Sometimes it is easier to just include a string of Elm code rather than build it up.

This function will allow you to do that. However, using this breaks the guarantee that the
generated Elm code will be valid. You should be careful to take into consideration things like
brackets in the context where you will use this expression.

-}
cheat : String -> Expression
cheat =
    Literal
