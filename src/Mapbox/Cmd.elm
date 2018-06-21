module Mapbox.Cmd exposing (Id, Outgoing, Option, Supported, duration, easing, offset, animate, panBy, panTo, zoomTo, zoomIn, zoomOut, rotateTo, jumpTo, easeTo, flyTo, curve, minZoom, speed, screenSpeed, maxDuration, stop, center, zoom, bearing, pitch, around, fitBounds, padding, Padding, linear, maxZoom, setRTLTextPlugin, Response, queryResults, getBounds, queryRenderedFeatures, Query, layers, filter, resize)

{-| This module has a bunch of essentially imperative commands for your map.

@docs Id, Outgoing

However, since a published library can't have ports in it, you will need to do some setup. The easiest way to do this is to copy [this file into your app](https://github.com/gampleman/elm-mapbox/blob/master/examples/MapCommands.elm).

@docs Option, Supported


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


### Other

@docs setRTLTextPlugin, resize


### Querying the map

@docs Response, queryResults, getBounds, queryRenderedFeatures, Query, layers, filter

-}

import Json.Decode as Decode
import Json.Encode as Encode exposing (Value)
import Mapbox.Element exposing (LngLat, Viewport)
import Mapbox.Expression exposing (DataExpression, Expression)


{-| The type of a port that you need to provide for this module to work.
-}
type alias Outgoing msg =
    Value -> Cmd msg


{-| Every command takes the DOM id of the map that it should operate on.
-}
type alias Id =
    String



-- AnimationOptions


{-| The animation's duration, measured in milliseconds.
-}
duration : Int -> Option { a | duration : Supported }
duration =
    Encode.int >> Option "duration"


{-| The name of an easing function. These must be passed to `elmMapbox`
in the `easingFunctions` option.
-}
easing : String -> Option { a | easing : Supported }
easing =
    Encode.string >> Option "easing"


{-| Offset of the target center relative to real map container center at the end of animation.
-}
offset : ( Int, Int ) -> Option { a | offset : Supported }
offset =
    encodePair Encode.int >> Option "offset"


{-| If false, no animation will occur.
-}
animate : Bool -> Option { a | animate : Supported }
animate =
    Encode.bool >> Option "animate"


{-| The desired center.
-}
center : LngLat -> Option { a | center : Supported }
center =
    encodePair Encode.float >> Option "center"


{-| The desired zoom level.
-}
zoom : Float -> Option { a | zoom : Supported }
zoom =
    Encode.float >> Option "zoom"


{-| The desired bearing, in degrees. The bearing is the compass direction that is "up"; for example, a bearing of 90° orients the map so that east is up.
-}
bearing : Float -> Option { a | bearing : Supported }
bearing =
    Encode.float >> Option "bearing"


{-| The desired pitch, in degrees.
-}
pitch : Float -> Option { a | pitch : Supported }
pitch =
    Encode.float >> Option "pitch"


{-| If `zoom` is specified, `around` determines the point around which the zoom is centered.
-}
around : LngLat -> Option { a | around : Supported }
around =
    encodePair Encode.float >> Option "around"


{-| The amount of padding in pixels to add to the given bounds.
-}
padding : Padding -> Option { a | padding : Supported }
padding =
    encodePadding >> Option "padding"


{-| -}
type alias Padding =
    { top : Int, right : Int, bottom : Int, left : Int }


encodePadding { top, right, bottom, left } =
    Encode.object
        [ ( "top", Encode.int top )
        , ( "right", Encode.int right )
        , ( "bottom", Encode.int bottom )
        , ( "left", Encode.int left )
        ]


{-| If true, the map transitions using `easeTo` . If false, the map transitions using `flyTo`.
-}
linear : Bool -> Option { a | linear : Supported }
linear =
    Encode.bool >> Option "linear"


{-| The maximum zoom level to allow when the map view transitions to the specified bounds.
-}
maxZoom : Float -> Option { a | maxZoom : Supported }
maxZoom =
    Encode.float >> Option "maxZoom"


