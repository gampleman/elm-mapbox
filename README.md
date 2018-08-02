# elm-mapbox

Great looking and performant maps in Elm using MapboxGl. Discuss in #maps on the Elm Slack.

### High quality mapping in Elm

There have been [some attempts](https://github.com/gampleman/elm-visualization/wiki/Data-Visualization-Packages#maps) to make native elm mapping packages. However, Mapbox offers a very complex solution that offers some killer features that are difficult to reproduce:

- client side high quality cartography
- high performance with large datasets

The way this works, the map accepts a configuration object called a **style**. The main thing in a style is a list of **layers**. Layers control what you see on the screen. Their order controls their layering (duh). Each layer references a data **source** and has a list of properties. Properties are a bit like CSS for maps in the sense that you can use them to specify colors, line thickness, etc. However, unlike CSS, the values that you pass to these use are **expressions** in a little language, that allows you to style based on other factors like the map's zoom level or actual data in any of the **features** being styled.

**Sources** specify how to get the data that powers the layers. Multiple layers can take in a single source.

This library allows you to specify the **style** declaratively passing it into a specific element in your view function. However, the map element holds some internal state: mostly about the position of the viewport and all the event handling needed to manipulate it. In my experience this is mostly what you want - the default map interactions tend to be appropriate. So this library includes commands that tell the map to modify its internal state (including stuff like animations etc).

### How this works

This library uses a combination of ports and custom elements. To get going,
install the accompanying npm library:

    npm install --save elm-mapbox

Then, when you are instantiating your Elm application, change it from:

```javascript
var app = Elm.MyApp.init();
```

to

```javascript
import elmMapbox from "elm-mapbox";

elmMapbox.registerCustomElement();
var app = Elm.MyApp.init();
elmMapbox.registerPorts(app);
```

(where `MyApp` is your main module and `init` can be any way of instantiating an elm application).

It is important that these operations proceed in this order, i.e. the custom element is registered before the application first renders. The ports can only be setup immediately afterwards (as they need a reference to the application).

Additionally, you may pass in your mapbox token as an option through this method:

```javascript
import elmMapbox from "elm-mapbox";

elmMapbox.registerCustomElement({token: 'pk45.rejkgnwejk'});
var app = Elm.MyApp.init();
elmMapbox.registerPorts(app);
```

Next, optionally, setup a ports module. The best way to do this is to to copy [this file](examples/MapCommands.elm) into your project.

This will allow you to easily use the commands to control parts of your map interactions imperatively.

### Example

Then you can go all out!

```elm
module Example01 exposing (main)

import Html exposing (div, text)
import Html.Attributes exposing (style)
import LngLat exposing (LngLat)
import MapCommands
import Mapbox.Cmd.Option as Opt
import Mapbox.Element exposing (..)
import Mapbox.Expression as E exposing (false, float, int, str, true)
import Mapbox.Layer as Layer
import Mapbox.Source as Source
import Mapbox.Style as Style exposing (Style(..))


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \m -> Sub.none
        }


init =
    ( { position = LngLat 0 0 }, Cmd.none )


type Msg
    = Hover EventData
    | Click EventData


update msg model =
    case msg of
        Hover { lngLat } ->
            ( { model | position = lngLat }, Cmd.none )

        Click { lngLat } ->
            ( model, MapCommands.fitBounds [ Opt.linear True, Opt.maxZoom 10 ] ( LngLat.map (\a -> a - 0.2) lngLat, LngLat.map (\a -> a + 0.2) lngLat ) )


view model =
    div [ style [ ( "width", "100vw" ), ( "height", "100vh" ) ] ]
        [ css
        , map
            [ maxZoom 5
            , onMouseMove Hover
            , onClick Click
            , id "my-map"
            ]
            (Style
                { transition = Style.defaultTransition
                , light = Style.defaultLight
                , sources =
                    [ Source.vectorFromUrl "composite" "mapbox://mapbox.mapbox-terrain-v2,mapbox.mapbox-streets-v7" ]
                , misc =
                    [ Style.name "light"
                    , Style.defaultCenter <| LngLat 20.39789404164037 43.22523201923144
                    , Style.defaultZoomLevel 1.5967483759772743
                    , Style.sprite "mapbox://sprites/astrosat/cjht22eqw0lfc2ro6z0qhlm29"
                    , Style.glyphs "mapbox://fonts/astrosat/{fontstack}/{range}.pbf"
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

                        , Layer.fillColor (E.ifElse (E.coalesce [ (E.featureState (str "hover")), false ]) (E.rgba 20 227 227 1) (E.rgba 227 227 227 1))
                        , Layer.fillOpacity (float 0.6)
                        ]
                    ]
                }
            )
        , div [ style [ ( "position", "absolute" ), ( "bottom", "20px" ), ( "left", "20px" ) ] ] [ text (toString model.position) ]
        ]
```

### Support

This library is supported in all modern browsers. The `elmMapbox` library
has a `supported` function that can be injected via flags:

```javascript
import elmMapbox from "elm-mapbox";

var app = Elm.MyApp.fullscreen({
  mapboxSupported: elmMapbox.supported({
    // If  true , the function will return  false if the performance of
    // Mapbox GL JS would be dramatically worse than expected (e.g. a
    // software WebGL renderer would be used).
    failIfMajorPerformanceCaveat: true
  })
});
```

### Customizing the JS side

The `elmMapbox.registerCustomElement` function accepts an options object that takes the following options:

 - `token`: the Mapbox token. If you don't pass it here, you will need to use the `token` Elm attribute.
 - `onMount` a callback that gives you access to the mapbox instance whenever a map gets instantiated. Mostly useful for registering [plugins](https://www.mapbox.com/mapbox-gl-js/plugins).

Furthermore, the elm-mapbox element exposes its internal mapboxgl.js reference as a `map` property, which you can use if necessary (although, worth mentioning on slack if you are needing to do this).

The `elmMapbox.registerPorts` function accepts an option object that takes the following options:

 - `easingFunctions`: an object whose values are easing functions (i.e. they take a number between 0..1 and return a number between 0..1). You can refer to these with the `easing` option in the Cmd.Option module.

### License

(c) Jakub Hampl 2018

MIT License
