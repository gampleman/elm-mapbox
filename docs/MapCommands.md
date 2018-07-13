# MapCommands

This module has a bunch of essentially imperative commands for your map.

#### `id : String`

Maps should use this as their DOM id.

## Moving the map around

#### `panBy : List (Option { duration : S, easing : S, offset : S, animate : S }) -> ( Int, Int ) -> Cmd msg`

Pans the map by the specified offset.

#### `panTo : List (Option { duration : S, easing : S, offset : S, animate : S }) -> LngLat -> Cmd msg`

Pans the map to the specified location, with an animated transition.


#### `zoomTo : List (Option { duration : S, easing : S, offset : S, animate : S }) -> Float -> Cmd msg`

Zooms the map to the specified zoom level, with an animated transition.

#### `zoomIn : List (Option { duration : S, easing : S, offset : S, animate : S }) -> Cmd msg`

Increases the map's zoom level by 1.


#### `zoomOut : List (Option { duration : S, easing : S, offset : S, animate : S }) -> Cmd msg`

Decreases the map's zoom level by 1.

#### `rotateTo : List (Option { duration : S, easing : S, offset : S, animate : S }) -> Float -> Cmd msg`

Rotates the map to the specified bearing, with an animated transition. The bearing is the compass direction that is "up"; for example, a bearing of 90° orients the map so that east is up.

#### `jumpTo : List (Option { center : S, zoom : S, bearing : S, pitch : S, around : S }) -> Cmd msg`

Changes any combination of center, zoom, bearing, and pitch, without an animated transition. The map will retain its current values for any details not specified in options.

#### `easeTo : List (Option { ... }) -> Cmd msg`

Changes any combination of center, zoom, bearing, and pitch, with an animated transition between old and new values. The map will retain its current values for any details not specified in options.

Supported options:

- `center`
- `zoom`
- `bearing`
- `pitch`
- `around`
- `duration`
- `easing`
- `offset`
- `animate`

#### `flyTo : List (Option { ... }) -> Cmd msg`

Changes any combination of center, zoom, bearing, and pitch, animating the transition along a curve that evokes flight. The animation seamlessly incorporates zooming and panning to help the user maintain her bearings even after traversing a great distance.

Supported options:

- `center`
- `zoom`
- `bearing`
- `pitch`
- `around`
- `duration`
- `easing`
- `offset`
- `animate`
- `curve`
- `minZoom`
- `speed`
- `screenSpeed`
- `maxDuration`

#### `stop : Cmd msg`

Stops any animated transition underway.

## Fitting bounds

#### `fitBounds : List (Option { ... }) -> ( LngLat, LngLat ) -> Cmd msg`

Pans and zooms the map to contain its visible area within the specified geographical bounds. This function will also reset the map's bearing to 0 if bearing is nonzero.

Supported options:

- `padding`
- `easing`
- `linear`
- `offset`
- `maxZoom`


## Right-to-left

#### `setRTLTextPlugin : String -> Cmd msg`

Sets the map's [RTL text plugin](https://www.mapbox.com/mapbox-gl-js/plugins/#mapbox-gl-rtl-text). Necessary for supporting languages like Arabic and Hebrew that are written right-to-left. Takes a URL pointing to the Mapbox RTL text plugin source.


## Querying the map

```
type Response
    = GetBounds Int ( LngLat, LngLat )
    | QueryRenderedFeatures Int (List Value)
    | Error String
```

#### `queryResults : (Response -> msg) -> Sub msg`

Receive results from the queries.


#### `getBounds : Int -> Cmd msg`

Responds with the map's geographical bounds. Takes a numerical ID that allows you to associate the question with the answer.

### `queryRenderedFeatures : Int -> List (Option { layers : S, filter : S, query : S }) -> Query -> Cmd msg`

Returns an array of GeoJSON Feature objects representing visible features that satisfy the query parameters. Takes a numerical ID that allows you to associate the question with the answer.

The response: The properties value of each returned feature object contains the properties of its source feature. For GeoJSON sources, only string and numeric property values are supported (i.e. null, Array, and Object values are not supported).

Each feature includes a top-level layer property whose value is an object representing the style layer to which the feature belongs. Layout and paint properties in this object contain values which are fully evaluated for the given zoom level and feature.

Features from layers whose visibility property is "none", or from layers whose zoom range excludes the current zoom level are not included. Symbol features that have been hidden due to text or icon collision are not included. Features from all other layers are included, including features that may have no visible contribution to the rendered result; for example, because the layer's opacity or color alpha component is set to 0.

The topmost rendered feature appears first in the returned array, and subsequent features are sorted by descending z-order. Features that are rendered multiple times (due to wrapping across the antimeridian at low zoom levels) are returned only once (though subject to the following caveat).

Because features come from tiled vector data or GeoJSON data that is converted to tiles internally, feature geometries may be split or duplicated across tile boundaries and, as a result, features may appear multiple times in query results. For example, suppose there is a highway running through the bounding rectangle of a query. The results of the query will be those parts of the highway that lie within the map tiles covering the bounding rectangle, even if the highway extends into other tiles, and the portion of the highway within each map tile will be returned as a separate feature. Similarly, a point feature near a tile boundary may appear in multiple tiles due to tile buffering.
