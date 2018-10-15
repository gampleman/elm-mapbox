module Mapbox.Layer
    exposing
        ( Background
        , Circle
        , Fill
        , FillExtrusion
        , Heatmap
        , Hillshade
        , Layer
        , LayerAttr
        , Line
        , Raster
        , SourceId
        , Symbol
        , background
        , backgroundColor
        , backgroundOpacity
        , backgroundPattern
        , circle
        , circleBlur
        , circleColor
        , circleOpacity
        , circlePitchAlignment
        , circlePitchScale
        , circleRadius
        , circleStrokeColor
        , circleStrokeOpacity
        , circleStrokeWidth
        , circleTranslate
        , circleTranslateAnchor
        , encode
        , fill
        , fillAntialias
        , fillColor
        , fillExtrusion
        , fillExtrusionBase
        , fillExtrusionColor
        , fillExtrusionHeight
        , fillExtrusionOpacity
        , fillExtrusionPattern
        , fillExtrusionTranslate
        , fillExtrusionTranslateAnchor
        , fillExtrusionVerticalGradient
        , fillOpacity
        , fillOutlineColor
        , fillPattern
        , fillTranslate
        , fillTranslateAnchor
        , filter
        , heatmap
        , heatmapColor
        , heatmapIntensity
        , heatmapOpacity
        , heatmapRadius
        , heatmapWeight
        , hillshade
        , hillshadeAccentColor
        , hillshadeExaggeration
        , hillshadeHighlightColor
        , hillshadeIlluminationAnchor
        , hillshadeIlluminationDirection
        , hillshadeShadowColor
        , iconAllowOverlap
        , iconAnchor
        , iconColor
        , iconHaloBlur
        , iconHaloColor
        , iconHaloWidth
        , iconIgnorePlacement
        , iconImage
        , iconKeepUpright
        , iconOffset
        , iconOpacity
        , iconOptional
        , iconPadding
        , iconPitchAlignment
        , iconRotate
        , iconRotationAlignment
        , iconSize
        , iconTextFit
        , iconTextFitPadding
        , iconTranslate
        , iconTranslateAnchor
        , line
        , lineBlur
        , lineCap
        , lineColor
        , lineDasharray
        , lineGapWidth
        , lineGradient
        , lineJoin
        , lineMiterLimit
        , lineOffset
        , lineOpacity
        , linePattern
        , lineRoundLimit
        , lineTranslate
        , lineTranslateAnchor
        , lineWidth
        , maxzoom
        , metadata
        , minzoom
        , raster
        , rasterBrightnessMax
        , rasterBrightnessMin
        , rasterContrast
        , rasterFadeDuration
        , rasterHueRotate
        , rasterOpacity
        , rasterResampling
        , rasterSaturation
        , sourceLayer
        , symbol
        , symbolAvoidEdges
        , symbolPlacement
        , symbolSpacing
        , symbolZOrder
        , textAllowOverlap
        , textAnchor
        , textColor
        , textField
        , textFont
        , textHaloBlur
        , textHaloColor
        , textHaloWidth
        , textIgnorePlacement
        , textJustify
        , textKeepUpright
        , textLetterSpacing
        , textLineHeight
        , textMaxAngle
        , textMaxWidth
        , textOffset
        , textOpacity
        , textOptional
        , textPadding
        , textPitchAlignment
        , textRotate
        , textRotationAlignment
        , textSize
        , textTransform
        , textTranslate
        , textTranslateAnchor
        , visible
        )

{-| Layers specify what is actually rendered on the map and are rendered in order.

Except for layers of the background type, each layer needs to refer to a source. Layers take the data that they get from a source, optionally filter features, and then define how those features are styled.

There are two kinds of properties: _Layout_ and _Paint_ properties.

Layout properties are applied early in the rendering process and define how data for that layer is passed to the GPU. Changes to a layout property require an asynchronous "layout" step.

Paint properties are applied later in the rendering process. Changes to a paint property are cheap and happen synchronously.


### Working with layers

@docs Layer, SourceId, encode


### Layer Types

@docs background, fill, symbol, line, raster, circle, fillExtrusion, heatmap, hillshade
@docs Background, Fill, Symbol, Line, Raster, Circle, FillExtrusion, Heatmap, Hillshade


### General Attributes

@docs LayerAttr
@docs metadata, sourceLayer, minzoom, maxzoom, filter, visible


### Fill Attributes

@docs fillAntialias, fillColor, fillOpacity, fillOutlineColor, fillPattern, fillTranslate, fillTranslateAnchor


### Line Attributes

@docs lineBlur, lineCap, lineColor, lineDasharray, lineGapWidth, lineGradient, lineJoin, lineMiterLimit, lineOffset, lineOpacity, linePattern, lineRoundLimit, lineTranslate, lineTranslateAnchor, lineWidth


### Circle Attributes

@docs circleBlur, circleColor, circleOpacity, circlePitchAlignment, circlePitchScale, circleRadius, circleStrokeColor, circleStrokeOpacity, circleStrokeWidth, circleTranslate, circleTranslateAnchor


### Heatmap Attributes

@docs heatmapColor, heatmapIntensity, heatmapOpacity, heatmapRadius, heatmapWeight


### FillExtrusion Attributes

@docs fillExtrusionBase, fillExtrusionColor, fillExtrusionHeight, fillExtrusionOpacity, fillExtrusionPattern, fillExtrusionTranslate, fillExtrusionTranslateAnchor, fillExtrusionVerticalGradient


### Symbol Attributes

@docs iconAllowOverlap, iconAnchor, iconColor, iconHaloBlur, iconHaloColor, iconHaloWidth, iconIgnorePlacement, iconImage, iconKeepUpright, iconOffset, iconOpacity, iconOptional, iconPadding, iconPitchAlignment, iconRotate, iconRotationAlignment, iconSize, iconTextFit, iconTextFitPadding, iconTranslate, iconTranslateAnchor, symbolAvoidEdges, symbolPlacement, symbolSpacing, symbolZOrder, textAllowOverlap, textAnchor, textColor, textField, textFont, textHaloBlur, textHaloColor, textHaloWidth, textIgnorePlacement, textJustify, textKeepUpright, textLetterSpacing, textLineHeight, textMaxAngle, textMaxWidth, textOffset, textOpacity, textOptional, textPadding, textPitchAlignment, textRotate, textRotationAlignment, textSize, textTransform, textTranslate, textTranslateAnchor


### Raster Attributes

@docs rasterBrightnessMax, rasterBrightnessMin, rasterContrast, rasterFadeDuration, rasterHueRotate, rasterOpacity, rasterResampling, rasterSaturation


### Hillshade Attributes

@docs hillshadeAccentColor, hillshadeExaggeration, hillshadeHighlightColor, hillshadeIlluminationAnchor, hillshadeIlluminationDirection, hillshadeShadowColor


### Background Attributes

@docs backgroundColor, backgroundOpacity, backgroundPattern

-}

