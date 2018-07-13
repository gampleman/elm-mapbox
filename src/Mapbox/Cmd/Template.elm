module Mapbox.Cmd.Template exposing (Id, Outgoing, Option, Supported, panBy, panTo, zoomTo, zoomIn, zoomOut, rotateTo, jumpTo, easeTo, flyTo, stop, fitBounds, setRTLTextPlugin, queryResults, getBounds, queryRenderedFeatures, resize)

{-| This module has a bunch of essentially imperative commands for your map.

However, since a published library can't have ports in it, you will need to do some setup. The easiest way to do this is to copy [this file into your app](https://github.com/gampleman/elm-mapbox/blob/master/examples/MapCommands.elm). You can see the module docs for that [here](https://github.com/gampleman/elm-mapbox/blob/master/docs/MapCommands.md).

@docs Id, Outgoing, Option, Supported

You can of course customize the module you copy into your codebase to support things like having multiple maps on the page at once, etc.


### Moving the map around

@docs panBy, panTo, zoomTo, zoomIn, zoomOut, rotateTo, jumpTo, easeTo, flyTo, stop


### Fiting bounds

@docs fitBounds


### Other

@docs setRTLTextPlugin, resize


### Querying the map

@docs queryResults, getBounds, queryRenderedFeatures

-}

import Json.Decode as Decode
import Json.Encode as Encode exposing (Value)
import Mapbox.Cmd.Internal as Internal exposing (Option(..), Supported)
import Mapbox.Helpers exposing (encodePair)
import LngLat exposing (LngLat)


{-| The type of a port that you need to provide for this module to work.
-}
type alias Outgoing msg =
    Value -> Cmd msg


{-| Every command takes the DOM id of the map that it should operate on.
-}
type alias Id =
    String


{-| This is exported here to simply for convenience. See `Cmd.Option` for more docs.
-}
type alias Option support =
    Internal.Option support


{-| -}
type alias Supported =
    Internal.Supported



-- AnimationOptions


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
        [ ( "bounds", encodePair LngLat.encodeAsPair bounds )
        , encodeOptions options
        ]


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
    makeCmd prt id "panTo" [ ( "location", LngLat.encodeAsPair location ), encodeOptions options ]


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


{-| Returns an array of GeoJSON Feature objects representing visible features that satisfy the query parameters. Takes a numerical ID that allows you to associate the question with the answer.

The response: The properties value of each returned feature object contains the properties of its source feature. For GeoJSON sources, only string and numeric property values are supported (i.e. null, Array, and Object values are not supported).

Each feature includes a top-level layer property whose value is an object representing the style layer to which the feature belongs. Layout and paint properties in this object contain values which are fully evaluated for the given zoom level and feature.

Features from layers whose visibility property is "none", or from layers whose zoom range excludes the current zoom level are not included. Symbol features that have been hidden due to text or icon collision are not included. Features from all other layers are included, including features that may have no visible contribution to the rendered result; for example, because the layer's opacity or color alpha component is set to 0.

The topmost rendered feature appears first in the returned array, and subsequent features are sorted by descending z-order. Features that are rendered multiple times (due to wrapping across the antimeridian at low zoom levels) are returned only once (though subject to the following caveat).

Because features come from tiled vector data or GeoJSON data that is converted to tiles internally, feature geometries may be split or duplicated across tile boundaries and, as a result, features may appear multiple times in query results. For example, suppose there is a highway running through the bounding rectangle of a query. The results of the query will be those parts of the highway that lie within the map tiles covering the bounding rectangle, even if the highway extends into other tiles, and the portion of the highway within each map tile will be returned as a separate feature. Similarly, a point feature near a tile boundary may appear in multiple tiles due to tile buffering.

-}
queryRenderedFeatures : Outgoing msg -> Id -> Int -> List (Option { layers : Supported, filter : Supported, query : Supported }) -> Cmd msg
queryRenderedFeatures prt id reqId options =
    makeCmd prt
        id
        "queryRenderedFeatures"
        [ ( "requestId", Encode.int reqId )
        , encodeOptions options
        ]


{-| Wraps an incoming port so that you can get nicer subscritions:

    port elmMapboxIncoming : (Value -> msg) -> Sub msg

-}
queryResults : ((Value -> msg) -> Sub msg) -> (Int -> ( LngLat, LngLat ) -> response) -> (Int -> List Value -> response) -> (String -> response) -> (response -> msg) -> Sub msg
queryResults prt getBounds queryRenderedFeatures error tagger =
    prt (decodeResponse getBounds queryRenderedFeatures error >> tagger)


responseDecoder getBounds queryRenderedFeatures =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\s ->
                case s of
                    "getBounds" ->
                        Decode.map2 getBounds (Decode.field "id" Decode.int) (Decode.field "bounds" (decodePair LngLat.decodeFromPair))

                    "queryRenderedFeatures" ->
                        Decode.map2 queryRenderedFeatures (Decode.field "id" Decode.int) (Decode.field "features" (Decode.list Decode.value))

                    _ ->
                        Decode.fail <| "Unrecognized response type: " ++ s
            )


decodeResponse getBounds queryRenderedFeatures error value =
    case Decode.decodeValue (responseDecoder getBounds queryRenderedFeatures) value of
        Ok res ->
            res

        Err e ->
            error e
