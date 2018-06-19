module Mapbox.Style exposing (Style, encode, Light, defaultLight, Transition, defaultTransition, MiscAttr, sprite, glyphs, name, defaultCenter, defaultZoomLevel, defaultBearing, defaultPitch, metadata)

{-| A Mapbox style is a document that defines the visual appearance of a map: what data to draw, the order to draw it in, and how to style the data when drawing it. A style document is a JSON object with specific root level and nested properties. This specification defines and describes these properties.

@docs Style, encode


### Light

@docs Light, defaultLight


### Transition

@docs Transition, defaultTransition


### Misc Attributes

@docs MiscAttr, sprite, glyphs, name, defaultCenter, defaultZoomLevel, defaultBearing, defaultPitch, metadata

-}

import Array exposing (Array)
import Json.Encode as Encode exposing (Value)
import Mapbox.Expression exposing (Anchor(Viewport), CameraExpression, Color, Expression, float, floats, rgba)
import Mapbox.Helpers exposing (encodeAnchor)
import Mapbox.Layer exposing (Layer)
import Mapbox.Source exposing (Source)


{-| Encodes the style into JSON.
-}
encode : Style -> Value
encode style =
    [ ( "version", Encode.int 8 )
    , ( "transition", encodeTransition style.transition )
    , ( "light", encodeLight style.light )
    , ( "sources", Encode.object <| List.map (\source -> ( Mapbox.Source.getId source, Mapbox.Source.encode source )) style.sources )
    , ( "layers", Encode.list (List.map Mapbox.Layer.encode style.layers) )
    ]
        ++ List.map (\(MiscAttr key value) -> ( key, value )) style.misc
        |> Encode.object


encodeTransition : Transition -> Value
encodeTransition { duration, delay } =
    Encode.object [ ( "duration", Encode.int duration ), ( "delay", Encode.int delay ) ]


encodeLight : Light -> Value
encodeLight { anchor, position, color, intensity } =
    Encode.object
        [ ( "anchor", encodeAnchor anchor )
        , ( "position", Mapbox.Expression.encode position )
        , ( "color", Mapbox.Expression.encode color )
        , ( "intensity", Mapbox.Expression.encode intensity )
        ]


{-| This is the core representation of a Mapbox style. It has the following keys:


### Layers

These define what is actually rendered on screen. See the Mapbox.Layer module on how to configure these.


### Sources

These define the data sources that feed the Layers. See the Mapbox.Source module for more.


### Misc

These are all optional attributes.

All the other keys are values defined below.

-}
type alias Style =
    { transition : Transition
    , light : Light
    , layers : List Layer
    , sources : List Source
    , misc : List MiscAttr
    }


{-| -}
type MiscAttr
    = MiscAttr String Value


{-| A human-readable name for the style.
-}
name : String -> MiscAttr
name =
    Encode.string >> MiscAttr "name"


{-| Default map center in longitude and latitude. The style center will be used only if the map has not been positioned by other means (e.g. map options or user interaction).
-}
defaultCenter : Float -> Float -> MiscAttr
defaultCenter lat lng =
    Encode.list [ Encode.float lat, Encode.float lng ] |> MiscAttr "center"


{-| Default zoom level. The style zoom will be used only if the map has not been positioned by other means (e.g. map options or user interaction).
-}
defaultZoomLevel : Float -> MiscAttr
defaultZoomLevel =
    Encode.float >> MiscAttr "zoom"


{-| Arbitrary properties useful to track with the stylesheet, but do not influence rendering. Properties should be prefixed to avoid collisions, like 'mapbox:'.
-}
metadata : List ( String, Value ) -> MiscAttr
metadata =
    Encode.object >> MiscAttr "metadata"


{-| Default bearing, in degrees. The bearing is the compass direction that is "up"; for example, a bearing of 90° orients the map so that east is up. This value will be used only if the map has not been positioned by other means (e.g. map options or user interaction).
-}
defaultBearing : Float -> MiscAttr
defaultBearing =
    Encode.float >> MiscAttr "bearing"


{-| Default pitch, in degrees. Zero is perpendicular to the surface, for a look straight down at the map, while a greater value like 60 looks ahead towards the horizon. The style pitch will be used only if the map has not been positioned by other means (e.g. map options or user interaction).
-}
defaultPitch : Float -> MiscAttr
defaultPitch =
    Encode.float >> MiscAttr "pitch"


{-| A base URL for retrieving the sprite image and metadata. The extensions .png, .json and scale factor @2x.png will be automatically appended. This property is required if any layer uses the `backgroundPattern`, `fillPattern`, `linePattern`, `fillExtrusionPattern`, or `iconImage` properties.
-}
sprite : String -> MiscAttr
sprite =
    Encode.string >> MiscAttr "sprite"


{-| A URL template for loading signed-distance-field glyph sets in PBF format. The URL must include `{fontstack}` and `{range}` tokens. This property is required if any layer uses the `textField` layout property.
-}
glyphs : String -> MiscAttr
glyphs =
    Encode.string >> MiscAttr "glyphs"



-- Light


{-| The global light source.


### `anchor`

Whether extruded geometries are lit relative to the map or viewport.


### `position`

Position of the light source relative to lit (extruded) geometries, in `[r radial coordinate, a azimuthal angle, p polar angle]` where `r` indicates the distance from the center of the base of an object to its light, `a` indicates the position of the light relative to 0° (0° when the `anchor` is set to `viewport` corresponds to the top of the viewport, or 0° when `anchor` is set to `map` corresponds to due north, and degrees proceed clockwise), and `p` indicates the height of the light (from 0°, directly above, to 180°, directly below).


### `color`

Color tint for lighting extruded geometries.


### `intensity`

Intensity of lighting (on a scale from 0 to 1). Higher numbers will present as more extreme contrast.

-}
type alias Light =
    { anchor : Anchor
    , position : Expression CameraExpression (Array Float)
    , color : Expression CameraExpression Color
    , intensity : Expression CameraExpression Float
    }


{-| A decent default light.
-}
defaultLight : Light
defaultLight =
    { anchor = Viewport
    , position = floats [ 1.15, 210, 30 ]
    , color = rgba 255 255 255 1
    , intensity = float 0.5
    }


{-| A transition property controls timing for the interpolation between a transitionable style property's previous value and new value.


### `duration`

Time (in ms) allotted for transitions to complete.


### `delay`

Length of time (in ms) before a transition begins.

-}
type alias Transition =
    { duration : Int, delay : Int }


{-| The defaults for a transition
-}
defaultTransition : Transition
defaultTransition =
    { duration = 300
    , delay = 0
    }