{-| The zooming "curve" that will occur along the flight path.
A high value maximizes zooming for an exaggerated animation, while a
low value minimizes zooming for an effect closer to `easeTo`.
1.42 is the average value selected by participants in the user study discussed in [van Wijk (2003)](https://www.win.tue.nl/~vanwijk/zoompan.pdf).
A value of `6 ^ 0.25` would be equivalent to the root mean squared average velocity. A value of 1 would produce a circular motion.
-}
curve : Float -> Option { a | curve : Supported }
curve =
    Encode.float >> Option "curve"


{-| The zero-based zoom level at the peak of the flight path.
If `curve` is specified, this option is ignored.
-}
minZoom : Float -> Option { a | minZoom : Supported }
minZoom =
    Encode.float >> Option "minZoom"


{-| The average speed of the animation defined in relation to `curve`. A speed of 1.2 means that the map appears to move along the flight path by 1.2 times `curve` screenfuls every second. A screenful is the map's visible span. It does not correspond to a fixed physical distance, but varies by zoom level.
-}
speed : Float -> Option { a | speed : Supported }
speed =
    Encode.float >> Option "speed"


{-| The average speed of the animation measured in screenfuls per second, assuming a linear timing curve. If `speed` is specified, this option is ignored.
-}
screenSpeed : Float -> Option { a | screenSpeed : Supported }
screenSpeed =
    Encode.float >> Option "screenSpeed"


{-| The animation's maximum duration, measured in milliseconds. If duration exceeds maximum duration, it resets to 0.
-}
maxDuration : Float -> Option { a | maxDuration : Supported }
maxDuration =
    Encode.float >> Option "maxDuration"


encodePair encoder ( a, b ) =
    Encode.list [ encoder a, encoder b ]


decodePair decoder =
    Decode.list decoder
        |> Decode.andThen
            (\l ->
                case l of
                    [ a, b ] ->
                        Decode.succeed ( a, b )

                    _ ->
                        Decode.fail "Doesn't apear to be a pair"
            )


makeCmd : Outgoing msg -> Id -> String -> List ( String, Value ) -> Cmd msg
makeCmd prt id command params =
    prt <|
        Encode.object
            (( "command", Encode.string command )
                :: ( "target", Encode.string id )
                :: params
            )


{-| Resizes the map according to the dimensions of its container element.

This command must be sent after the map's container is resized, or when the map is shown after being initially hidden with CSS.

-}
resize : Outgoing msg -> Id -> Cmd msg
resize prt id =
    makeCmd prt id "resize" []


{-| Pans and zooms the map to contain its visible area within the specified geographical bounds. This function will also reset the map's bearing to 0 if bearing is nonzero.
-}
fitBounds :
    Outgoing msg
    -> Id
    ->
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
fitBounds prt id options bounds =
    makeCmd prt
        id
        "fitBounds"
        [ ( "bounds", encodePair (encodePair Encode.float) bounds )
        , encodeOptions options
        ]


{-| Options use phantom types to show which commands support them.
-}
type Option support
    = Option String Value


{-| -}
type Supported
    = Supported


encodeOptions opts =
    ( "options", Encode.object <| List.map (\(Option key val) -> ( key, val )) opts )


{-| Pans the map by the specified offest.
-}
panBy :
    Outgoing msg
    -> Id
    ->
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
panBy prt id options offset =
    makeCmd prt id "panBy" [ ( "offset", encodePair Encode.int offset ), encodeOptions options ]


{-| Pans the map to the specified location, with an animated transition.
-}
panTo :
    Outgoing msg
    -> Id
    ->
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
panTo prt id options location =
    makeCmd prt id "panTo" [ ( "location", encodePair Encode.float location ), encodeOptions options ]


{-| Zooms the map to the specified zoom level, with an animated transition.
-}
zoomTo :
    Outgoing msg
    -> Id
    ->
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
zoomTo prt id options zm =
    makeCmd prt id "zoomTo" [ ( "zoom", Encode.float zm ), encodeOptions options ]


{-| Increases the map's zoom level by 1.
-}
zoomIn :
    Outgoing msg
    -> Id
    ->
        List
            (Option
                { duration : Supported
                , easing : Supported
                , offset : Supported
                , animate : Supported
                }
            )
    -> Cmd msg
zoomIn prt id options =
    makeCmd prt id "zoomIn" [ encodeOptions options ]


{-| Decreases the map's zoom level by 1.
-}
zoomOut :
    Outgoing msg
    -> Id
    ->
        List
            (Option
                { duration : Supported
                , easing : Supported
                , offset : Supported
                , animate : Supported
                }
            )
    -> Cmd msg
zoomOut prt id options =
    makeCmd prt id "zoomOut" [ encodeOptions options ]


{-| Rotates the map to the specified bearing, with an animated transition. The bearing is the compass direction that is "up"; for example, a bearing of 90° orients the map so that east is up.
-}
rotateTo :
    Outgoing msg
    -> Id
    ->
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
rotateTo prt id options zm =
    makeCmd prt id "rotateTo" [ ( "bearing", Encode.float zm ), encodeOptions options ]


{-| Changes any combination of center, zoom, bearing, and pitch, without an animated transition. The map will retain its current values for any details not specified in options.
-}
jumpTo :
    Outgoing msg
    -> Id
    ->
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
jumpTo prt id options =
    makeCmd prt id "jumpTo" [ encodeOptions options ]


{-| Changes any combination of center, zoom, bearing, and pitch, with an animated transition between old and new values. The map will retain its current values for any details not specified in options.
-}
easeTo :
    Outgoing msg
    -> Id
    ->
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
easeTo prt id options =
    makeCmd prt id "easeTo" [ encodeOptions options ]


{-| Changes any combination of center, zoom, bearing, and pitch, animating the transition along a curve that evokes flight. The animation seamlessly incorporates zooming and panning to help the user maintain her bearings even after traversing a great distance.
-}
flyTo :
    Outgoing msg
    -> Id
    ->
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
flyTo prt id options =
    makeCmd prt id "flyTo" [ encodeOptions options ]


{-| Stops any animated transition underway.
-}
stop : Outgoing msg -> Id -> Cmd msg
stop prt id =
    makeCmd prt id "stop" []


{-| Sets the map's [RTL text plugin](https://www.mapbox.com/mapbox-gl-js/plugins/#mapbox-gl-rtl-text). Necessary for supporting languages like Arabic and Hebrew that are written right-to-left. Takes a URL pointing to the Mapbox RTL text plugin source.
-}
setRTLTextPlugin : Outgoing msg -> Id -> String -> Cmd msg
setRTLTextPlugin prt id url =
    makeCmd prt id "setRTLTextPlugin" [ ( "url", Encode.string url ) ]



-- incoming


{-| Responds with the map's geographical bounds. Takes a numerical ID that allows you to associate the question with the answer.
-}
getBounds : Outgoing msg -> Id -> Int -> Cmd msg
getBounds prt id reqId =
    makeCmd prt id "getBounds" [ ( "requestId", Encode.int reqId ) ]


{-| The geometry of the query region. Either a point, a bounding box (specified in terms of southwest and northeast points), or what is currently visible in the viewport.
-}
type Query
    = Viewport
    | Point LngLat
    | Box LngLat LngLat


encodeQuery query =
    case query of
        Viewport ->
            Encode.string "viewport"

        Point lngLat ->
            encodePair Encode.float lngLat

        Box sw ne ->
            encodePair (encodePair Encode.float) ( sw, ne )


{-| Returns an array of GeoJSON Feature objects representing visible features that satisfy the query parameters. Takes a numerical ID that allows you to associate the question with the answer.

The response: The properties value of each returned feature object contains the properties of its source feature. For GeoJSON sources, only string and numeric property values are supported (i.e. null, Array, and Object values are not supported).

Each feature includes a top-level layer property whose value is an object representing the style layer to which the feature belongs. Layout and paint properties in this object contain values which are fully evaluated for the given zoom level and feature.

Features from layers whose visibility property is "none", or from layers whose zoom range excludes the current zoom level are not included. Symbol features that have been hidden due to text or icon collision are not included. Features from all other layers are included, including features that may have no visible contribution to the rendered result; for example, because the layer's opacity or color alpha component is set to 0.

The topmost rendered feature appears first in the returned array, and subsequent features are sorted by descending z-order. Features that are rendered multiple times (due to wrapping across the antimeridian at low zoom levels) are returned only once (though subject to the following caveat).

Because features come from tiled vector data or GeoJSON data that is converted to tiles internally, feature geometries may be split or duplicated across tile boundaries and, as a result, features may appear multiple times in query results. For example, suppose there is a highway running through the bounding rectangle of a query. The results of the query will be those parts of the highway that lie within the map tiles covering the bounding rectangle, even if the highway extends into other tiles, and the portion of the highway within each map tile will be returned as a separate feature. Similarly, a point feature near a tile boundary may appear in multiple tiles due to tile buffering.

-}
queryRenderedFeatures : Outgoing msg -> Id -> Int -> List (Option { layers : Supported, filter : Supported }) -> Query -> Cmd msg
queryRenderedFeatures prt id reqId options query =
    makeCmd prt
        id
        "queryRenderedFeatures"
        [ ( "requestId", Encode.int reqId )
        , ( "query", encodeQuery query )
        , encodeOptions options
        ]


{-| A list of style layer IDs for the query to inspect. Only features within these layers will be returned. If this parameter is not set, all layers will be checked.
-}
layers : List String -> Option { a | layers : Supported }
layers =
    List.map Encode.string >> Encode.list >> Option "layers"


{-| A filter to limit query results.
-}
filter : Expression DataExpression Bool -> Option { a | filter : Supported }
filter =
    Mapbox.Expression.encode >> Option "filter"


{-| A response to the queries. See the relevant methods for more information.
-}
type Response
    = GetBounds Int ( LngLat, LngLat )
    | QueryRenderedFeatures Int (List Value)
    | Error String


{-| Wraps an incoming port so that you can get nicer subscritions:

    port elmMapboxIncoming : (Value -> msg) -> Sub msg


    -- exposed

    queryResults : (Response -> msg) -> Sub msg

    queryResuls =
        Mapbox.Cmd.queryResults elmMapboxIncoming

-}
queryResults : ((Value -> msg) -> Sub msg) -> (Response -> msg) -> Sub msg
queryResults prt tagger =
    prt (decodeResponse >> tagger)


responseDecoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\s ->
                case s of
                    "getBounds" ->
                        Decode.map2 GetBounds (Decode.field "id" Decode.int) (Decode.field "bounds" (decodePair (decodePair Decode.float)))

                    "queryRenderedFeatures" ->
                        Decode.map2 QueryRenderedFeatures (Decode.field "id" Decode.int) (Decode.field "features" (Decode.list Decode.value))

                    _ ->
                        Decode.fail <| "Unrecognized response type: " ++ s
            )


decodeResponse value =
    case Decode.decodeValue responseDecoder value of
        Ok res ->
            res

        Err e ->
            Error e
