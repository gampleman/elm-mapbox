module Mapbox.Style exposing
    ( Style, fromUrl, create, insertAfter
    , mapboxStreets, mapboxOutdoors, mapboxLight, mapboxDark, mapboxSatellite, mapboxSatelliteStreets
    , Attr, sprite, glyphs, name, defaultCenter, defaultZoomLevel, defaultBearing, defaultPitch, metadata, light, Light, transition, Transition
    )

{-| A Mapbox style is a document that defines the visual appearance of a map: what data to draw, the order to draw it in, and how to style the data when drawing it. A style document is a JSON object with specific root level and nested properties. This specification defines and describes these properties.

@docs Style, fromUrl, create, insertAfter


### Predefined styles

You can also use one of these predefined styles.

@docs mapboxStreets, mapboxOutdoors, mapboxLight, mapboxDark, mapboxSatellite, mapboxSatelliteStreets


### Attributes

@docs Attr, sprite, glyphs, name, defaultCenter, defaultZoomLevel, defaultBearing, defaultPitch, metadata, light, Light, transition, Transition

-}

import Array exposing (Array)
import Internal exposing (Supported)
import Json.Encode as Encode exposing (Value)
import LngLat exposing (LngLat)
import Mapbox.Expression exposing (CameraExpression, Color, Expression, float, floats, rgba, viewport)
import Mapbox.Layer exposing (Layer)
import Mapbox.Source exposing (Source)


{-| A mapbox style.

You can either create a style spec in Elm or load one from a remote URL, optionally adding custom layers and source on top.

-}
type alias Style msg =
    Internal.Style msg


{-| To load a style from the Mapbox API, you can use a URL of the form `Mapbox.Style.fromUrl "mapbox://styles/:owner/:style"`, where `:owner` is your Mapbox account name and `:style` is the style ID.
-}
fromUrl : String -> Style msg
fromUrl url =
    Internal.FromUrl url []


{-| You can also create a style from scratch.
-}
create : List Attr -> List (Layer msg) -> Style msg
create attrs layers =
    Internal.Style layers (List.map (\(Attr key val) -> ( key, val )) attrs)


{-| Add a layer (and potentially the linked source, if not already present), to the style. You must specify the ID of the layer after which you would like to insert the layer.

Note: If using a remote style, you will get a JavaScript exception if the layer id doesn't exist in the style. I recommend making your own copy of a style (instead of using the built-in ones), as Mapbox may change their styles without warning. For created styles using the `create` function, the layer will simply be appended at the end.

While using this with styles created using the `create` function works, it is not recommended, as it will be slower than just putting in the layer in the first place.

-}
insertAfter : String -> Layer msg -> Style msg -> Style msg
insertAfter id layer style =
    case style of
        Internal.Style layers attributes ->
            Internal.Style
                (List.concatMap
                    (\((Internal.Layer layerProps) as lyr) ->
                        if id == layerProps.id then
                            [ lyr, layer ]

                        else
                            [ lyr ]
                    )
                    layers
                )
                attributes

        Internal.FromUrl url layerInsertions ->
            Internal.FromUrl url (( id, layer ) :: layerInsertions)


{-| -}
mapboxStreets : Style msg
mapboxStreets =
    fromUrl "mapbox://styles/mapbox/streets-v10"


{-| -}
mapboxOutdoors : Style msg
mapboxOutdoors =
    fromUrl "mapbox://styles/mapbox/outdoors-v10"


{-| -}
mapboxLight : Style msg
mapboxLight =
    fromUrl "mapbox://styles/mapbox/light-v9"


{-| -}
mapboxDark : Style msg
mapboxDark =
    fromUrl "mapbox://styles/mapbox/dark-v9"


{-| -}
mapboxSatellite : Style msg
mapboxSatellite =
    fromUrl "mapbox://styles/mapbox/satellite-v9"


{-| -}
mapboxSatelliteStreets : Style msg
mapboxSatelliteStreets =
    fromUrl "mapbox://styles/mapbox/satellite-streets-v10"


encodeTransition : Transition -> Value
encodeTransition { duration, delay } =
    Encode.object [ ( "duration", Encode.int duration ), ( "delay", Encode.int delay ) ]


encodeLight : Light -> Value
encodeLight { anchor, position, color, intensity } =
    Encode.object
        [ ( "anchor", Mapbox.Expression.encode anchor )
        , ( "position", Mapbox.Expression.encode position )
        , ( "color", Mapbox.Expression.encode color )
        , ( "intensity", Mapbox.Expression.encode intensity )
        ]


{-| -}
type Attr
    = Attr String Value


{-| A human-readable name for the style.
-}
name : String -> Attr
name =
    Encode.string >> Attr "name"


{-| Default map center in longitude and latitude. The style center will be used only if the map has not been positioned by other means (e.g. map options or user interaction).
-}
defaultCenter : LngLat -> Attr
defaultCenter =
    LngLat.encodeAsPair >> Attr "center"


{-| Default zoom level. The style zoom will be used only if the map has not been positioned by other means (e.g. map options or user interaction).
-}
defaultZoomLevel : Float -> Attr
defaultZoomLevel =
    Encode.float >> Attr "zoom"


{-| Arbitrary properties useful to track with the stylesheet, but do not influence rendering. Properties should be prefixed to avoid collisions, like 'mapbox:'.
-}
metadata : List ( String, Value ) -> Attr
metadata =
    Encode.object >> Attr "metadata"


{-| Default bearing, in degrees. The bearing is the compass direction that is "up"; for example, a bearing of 90° orients the map so that east is up. This value will be used only if the map has not been positioned by other means (e.g. map options or user interaction).
-}
defaultBearing : Float -> Attr
defaultBearing =
    Encode.float >> Attr "bearing"


{-| Default pitch, in degrees. Zero is perpendicular to the surface, for a look straight down at the map, while a greater value like 60 looks ahead towards the horizon. The style pitch will be used only if the map has not been positioned by other means (e.g. map options or user interaction).
-}
defaultPitch : Float -> Attr
defaultPitch =
    Encode.float >> Attr "pitch"


{-| A base URL for retrieving the sprite image and metadata. The extensions .png, .json and scale factor @2x.png will be automatically appended. This property is required if any layer uses the `backgroundPattern`, `fillPattern`, `linePattern`, `fillExtrusionPattern`, or `iconImage` properties.
-}
sprite : String -> Attr
sprite =
    Encode.string >> Attr "sprite"


{-| A URL template for loading signed-distance-field glyph sets in PBF format. The URL must include `{fontstack}` and `{range}` tokens. This property is required if any layer uses the `textField` layout property.
-}
glyphs : String -> Attr
glyphs =
    Encode.string >> Attr "glyphs"



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
    { anchor : Expression CameraExpression { map : Supported, viewport : Supported }
    , position : Expression CameraExpression (Array Float)
    , color : Expression CameraExpression Color
    , intensity : Expression CameraExpression Float
    }


light : Light -> Attr
light =
    encodeLight >> Attr "light"


{-| A transition property controls timing for the interpolation between a transitionable style property's previous value and new value.


### `duration`

Time (in ms) allotted for transitions to complete.


### `delay`

Length of time (in ms) before a transition begins.

-}
type alias Transition =
    { duration : Int, delay : Int }


transition : Transition -> Attr
transition =
    encodeTransition >> Attr "transition"
