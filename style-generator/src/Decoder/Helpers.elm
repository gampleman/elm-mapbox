module Decoder.Helpers exposing (todo)

import Json.Decode as D exposing (Decoder)
import Json.Encode
import Lib


todo =
    D.map (\val -> Lib.todo ("The expression " ++ Json.Encode.encode 0 val ++ " is not yet supported")) D.value
