module Mapbox.Expression
    exposing
        ( Expression
        , DataExpression
        , CameraExpression
        , encode
        , Color
        , Object
        , Collator
        , defaultCollator
        , true
        , false
        , bool
        , int
        , float
        , str
        , rgba
        , floats
        , strings
        , object
        , collator
        , assertArray
        , assertArrayOfStrings
        , assertArrayOfFloats
        , assertArrayOfBools
        , assertBool
        , assertFloat
        , assertObject
        , assertString
        , toBool
        , toColor
        , toFloat
        , toString
        , typeof
        , at
        , get
        , has
        , count
        , length
        , featureState
        , geometryType
        , id
        , properties
        , getProperty
        , hasProperty
        , isEqual
        , notEqual
        , lessThan
        , lessThanOrEqual
        , greaterThan
        , greaterThanOrEqual
        , isEqualWithCollator
        , notEqualWithCollator
        , lessThanWithCollator
        , lessThanOrEqualWithCollator
        , greaterThanWithCollator
        , greaterThanOrEqualWithCollator
        , not
        , all
        , any
        , ifElse
        , conditionally
        , matchesStr
        , matchesFloat
        , coalesce
        , interpolate
        , Interpolation(..)
        , step
        , append
        , downcase
        , upcase
        , isSupportedScript
        , resolvedLocale
        , makeRGBColor
        , makeRGBAColor
        , rgbaChannels
        , minus
        , multiply
        , divideBy
        , modBy
        , plus
        , raiseBy
        , sqrt
        , abs
        , ceil
        , floor
        , round
        , cos
        , sin
        , tan
        , acos
        , asin
        , atan
        , e
        , pi
        , ln
        , ln2
        , log10
        , log2
        , zoom
        , heatmapDensity
        , lineProgress
        , Anchor(..)
        , anchorMap
        , anchorViewport
        , AnchorAuto
        , anchorAutoMap
        , anchorAutoViewport
        , anchorAutoAuto
        , Position
        , positionCenter
        , positionLeft
        , positionRight
        , positionTop
        , positionBottom
        , positionTopLeft
        , positionTopRight
        , positionBottomLeft
        , positionBottomRight
        , TextFit
        , textFitNone
        , textFitWidth
        , textFitHeight
        , textFitBoth
        , LineCap
        , lineCapButt
        , lineCapRound
        , lineCapSquare
        , LineJoin
        , lineJoinBevel
        , lineJoinRound
        , lineJoinMiter
        , SymbolPlacement
        , symbolPlacementPoint
        , symbolPlacementLine
        , symbolPlacementLineCenter
        , TextJustify
        , textJustifyLeft
        , textJustifyCenter
        , textJustifyRight
        , TextTransform
        , textTransformNone
        , textTransformUppercase
        , textTransformLowercase
        , RasterResampling
        , rasterResamplingLinear
        , rasterResamplingNearest
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

@docs Color, Object, Collator

(And also a bunch of Enum types, that will be documented in the Enums section).

You can use the following functions to transfer Elm values into the Expression language:

@docs true, false, bool, int, float, str, rgba, floats, strings, object, collator, defaultCollator

In some cases, you will need to force the type system to cooperate.
The following assertions will force the type and cause a run-time error
if the type is wrong:

@docs assertArray, assertArrayOfStrings, assertArrayOfFloats, assertArrayOfBools, assertBool, assertFloat, assertObject, assertString

You can also use these functions to explicitly cast to a particular type:

@docs toBool, toColor, toFloat, toString

@docs typeof


### Lookup

@docs at, get, has, count, length


### Feature data

@docs featureState, geometryType, id, properties, getProperty, hasProperty


### Decision

The expressions in this section can be used to add conditional logic to your styles.

@docs isEqual, notEqual, lessThan, lessThanOrEqual, greaterThan, greaterThanOrEqual

Strings can be compared with a collator for locale specific comparisons:

@docs isEqualWithCollator, notEqualWithCollator,lessThanWithCollator, lessThanOrEqualWithCollator, greaterThanWithCollator, greaterThanOrEqualWithCollator

Logical operators:

@docs not, all, any

Control flow:

@docs ifElse, conditionally, matchesStr, matchesFloat, coalesce


### Ramps, scales, curves

@docs interpolate, Interpolation, step


### String

@docs append, downcase, upcase, isSupportedScript, resolvedLocale


### Color

@docs makeRGBColor, makeRGBAColor, rgbaChannels


### Math

@docs minus, multiply, divideBy, modBy, plus, raiseBy, sqrt, abs, ceil, floor, round, cos, sin, tan, acos, asin, atan, e, pi, ln, ln2, log10, log2


### Zoom

@docs zoom


### Heatmap

@docs heatmapDensity, lineProgress


### Enums

These are required for various layer properties.

@docs Anchor, anchorMap, anchorViewport, AnchorAuto, anchorAutoMap, anchorAutoViewport, anchorAutoAuto, Position, positionCenter, positionLeft, positionRight, positionTop, positionBottom, positionTopLeft, positionTopRight, positionBottomLeft, positionBottomRight, TextFit, textFitNone, textFitWidth, textFitHeight, textFitBoth, LineCap, lineCapButt, lineCapRound, lineCapSquare, LineJoin, lineJoinBevel, lineJoinRound, lineJoinMiter, SymbolPlacement, symbolPlacementPoint, symbolPlacementLine, symbolPlacementLineCenter, TextJustify, textJustifyLeft, textJustifyCenter, textJustifyRight, TextTransform, textTransformNone, textTransformUppercase, textTransformLowercase, RasterResampling, rasterResamplingLinear, rasterResamplingNearest

-}

