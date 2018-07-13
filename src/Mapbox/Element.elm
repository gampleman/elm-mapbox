module Mapbox.Element exposing (map, css, MapboxAttr, token, id, maxZoom, minZoom, maxBounds, renderWorldCopies, EventData, TouchEvent, eventFeaturesFilter, eventFeaturesLayers, onMouseDown, onMouseUp, onMouseOver, onMouseMove, onClick, onDblClick, onMouseOut, onContextMenu, onZoom, onZoomStart, onZoomEnd, onRotate, onRotateStart, onRotateEnd, onTouchEnd, onTouchMove, onTouchCancel)

{-| This library wraps a Custom Element that actually renders a map.

@docs map, css, MapboxAttr


### Attributes

@docs token, id, maxZoom, minZoom, maxBounds, renderWorldCopies


### Events

@docs EventData, TouchEvent, eventFeaturesFilter, eventFeaturesLayers

@docs onMouseDown, onMouseUp, onMouseOver, onMouseMove, onClick, onDblClick, onMouseOut, onContextMenu, onZoom, onZoomStart, onZoomEnd, onRotate, onRotateStart, onRotateEnd, onTouchEnd, onTouchMove, onTouchCancel

-}

import Html exposing (Attribute, Html, node)
import Html.Attributes exposing (attribute, property)
import Html.Events exposing (Options)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode
import LngLat exposing (LngLat)
import Mapbox.Expression exposing (DataExpression, Expression)
import Mapbox.Style exposing (Style)
import Mapbox.Helpers exposing (encodePair)


{-| This is the type that all attributes have.
-}
type MapboxAttr msg
    = MapboxAttr (Attribute msg)


type Position
    = TopLeft
    | BottomLeft
    | TopRight
    | BottomRight


{-| A Map html element renders a map based on a Style.
-}
map : List (MapboxAttr msg) -> Style -> Html msg
map attrs style =
    let
        props =
            (Mapbox.Style.encode style
                |> property "mapboxStyle"
            )
                :: (List.map (\(MapboxAttr attr) -> attr) attrs)
    in
        node "elm-mapbox-map" props []


{-| This is literally:

    <link
      href='https://api.tiles.mapbox.com/mapbox-gl-js/v0.46.0/mapbox-gl.css'
      rel='stylesheet' />

You can include the required styles yourself if it fits better with the way you deploy your assets, this is meant as a quick way to get started.

-}
css : Html msg
css =
    node "link" [ attribute "href" "https://api.tiles.mapbox.com/mapbox-gl-js/v0.46.0/mapbox-gl.css", attribute "rel" "stylesheet" ] []


{-| The minimum zoom level of the map (0-24).
-}
minZoom : Float -> MapboxAttr msg
minZoom =
    Encode.float >> property "minZoom" >> MapboxAttr


{-| The maximum zoom level of the map (0-24). Default 22.
-}
maxZoom : Float -> MapboxAttr msg
maxZoom =
    Encode.float >> property "maxZoom" >> MapboxAttr


