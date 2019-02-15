module Mapbox.Expression exposing
    ( Expression, DataExpression, CameraExpression
    , encode
    , Color, Object, Collator, FormattedText
    , true, false, bool, int, float, str, rgba, floats, strings, object, collator, defaultCollator
    , assertArray, assertArrayOfStrings, assertArrayOfFloats, assertArrayOfBools, assertBool, assertFloat, assertObject, assertString
    , toBool, toColor, toFloat, toString, toFormattedText
    , formatNumber, NumberFormatOption, locale, currency, minFractionDigits, maxFractionDigits
    , typeof
    , at, get, has, count, length
    , featureState, geometryType, id, properties, getProperty, hasProperty
    , isEqual, notEqual, lessThan, lessThanOrEqual, greaterThan, greaterThanOrEqual
    , isEqualWithCollator, notEqualWithCollator, lessThanWithCollator, lessThanOrEqualWithCollator, greaterThanWithCollator, greaterThanOrEqualWithCollator
    , not, all, any
    , ifElse, conditionally, matchesStr, matchesFloat, coalesce
    , interpolate, Interpolation(..), step
    , append, downcase, upcase, isSupportedScript, resolvedLocale
    , format, FormattedString, formatted, fontScaledBy, withFont
    , makeRGBColor, makeRGBAColor, rgbaChannels
    , minus, multiply, divideBy, modBy, plus, raiseBy, sqrt, abs, ceil, floor, round, cos, sin, tan, acos, asin, atan, e, pi, ln, ln2, log10, log2
    , zoom, heatmapDensity, lineProgress
    , map, viewport, auto, center, left, right, top, bottom, topLeft, topRight, bottomLeft, bottomRight, none, width, height, both, butt, rounded, square, bevel, miter, point, lineCenter, line, uppercase, lowercase, linear, nearest, viewportY, source
    )

