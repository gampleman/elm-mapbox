# elm-mapbox

Great looking and performant maps in Elm using MapboxGl. Discuss in #maps on the Elm Slack.

### How this works

This library uses a combination of ports and custom elements. To get going,
install the accompanying npm library:

    npm install --save elm-mapbox

Then, when you are instantiating your Elm application, change it from:

```javascript
var app = Elm.MyApp.fullscreen();
```

to

```javascript
import elmMapbox from "elm-mapbox";

var app = elmMapbox(Elm.MyApp.fullscreen());
```

(where `MyApp` is your main module and `fullscreen` can be any way of instantiating an elm application).

Additionally, you may pass in your mapbox token as an option to this method:

```javascript
import elmMapbox from "elm-mapbox";

var app = elmMapbox(Elm.MyApp.fullscreen(), {token: 'pk45.rejkgnwejk'});
```

Next, optionally, setup a ports module. The best way to do this is to to copy [this file](examples/MapCommands.elm) into your project.

This will allow you to easily use the commands to control parts of your map interactions imperatively.

### Example

Then you can go all out!

```elm
module Example01 exposing (main)

import Html exposing (div, text)
import Html.Attributes exposing (style)
import Json.Decode exposing (Value)
import Mapbox.Element exposing (..)
import Mapbox.Expression as E exposing (false, float, int, str, true)
import Mapbox.Layer as Layer
import Mapbox.Source as Source
import Mapbox.Style as Style exposing (Style(..))
import MapCommands


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \m -> Sub.none
        }


init =
    ( { position = ( 0, 0 ) }, Cmd.none )


type Msg
    = Hover EventData
    | Click EventData


mapPair f ( a, b ) =
    ( f a, f b )


update msg model =
    case msg of
        Hover { lngLat } ->
            ( { model | position = lngLat }, Cmd.none )

        Click { lngLat } ->
            ( model, MapCommands.fitBounds [] ( mapPair (\a -> a - 0.2) lngLat, mapPair (\a -> a + 0.2) lngLat ) )

style =
    Style
      { transition = Style.defaultTransition
      , light = Style.defaultLight
      , sources =
          [ Source.vectorFromUrl "composite" "mapbox://mapbox.mapbox-terrain-v2,mapbox.mapbox-streets-v7" ]
      , misc =
          [ Style.name "light"
          , Style.defaultCenter 20.39789404164037 43.22523201923144
          , Style.defaultZoomLevel 1.5967483759772743
          , Style.sprite "mapbox://sprites/user/cjht22eqw0lfc2ro6z0qhlm29"
          , Style.glyphs "mapbox://fonts/user/{fontstack}/{range}.pbf"
          ]
      , layers =
          [ Layer.background "background"
              [ E.rgba 246 246 244 1 |> Layer.backgroundColor
              ]
          , Layer.fill "landcover"
              "composite"
              [ Layer.sourceLayer "landcover"
              , E.any
                  [ E.getProperty (str "class") |> E.isEqual (str "wood")
                  , E.getProperty (str "class") |> E.isEqual (str "scrub")
                  , E.getProperty (str "class") |> E.isEqual (str "grass")
                  , E.getProperty (str "class") |> E.isEqual (str "crop")
                  ]
                  |> Layer.filter
              , Layer.fillColor (E.rgba 227 227 227 1)
              , Layer.fillOpacity (float 0.6)
              ]
          ]
      }

view model =
    div [ style [ ( "width", "100vw" ), ( "height", "100vh" ) ] ]
        [ css
        , map [ onMouseMove Hover, onClick Click, id MapCommands.id ] style
        , div [ style [ ( "position", "absolute" ), ( "bottom", "20px" ), ( "left", "20px" ) ] ] [ text (toString model.position) ]
        ]
```

### Support

This library is supported in all modern browsers. The `elmMapbox` library
has a `supported` function that can be injected via flags:

```javascript
import elmMapbox from "elm-mapbox";

var app = elmMapbox(Elm.MyApp.fullscreen({
  mapboxSupported: elmMapbox.supported({
    // If  true , the function will return  false if the performance of
    // Mapbox GL JS would be dramatically worse than expected (e.g. a
    // software WebGL renderer would be used).
    failIfMajorPerformanceCaveat: true
  })
}));
```

### Customizing the JS side

The `elmMapbox` function accepts an options object that takes the following options:

 - `token`: the Mapbox token. If you don't pass it here, you will need to use the `token` Elm attribute.
 - `outgoingPort`: the name of the outgoing port. Default: `elmMapboxOutgoing`.
 - `incomingPort`: the name of the incoming port. Default `elmMapboxIncoming`.
 - `easingFunctions`: an object whose values are easing functions (i.e. they take a number between 0..1 and return a number between 0..1). You can refer to these with the `easing` option in the Cmd module.

### License

(c) Jakub Hampl 2018

MIT License