import Array exposing (Array)
import Json.Encode as Encode exposing (Value)
import Mapbox.Expression as Expression exposing (Anchor, Auto, CameraExpression, Color, DataExpression, Expression, FormattedText, LineCap, LineJoin, Position, RasterResampling, SymbolPlacement, SymbolZOrder, TextFit, TextJustify, TextTransform)


{-| Represents a layer.
-}
type Layer
    = Layer Value


{-| All layers (except background layers) need a source
-}
type alias SourceId =
    String


{-| -}
type Background
    = BackgroundLayer


{-| -}
type Fill
    = FillLayer


{-| -}
type Symbol
    = SymbolLayer


{-| -}
type Line
    = LineLayer


{-| -}
type Raster
    = RasterLayer


{-| -}
type Circle
    = CircleLayer


{-| -}
type FillExtrusion
    = FillExtrusionLayer


{-| -}
type Heatmap
    = HeatmapLayer


{-| -}
type Hillshade
    = HillshadeLayer


{-| Turns a layer into JSON
-}
encode : Layer -> Value
encode (Layer value) =
    value


layerImpl tipe id source attrs =
    [ ( "type", Encode.string tipe )
    , ( "id", Encode.string id )
    , ( "source", Encode.string source )
    ]
        ++ encodeAttrs attrs
        |> Encode.object
        |> Layer


encodeAttrs attrs =
    let
        { top, layout, paint } =
            List.foldl
                (\attr lists ->
                    case attr of
                        Top key val ->
                            { lists | top = ( key, val ) :: lists.top }

                        Paint key val ->
                            { lists | paint = ( key, val ) :: lists.paint }

                        Layout key val ->
                            { lists | layout = ( key, val ) :: lists.layout }
                )
                { top = [], layout = [], paint = [] }
                attrs
    in
    ( "layout", Encode.object layout ) :: ( "paint", Encode.object paint ) :: top


{-| The background color or pattern of the map.
-}
background : String -> List (LayerAttr Background) -> Layer
background id attrs =
    [ ( "type", Encode.string "background" )
    , ( "id", Encode.string id )
    ]
        ++ encodeAttrs attrs
        |> Encode.object
        |> Layer


{-| A filled polygon with an optional stroked border.
-}
fill : String -> SourceId -> List (LayerAttr Fill) -> Layer
fill =
    layerImpl "fill"


{-| A stroked line.
-}
line : String -> SourceId -> List (LayerAttr Line) -> Layer
line =
    layerImpl "line"


{-| An icon or a text label.
-}
symbol : String -> SourceId -> List (LayerAttr Symbol) -> Layer
symbol =
    layerImpl "symbol"


{-| Raster map textures such as satellite imagery.
-}
raster : String -> SourceId -> List (LayerAttr Raster) -> Layer
raster =
    layerImpl "raster"


{-| A filled circle.
-}
circle : String -> SourceId -> List (LayerAttr Circle) -> Layer
circle =
    layerImpl "circle"


{-| An extruded (3D) polygon.
-}
fillExtrusion : String -> SourceId -> List (LayerAttr FillExtrusion) -> Layer
fillExtrusion =
    layerImpl "fill-extrusion"


{-| A heatmap.
-}
heatmap : String -> SourceId -> List (LayerAttr Heatmap) -> Layer
heatmap =
    layerImpl "heatmap"


{-| Client-side hillshading visualization based on DEM data. Currently, the implementation only supports Mapbox Terrain RGB and Mapzen Terrarium tiles.
-}
hillshade : String -> SourceId -> List (LayerAttr Hillshade) -> Layer
hillshade =
    layerImpl "hillshade"


{-| -}
type LayerAttr tipe
    = Top String Value
    | Paint String Value
    | Layout String Value



-- General Attributes


{-| Arbitrary properties useful to track with the layer, but do not influence rendering. Properties should be prefixed to avoid collisions, like 'mapbox:'.
-}
metadata : Value -> LayerAttr all
metadata =
    Top "metadata"


{-| Layer to use from a vector tile source. Required for vector tile sources; prohibited for all other source types, including GeoJSON sources.
-}
sourceLayer : String -> LayerAttr all
sourceLayer =
    Encode.string >> Top "source-layer"


{-| The minimum zoom level for the layer. At zoom levels less than the minzoom, the layer will be hidden. A number between 0 and 24 inclusive.
-}
minzoom : Float -> LayerAttr all
minzoom =
    Encode.float >> Top "minzoom"


{-| The maximum zoom level for the layer. At zoom levels equal to or greater than the maxzoom, the layer will be hidden. A number between 0 and 24 inclusive.
-}
maxzoom : Float -> LayerAttr all
maxzoom =
    Encode.float >> Top "maxzoom"


{-| A expression specifying conditions on source features. Only features that match the filter are displayed.
-}
filter : Expression any Bool -> LayerAttr all
filter =
    Expression.encode >> Top "filter"


{-| Whether this layer is displayed.
-}
visible : Expression CameraExpression Bool -> LayerAttr any
visible vis =
    Layout "visibility" <| Expression.encode <| Expression.ifElse vis (Expression.str "visible") (Expression.str "none")