{-| Your [Mapbox API Token](https://www.mapbox.com/help/create-api-access-token/).
-}
token : String -> MapboxAttr msg
token =
    Encode.string >> property "token" >> MapboxAttr


{-| The element's Id. This should be unique. You will need this if you want to use the Mapbox.Cmd module.
-}
id : String -> MapboxAttr msg
id =
    attribute "id" >> MapboxAttr


{-| If set, the map will be constrained to the given bounds. The bounds are the `(south-west corner, north-east corner)`.
-}
maxBounds : ( LngLat, LngLat ) -> MapboxAttr msg
maxBounds =
    encodePair LngLat.encodeAsPair >> property "maxBounds" >> MapboxAttr


{-| If true, multiple copies of the world will be rendered, when zoomed out.
-}
renderWorldCopies : Bool -> MapboxAttr msg
renderWorldCopies =
    Encode.bool >> property "renderWorldCopies" >> MapboxAttr


{-| This is a declarative API for controlling states on the features.

The API takes a bunch of GeoJSON features (these can be returned from the event listeners for example). They should at a minimum have these properties defined:

  - `source`
  - `sourceLayer` (only for vector sources)
  - `id` the feature's unique id

Then you can give it a `List ( String, Value )` state. You can use this state infromation through the `Mapbox.Expression.featureState` expression.

This needs more design before release.

-}
featureState : List ( Value, List ( String, Value ) ) -> MapboxAttr msg
featureState =
    List.map (\( feature, state ) -> Encode.list [ feature, Encode.object state ])
        >> Encode.list
        >> property "featureState"
        >> MapboxAttr



-- Events


{-| By default the `renderedFeatures` property in events will return
a lot of data. If you don't need it, you can provide a filter to filter that data. This will make things more performant.
-}
eventFeaturesFilter : Expression DataExpression Bool -> MapboxAttr msg
eventFeaturesFilter =
    Mapbox.Expression.encode >> property "eventFeaturesFilter" >> MapboxAttr


{-| By default the `renderedFeatures` property in events will return
a lot of data. Here you can specify which layers you want to search for intersections. If you don't care about intersecting data at all, you can optimize performance by passing an empty list to this attribute.
-}
eventFeaturesLayers : List String -> MapboxAttr msg
eventFeaturesLayers =
    List.map Encode.string >> Encode.list >> property "eventFeaturesLayers" >> MapboxAttr


{-| This allows you to use other events not provided by this libary.

See <https://www.mapbox.com/mapbox-gl-js/api/#map.event> for all supported events.

-}
onWithOptions : String -> Options -> Decoder msg -> MapboxAttr msg
onWithOptions type_ opts decoder =
    Html.Events.onWithOptions type_ opts decoder |> MapboxAttr


{-| `point` is the coordinates in pixels in screen space.

`lngLat` is the coordinates as a longitude, latitude in geographic space.

`renderedFeatures` is a geojson that intersect the `lngLat`:

The properties value of each returned feature object contains the properties of its source feature. For GeoJSON sources, only string and numeric property values are supported (i.e. null, Array, and Object values are not supported).

Each feature includes a top-level layer property whose value is an object representing the style layer to which the feature belongs. Layout and paint properties in this object contain values which are fully evaluated for the given zoom level and feature.

Features from layers whose visibility property is "none", or from layers whose zoom range excludes the current zoom level are not included. Symbol features that have been hidden due to text or icon collision are not included. Features from all other layers are included, including features that may have no visible contribution to the rendered result; for example, because the layer's opacity or color alpha component is set to 0.

The topmost rendered feature appears first in the returned array, and subsequent features are sorted by descending z-order. Features that are rendered multiple times (due to wrapping across the antimeridian at low zoom levels) are returned only once (though subject to the following caveat).

Because features come from tiled vector data or GeoJSON data that is converted to tiles internally, feature geometries may be split or duplicated across tile boundaries and, as a result, features may appear multiple times in query results. For example, suppose there is a highway running through the bounding rectangle of a query. The results of the query will be those parts of the highway that lie within the map tiles covering the bounding rectangle, even if the highway extends into other tiles, and the portion of the highway within each map tile will be returned as a separate feature. Similarly, a point feature near a tile boundary may appear in multiple tiles due to tile buffering.

-}
type alias EventData =
    { point : ( Int, Int )
    , lngLat : LngLat
    , renderedFeatures : List Value
    }


{-| `touches` will list stuff for every finger involved in a gesture.

`center` refers to the point in the geometric center of `touches`.

-}
type alias TouchEvent =
    { touches : List EventData
    , center : EventData
    }


decodePoint =
    Decode.map2 (,) (Decode.field "x" Decode.int) (Decode.field "y" Decode.int)


decodeEventData =
    Decode.map3 EventData
        (Decode.field "point" decodePoint)
        (Decode.field "lngLat" LngLat.decodeFromObject)
        (Decode.field "features" (Decode.list Decode.value))


decodeTouchEvent =
    Decode.map2 TouchEvent
        (Decode.map3 (List.map3 EventData)
            (Decode.field "points" (Decode.list decodePoint))
            (Decode.field "lngLats" (Decode.list LngLat.decodeFromObject))
            (Decode.field "perPointFeatures" (Decode.list (Decode.list Decode.value)))
        )
        decodeEventData


{-| Fired when a pointing device (usually a mouse) is pressed within the map.
-}
onMouseDown : (EventData -> msg) -> MapboxAttr msg
onMouseDown tagger =
    Html.Events.on "mousedown" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired when a pointing device (usually a mouse) is released within the map.
-}
onMouseUp : (EventData -> msg) -> MapboxAttr msg
onMouseUp tagger =
    Html.Events.on "mouseup" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired when a pointing device (usually a mouse) is moved within the map.
-}
onMouseOver : (EventData -> msg) -> MapboxAttr msg
onMouseOver tagger =
    Html.Events.on "mouseover" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired when a pointing device (usually a mouse) is moved within the map.
