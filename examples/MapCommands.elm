port module MapCommands exposing (id, duration, easing, offset, animate, panBy, panTo, zoomTo, zoomIn, zoomOut, rotateTo, jumpTo, easeTo, flyTo, curve, minZoom, speed, screenSpeed, maxDuration, stop, center, zoom, bearing, pitch, around, fitBounds, padding, linear, maxZoom, setRTLTextPlugin, Response, queryResults, getBounds, queryRenderedFeatures, Query, layers, filter)

{-| This module has a bunch of essentially imperative commands for your map.

@docs Option


### Animation options

Options common to map movement commands that involve animation, such as panBy and easeTo, controlling the duration and easing function of the animation. All properties are optional.

@docs duration, easing, offset, animate


### Moving the map around

@docs panBy, panTo, zoomTo, zoomIn, zoomOut, rotateTo, jumpTo, easeTo, flyTo, curve, minZoom, speed, screenSpeed, maxDuration, stop


### Camera Options

Options common to `jumpTo`, `easeTo`, and `flyTo`, controlling the desired location, zoom, bearing, and pitch of the camera. All properties are optional, and when a property is omitted, the current camera value for that property will remain unchanged.

@docs center, zoom, bearing, pitch, around


### Fiting bounds

@docs fitBounds, padding, Padding, linear, maxZoom


### Right-to-left

@docs setRTLTextPlugin


### Querying the map

@docs Response, queryResults, getBounds, queryRenderedFeatures, Query, layers, filter

-}

import Mapbox.Cmd as Template exposing (Option, Supported)
import Json.Decode as Decode
import Json.Encode as Encode exposing (Value)
import Mapbox.Element exposing (LngLat, Viewport)
import Mapbox.Expression exposing (DataExpression, Expression)


port elmMapboxOutgoing : Value -> Cmd msg


{-| Maps should use this as their DOM id.
-}
id : Template.Id
id =
    "my-map"



-- AnimationOptions


{-| The animation's duration, measured in milliseconds.
-}
duration : Int -> Option { a | duration : Supported }
duration =
    Template.duration


{-| The name of an easing function. These must be passed to `elmMapbox`
in the `easingFunctions` option.
-}
easing : String -> Option { a | easing : Supported }
easing =
    Template.easing


{-| Offset of the target center relative to real map container center at the end of animation.
-}
offset : ( Int, Int ) -> Option { a | offset : Supported }
offset =
    Template.offset


{-| If false, no animation will occur.
-}
animate : Bool -> Option { a | animate : Supported }
animate =
    Template.animate


{-| The desired center.
-}
center : LngLat -> Option { a | center : Supported }
center =
    Template.center


{-| The desired zoom level.
-}
zoom : Float -> Option { a | zoom : Supported }
zoom =
    Template.zoom


{-| The desired bearing, in degrees. The bearing is the compass direction that is "up"; for example, a bearing of 90° orients the map so that east is up.
-}
bearing : Float -> Option { a | bearing : Supported }
bearing =
    Template.bearing


{-| The desired pitch, in degrees.
-}
pitch : Float -> Option { a | pitch : Supported }
pitch =
    Template.pitch


{-| If `zoom` is specified, `around` determines the point around which the zoom is centered.
-}
around : LngLat -> Option { a | around : Supported }
around =
    Template.around


{-| The amount of padding in pixels to add to the given bounds.
-}
padding : Template.Padding -> Option { a | padding : Supported }
padding =
    Template.padding


{-| If true, the map transitions using `easeTo` . If false, the map transitions using `flyTo`.
-}
linear : Bool -> Option { a | linear : Supported }
linear =
    Template.linear


{-| The maximum zoom level to allow when the map view transitions to the specified bounds.
-}
maxZoom : Float -> Option { a | maxZoom : Supported }
maxZoom =
    Template.maxZoom