import Array exposing (Array)
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
type Expression exprType resultType
    = Expression Value


{-| A camera expression is any expression that uses the zoom operator. Such expressions allow the the appearance of a layer
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
type Anchor
    = Map
    | Viewport


{-| -}
anchorMap : Expression exprType Anchor
anchorMap =
    Expression (Json.Encode.string "map")


{-| -}
anchorViewport : Expression exprType Anchor
anchorViewport =
    Expression (Json.Encode.string "viewport")


{-| -}
type AnchorAuto
    = AnchorAuto


{-| -}
anchorAutoMap : Expression exprType AnchorAuto
anchorAutoMap =
    Expression (Json.Encode.string "map")


{-| -}
anchorAutoViewport : Expression exprType AnchorAuto
anchorAutoViewport =
    Expression (Json.Encode.string "viewport")


{-| -}
anchorAutoAuto : Expression exprType AnchorAuto
anchorAutoAuto =
    Expression (Json.Encode.string "auto")


{-| -}
type Position
    = Position


{-| -}
positionCenter : Expression exprType Position
positionCenter =
    Expression (Json.Encode.string "center")


{-| -}
positionLeft : Expression exprType Position
positionLeft =
    Expression (Json.Encode.string "left")


{-| -}
positionRight : Expression exprType Position
positionRight =
    Expression (Json.Encode.string "right")


{-| -}
positionTop : Expression exprType Position
positionTop =
    Expression (Json.Encode.string "top")


{-| -}
positionBottom : Expression exprType Position
positionBottom =
    Expression (Json.Encode.string "bottom")


{-| -}
positionTopLeft : Expression exprType Position
positionTopLeft =
    Expression (Json.Encode.string "top-left")


{-| -}
positionTopRight : Expression exprType Position
positionTopRight =
    Expression (Json.Encode.string "top-right")


{-| -}
positionBottomLeft : Expression exprType Position
positionBottomLeft =
    Expression (Json.Encode.string "bottom-left")


{-| -}
positionBottomRight : Expression exprType Position
positionBottomRight =
    Expression (Json.Encode.string "bottom-right")


{-| -}
type TextFit
    = TextFit


{-| -}
textFitNone : Expression exprType TextFit
textFitNone =
    Expression (Json.Encode.string "none")


{-| -}
textFitWidth : Expression exprType TextFit
textFitWidth =
    Expression (Json.Encode.string "width")


{-| -}
textFitHeight : Expression exprType TextFit
textFitHeight =
    Expression (Json.Encode.string "height")


{-| -}
textFitBoth : Expression exprType TextFit
textFitBoth =
    Expression (Json.Encode.string "both")


{-| -}
type LineCap
    = LineCap


{-| -}
lineCapButt : Expression exprType LineCap
lineCapButt =
    Expression (Json.Encode.string "butt")


{-| -}
lineCapRound : Expression exprType LineCap
lineCapRound =
    Expression (Json.Encode.string "round")


{-| -}
lineCapSquare : Expression exprType LineCap
lineCapSquare =
    Expression (Json.Encode.string "square")


{-| -}
type LineJoin
    = LineJoin


{-| -}
lineJoinBevel : Expression exprType LineJoin
lineJoinBevel =
    Expression (Json.Encode.string "bevel")


{-| -}
lineJoinRound : Expression exprType LineJoin
lineJoinRound =
    Expression (Json.Encode.string "round")


{-| -}
lineJoinMiter : Expression exprType LineJoin
lineJoinMiter =
    Expression (Json.Encode.string "miter")


{-| Label placement relative to its geometry.
-}
type SymbolPlacement
    = SymbolPlacement


{-| The label is placed at the point where the geometry is located.
-}
symbolPlacementPoint : Expression exprType SymbolPlacement
symbolPlacementPoint =
    Expression (Json.Encode.string "point")


{-| The label is placed at the center of the line of the geometry. Can only be used on LineString and Polygon geometries. Note that a single feature in a vector tile may contain multiple line geometries.
-}
symbolPlacementLineCenter : Expression exprType SymbolPlacement
symbolPlacementLineCenter =
    Expression (Json.Encode.string "line-center")


{-| The label is placed along the line of the geometry. Can only be used on LineString and Polygon geometries.
-}
symbolPlacementLine : Expression exprType SymbolPlacement
symbolPlacementLine =
    Expression (Json.Encode.string "line")


{-| -}
type TextJustify
    = TextJustify


{-| -}
textJustifyLeft : Expression exprType TextJustify
textJustifyLeft =
    Expression (Json.Encode.string "left")


{-| -}
textJustifyCenter : Expression exprType TextJustify
textJustifyCenter =
    Expression (Json.Encode.string "center")


{-| -}
textJustifyRight : Expression exprType TextJustify
textJustifyRight =
    Expression (Json.Encode.string "right")


{-| -}
type TextTransform
    = TextTransform


{-| -}
textTransformNone : Expression exprType TextTransform
textTransformNone =
    Expression (Json.Encode.string "none")


{-| -}
textTransformUppercase : Expression exprType TextTransform
textTransformUppercase =
    Expression (Json.Encode.string "uppercase")


{-| -}
textTransformLowercase : Expression exprType TextTransform
textTransformLowercase =
    Expression (Json.Encode.string "lowercase")


{-| -}
type RasterResampling
    = RasterResampling


{-| (Bi)linear filtering interpolates pixel values using the weighted average of the four closest original source pixels creating a smooth but blurry look when overscaled.
-}
rasterResamplingLinear : Expression exprType RasterResampling
rasterResamplingLinear =
    Expression (Json.Encode.string "linear")


{-| Nearest neighbor filtering interpolates pixel values using the nearest original source pixel creating a sharp but pixelated look when overscaled.
-}
rasterResamplingNearest : Expression exprType RasterResampling
rasterResamplingNearest =
    Expression (Json.Encode.string "nearest")



-- literals


{-| -}
rgba : Float -> Float -> Float -> Float -> Expression exprType Color
rgba r g b a =
    Expression (Json.Encode.string ("rgba" ++ Basics.toString ( r, g, b, a )))


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
    List.map encode >> Json.Encode.list >> Expression >> call1 "literal"


{-| Returns a `Collator` for use in locale-dependent comparison operations. The first argument specifies if the comparison should be case sensitive. The second specifies if it is diacritic sensitive. The final locale argument specifies the IETF language tag of the locale to use.
-}
collator : Expression e1 Bool -> Expression e2 Bool -> Expression e3 String -> Expression e4 Collator
collator (Expression caseSensitive) (Expression diacriticSensitive) (Expression locale) =
    Expression
        (Json.Encode.list
            (Json.Encode.string "collator"
                :: [ Json.Encode.object
                        [ ( "case-sensitive", caseSensitive )
                        , ( "diacritic-sensitive", diacriticSensitive )
                        , ( "locale", locale )
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
    Expression (Json.Encode.list (Json.Encode.string name :: args))


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
          [ ("hospital", str "icon-hospital")
          , ("clinic", str "icon-medical")
          ]
          (str "icon-generic") -- fallback value
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
      |> matchesStr
          [ (1, str "icon-hospital")
          , (2, str "icon-medical")
          ]
          (str "icon-generic") -- fallback value
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
step : Expression exprType2 Float -> List ( Float, Expression exprType1 output ) -> Expression exprType1 output -> Expression exprType2 output
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


{-| Returns true if the input string is expected to render legibly. Returns false if the input string contains sections that cannot be rendered without potential loss of meaning (e.g. Indic scripts that require complex text shaping, or right-to-left scripts if the the mapbox-gl-rtl-text plugin is not in use in Mapbox GL JS).
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