-- Fill


{-| Controls the frame of reference for `fillTranslate`. Paint property. Defaults to `anchorMap`. Requires `fillTranslate`.

  - `anchorMap`: The fill is translated relative to the map.
  - `anchorViewport`: The fill is translated relative to the viewport.

-}
fillTranslateAnchor : Expression CameraExpression (Anchor Never) -> LayerAttr Fill
fillTranslateAnchor =
    Expression.encode >> Paint "fill-translate-anchor"


{-| Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels. Paint property.
-}
fillPattern : Expression any String -> LayerAttr Fill
fillPattern =
    Expression.encode >> Paint "fill-pattern"


{-| The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used. Paint property. Defaults to `#000000`. Disabled by `fillPattern`.
-}
fillColor : Expression any Color -> LayerAttr Fill
fillColor =
    Expression.encode >> Paint "fill-color"


{-| The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Paint property.
Units in pixels. Defaults to `0,0`.
-}
fillTranslate : Expression CameraExpression (Array Float) -> LayerAttr Fill
fillTranslate =
    Expression.encode >> Paint "fill-translate"


{-| The opacity of the entire fill layer. In contrast to the `fillColor`, this value will also affect the 1px stroke around the fill, if the stroke is used. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`.

-}
fillOpacity : Expression any Float -> LayerAttr Fill
fillOpacity =
    Expression.encode >> Paint "fill-opacity"


{-| The outline color of the fill. Matches the value of `fillColor` if unspecified. Paint property. Disabled by `fillPattern`. Requires `fillAntialias` to be `true`.
-}
fillOutlineColor : Expression any Color -> LayerAttr Fill
fillOutlineColor =
    Expression.encode >> Paint "fill-outline-color"


{-| Whether or not the fill should be antialiased. Paint property. Defaults to `true`.
-}
fillAntialias : Expression CameraExpression Bool -> LayerAttr Fill
fillAntialias =
    Expression.encode >> Paint "fill-antialias"



-- Line


{-| Blur applied to the line, in pixels. Paint property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `0`.

-}
lineBlur : Expression any Float -> LayerAttr Line
lineBlur =
    Expression.encode >> Paint "line-blur"


{-| Controls the frame of reference for `lineTranslate`. Paint property. Defaults to `anchorMap`. Requires `lineTranslate`.

  - `anchorMap`: The line is translated relative to the map.
  - `anchorViewport`: The line is translated relative to the viewport.

-}
lineTranslateAnchor : Expression CameraExpression (Anchor Never) -> LayerAttr Line
lineTranslateAnchor =
    Expression.encode >> Paint "line-translate-anchor"


{-| Defines a gradient with which to color a line feature. Can only be used with GeoJSON sources that specify `"lineMetrics": true`. Paint property. Disabled by `lineDasharray`. Disabled by `linePattern`. Requires `source` to be `geojson`.
-}
lineGradient : Expression CameraExpression Color -> LayerAttr Line
lineGradient =
    Expression.encode >> Paint "line-gradient"


{-| Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Paint property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `0`.

-}
lineGapWidth : Expression any Float -> LayerAttr Line
lineGapWidth =
    Expression.encode >> Paint "line-gap-width"


{-| Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels. Paint property.
-}
linePattern : Expression any String -> LayerAttr Line
linePattern =
    Expression.encode >> Paint "line-pattern"


{-| Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Paint property.

Should be greater than or equal to `0`.
Units in line widths. Disabled by `linePattern`.

-}
lineDasharray : Expression CameraExpression (Array Float) -> LayerAttr Line
lineDasharray =
    Expression.encode >> Paint "line-dasharray"


{-| Stroke thickness. Paint property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `1`.

-}
lineWidth : Expression any Float -> LayerAttr Line
lineWidth =
    Expression.encode >> Paint "line-width"


{-| The color with which the line will be drawn. Paint property. Defaults to `#000000`. Disabled by `linePattern`.
-}
lineColor : Expression any Color -> LayerAttr Line
lineColor =
    Expression.encode >> Paint "line-color"


{-| The display of line endings. Layout property. Defaults to `lineCapButt`.
-}
lineCap : Expression CameraExpression LineCap -> LayerAttr Line
lineCap =
    Expression.encode >> Layout "line-cap"


{-| The display of lines when joining. Layout property. Defaults to `lineJoinMiter`.
-}
lineJoin : Expression any LineJoin -> LayerAttr Line
lineJoin =
    Expression.encode >> Layout "line-join"


{-| The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Paint property.
Units in pixels. Defaults to `0,0`.
-}
lineTranslate : Expression CameraExpression (Array Float) -> LayerAttr Line
lineTranslate =
    Expression.encode >> Paint "line-translate"


{-| The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Paint property.
Units in pixels. Defaults to `0`.
-}
lineOffset : Expression any Float -> LayerAttr Line
lineOffset =
    Expression.encode >> Paint "line-offset"


