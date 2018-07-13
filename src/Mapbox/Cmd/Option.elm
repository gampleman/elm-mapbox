module Mapbox.Cmd.Option exposing (duration, easing, offset, animate, curve, minZoom, speed, screenSpeed, maxDuration, center, zoom, bearing, pitch, around, padding, Padding, linear, maxZoom, layers, filter, intersectsPoint, intersectsBox)

{-|


### Animation options

Options common to map movement commands that involve animation, such as panBy and easeTo, controlling the duration and easing function of the animation. All properties are optional.

@docs duration, easing, offset, animate

@docs curve, minZoom, speed, screenSpeed, maxDuration


### Camera Options

Options common to `jumpTo`, `easeTo`, and `flyTo`, controlling the desired location, zoom, bearing, and pitch of the camera. All properties are optional, and when a property is omitted, the current camera value for that property will remain unchanged.

@docs center, zoom, bearing, pitch, around


### Fiting bounds

@docs padding, Padding, linear, maxZoom


### Querying rendered features

@docs layers, filter, intersectsPoint, intersectsBox

-}

import Mapbox.Helpers exposing (encodePair)
import Json.Encode as Encode exposing (Value)
import Mapbox.Cmd.Internal as Internal exposing (Option(..), Supported)
import Mapbox.Helpers exposing (encodePair)
import LngLat exposing (LngLat)
import Mapbox.Expression exposing (DataExpression, Expression)


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
    LngLat.encodeAsPair >> Option "center"


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
    LngLat.encodeAsPair >> Option "around"


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


{-| Only include layers that instersect this point.
-}
intersectsPoint : LngLat -> Option { a | query : Supported }
intersectsPoint =
    LngLat.encodeAsPair >> Option "query"


{-| Only include layers that instersect the box (defined as south west / north east corners).
-}
intersectsBox : ( LngLat, LngLat ) -> Option { a | query : Supported }
intersectsBox =
    encodePair (LngLat.encodeAsPair) >> Option "query"
