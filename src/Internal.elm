module Internal exposing (Expression(..), Supported)

import Json.Encode exposing (Value)


type Expression exprType resultType
    = Expression Value


type Supported
    = Supported