{-| The opacity at which the line will be drawn. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`.

-}
lineOpacity : Expression any Float -> LayerAttr Line
lineOpacity =
    Expression.encode >> Paint "line-opacity"


{-| Used to automatically convert miter joins to bevel joins for sharp angles. Layout property. Defaults to `2`. Requires `lineJoin` to be `miter`.
-}
lineMiterLimit : Expression CameraExpression Float -> LayerAttr Line
lineMiterLimit =
    Expression.encode >> Layout "line-miter-limit"


{-| Used to automatically convert round joins to miter joins for shallow angles. Layout property. Defaults to `1.05`. Requires `lineJoin` to be `round`.
-}
lineRoundLimit : Expression CameraExpression Float -> LayerAttr Line
lineRoundLimit =
    Expression.encode >> Layout "line-round-limit"



-- Circle


{-| Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Paint property. Defaults to `0`.
-}
circleBlur : Expression any Float -> LayerAttr Circle
circleBlur =
    Expression.encode >> Paint "circle-blur"


{-| Circle radius. Paint property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `5`.

-}
circleRadius : Expression any Float -> LayerAttr Circle
circleRadius =
    Expression.encode >> Paint "circle-radius"


{-| Controls the frame of reference for `circleTranslate`. Paint property. Defaults to `anchorMap`. Requires `circleTranslate`.

  - `anchorMap`: The circle is translated relative to the map.
  - `anchorViewport`: The circle is translated relative to the viewport.

-}
circleTranslateAnchor : Expression CameraExpression (Anchor Never) -> LayerAttr Circle
circleTranslateAnchor =
    Expression.encode >> Paint "circle-translate-anchor"


{-| Controls the scaling behavior of the circle when the map is pitched. Paint property. Defaults to `anchorMap`.

  - `anchorMap`: Circles are scaled according to their apparent distance to the camera.
  - `anchorViewport`: Circles are not scaled.

-}
circlePitchScale : Expression CameraExpression (Anchor Never) -> LayerAttr Circle
circlePitchScale =
    Expression.encode >> Paint "circle-pitch-scale"


{-| Orientation of circle when map is pitched. Paint property. Defaults to `anchorViewport`.

  - `anchorMap`: The circle is aligned to the plane of the map.
  - `anchorViewport`: The circle is aligned to the plane of the viewport.

-}
circlePitchAlignment : Expression CameraExpression (Anchor Never) -> LayerAttr Circle
circlePitchAlignment =
    Expression.encode >> Paint "circle-pitch-alignment"


{-| The fill color of the circle. Paint property. Defaults to `#000000`.
-}
circleColor : Expression any Color -> LayerAttr Circle
circleColor =
    Expression.encode >> Paint "circle-color"


{-| The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Paint property.
Units in pixels. Defaults to `0,0`.
-}
circleTranslate : Expression CameraExpression (Array Float) -> LayerAttr Circle
circleTranslate =
    Expression.encode >> Paint "circle-translate"


{-| The opacity at which the circle will be drawn. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`.

-}
circleOpacity : Expression any Float -> LayerAttr Circle
circleOpacity =
    Expression.encode >> Paint "circle-opacity"


{-| The opacity of the circle's stroke. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`.

-}
circleStrokeOpacity : Expression any Float -> LayerAttr Circle
circleStrokeOpacity =
    Expression.encode >> Paint "circle-stroke-opacity"


{-| The stroke color of the circle. Paint property. Defaults to `#000000`.
-}
circleStrokeColor : Expression any Color -> LayerAttr Circle
circleStrokeColor =
    Expression.encode >> Paint "circle-stroke-color"


{-| The width of the circle's stroke. Strokes are placed outside of the `circleRadius`. Paint property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `0`.

-}
circleStrokeWidth : Expression any Float -> LayerAttr Circle
circleStrokeWidth =
    Expression.encode >> Paint "circle-stroke-width"



-- Heatmap


{-| A measure of how much an individual point contributes to the heatmap. A value of 10 would be equivalent to having 10 points of weight 1 in the same spot. Especially useful when combined with clustering. Paint property.

Should be greater than or equal to `0`. Defaults to `1`.

-}
heatmapWeight : Expression any Float -> LayerAttr Heatmap
heatmapWeight =
    Expression.encode >> Paint "heatmap-weight"


{-| Defines the color of each pixel based on its density value in a heatmap. The value should be an Expression that uses `heatmapDensity` as input. Defaults to:

      E.heatmapDensity
      |> E.interpolate E.Linear
        [ (0.0, rgba 0 0 255 0)
        , (0.1, rgba 65 105 225 1)
        , (0.3, rgba 0 255 255 1)
        , (0.5, rgba 0 255 0 1)
        , (0.7, rgba 255 255 0 1)
        , (1.0, rgba 255 0 0 1)] Paint property.

-}
heatmapColor : Expression CameraExpression Color -> LayerAttr Heatmap
heatmapColor =
    Expression.encode >> Paint "heatmap-color"


{-| Radius of influence of one heatmap point in pixels. Increasing the value makes the heatmap smoother, but less detailed. Paint property.

Should be greater than or equal to `1`.
Units in pixels. Defaults to `30`.

-}
heatmapRadius : Expression any Float -> LayerAttr Heatmap
heatmapRadius =
    Expression.encode >> Paint "heatmap-radius"


{-| Similar to `heatmapWeight` but controls the intensity of the heatmap globally. Primarily used for adjusting the heatmap based on zoom level. Paint property.

Should be greater than or equal to `0`. Defaults to `1`.

-}
heatmapIntensity : Expression CameraExpression Float -> LayerAttr Heatmap
heatmapIntensity =
    Expression.encode >> Paint "heatmap-intensity"


{-| The global opacity at which the heatmap layer will be drawn. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`.

-}
heatmapOpacity : Expression CameraExpression Float -> LayerAttr Heatmap
heatmapOpacity =
    Expression.encode >> Paint "heatmap-opacity"



-- FillExtrusion


{-| Controls the frame of reference for `fillExtrusionTranslate`. Paint property. Defaults to `anchorMap`. Requires `fillExtrusionTranslate`.

  - `anchorMap`: The fill extrusion is translated relative to the map.
  - `anchorViewport`: The fill extrusion is translated relative to the viewport.

-}
fillExtrusionTranslateAnchor : Expression CameraExpression (Anchor Never) -> LayerAttr FillExtrusion
fillExtrusionTranslateAnchor =
    Expression.encode >> Paint "fill-extrusion-translate-anchor"


{-| Name of image in sprite to use for drawing images on extruded fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels. Paint property.
-}
fillExtrusionPattern : Expression any String -> LayerAttr FillExtrusion
fillExtrusionPattern =
    Expression.encode >> Paint "fill-extrusion-pattern"


{-| The base color of the extruded fill. The extrusion's surfaces will be shaded differently based on this color in combination with the root `light` settings. If this color is specified as `rgba` with an alpha component, the alpha component will be ignored; use `fillExtrusionOpacity` to set layer opacity. Paint property. Defaults to `#000000`. Disabled by `fillExtrusionPattern`.
-}
fillExtrusionColor : Expression any Color -> LayerAttr FillExtrusion
fillExtrusionColor =
    Expression.encode >> Paint "fill-extrusion-color"