-}
onMouseMove : (EventData -> msg) -> MapboxAttr msg
onMouseMove tagger =
    Html.Events.on "mousemove" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired when a pointing device (usually a mouse) is pressed and released at the same point on the map.
-}
onClick : (EventData -> msg) -> MapboxAttr msg
onClick tagger =
    Html.Events.on "click" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired when a pointing device (usually a mouse) is clicked twice at the same point on the map.
-}
onDblClick : (EventData -> msg) -> MapboxAttr msg
onDblClick tagger =
    Html.Events.on "dblclick" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired when a point device (usually a mouse) leaves the map's canvas.
-}
onMouseOut : (EventData -> msg) -> MapboxAttr msg
onMouseOut tagger =
    Html.Events.on "mouseout" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired when the right button of the mouse is clicked or the context menu key is pressed within the map.
-}
onContextMenu : (EventData -> msg) -> MapboxAttr msg
onContextMenu tagger =
    Html.Events.on "contextmenu" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired repeatedly during an animated transition from one zoom level to another.
-}
onZoom : (EventData -> msg) -> MapboxAttr msg
onZoom tagger =
    Html.Events.on "zoom" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired just before the map begins a transition from one zoom level to another.
-}
onZoomStart : (EventData -> msg) -> MapboxAttr msg
onZoomStart tagger =
    Html.Events.on "zoomstart" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired just after the map completes a transition from one zoom level to another.
-}
onZoomEnd : (EventData -> msg) -> MapboxAttr msg
onZoomEnd tagger =
    Html.Events.on "zoomend" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired repeatedly during a "drag to rotate" interaction.
-}
onRotate : (EventData -> msg) -> MapboxAttr msg
onRotate tagger =
    Html.Events.on "rotate" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired when a "drag to rotate" interaction starts.
-}
onRotateStart : (EventData -> msg) -> MapboxAttr msg
onRotateStart tagger =
    Html.Events.on "rotatestart" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired when a "drag to rotate" interaction ends.
-}
onRotateEnd : (EventData -> msg) -> MapboxAttr msg
onRotateEnd tagger =
    Html.Events.on "rotateend" (Decode.map tagger decodeEventData)
        |> MapboxAttr


{-| Fired when a touchend event occurs within the map.
-}
onTouchEnd : (TouchEvent -> msg) -> MapboxAttr msg
onTouchEnd tagger =
    Html.Events.on "touchend" (Decode.map tagger decodeTouchEvent)
        |> MapboxAttr


{-| Fired when a touchmove event occurs within the map.
-}
onTouchMove : (TouchEvent -> msg) -> MapboxAttr msg
onTouchMove tagger =
    Html.Events.on "touchmove" (Decode.map tagger decodeTouchEvent)
        |> MapboxAttr


{-| Fired when a touchcancel event occurs within the map.
-}
onTouchCancel : (TouchEvent -> msg) -> MapboxAttr msg
onTouchCancel tagger =
    Html.Events.on "touchcancel" (Decode.map tagger decodeTouchEvent)
        |> MapboxAttr



-- encodePosition pos =
--     case pos of
--         TopLeft ->
--             Encode.string "top-left"
--
--         BottomLeft ->
--             Encode.string "bottom-left"
--
--         TopRight ->
--             Encode.string "top-right"
--
--         BottomRight ->
--             Encode.string "bottom-right"
--- Controlled mode


{-| -}
type alias Viewport =
    { center : LngLat
    , zoom : Float
    , bearing : Float
    , pitch : Float
    }


{-| By default the map is "uncontrolled". By this we mean that it has its own internal state (namely the center, zoom level, pitch and bearing). This is nice if you don't care about these, but it does break some of the niceness of TEA. It also means some advanced interaction techniques are impossible to implement. For this reason we allow controlled mode where no event handlers are attached, but you need to feed the element its state. So it's up to you to implement all the user interactions. In the future, this library may help with that, but in the present this is not available.

Not done, so let's not release this.

-}
controlledMap : Viewport -> List (MapboxAttr msg) -> Style -> Html msg
controlledMap { center, zoom, bearing, pitch } attrs style =
    let
        props =
            property "mapboxStyle" (Mapbox.Style.encode style)
                :: property "interactive" (Encode.bool False)
                :: property "center" (LngLat.encodeAsPair center)
                :: property "zoom" (Encode.float zoom)
                :: property "bearing" (Encode.float bearing)
                :: property "pitch" (Encode.float pitch)
                :: List.map (\(MapboxAttr attr) -> attr) attrs
    in
        node "elm-mapbox-map" props []