{-| The zooming "curve" that will occur along the flight path.
A high value maximizes zooming for an exaggerated animation, while a
low value minimizes zooming for an effect closer to `easeTo`.
1.42 is the average value selected by participants in the user study discussed in [van Wijk (2003)](https://www.win.tue.nl/~vanwijk/zoompan.pdf).
A value of `6 ^ 0.25` would be equivalent to the root mean squared average velocity. A value of 1 would produce a circular motion.
-}
curve : Float -> Option { a | curve : Supported }
curve =
    Template.curve


{-| The zero-based zoom level at the peak of the flight path.
If `curve` is specified, this option is ignored.
-}
minZoom : Float -> Option { a | minZoom : Supported }
minZoom =
    Template.minZoom


{-| The average speed of the animation defined in relation to `curve`. A speed of 1.2 means that the map appears to move along the flight path by 1.2 times `curve` screenfuls every second. A screenful is the map's visible span. It does not correspond to a fixed physical distance, but varies by zoom level.
-}
speed : Float -> Option { a | speed : Supported }
speed =
    Template.speed


{-| The average speed of the animation measured in screenfuls per second, assuming a linear timing curve. If `speed` is specified, this option is ignored.
-}
screenSpeed : Float -> Option { a | screenSpeed : Supported }
screenSpeed =
    Template.screenSpeed


{-| The animation's maximum duration, measured in milliseconds. If duration exceeds maximum duration, it resets to 0.
-}
maxDuration : Float -> Option { a | maxDuration : Supported }
maxDuration =
    Template.maxDuration


{-| Resizes the map according to the dimensions of its container element.

This command must be sent after the map's container is resized, or when the map is shown after being initially hidden with CSS.

-}
resize : Cmd msg
resize =
    Template.resize elmMapboxOutgoing id


{-| Pans and zooms the map to contain its visible area within the specified geographical bounds. This function will also reset the map's bearing to 0 if bearing is nonzero.
-}
fitBounds :
    List
        (Option
            { padding : Supported
            , easing : Supported
            , linear : Supported
            , offset : Supported
            , maxZoom : Supported
            }
        )
    -> ( LngLat, LngLat )
    -> Cmd msg
fitBounds =
    Template.fitBounds elmMapboxOutgoing id


{-| Pans the map by the specified offest.
-}
panBy :
    List
        (Option
            { duration : Supported
            , easing : Supported
            , offset : Supported
            , animate : Supported
            }
        )
    -> ( Int, Int )
    -> Cmd msg
panBy =
    Template.panBy elmMapboxOutgoing id


{-| Pans the map to the specified location, with an animated transition.
-}
panTo :
    List
        (Option
            { duration : Supported
            , easing : Supported
            , offset : Supported
            , animate : Supported
            }
        )
    -> LngLat
    -> Cmd msg
panTo =
    Template.panTo elmMapboxOutgoing id


{-| Zooms the map to the specified zoom level, with an animated transition.
-}
zoomTo :
    List
        (Option
            { duration : Supported
            , easing : Supported
            , offset : Supported
            , animate : Supported
            }
        )
    -> Float
    -> Cmd msg
zoomTo =
    Template.zoomTo elmMapboxOutgoing id


{-| Increases the map's zoom level by 1.
-}
zoomIn :
    List
        (Option
            { duration : Supported
            , easing : Supported
            , offset : Supported
            , animate : Supported
            }
        )
    -> Cmd msg
zoomIn =
    Template.zoomIn elmMapboxOutgoing id


{-| Decreases the map's zoom level by 1.
-}
zoomOut :
    List
        (Option
            { duration : Supported
            , easing : Supported
            , offset : Supported
            , animate : Supported
            }
        )
    -> Cmd msg
zoomOut =
    Template.zoomOut elmMapboxOutgoing id


{-| Rotates the map to the specified bearing, with an animated transition. The bearing is the compass direction that is "up"; for example, a bearing of 90° orients the map so that east is up.
-}
rotateTo :
    List
        (Option
            { duration : Supported
            , easing : Supported
            , offset : Supported
            , animate : Supported
            }
        )
    -> Float
    -> Cmd msg
rotateTo =
    Template.rotateTo elmMapboxOutgoing id


{-| Changes any combination of center, zoom, bearing, and pitch, without an animated transition. The map will retain its current values for any details not specified in options.
-}
jumpTo :
    List
        (Option
            { center : Supported
            , zoom : Supported
            , bearing : Supported
            , pitch : Supported
            , around : Supported
            }
        )
    -> Cmd msg
jumpTo =
    Template.jumpTo elmMapboxOutgoing id


{-| Changes any combination of center, zoom, bearing, and pitch, with an animated transition between old and new values. The map will retain its current values for any details not specified in options.
-}
easeTo :
    List
        (Option
            { center : Supported
            , zoom : Supported
            , bearing : Supported
            , pitch : Supported
            , around : Supported
            , duration : Supported
            , easing : Supported
            , offset : Supported
            , animate : Supported
            }
        )
    -> Cmd msg
easeTo =
    Template.easeTo elmMapboxOutgoing id


{-| Changes any combination of center, zoom, bearing, and pitch, animating the transition along a curve that evokes flight. The animation seamlessly incorporates zooming and panning to help the user maintain her bearings even after traversing a great distance.
-}
flyTo :
    List
        (Option
            { center : Supported
            , zoom : Supported
            , bearing : Supported
            , pitch : Supported
            , around : Supported
            , duration : Supported
            , easing : Supported
            , offset : Supported
            , animate : Supported
            , curve : Supported
            , minZoom : Supported
            , speed : Supported
            , screenSpeed : Supported
            , maxDuration : Supported
            }
        )
    -> Cmd msg
flyTo =
    Template.flyTo elmMapboxOutgoing id


{-| Stops any animated transition underway.
-}
stop : Cmd msg
stop =
    Template.stop elmMapboxOutgoing id


{-| Sets the map's [RTL text plugin](https://www.mapbox.com/mapbox-gl-js/plugins/#mapbox-gl-rtl-text). Necessary for supporting languages like Arabic and Hebrew that are written right-to-left. Takes a URL pointing to the Mapbox RTL text plugin source.
-}
setRTLTextPlugin : String -> Cmd msg
setRTLTextPlugin =
    Template.setRTLTextPlugin elmMapboxOutgoing id



-- incoming


{-| Responds with the map's geographical bounds. Takes a numerical ID that allows you to associate the question with the answer.
-}
getBounds : Int -> Cmd msg
getBounds =
    Template.getBounds elmMapboxOutgoing id


{-| The geometry of the query region. Either a point, a bounding box (specified in terms of southwest and northeast points), or what is currently visible in the viewport.
-}
type alias Query =
    Template.Query


{-| Returns an array of GeoJSON Feature objects representing visible features that satisfy the query parameters. Takes a numerical ID that allows you to associate the question with the answer.

The response: The properties value of each returned feature object contains the properties of its source feature. For GeoJSON sources, only string and numeric property values are supported (i.e. null, Array, and Object values are not supported).

Each feature includes a top-level layer property whose value is an object representing the style layer to which the feature belongs. Layout and paint properties in this object contain values which are fully evaluated for the given zoom level and feature.

Features from layers whose visibility property is "none", or from layers whose zoom range excludes the current zoom level are not included. Symbol features that have been hidden due to text or icon collision are not included. Features from all other layers are included, including features that may have no visible contribution to the rendered result; for example, because the layer's opacity or color alpha component is set to 0.

The topmost rendered feature appears first in the returned array, and subsequent features are sorted by descending z-order. Features that are rendered multiple times (due to wrapping across the antimeridian at low zoom levels) are returned only once (though subject to the following caveat).

Because features come from tiled vector data or GeoJSON data that is converted to tiles internally, feature geometries may be split or duplicated across tile boundaries and, as a result, features may appear multiple times in query results. For example, suppose there is a highway running through the bounding rectangle of a query. The results of the query will be those parts of the highway that lie within the map tiles covering the bounding rectangle, even if the highway extends into other tiles, and the portion of the highway within each map tile will be returned as a separate feature. Similarly, a point feature near a tile boundary may appear in multiple tiles due to tile buffering.

-}
queryRenderedFeatures : Int -> List (Option { layers : Supported, filter : Supported }) -> Query -> Cmd msg
queryRenderedFeatures =
    Template.queryRenderedFeatures elmMapboxOutgoing id


{-| A list of style layer IDs for the query to inspect. Only features within these layers will be returned. If this parameter is not set, all layers will be checked.
-}
layers : List String -> Option { a | layers : Supported }
layers =
    Template.layers


{-| A filter to limit query results.
-}
filter : Expression DataExpression Bool -> Option { a | filter : Supported }
filter =
    Template.filter


{-| A response to the queries. See the relevant methods for more information.
-}
type alias Response =
    Template.Response


port elmMapboxIncoming : (Value -> msg) -> Sub msg


{-| Recieve results from the queries
-}
queryResults : (Response -> msg) -> Sub msg
queryResults =
    Template.queryResults elmMapboxIncoming