{-| The geometry's offset. Values are [x, y] where negatives indicate left and up (on the flat plane), respectively. Paint property.
Units in pixels. Defaults to `0,0`.
-}
fillExtrusionTranslate : Expression CameraExpression (Array Float) -> LayerAttr FillExtrusion
fillExtrusionTranslate =
    Expression.encode >> Paint "fill-extrusion-translate"


{-| The height with which to extrude the base of this layer. Must be less than or equal to `fillExtrusionHeight`. Paint property.

Should be greater than or equal to `0`.
Units in meters. Defaults to `0`. Requires `fillExtrusionHeight`.

-}
fillExtrusionBase : Expression any Float -> LayerAttr FillExtrusion
fillExtrusionBase =
    Expression.encode >> Paint "fill-extrusion-base"


{-| The height with which to extrude this layer. Paint property.

Should be greater than or equal to `0`.
Units in meters. Defaults to `0`.

-}
fillExtrusionHeight : Expression any Float -> LayerAttr FillExtrusion
fillExtrusionHeight =
    Expression.encode >> Paint "fill-extrusion-height"


{-| The opacity of the entire fill extrusion layer. This is rendered on a per-layer, not per-feature, basis, and data-driven styling is not available. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`.

-}
fillExtrusionOpacity : Expression CameraExpression Float -> LayerAttr FillExtrusion
fillExtrusionOpacity =
    Expression.encode >> Paint "fill-extrusion-opacity"


{-| Whether to apply a vertical gradient to the sides of a fill-extrusion layer. If true, sides will be shaded slightly darker farther down. Paint property. Defaults to `true`.
-}
fillExtrusionVerticalGradient : Expression CameraExpression Bool -> LayerAttr FillExtrusion
fillExtrusionVerticalGradient =
    Expression.encode >> Paint "fill-extrusion-vertical-gradient"



-- Symbol


{-| Controls the frame of reference for `iconTranslate`. Paint property. Defaults to `anchorMap`. Requires `iconImage`. Requires `iconTranslate`.

  - `anchorMap`: Icons are translated relative to the map.
  - `anchorViewport`: Icons are translated relative to the viewport.

-}
iconTranslateAnchor : Expression CameraExpression (Anchor Never) -> LayerAttr Symbol
iconTranslateAnchor =
    Expression.encode >> Paint "icon-translate-anchor"


{-| Controls the frame of reference for `textTranslate`. Paint property. Defaults to `anchorMap`. Requires `textField`. Requires `textTranslate`.

  - `anchorMap`: The text is translated relative to the map.
  - `anchorViewport`: The text is translated relative to the viewport.

-}
textTranslateAnchor : Expression CameraExpression (Anchor Never) -> LayerAttr Symbol
textTranslateAnchor =
    Expression.encode >> Paint "text-translate-anchor"


{-| Controls the order in which overlapping symbols in the same layer are rendered Layout property. Defaults to `orderViewportY`.
-}
symbolZOrder : Expression CameraExpression SymbolZOrder -> LayerAttr Symbol
symbolZOrder =
    Expression.encode >> Layout "symbol-z-order"


{-| Distance between two symbol anchors. Layout property.

Should be greater than or equal to `1`.
Units in pixels. Defaults to `250`. Requires `symbolPlacement` to be `line`.

-}
symbolSpacing : Expression CameraExpression Float -> LayerAttr Symbol
symbolSpacing =
    Expression.encode >> Layout "symbol-spacing"


{-| Distance of halo to the font outline. Max text halo width is 1/4 of the font-size. Paint property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `0`. Requires `textField`.

-}
textHaloWidth : Expression any Float -> LayerAttr Symbol
textHaloWidth =
    Expression.encode >> Paint "text-halo-width"


{-| Distance of halo to the icon outline. Paint property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `0`. Requires `iconImage`.

-}
iconHaloWidth : Expression any Float -> LayerAttr Symbol
iconHaloWidth =
    Expression.encode >> Paint "icon-halo-width"


{-| Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Paint property.
Units in pixels. Defaults to `0,0`. Requires `iconImage`.
-}
iconTranslate : Expression CameraExpression (Array Float) -> LayerAttr Symbol
iconTranslate =
    Expression.encode >> Paint "icon-translate"


{-| Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Paint property.
Units in pixels. Defaults to `0,0`. Requires `textField`.
-}
textTranslate : Expression CameraExpression (Array Float) -> LayerAttr Symbol
textTranslate =
    Expression.encode >> Paint "text-translate"


{-| Fade out the halo towards the outside. Paint property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `0`. Requires `iconImage`.

-}
iconHaloBlur : Expression any Float -> LayerAttr Symbol
iconHaloBlur =
    Expression.encode >> Paint "icon-halo-blur"


{-| Font size. Layout property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `16`. Requires `textField`.

-}
textSize : Expression any Float -> LayerAttr Symbol
textSize =
    Expression.encode >> Layout "text-size"


{-| Font stack to use for displaying text. Layout property. Requires `textField`.
-}
textFont : Expression any (Array String) -> LayerAttr Symbol
textFont =
    Expression.encode >> Layout "text-font"


{-| If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not. Layout property. Defaults to `false`. Requires `textField`. Requires `iconImage`.
-}
textOptional : Expression CameraExpression Bool -> LayerAttr Symbol
textOptional =
    Expression.encode >> Layout "text-optional"


{-| If true, other symbols can be visible even if they collide with the icon. Layout property. Defaults to `false`. Requires `iconImage`.
-}
iconIgnorePlacement : Expression CameraExpression Bool -> LayerAttr Symbol
iconIgnorePlacement =
    Expression.encode >> Layout "icon-ignore-placement"


{-| If true, other symbols can be visible even if they collide with the text. Layout property. Defaults to `false`. Requires `textField`.
-}
textIgnorePlacement : Expression CameraExpression Bool -> LayerAttr Symbol
textIgnorePlacement =
    Expression.encode >> Layout "text-ignore-placement"


{-| If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not. Layout property. Defaults to `false`. Requires `iconImage`. Requires `textField`.
-}
iconOptional : Expression CameraExpression Bool -> LayerAttr Symbol
iconOptional =
    Expression.encode >> Layout "icon-optional"


{-| If true, the icon may be flipped to prevent it from being rendered upside-down. Layout property. Defaults to `false`. Requires `iconImage`. Requires `iconRotationAlignment` to be `map`. Requires `symbolPlacement` to be `symbolPlacementLine`, or `symbolPlacementLineCenter`.
-}
iconKeepUpright : Expression CameraExpression Bool -> LayerAttr Symbol
iconKeepUpright =
    Expression.encode >> Layout "icon-keep-upright"


{-| If true, the icon will be visible even if it collides with other previously drawn symbols. Layout property. Defaults to `false`. Requires `iconImage`.
-}
iconAllowOverlap : Expression CameraExpression Bool -> LayerAttr Symbol
iconAllowOverlap =
    Expression.encode >> Layout "icon-allow-overlap"


{-| If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. Layout property. Defaults to `false`.
-}
symbolAvoidEdges : Expression CameraExpression Bool -> LayerAttr Symbol
symbolAvoidEdges =
    Expression.encode >> Layout "symbol-avoid-edges"


{-| If true, the text may be flipped vertically to prevent it from being rendered upside-down. Layout property. Defaults to `true`. Requires `textField`. Requires `textRotationAlignment` to be `map`. Requires `symbolPlacement` to be `symbolPlacementLine`, or `symbolPlacementLineCenter`.
-}
textKeepUpright : Expression CameraExpression Bool -> LayerAttr Symbol
textKeepUpright =
    Expression.encode >> Layout "text-keep-upright"


{-| If true, the text will be visible even if it collides with other previously drawn symbols. Layout property. Defaults to `false`. Requires `textField`.
-}
textAllowOverlap : Expression CameraExpression Bool -> LayerAttr Symbol
textAllowOverlap =
    Expression.encode >> Layout "text-allow-overlap"


{-| In combination with `symbolPlacement`, determines the rotation behavior of icons. Layout property. Defaults to `anchorAuto`. Requires `iconImage`.

  - `anchorMap`: When `symbolPlacement` is set to `symbolPlacementPoint`, aligns icons east-west. When `symbolPlacement` is set to `symbolPlacementLine` or `symbolPlacementLineCenter`, aligns icon x-axes with the line.
  - `anchorViewport`: Produces icons whose x-axes are aligned with the x-axis of the viewport, regardless of the value of `symbolPlacement`.
  - `anchorAuto`: When `symbolPlacement` is set to `symbolPlacementPoint`, this is equivalent to `anchorViewport`. When `symbolPlacement` is set to `symbolPlacementLine` or `symbolPlacementLineCenter`, this is equivalent to `anchorMap`.

-}
iconRotationAlignment : Expression CameraExpression (Anchor Auto) -> LayerAttr Symbol
iconRotationAlignment =
    Expression.encode >> Layout "icon-rotation-alignment"


{-| In combination with `symbolPlacement`, determines the rotation behavior of the individual glyphs forming the text. Layout property. Defaults to `anchorAuto`. Requires `textField`.

  - `anchorMap`: When `symbolPlacement` is set to `symbolPlacementPoint`, aligns text east-west. When `symbolPlacement` is set to `symbolPlacementLine` or `symbolPlacementLineCenter`, aligns text x-axes with the line.
  - `anchorViewport`: Produces glyphs whose x-axes are aligned with the x-axis of the viewport, regardless of the value of `symbolPlacement`.
  - `anchorAuto`: When `symbolPlacement` is set to `symbolPlacementPoint`, this is equivalent to `anchorViewport`. When `symbolPlacement` is set to `symbolPlacementLine` or `symbolPlacementLineCenter`, this is equivalent to `anchorMap`.

-}
textRotationAlignment : Expression CameraExpression (Anchor Auto) -> LayerAttr Symbol
textRotationAlignment =
    Expression.encode >> Layout "text-rotation-alignment"


{-| Label placement relative to its geometry. Layout property. Defaults to `symbolPlacementPoint`.
-}
symbolPlacement : Expression CameraExpression SymbolPlacement -> LayerAttr Symbol
symbolPlacement =
    Expression.encode >> Layout "symbol-placement"


{-| Maximum angle change between adjacent characters. Layout property.
Units in degrees. Defaults to `45`. Requires `textField`. Requires `symbolPlacement` to be `symbolPlacementLine`, or `symbolPlacementLineCenter`.
-}
textMaxAngle : Expression CameraExpression Float -> LayerAttr Symbol
textMaxAngle =
    Expression.encode >> Layout "text-max-angle"


{-| Name of image in sprite to use for drawing an image background. Layout property.
-}
iconImage : Expression any String -> LayerAttr Symbol
iconImage =
    Expression.encode >> Layout "icon-image"


{-| Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `iconSize` to obtain the final offset in pixels. When combined with `iconRotate` the offset will be as if the rotated direction was up. Layout property. Defaults to `0,0`. Requires `iconImage`.
-}
iconOffset : Expression any (Array Float) -> LayerAttr Symbol
iconOffset =
    Expression.encode >> Layout "icon-offset"


{-| Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. Layout property.
Units in ems. Defaults to `0,0`. Requires `textField`.
-}
textOffset : Expression any (Array Float) -> LayerAttr Symbol
textOffset =
    Expression.encode >> Layout "text-offset"


{-| Orientation of icon when map is pitched. Layout property. Defaults to `anchorAuto`. Requires `iconImage`.

  - `anchorMap`: The icon is aligned to the plane of the map.
  - `anchorViewport`: The icon is aligned to the plane of the viewport.
  - `anchorAuto`: Automatically matches the value of `iconRotationAlignment`.

-}
iconPitchAlignment : Expression CameraExpression (Anchor Auto) -> LayerAttr Symbol
iconPitchAlignment =
    Expression.encode >> Layout "icon-pitch-alignment"


{-| Orientation of text when map is pitched. Layout property. Defaults to `anchorAuto`. Requires `textField`.

  - `anchorMap`: The text is aligned to the plane of the map.
  - `anchorViewport`: The text is aligned to the plane of the viewport.
  - `anchorAuto`: Automatically matches the value of `textRotationAlignment`.

-}
textPitchAlignment : Expression CameraExpression (Anchor Auto) -> LayerAttr Symbol
textPitchAlignment =
    Expression.encode >> Layout "text-pitch-alignment"


{-| Part of the icon placed closest to the anchor. Layout property. Defaults to `positionCenter`. Requires `iconImage`.
-}
iconAnchor : Expression any Position -> LayerAttr Symbol
iconAnchor =
    Expression.encode >> Layout "icon-anchor"


{-| Part of the text placed closest to the anchor. Layout property. Defaults to `positionCenter`. Requires `textField`.
-}
textAnchor : Expression any Position -> LayerAttr Symbol
textAnchor =
    Expression.encode >> Layout "text-anchor"


{-| Rotates the icon clockwise. Layout property.
Units in degrees. Defaults to `0`. Requires `iconImage`.
-}
iconRotate : Expression any Float -> LayerAttr Symbol
iconRotate =
    Expression.encode >> Layout "icon-rotate"


{-| Rotates the text clockwise. Layout property.
Units in degrees. Defaults to `0`. Requires `textField`.
-}
textRotate : Expression any Float -> LayerAttr Symbol
textRotate =
    Expression.encode >> Layout "text-rotate"


{-| Scales the icon to fit around the associated text. Layout property. Defaults to `textFitNone`. Requires `iconImage`. Requires `textField`.
-}
iconTextFit : Expression CameraExpression TextFit -> LayerAttr Symbol
iconTextFit =
    Expression.encode >> Layout "icon-text-fit"


{-| Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `iconSize`. 1 is the original size; 3 triples the size of the image. Layout property.

Should be greater than or equal to `0`.
Units in factor of the original icon size. Defaults to `1`. Requires `iconImage`.

-}
iconSize : Expression any Float -> LayerAttr Symbol
iconSize =
    Expression.encode >> Layout "icon-size"


{-| Size of the additional area added to dimensions determined by `iconTextFit`, in clockwise order: top, right, bottom, left. Layout property.
Units in pixels. Defaults to `0,0,0,0`. Requires `iconImage`. Requires `textField`. Requires `iconTextFit` to be `textFitBoth`, or `textFitWidth`, or `textFitHeight`.
-}
iconTextFitPadding : Expression CameraExpression (Array Float) -> LayerAttr Symbol
iconTextFitPadding =
    Expression.encode >> Layout "icon-text-fit-padding"


{-| Size of the additional area around the icon bounding box used for detecting symbol collisions. Layout property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `2`. Requires `iconImage`.

-}
iconPadding : Expression CameraExpression Float -> LayerAttr Symbol
iconPadding =
    Expression.encode >> Layout "icon-padding"


{-| Size of the additional area around the text bounding box used for detecting symbol collisions. Layout property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `2`. Requires `textField`.

-}
textPadding : Expression CameraExpression Float -> LayerAttr Symbol
textPadding =
    Expression.encode >> Layout "text-padding"


{-| Specifies how to capitalize text, similar to the CSS `textTransform` property. Layout property. Defaults to `textTransformNone`. Requires `textField`.
-}
textTransform : Expression any TextTransform -> LayerAttr Symbol
textTransform =
    Expression.encode >> Layout "text-transform"


{-| Text justification options. Layout property. Defaults to `textJustifyCenter`. Requires `textField`.
-}
textJustify : Expression any TextJustify -> LayerAttr Symbol
textJustify =
    Expression.encode >> Layout "text-justify"


{-| Text leading value for multi-line text. Layout property.
Units in ems. Defaults to `1.2`. Requires `textField`.
-}
textLineHeight : Expression CameraExpression Float -> LayerAttr Symbol
textLineHeight =
    Expression.encode >> Layout "text-line-height"


{-| Text tracking amount. Layout property.
Units in ems. Defaults to `0`. Requires `textField`.
-}
textLetterSpacing : Expression any Float -> LayerAttr Symbol
textLetterSpacing =
    Expression.encode >> Layout "text-letter-spacing"


{-| The color of the icon's halo. Icon halos can only be used with SDF icons. Paint property. Defaults to `rgba 0 0 0 0`. Requires `iconImage`.
-}
iconHaloColor : Expression any Color -> LayerAttr Symbol
iconHaloColor =
    Expression.encode >> Paint "icon-halo-color"


{-| The color of the icon. This can only be used with sdf icons. Paint property. Defaults to `#000000`. Requires `iconImage`.
-}
iconColor : Expression any Color -> LayerAttr Symbol
iconColor =
    Expression.encode >> Paint "icon-color"


