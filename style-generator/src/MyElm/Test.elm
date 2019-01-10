module MyElm.Test exposing (main)

import Html exposing (pre, text)
import MyElm.Syntax exposing (Exposing(..), QualifiedName(..), Type(..), call0, call1, customType, fun1, local, module2string, typeName, write)


mod =
    write
        { name = [ "MyElm", "Test" ]
        , exposes = [ ValueExposed "main" ]
        , doc = Just "This module is a test module"
        , declarations =
            [ customType "List"
                [ ( "Empty", [] )
                , ( "Cons", [ TypeVariable "a", NamedType (local "List") [ TypeVariable "a" ] ] )
                ]
            , fun1 "writeFunction"
                (Just ( NamedType (typeName [ "Elm", "Syntax", "Declaration" ] "Function") [], NamedType (local "Writer") [] ))
                "func"
                (\func ->
                    call0 func
                )
            ]
        }


main =
    pre [] [ text mod ]



{-
   writeFunction : Function -> Writer
   writeFunction { documentation, signature, declaration } =
       breaked
           [ maybe (Maybe.map writeDocumentation documentation)
           , maybe (Maybe.map (Node.value >> writeSignature) signature)
           , writeFunctionImplementation <| Node.value declaration
           ]
-}
