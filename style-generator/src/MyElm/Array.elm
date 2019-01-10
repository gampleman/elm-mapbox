module MyElm.Array exposing (arrayType, empty, repeat)

import MyElm.Syntax exposing (Expression, Type, typeName, valueName)


arrayType : Type -> Type
arrayType arg =
    NamedType (typeName [ "Array" ] "Array") [ arg ]


empty : Expression
empty =
    call0 [ "Array" ] "empty"


repeat : Expression -> Expression -> Expression
repeat =
    call2 [ "Array" ] "repeat"