{-| The color of the text's halo, which helps it stand out from backgrounds. Paint property. Defaults to `rgba 0 0 0 0`. Requires `textField`.
-}
textHaloColor : Expression any Color -> LayerAttr Symbol
textHaloColor =
    Expression.encode >> Paint "text-halo-color"


{-| The color with which the text will be drawn. Paint property. Defaults to `#000000`. Requires `textField`.
-}
textColor : Expression any Color -> LayerAttr Symbol
textColor =
    Expression.encode >> Paint "text-color"


{-| The halo's fadeout distance towards the outside. Paint property.

Should be greater than or equal to `0`.
Units in pixels. Defaults to `0`. Requires `textField`.

-}
textHaloBlur : Expression any Float -> LayerAttr Symbol
textHaloBlur =
    Expression.encode >> Paint "text-halo-blur"


{-| The maximum line width for text wrapping. Layout property.

Should be greater than or equal to `0`.
Units in ems. Defaults to `10`. Requires `textField`.

-}
textMaxWidth : Expression any Float -> LayerAttr Symbol
textMaxWidth =
    Expression.encode >> Layout "text-max-width"


{-| The opacity at which the icon will be drawn. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`. Requires `iconImage`.

-}
iconOpacity : Expression any Float -> LayerAttr Symbol
iconOpacity =
    Expression.encode >> Paint "icon-opacity"


{-| The opacity at which the text will be drawn. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`. Requires `textField`.

-}
textOpacity : Expression any Float -> LayerAttr Symbol
textOpacity =
    Expression.encode >> Paint "text-opacity"


