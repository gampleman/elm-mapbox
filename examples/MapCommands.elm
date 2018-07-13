port module MapCommands exposing (id, panBy, panTo, zoomTo, zoomIn, zoomOut, rotateTo, jumpTo, easeTo, flyTo, stop, fitBounds, setRTLTextPlugin, Response, queryResults, getBounds, queryRenderedFeatures)

{-| This module has a bunch of essentially imperative commands for your map.

@docs id


### Moving the map around

@docs panBy, panTo, zoomTo, zoomIn, zoomOut, rotateTo, jumpTo, easeTo, flyTo, stop


### Fitting bounds

@docs fitBounds


### Right-to-left

@docs setRTLTextPlugin


### Querying the map

@docs Response, queryResults, getBounds, queryRenderedFeatures, Query

-}

import Mapbox.Cmd.Template as Template exposing (Option, Supported)
import Json.Encode as Encode exposing (Value)
import LngLat exposing (LngLat)


port elmMapboxOutgoing : Value -> Cmd msg


{-| Maps should use this as their DOM id.
-}
id : Template.Id
id =
    "my-map"


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


{-| Pans the map by the specified offset.
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


{-| Returns an array of GeoJSON Feature objects representing visible features that satisfy the query parameters. Takes a numerical ID that allows you to associate the question with the answer.

The response: The properties value of each returned feature object contains the properties of its source feature. For GeoJSON sources, only string and numeric property values are supported (i.e. null, Array, and Object values are not supported).

Each feature includes a top-level layer property whose value is an object representing the style layer to which the feature belongs. Layout and paint properties in this object contain values which are fully evaluated for the given zoom level and feature.

Features from layers whose visibility property is "none", or from layers whose zoom range excludes the current zoom level are not included. Symbol features that have been hidden due to text or icon collision are not included. Features from all other layers are included, including features that may have no visible contribution to the rendered result; for example, because the layer's opacity or color alpha component is set to 0.

The topmost rendered feature appears first in the returned array, and subsequent features are sorted by descending z-order. Features that are rendered multiple times (due to wrapping across the antimeridian at low zoom levels) are returned only once (though subject to the following caveat).

Because features come from tiled vector data or GeoJSON data that is converted to tiles internally, feature geometries may be split or duplicated across tile boundaries and, as a result, features may appear multiple times in query results. For example, suppose there is a highway running through the bounding rectangle of a query. The results of the query will be those parts of the highway that lie within the map tiles covering the bounding rectangle, even if the highway extends into other tiles, and the portion of the highway within each map tile will be returned as a separate feature. Similarly, a point feature near a tile boundary may appear in multiple tiles due to tile buffering.

-}
queryRenderedFeatures : Int -> List (Option { layers : Supported, filter : Supported, query : Supported }) -> Cmd msg
queryRenderedFeatures =
    Template.queryRenderedFeatures elmMapboxOutgoing id


{-| A response to the queries. See the relevant methods for more information.
-}
type Response
    = GetBounds Int ( LngLat, LngLat )
    | QueryRenderedFeatures Int (List Value)
    | Error String


port elmMapboxIncoming : (Value -> msg) -> Sub msg


{-| Receive results from the queries
-}
queryResults : (Response -> msg) -> Sub msg
queryResults =
    Template.queryResults elmMapboxIncoming GetBounds QueryRenderedFeatures Error
