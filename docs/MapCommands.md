# MapCommands

Tell your map to do something! Most of these Commands tell your map to (with or without animation) to show a different location. You can use the options from `Mapbox.Cmd.Option` to configure these.

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

#### `fitBounds : List (Option { ... }) -> ( LngLat, LngLat ) -> Cmd msg`

Pans and zooms the map to contain its visible area within the specified geographical bounds. This function will also reset the map's bearing to 0 if bearing is nonzero.

Supported options:

- `padding`
- `easing`
- `linear`
- `offset`
- `maxZoom`


#### `stop : Cmd msg`

Stops any animated transition underway.


## Other

#### `resize : Cmd msg`

Resizes the map according to the dimensions of its container element.

This command must be sent after the map's container is resized, or when the map is shown after being initially hidden with CSS.