{-| Value to use for a text label. Layout property. Defaults to ``.
-}
textField : Expression any FormattedText -> LayerAttr Symbol
textField =
    Expression.encode >> Layout "text-field"



-- Raster


{-| Fade duration when a new tile is added. Paint property.

Should be greater than or equal to `0`.
Units in milliseconds. Defaults to `300`.

-}
rasterFadeDuration : Expression CameraExpression Float -> LayerAttr Raster
rasterFadeDuration =
    Expression.encode >> Paint "raster-fade-duration"


{-| Increase or reduce the brightness of the image. The value is the maximum brightness. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`.

-}
rasterBrightnessMax : Expression CameraExpression Float -> LayerAttr Raster
rasterBrightnessMax =
    Expression.encode >> Paint "raster-brightness-max"


{-| Increase or reduce the brightness of the image. The value is the minimum brightness. Paint property.

Should be between `0` and `1` inclusive. Defaults to `0`.

-}
rasterBrightnessMin : Expression CameraExpression Float -> LayerAttr Raster
rasterBrightnessMin =
    Expression.encode >> Paint "raster-brightness-min"


{-| Increase or reduce the contrast of the image. Paint property.

Should be between `-1` and `1` inclusive. Defaults to `0`.

-}
rasterContrast : Expression CameraExpression Float -> LayerAttr Raster
rasterContrast =
    Expression.encode >> Paint "raster-contrast"


{-| Increase or reduce the saturation of the image. Paint property.

Should be between `-1` and `1` inclusive. Defaults to `0`.

-}
rasterSaturation : Expression CameraExpression Float -> LayerAttr Raster
rasterSaturation =
    Expression.encode >> Paint "raster-saturation"


{-| Rotates hues around the color wheel. Paint property.
Units in degrees. Defaults to `0`.
-}
rasterHueRotate : Expression CameraExpression Float -> LayerAttr Raster
rasterHueRotate =
    Expression.encode >> Paint "raster-hue-rotate"


{-| The opacity at which the image will be drawn. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`.

-}
rasterOpacity : Expression CameraExpression Float -> LayerAttr Raster
rasterOpacity =
    Expression.encode >> Paint "raster-opacity"