{-| Expressions form a little language that can be used to compute values for various layer properties.

It is recommended to import them in the following fashion:

    import Mapbox.Expression as E exposing (Expression, CameraExpression, DataExpression, str, float, int, true, false)

This way you can use the language without much syntactic fuss and you have easy access to the literals.


### Example

You'd like to adjust font size of a town based on the number of people who live there. In plain Elm, you might wright the following function:

    sizeByPopulation : Dict String Int -> Int
    sizeByPopulation properties =
        Dict.get "population" properties
            |> Maybe.withDefault 1000
            |> scale ( 0, 1000 ) ( 9, 20 )

In the expression language you can do this in a similar fassion:

    sizeByPopulation : Expression DataExpression Float
    sizeByPopulation =
        E.getProperty "population"
            |> E.toFloat 1000
            |> E.interpolate E.Linear
                [ ( 0, int 9 )
                , ( 1000, int 20 )
                ]


### Table of contents

  - [Types](#types)
  - [Lookup](#lookup)
  - [Feature data](#feature-data)
  - [Decision](#decision)
  - [Ramps, scales, curves](#ramps-scales-curves)
  - [String](#string)
  - [Formatted Text](#formatted-text)
  - [Color](#color)
  - [Math](#math)
  - [Misx](#misc)
  - [Enums](#enums)

**Note**: If you are familiar with the JS version of the style spec,
we have made a few changes. Argument order has been switched for many functions to support using pipeline style more naturally. Some functions use overloading in the original, these have been renamed to
not be overloaded. Finally, we have chosen not to represent some parts of the spec that are superflous (especially when used from Elm), namely functions and let-in expressions.

@docs Expression, DataExpression, CameraExpression

@docs encode


### Types

All of the types used as expression results are phantom (i.e. they don't have any runtime values but are used purely for compile-time checking). As such we use a mix of standard elm types for their familiarty:

  - `Float`
  - `String`
  - `Array`
  - `Bool`

We introduce the following types:

@docs Color, Object, Collator, FormattedText

(And also a bunch of Enum types, that will be documented in the Enums section).

You can use the following functions to transfer Elm values into the Expression language:

@docs true, false, bool, int, float, str, rgba, floats, strings, object, collator, defaultCollator

In some cases, you will need to force the type system to cooperate.
The following assertions will force the type and cause a run-time error
if the type is wrong:

@docs assertArray, assertArrayOfStrings, assertArrayOfFloats, assertArrayOfBools, assertBool, assertFloat, assertObject, assertString

You can also use these functions to explicitly cast to a particular type:

@docs toBool, toColor, toFloat, toString, toFormattedText

@docs formatNumber, NumberFormatOption, locale, currency, minFractionDigits, maxFractionDigits

@docs typeof


### Lookup

@docs at, get, has, count, length


### Feature data

@docs featureState, geometryType, id, properties, getProperty, hasProperty


### Decision

The expressions in this section can be used to add conditional logic to your styles.

@docs isEqual, notEqual, lessThan, lessThanOrEqual, greaterThan, greaterThanOrEqual

Strings can be compared with a collator for locale specific comparisons:

@docs isEqualWithCollator, notEqualWithCollator, lessThanWithCollator, lessThanOrEqualWithCollator, greaterThanWithCollator, greaterThanOrEqualWithCollator

Logical operators:

@docs not, all, any

Control flow:

@docs ifElse, conditionally, matchesStr, matchesFloat, coalesce


### Ramps, scales, curves

@docs interpolate, Interpolation, step


### String

@docs append, downcase, upcase, isSupportedScript, resolvedLocale


### Formatted Text

@docs format, FormattedString, formatted, fontScaledBy, withFont


### Color

@docs makeRGBColor, makeRGBAColor, rgbaChannels


### Math

@docs minus, multiply, divideBy, modBy, plus, raiseBy, sqrt, abs, ceil, floor, round, cos, sin, tan, acos, asin, atan, e, pi, ln, ln2, log10, log2


### Misc

@docs zoom, heatmapDensity, lineProgress


### Enums

These are required for various layer properties. They are not documented here as they are overloaded - you will find descriptions
of their effects at the relevant layer property.

**Note:** You may notice that these have slightly odd types. These types allow them to be overloaded for multiple properties, but still remain type safe. Don't worry about these too much!

@docs map, viewport, auto, center, left, right, top, bottom, topLeft, topRight, bottomLeft, bottomRight, none, width, height, both, butt, rounded, square, bevel, miter, point, lineCenter, line, uppercase, lowercase, linear, nearest, viewportY, source

-}

import Array exposing (Array)
import Internal exposing (..)
import Json.Encode exposing (Value)


{-| Expressions are zero overhead wrappers over the underlying JSON language that attempt to provide some type safety.

Note however, that while being a strictly typed language, it has slighlty different semantics tham Elm:

  - There is only a single number type. I have denoted it `Float`. You will notice that the `int` function takes an Elm int
    value and converts it to an `Expression expr Float`.
  - All values may be `null`. There is no `Maybe` type. You can use the `coalesce` function to handle this.
  - There is no distinction between `List`, `Array`, and tuples. Hence all collections are labeled as `Array`.
  - Dictionaries are called `Object`. The keys are always `String`, but the values can be of mixed types. Hence retrieving
    values from them makes code untyped.
  - You can force the types of things using the `assert...` functions. This will generate a runtime error if the type doesn't
    match. This should be necessary only rarely.

The `exprType` can be:

  - `CameraExpression`
  - `DataExpression`
  - or a type variable representing either of the above

The intent is to help you not break your style by using a DataExpression (for example) where it isn't supported. However, this isn't entirely foolproof, so some caution is advised.

-}
type alias Expression exprType resultType =
    Internal.Expression exprType resultType


{-| A camera expression is any expression that uses the zoom operator. Such expressions allow the appearance of a layer
to change with the map's zoom level. Camera expressions can be used to create the appearance of depth and to control data density.

    zoom
        |> interpolate Linear
            [ ( 5, int 1 )
            , ( 10, int 5 )
            ]
        |> Layer.circleRadius

This example uses the `interpolate` operator to define a linear relationship between zoom level and circle size using a set of input-output pairs. In this case, the expression indicates that the circle radius should be 1 pixel when the zoom level is 5 or below, and 5 pixels when the zoom is 10 or above. In between, the radius will be linearly interpolated between 1 and 5 pixels

Camera expressions are allowed anywhere an expression may be used. However, when a camera expression used as the value of a layout or paint property, the `zoom` operator must appear only as the input to an outer `interpolate` or `step` expression

There is an important difference between layout and paint properties in the timing of camera expression evaluation. Paint property camera expressions are re-evaluated whenever the zoom level changes, even fractionally. For example, a paint property camera expression will be re-evaluated continuously as the map moves between zoom levels 4.1 and 4.6. On the other hand, a layout property camera expression is evaluated only at integer zoom levels. It will not be re-evaluated as the zoom changes from 4.1 to 4.6 -- only if it goes above 5 or below 4.

-}
type CameraExpression
    = CameraExpression


{-| A data expression is any expression that access feature data -- that is, any expression that uses one of the data operators: `getProperty`, `hasProperty` , `id`, `geometryType`, or `properties`. Data expressions allow a feature's properties to determine its appearance. They can be used to differentiate features within the same layer and to create data visualizations.

    makeRGBColor
        -- red is higher when feature.properties.temperature is higher
        (getProperty "temperature")
        -- green is always zero
        (int 0)
        -- blue is higher when feature.properties.temperature is lower
        (getProperty "temperature" |> minus 100)
        |> Layer.circleColor

This example uses the `getProperty` operator to obtain the temperature value of each feature. That value is used to compute arguments to the `makeRGBColor` operator, defining a color in terms of its red, green, and blue components.

-}
type DataExpression
    = DataExpression


{-| Turns an expression into JSON
-}
encode : Expression exprType a -> Value
encode (Expression value) =
    value


{-| Represents a mixed-type dictionary where keys are always strings
-}
type Object
    = Object


{-| Represents a color value
-}
type Color
    = Color


{-| Used for locale sensitive string comparisons.
-}
type Collator
    = Collator



-- Enums


{-| -}
map : Expression exprType { a | map : Supported }
map =
    Expression (Json.Encode.string "map")


{-| -}
viewport : Expression exprType { a | viewport : Supported }
viewport =
    Expression (Json.Encode.string "viewport")


{-| -}
auto : Expression exprType { a | auto : Supported }
auto =
    Expression (Json.Encode.string "auto")


{-| -}
center : Expression exprType { a | center : Supported }
center =
    Expression (Json.Encode.string "center")


{-| -}
left : Expression exprType { a | left : Supported }
left =
    Expression (Json.Encode.string "left")


{-| -}
right : Expression exprType { a | right : Supported }
right =
    Expression (Json.Encode.string "right")


{-| -}
top : Expression exprType { a | top : Supported }
top =
    Expression (Json.Encode.string "top")


{-| -}
bottom : Expression exprType { a | bottom : Supported }
bottom =
    Expression (Json.Encode.string "bottom")


{-| -}
topLeft : Expression exprType { a | topLeft : Supported }
topLeft =
    Expression (Json.Encode.string "top-left")


{-| -}
topRight : Expression exprType { a | topRight : Supported }
topRight =
    Expression (Json.Encode.string "top-right")


{-| -}
bottomLeft : Expression exprType { a | bottomLeft : Supported }
bottomLeft =
    Expression (Json.Encode.string "bottom-left")


{-| -}
bottomRight : Expression exprType { a | bottomRight : Supported }
bottomRight =
    Expression (Json.Encode.string "bottom-right")


{-| -}
none : Expression exprType { a | none : Supported }
none =
    Expression (Json.Encode.string "none")


{-| -}
width : Expression exprType { a | width : Supported }
width =
    Expression (Json.Encode.string "width")


{-| -}
height : Expression exprType { a | height : Supported }
height =
    Expression (Json.Encode.string "height")


{-| -}
both : Expression exprType { a | both : Supported }
both =
    Expression (Json.Encode.string "both")


{-| -}
butt : Expression exprType { a | butt : Supported }
butt =
    Expression (Json.Encode.string "butt")


{-| -}
rounded : Expression exprType { a | rounded : Supported }
rounded =
    Expression (Json.Encode.string "round")


{-| -}
square : Expression exprType { a | square : Supported }
square =
    Expression (Json.Encode.string "square")


{-| -}
bevel : Expression exprType { a | bevel : Supported }
bevel =
    Expression (Json.Encode.string "bevel")


{-| -}
miter : Expression exprType { a | miter : Supported }
miter =
    Expression (Json.Encode.string "miter")


{-| -}
point : Expression exprType { a | point : Supported }
point =
    Expression (Json.Encode.string "point")


{-| -}
lineCenter : Expression exprType { a | lineCenter : Supported }
lineCenter =
    Expression (Json.Encode.string "line-center")


{-| -}
line : Expression exprType { a | line : Supported }
line =
    Expression (Json.Encode.string "line")


{-| -}
uppercase : Expression exprType { a | uppercase : Supported }
uppercase =
    Expression (Json.Encode.string "uppercase")


{-| -}
lowercase : Expression exprType { a | lowercase : Supported }
lowercase =
    Expression (Json.Encode.string "lowercase")


{-| -}
linear : Expression exprType { a | linear : Supported }
linear =
    Expression (Json.Encode.string "linear")


{-| -}
nearest : Expression exprType { a | nearest : Supported }
nearest =
    Expression (Json.Encode.string "nearest")


{-| -}
viewportY : Expression exprType { a | viewportY : Supported }
viewportY =
    Expression (Json.Encode.string "viewport-y")


{-| -}
source : Expression exprType { a | source : Supported }
source =
    Expression (Json.Encode.string "source")



-- literals


{-| -}
rgba : Float -> Float -> Float -> Float -> Expression exprType Color
rgba r g b a =
    Expression (Json.Encode.string ("rgba(" ++ String.fromFloat r ++ ", " ++ String.fromFloat g ++ ", " ++ String.fromFloat b ++ ", " ++ String.fromFloat a ++ ")"))


{-| -}
str : String -> Expression exprType String
str s =
    Expression (Json.Encode.string s)


{-| -}
bool : Bool -> Expression exprType Bool
bool b =
    Expression (Json.Encode.bool b)


{-| -}
true : Expression exprType Bool
true =
    bool True


{-| -}
false : Expression exprType Bool
false =
    bool False


{-| -}
int : Int -> Expression exprType Float
int number =
    Expression (Json.Encode.int number)


{-| -}
float : Float -> Expression exprType Float
float number =
    Expression (Json.Encode.float number)


{-| -}
floats : List Float -> Expression exprType (Array Float)
floats =
    List.map float >> list


{-| -}
strings : List String -> Expression exprType (Array String)
strings =
    List.map str >> list


list : List (Expression exprType a) -> Expression exprType (Array a)
list =
    Json.Encode.list encode >> Expression >> call1 "literal"


{-| -}
type NumberFormatOption
    = NFOption String Value


{-| Specifies the locale to use as a BCP 47 language tag. Defaults to the current locale.
-}
locale : Expression exprType String -> NumberFormatOption
locale =
    encode >> NFOption "locale"


{-| If set, will include a currency symbol in the resulting number (such as "JP¥" or "€"). Should be a ISO 4217 currency code.
-}
currency : Expression exprType String -> NumberFormatOption
currency =
    encode >> NFOption "currency"


{-| Formatter will include at least this many digits after the decimal point. Defaults to 0.
-}
minFractionDigits : Expression exprType Float -> NumberFormatOption
minFractionDigits =
    encode >> NFOption "min-fraction-digits"


{-| Formatter will include at most this many digits after the decimal point. Defaults to 3.
-}
maxFractionDigits : Expression exprType Float -> NumberFormatOption
maxFractionDigits =
    encode >> NFOption "max-fraction-digits"


{-| Converts the input number into a string representation following locale dependent formatting rules.
-}
formatNumber : List NumberFormatOption -> Expression exprType Float -> Expression exprType String
formatNumber options number =
    Expression
        (Json.Encode.list identity
            (Json.Encode.string "number-format"
                :: encode number
                :: [ Json.Encode.object (List.map (\(NFOption k v) -> ( k, v )) options)
                   ]
            )
        )


{-| Returns a `Collator` for use in locale-dependent comparison operations. The first argument specifies if the comparison should be case sensitive. The second specifies if it is diacritic sensitive. The final locale argument specifies the IETF language tag of the locale to use.
-}
collator : Expression e1 Bool -> Expression e2 Bool -> Expression e3 String -> Expression e4 Collator
collator (Expression caseSensitive) (Expression diacriticSensitive) (Expression lcle) =
    Expression
        (Json.Encode.list identity
            (Json.Encode.string "collator"
                :: [ Json.Encode.object
                        [ ( "case-sensitive", caseSensitive )
                        , ( "diacritic-sensitive", diacriticSensitive )
                        , ( "locale", lcle )
                        ]
                   ]
            )
        )


{-| Returns a `Collator` with the default locale (which depends on the system running the code), which is not sensitive to case nor diacritic.
-}
defaultCollator : Expression exprType Collator
defaultCollator =
    call0 "collator"


{-| Takes a list of key value pairs. The values are JSON Values,
therefore allowing for mixed types.
-}
object : List ( String, Value ) -> Expression exprType Object
object =
    Json.Encode.object >> Expression >> call1 "literal"


{-| Represents a richly formatted string.
-}
type FormattedText
    = FormattedText


{-| Returns formatted text containing annotations for use in mixed-format text-field entries.

    Layer.textField <|
        E.format
            [ E.getProperty (str "name_en")
                |> E.formatted
                |> E.fontScaledBy (float 1.2)
            , E.formatted (str "\n")
            , E.getProperty (str "name")
                |> E.formatted
                |> E.fontScaledBy (float 0.8)
                |> E.withFont (E.strings [ "DIN Offc Pro Medium" ])

-}
format : List FormattedString -> Expression exprType FormattedText
format =
    List.concatMap (\(FormattedString strExpr maybeScaleExpr maybeFontStack) -> [ strExpr, encodeFormatArgs maybeScaleExpr maybeFontStack ])
        >> call "format"


encodeFormatArgs maybeScaleExpr maybeFontStack =
    [ Maybe.map (\scaleExp -> ( "font-scale", scaleExp )) maybeScaleExpr
    , Maybe.map (\fontStack -> ( "text-font", fontStack )) maybeFontStack
    ]
        |> List.filterMap identity
        |> Json.Encode.object


{-| A FormattedText is composed of a list of FormattedString which essentially are a tuple of a string expression and some formatting information that applies to that string.
-}
type FormattedString
    = FormattedString Value (Maybe Value) (Maybe Value)


{-| Takes a String Expression and turns it into a FormattedString with default formatting.
-}
formatted : Expression exprType String -> FormattedString
formatted s =
    FormattedString (encode s) Nothing Nothing


{-| Specifies a scaling factor relative to the text-size specified in the root layout properties.

Note: this is indempotent, so calling `str "hi" |> formatted |> fontScaledBy 1.2 |> fontScaledBy 1.2` is equivalent to `str "hi" |> formatted |> fontScaledBy 1.2` rather than `str "hi" |> formatted |> fontScaledBy 1.44`.

-}
fontScaledBy : Expression exprType Float -> FormattedString -> FormattedString
fontScaledBy scale (FormattedString s _ fs) =
    FormattedString s (Just (encode scale)) fs


{-| Overrides the font specified by the root layout properties.
-}
withFont : Expression exprType (Array String) -> FormattedString -> FormattedString
withFont stack (FormattedString s scale _) =
    FormattedString s scale (Just (encode stack))



-- Type Functions


{-| -}
assertArray : Expression exprType any -> Expression exprType (Array any)
assertArray =
    call1 "array"


{-| -}
assertArrayOfStrings : Expression exprType any -> Expression exprType (Array String)
assertArrayOfStrings =
    call2 "array" (str "string")


{-| -}
assertArrayOfFloats : Expression exprType any -> Expression exprType (Array Float)
assertArrayOfFloats =
    call2 "array" (str "number")


{-| -}
assertArrayOfBools : Expression exprType any -> Expression exprType (Array Bool)
assertArrayOfBools =
    call2 "array" (str "boolean")


{-| -}
assertBool : Expression exprType any -> Expression exprType Bool
assertBool =
    call1 "boolean"


{-| -}
assertBoolWithFalback : Bool -> Expression exprType any -> Expression exprType Bool
assertBoolWithFalback fallback value =
    call2 "boolean" value (bool fallback)



-- assertAtLeastOneBool : List (Expression exprType any) -> Expression exprType Bool
-- assertAtLeastOneBool =
--     call "boolean"


{-| -}
assertFloat : Expression exprType any -> Expression exprType Float
assertFloat =
    call1 "number"


{-| -}
assertObject : Expression exprType any -> Expression exprType Object
assertObject =
    call1 "object"


{-| -}
assertString : Expression exprType any -> Expression exprType String
assertString =
    call1 "string"


{-| Converts the input value to a boolean. The result is false when then input is an empty string, 0, false, null, or NaN; otherwise it is true.
-}
toBool : Expression exprType any -> Expression exprType Bool
toBool =
    call1 "to-boolean"


{-| Converts the input value to a color. If it can't be converted, the falback value will be used.

    input
      |> toColor (rgba 0 0 0 1) -- fallback color

-}
toColor : Expression exprType2 Color -> Expression exprType any -> Expression exprType Color
toColor fallback input =
    call2 "to-color" input fallback


{-| Converts the input value to a number, if possible. If the input is null or false, the result is 0. If the input is true, the result is 1. If the input is a string, it is converted to a number as specified by the ["ToNumber Applied to the String Type" algorithm of the ECMAScript Language Specification](https://tc39.github.io/ecma262/#sec-tonumber-applied-to-the-string-type). If this fails, the fallback value is used.

    input
      |> toFloat 0 -- fallback

-}
toFloat : Float -> Expression exprType any -> Expression exprType Float
toFloat fallback input =
    call2 "to-number" input (float fallback)


{-| Converts the input value to a string. If the input is `null`, the result is `""`. If the input is a boolean, the result is `"true"` or `"false"`. If the input is a number, it is converted to a string as specified by the ["NumberToString" algorithm](https://tc39.github.io/ecma262/#sec-tostring-applied-to-the-number-type) of the ECMAScript Language Specification. If the input is a color, it is converted to a string of the form `"rgba(r,g,b,a)"`, where r, g, and b are numerals ranging from 0 to 255, and a ranges from 0 to 1. Otherwise, the input is converted to a string in the format specified by the [`JSON.stringify`](https://tc39.github.io/ecma262/#sec-json.stringify) function of the ECMAScript Language Specification.
-}
toString : Expression exprType any -> Expression exprType String
toString =
    call1 "to-string"


{-| Just like `toString`, but outputs a formatted string useable for displaying to users.
-}
toFormattedText : Expression exprType any -> Expression exprType FormattedText
toFormattedText =
    call1 "to-string"


{-| Returns a string describing the type of the given value.
-}
typeof : Expression exprType any -> Expression exprType String
typeof =
    call1 "typeof"



-- Expressions


call0 n =
    call n []


call1 n (Expression a) =
    call n [ a ]


call2 n (Expression a) (Expression b) =
    call n [ a, b ]


call3 n (Expression a) (Expression b) (Expression c) =
    call n [ a, b, c ]


call4 n (Expression a) (Expression b) (Expression c) (Expression d) =
    call n [ a, b, c, d ]


calln n expressions =
    call n (List.map encode expressions)


call name args =
    Expression (Json.Encode.list identity (Json.Encode.string name :: args))


{-| Retrieves a property value from the current feature's state. Returns null if the requested property is not present on the feature's state. A feature's state is not part of the GeoJSON or vector tile data, and must be set programmatically on each feature. Note that `featureState` can only be used with paint properties that support data-driven styling.
-}
featureState : Expression exprType String -> Expression DataExpression any
featureState =
    call1 "feature-state"


{-| Gets the feature's geometry type: Point, MultiPoint, LineString, MultiLineString, Polygon, MultiPolygon.
-}
geometryType : Expression DataExpression String
geometryType =
    call0 "geometry-type"


{-| Gets the feature's id, if it has one.
-}
id : Expression DataExpression any
id =
    call0 "id"


{-| Gets the feature properties object. Note that in some cases, it may be more efficient to use `getProperty (str "property-name")` directly.
-}
properties : Expression DataExpression Object
properties =
    call0 "properties"


{-| Retrieves an item from an array.
-}
at : Expression exprType1 Float -> Expression exprType2 (Array a) -> Expression exprType2 a
at =
    call2 "at"


{-| Retrieves a property value from the current feature's properties. Returns null if the requested property is missing.
-}
getProperty : Expression exprType String -> Expression DataExpression any
getProperty =
    call1 "get"


{-| Retrieves a property value from an object. Returns null if the requested property is missing.
-}
get : Expression exprType1 String -> Expression exprType2 Object -> Expression exprType2 any
get =
    call2 "get"


{-| Tests for the presence of an property value in the current feature's properties.
-}
hasProperty : Expression exprType String -> Expression DataExpression Bool
hasProperty =
    call1 "has"


{-| Tests for the presence of an property value in an object.
-}
has : Expression exprType1 String -> Expression exprType2 Object -> Expression exprType2 Bool
has =
    call2 "has"


{-| Gets the length of an array.
-}
count : Expression exprType (Array any) -> Expression exprType Float
count =
    call1 "length"


{-| Gets the length of a string.
-}
length : Expression exprType String -> Expression exprType Float
length =
    call1 "length"


{-| Logical negation. Returns true if the input is false, and false if the input is true.
-}
not : Expression exprType Bool -> Expression exprType Bool
not =
    call1 "!"


{-| Returns true if the input values are not equal, false otherwise.
-}
notEqual : Expression exprType1 a -> Expression exprType2 a -> Expression exprType1 Bool
notEqual =
    call2 "!="


{-| -}
notEqualWithCollator : Expression exprType1 String -> Expression exprType2 String -> Expression exprType3 Collator -> Expression exprType1 Bool
notEqualWithCollator =
    call3 "!="


{-| Returns true if the first input is strictly less than the second, false otherwise.
-}
lessThan : Expression exprType1 comparable -> Expression exprType2 comparable -> Expression exprType1 Bool
lessThan =
    call2 "<"


{-| -}
lessThanWithCollator : Expression exprType1 String -> Expression exprType2 String -> Expression exprType3 Collator -> Expression exprType1 Bool
lessThanWithCollator =
    call3 "<"


{-| Returns true if the first input is less than or equal to the second, false otherwise.
-}
lessThanOrEqual : Expression exprType1 comparable -> Expression exprType2 comparable -> Expression exprType1 Bool
lessThanOrEqual =
    call2 "<="


{-| -}
lessThanOrEqualWithCollator : Expression exprType1 String -> Expression exprType2 String -> Expression exprType3 Collator -> Expression exprType1 Bool
lessThanOrEqualWithCollator =
    call3 "<="


{-| Returns true if the input values are equal, false otherwise.
-}
isEqual : Expression exprType1 a -> Expression exprType2 a -> Expression exprType1 Bool
isEqual =
    call2 "=="


{-| -}
isEqualWithCollator : Expression exprType1 String -> Expression exprType2 String -> Expression exprType3 Collator -> Expression exprType1 Bool
isEqualWithCollator =
    call3 "=="


{-| Returns true if the first input is strictly greater than the second, false otherwise.
-}
greaterThan : Expression exprType1 comparable -> Expression exprType2 comparable -> Expression exprType1 Bool
greaterThan =
    call2 ">"


{-| -}
greaterThanWithCollator : Expression exprType1 String -> Expression exprType2 String -> Expression exprType3 Collator -> Expression exprType1 Bool
greaterThanWithCollator =
    call3 ">"


{-| Returns true if the first input is greater than or equal to the second, false otherwise.
-}
greaterThanOrEqual : Expression exprType1 comparable -> Expression exprType2 comparable -> Expression exprType1 Bool
greaterThanOrEqual =
    call2 ">="


{-| -}
greaterThanOrEqualWithCollator : Expression exprType1 String -> Expression exprType2 String -> Expression exprType3 Collator -> Expression exprType1 Bool
greaterThanOrEqualWithCollator =
    call3 ">="


{-| Returns true if all the inputs are true, false otherwise. The inputs are evaluated in order, and evaluation is short-circuiting: once an input expression evaluates to false, the result is false and no further input expressions are evaluated.
-}
all : List (Expression exprType Bool) -> Expression exprType Bool
all =
    calln "all"


{-| Returns true if any of the inputs are true, false otherwise. The inputs are evaluated in order, and evaluation is short-circuiting: once an input expression evaluates to true, the result is true and no further input expressions are evaluated.
-}
any : List (Expression exprType Bool) -> Expression exprType Bool
any =
    calln "any"


{-| Evaluates each expression in turn until the first non-null value is obtained, and returns that value.
-}
coalesce : List (Expression exprType outputType) -> Expression exprType outputType
coalesce =
    calln "coalesce"


{-| The ternary operator:

    Layer.iconImage <|
        ifElse
            (greaterThan (getProperty (str "size")) (float 30))
            (str "hospital-32")
            (str "clinic-32")

-}
ifElse : Expression exprType1 Bool -> Expression exprType2 output -> Expression exprType3 output -> Expression exprType1 output
ifElse =
    call3 "case"


{-| Selects the first output whose condition evaluates to `true`
-}
conditionally : List ( Expression exprType1 Bool, Expression exprType2 output ) -> Expression exprType2 output -> Expression exprType1 output
conditionally vals (Expression default) =
    call "case" (List.concatMap (\( Expression cond, Expression res ) -> [ cond, res ]) vals ++ [ default ])


{-| Selects the output whose label value matches the input value, or the fallback value if no match is found.

    getProperty (str "type")
        |> matchesStr
            [ ( "hospital", str "icon-hospital" )
            , ( "clinic", str "icon-medical" )
            ]
            (str "icon-generic")
        -- fallback value
        |> Layer.iconImage

-}
matchesStr : List ( String, Expression exprType2 output ) -> Expression exprType1 output -> Expression exprType3 String -> Expression exprType3 output
matchesStr options (Expression default) (Expression input) =
    let
        properOptions =
            List.concatMap (\( label, Expression output ) -> [ Json.Encode.string label, output ]) options
    in
    call "match" (input :: properOptions ++ [ default ])


{-| Selects the output whose label value matches the input value, or the fallback value if no match is found.

    getProperty (str "size")
        |> matchesFloat
            [ ( 1, str "icon-hospital" )
            , ( 2, str "icon-medical" )
            ]
            (str "icon-generic")
        -- fallback value
        |> Layer.iconImage

-}
matchesFloat : List ( Float, Expression exprType2 output ) -> Expression exprType1 output -> Expression exprType3 Float -> Expression exprType3 output
matchesFloat options (Expression default) (Expression input) =
    let
        properOptions =
            List.concatMap (\( label, Expression output ) -> [ Json.Encode.float label, output ]) options
    in
    call "match" (input :: properOptions ++ [ default ])


{-| Interpolation types:

  - `Linear`: interpolates linearly between the pair of stops just less than and just greater than the input.
  - `Exponential base`: interpolates exponentially between the stops just less than and just greater than the input. `base` controls the rate at which the output increases: higher values make the output increase more towards the high end of the range. With values close to 1 the output increases linearly.
  - `CubicBezier (x1, y1)  (x2, y2)`: interpolates using the cubic bezier curve defined by the given control points.

-}
type Interpolation
    = Linear
    | Exponential Float
    | CubicBezier ( Float, Float ) ( Float, Float )


encodeInterpolation interpolation =
    case interpolation of
        Linear ->
            call0 "linear"

        Exponential base ->
            call "exponential" [ Json.Encode.float base ]

        CubicBezier ( x1, y1 ) ( x2, y2 ) ->
            call "cubic-bezier" [ Json.Encode.float x1, Json.Encode.float y1, Json.Encode.float x2, Json.Encode.float y2 ]


{-| Produces continuous, smooth results by interpolating between pairs of input and output values ("stops"). The output type must be `Float`, `Array Float`, or `Color`.

    zoom
        |> interpolate Linear
            [ ( 5, int 1 )
            , ( 10, int 5 )
            ]
        |> Layer.circleRadius

-}
interpolate : Interpolation -> List ( Float, Expression exprType2 outputType ) -> Expression exprType1 Float -> Expression exprType1 outputType
interpolate interpolation stops (Expression input) =
    call "interpolate" <| (encodeInterpolation interpolation |> encode) :: input :: List.concatMap (\( stop, Expression res ) -> [ Json.Encode.float stop, res ]) stops


{-| Produces discrete, stepped results by evaluating a piecewise-constant function defined by pairs of input and output values ("stops"). Stop inputs must be Floats in strictly ascending order. Returns the output value of the stop just less than the input, or the first input if the input is less than the first stop.

    zoom
        |> step (int 1)
            [ ( 5, int 3 )
            , ( 10, int 5 )
            ]
        |> Layer.circleRadius

-}
step : Expression exprType1 output -> List ( Float, Expression exprType1 output ) -> Expression exprType2 Float -> Expression exprType2 output
step (Expression default) stops (Expression input) =
    call "step" <| input :: default :: List.concatMap (\( stop, Expression res ) -> [ Json.Encode.float stop, res ]) stops


{-| Returns a string consisting of the concatenation of the inputs.

Argument order designed for pipelines:

    a |> append b --> a ++ b

-}
append : Expression exprType String -> Expression exprType String -> Expression exprType String
append a b =
    call2 "concat" b a


{-| Returns the input string converted to lowercase. Follows the Unicode Default Case Conversion algorithm and the locale-insensitive case mappings in the Unicode Character Database.
-}
downcase : Expression exprType String -> Expression exprType String
downcase =
    call1 "downcase"


{-| Returns true if the input string is expected to render legibly. Returns false if the input string contains sections that cannot be rendered without potential loss of meaning (e.g. Indic scripts that require complex text shaping, or right-to-left scripts if the mapbox-gl-rtl-text plugin is not in use in Mapbox GL JS).
-}
isSupportedScript : Expression exprType String -> Expression exprType Bool
isSupportedScript =
    call1 "is-supported-script"


{-| Returns the IETF language tag of the locale being used by the provided collator. This can be used to determine the default system locale, or to determine if a requested locale was successfully loaded.
-}
resolvedLocale : Expression exprType Collator -> Expression exprType String
resolvedLocale =
    call1 "resolved-locale"


{-| Returns the input string converted to uppercase. Follows the Unicode Default Case Conversion algorithm and the locale-insensitive case mappings in the Unicode Character Database.
-}
upcase : Expression exprType String -> Expression exprType String
upcase =
    call1 "upcase"


{-| Creates a color value from red, green, and blue components, which must range between 0 and 255, and an alpha component of 1. If any component is out of range, the expression is an error.
-}
makeRGBColor : Expression exprType Float -> Expression exprType Float -> Expression exprType Float -> Expression exprType Color
makeRGBColor =
    call3 "rgb"


{-| Creates a color value from red, green, blue components, which must range between 0 and 255, and an alpha component which must range between 0 and 1. If any component is out of range, the expression is an error.
-}
makeRGBAColor : Expression exprType Float -> Expression exprType Float -> Expression exprType Float -> Expression exprType Float -> Expression exprType Color
makeRGBAColor =
    call4 "rgba"


{-| Returns a four-element array containing the input color's red, green, blue, and alpha components, in that order.
-}
rgbaChannels : Expression exprType Color -> Expression exprType (Array Float)
rgbaChannels =
    call1 "to-rgba"



-- Math


{-| Returns the result of subtracting the first input from the second.

    a |> minus b --> a - b

-}
minus : Expression exprType Float -> Expression exprType Float -> Expression exprType Float
minus a b =
    call2 "-" b a


{-| Returns the product of the inputs.
-}
multiply : Expression exprType Float -> Expression exprType Float -> Expression exprType Float
multiply =
    call2 "*"


{-| Returns the result of floating point division of the second input by the first.

    a |> divideBy b --> a / b

-}
divideBy : Expression exprType Float -> Expression exprType Float -> Expression exprType Float
divideBy a b =
    call2 "/" b a


{-| Returns the remainder after integer division of the second input by the first.

    a |> modBy b --> a % b

-}
modBy : Expression exprType Float -> Expression exprType Float -> Expression exprType Float
modBy a b =
    call2 "%" b a


{-| Returns the result of raising the second input to the power specified by the first.

    a |> raiseBy b --> a ^ b

-}
raiseBy : Expression exprType Float -> Expression exprType Float -> Expression exprType Float
raiseBy a b =
    call2 "^" b a


{-| Returns the sum of the inputs.
-}
plus : Expression exprType Float -> Expression exprType Float -> Expression exprType Float
plus =
    call2 "+"


{-| Returns the absolute value of the input.
-}
abs : Expression exprType Float -> Expression exprType Float
abs =
    call1 "abs"


{-| Returns the arccosine of the input.
-}
acos : Expression exprType Float -> Expression exprType Float
acos =
    call1 "acos"


{-| Returns the arcsine of the input.
-}
asin : Expression exprType Float -> Expression exprType Float
asin =
    call1 "asin"


{-| Returns the arctangent of the input.
-}
atan : Expression exprType Float -> Expression exprType Float
atan =
    call1 "atan"


{-| Returns the smallest integer that is greater than or equal to the input.
-}
ceil : Expression exprType Float -> Expression exprType Float
ceil =
    call1 "ceil"


{-| Returns the cosine of the input.
-}
cos : Expression exprType Float -> Expression exprType Float
cos =
    call1 "cos"


{-| Returns the mathematical constant e.
-}
e : Expression exprType Float
e =
    call0 "e"


{-| Returns the largest integer that is less than or equal to the input.
-}
floor : Expression exprType Float -> Expression exprType Float
floor =
    call1 "floor"


{-| Returns the natural logarithm of the input.
-}
ln : Expression exprType Float -> Expression exprType Float
ln =
    call1 "ln"


{-| Returns mathematical constant ln(2).
-}
ln2 : Expression exprType Float
ln2 =
    call0 "ln2"


{-| Returns the base-ten logarithm of the input.
-}
log10 : Expression exprType Float -> Expression exprType Float
log10 =
    call1 "log10"


{-| Returns the base-two logarithm of the input.
-}
log2 : Expression exprType Float -> Expression exprType Float
log2 =
    call1 "log2"


{-| Returns the maximum value of the inputs.
-}
max : Expression exprType Float -> Expression exprType Float -> Expression exprType Float
max =
    call2 "max"


{-| Returns the minimum value of the inputs.
-}
min : Expression exprType Float -> Expression exprType Float -> Expression exprType Float
min =
    call2 "min"


{-| -}
pi : Expression exprType Float
pi =
    call0 "pi"


{-| Rounds the input to the nearest integer. Halfway values are rounded away from zero. For example, `round  (float -1.5)` evaluates to -2.
-}
round : Expression exprType Float -> Expression exprType Float
round =
    call1 "round"


{-| Returns the sine of the input.
-}
sin : Expression exprType Float -> Expression exprType Float
sin =
    call1 "sin"


{-| Returns the square root of the input.
-}
sqrt : Expression exprType Float -> Expression exprType Float
sqrt =
    call1 "sqrt"


{-| Returns the tangent of the input.
-}
tan : Expression exprType Float -> Expression exprType Float
tan =
    call1 "tan"



-- Zoom


{-| Gets the current zoom level. Note that in style layout and paint properties, `zoom` may only appear as the input to a top-level `step` or `interpolate` expression.
-}
zoom : Expression CameraExpression Float
zoom =
    call0 "zoom"


{-| Gets the kernel density estimation of a pixel in a heatmap layer, which is a relative measure of how many data points are crowded around a particular pixel. Can only be used in the `heatmapColor` property.
-}
heatmapDensity : Expression exprType Float
heatmapDensity =
    call0 "heatmap-density"


{-| Gets the progress along a gradient line. Can only be used in the `lineGradient` property.
-}
lineProgress : Expression exprType Float
lineProgress =
    call0 "line-progress"
