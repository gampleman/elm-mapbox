port module MapCommands exposing (easeTo, fitBounds, flyTo, id, jumpTo, panBy, panTo, resize, rotateTo, stop, zoomIn, zoomOut, zoomTo)

{-| Tell your map to do something! Most of these Commands tell your map to (with or without animation) to show a different location. You can use the options from `Mapbox.Cmd.Option` to configure these.

@docs id


### Moving the map around

@docs panBy, panTo, zoomTo, zoomIn, zoomOut, rotateTo, jumpTo, easeTo, flyTo, fitBounds, stop


### Other

@docs resize

-}

import Json.Encode as Encode exposing (Value)
import LngLat exposing (LngLat)
import Mapbox.Cmd.Template as Template exposing (Option, Supported)


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