{-| The resampling/interpolation method to use for overscaling, also known as texture magnification filter Paint property. Defaults to `rasterResamplingLinear`.
-}
rasterResampling : Expression CameraExpression RasterResampling -> LayerAttr Raster
rasterResampling =
    Expression.encode >> Paint "raster-resampling"



-- Hillshade


{-| Direction of light source when map is rotated. Paint property. Defaults to `anchorViewport`.

  - `anchorMap`: The hillshade illumination is relative to the north direction.
  - `anchorViewport`: The hillshade illumination is relative to the top of the viewport.

-}
hillshadeIlluminationAnchor : Expression CameraExpression (Anchor Never) -> LayerAttr Hillshade
hillshadeIlluminationAnchor =
    Expression.encode >> Paint "hillshade-illumination-anchor"


{-| Intensity of the hillshade Paint property.

Should be between `0` and `1` inclusive. Defaults to `0.5`.

-}
hillshadeExaggeration : Expression CameraExpression Float -> LayerAttr Hillshade
hillshadeExaggeration =
    Expression.encode >> Paint "hillshade-exaggeration"


{-| The direction of the light source used to generate the hillshading with 0 as the top of the viewport if `hillshadeIlluminationAnchor` is set to `anchorViewport` and due north if `hillshadeIlluminationAnchor` is set to `anchorMap`. Paint property.

Should be between `0` and `359` inclusive. Defaults to `335`.

-}
hillshadeIlluminationDirection : Expression CameraExpression Float -> LayerAttr Hillshade
hillshadeIlluminationDirection =
    Expression.encode >> Paint "hillshade-illumination-direction"


{-| The shading color of areas that face away from the light source. Paint property. Defaults to `#000000`.
-}
hillshadeShadowColor : Expression CameraExpression Color -> LayerAttr Hillshade
hillshadeShadowColor =
    Expression.encode >> Paint "hillshade-shadow-color"


{-| The shading color of areas that faces towards the light source. Paint property. Defaults to `#FFFFFF`.
-}
hillshadeHighlightColor : Expression CameraExpression Color -> LayerAttr Hillshade
hillshadeHighlightColor =
    Expression.encode >> Paint "hillshade-highlight-color"


{-| The shading color used to accentuate rugged terrain like sharp cliffs and gorges. Paint property. Defaults to `#000000`.
-}
hillshadeAccentColor : Expression CameraExpression Color -> LayerAttr Hillshade
hillshadeAccentColor =
    Expression.encode >> Paint "hillshade-accent-color"



-- Background


{-| Name of image in sprite to use for drawing an image background. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels. Paint property.
-}
backgroundPattern : Expression CameraExpression String -> LayerAttr Background
backgroundPattern =
    Expression.encode >> Paint "background-pattern"


{-| The color with which the background will be drawn. Paint property. Defaults to `#000000`. Disabled by `backgroundPattern`.
-}
backgroundColor : Expression CameraExpression Color -> LayerAttr Background
backgroundColor =
    Expression.encode >> Paint "background-color"


{-| The opacity at which the background will be drawn. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`.

-}
backgroundOpacity : Expression CameraExpression Float -> LayerAttr Background
backgroundOpacity =
    Expression.encode >> Paint "background-opacity"
