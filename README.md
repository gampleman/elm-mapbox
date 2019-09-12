
> This is only a fork of the great elm-mapbox library from Jakub Hampl with some
> quick fixes, that I needed for my project. Please use the original version from
> https://github.com/gampleman/elm-mapbox
>
> I will remove the project when this functionality will be available in the
> original project.

__Changes:__

* Use the patch after running `npm i` in order to remove some errors
  (at least on my system) with TouchEvents and not ready loaded maps

  `patch -N node_modules/elm-mapbox/dist/elm-mapbox.umd.js < elm-mapbox.umd.js.patch`

* This version contains some decoders for `StyleDef`, which are nice to
  use, if you want to load your maps from MapBox-Studio and add some custom
  layers in your code ... see for example examples/Example04

* Or, as in my case, you can also use the great style generator to generate your
  `StyleDef`, which in my case caused some errors and remove the layers by a
  simple json-parser. Simply copy your original json definition into a string ...

  ``` elm
  Style
    { transition = Style.defaultTransition
    , light = Style.defaultLight
    , layers =
        """
        [{"id": "background","type": "background","layout": {"visibility": "visi
        ble"},"paint": {"background-color": "#fff", "background-opacity": 1},"in
        teractive": true},{"id": "waterway","type": "line","metadata": {"mapbox:
        group": "1452116608071.19"},"source": "mapbox://mapbox.mapbox-streets-v6
        ","source-layer": "waterway","layout": {"visibility": "visible","line-ca
        p": "round","line-join": "round"},"paint": {"line-width": 2,"line-color"
        : "#62b0f0","line-blur": 0,"line-opacity": 0.7},"interactive": true},{"i
        d": "water","type": "fill","metadata": {"mapbox:group": "14521166080 ...
        """
         |> Layer.jsonList
    , ...
  ```

* If you want to achieve the same, but only for one layer, then use `Layer.json`...




# elm-mapbox

Great looking and performant maps in Elm using MapboxGl. Discuss in #maps on the Elm Slack.

### High Quality Mapping in Elm

There have been [some attempts](https://github.com/gampleman/elm-visualization/wiki/Data-Visualization-Packages#maps) to make native elm mapping packages. However, Mapbox offers a very complex solution that offers some killer features that are difficult to reproduce:

- client side high quality cartography
- high performance with large datasets

The way this works, the map accepts a configuration object called a **style**. The main thing in a style is a list of **layers**. Layers control what you see on the screen. Their order controls their layering (duh). Each layer references a data **source** and has a list of properties. Properties are a bit like CSS for maps in the sense that you can use them to specify colors, line thickness, etc. However, unlike CSS, the values that you pass to these use are **expressions** in a little language, that allows you to style based on other factors like the map's zoom level or actual data in any of the **features** being styled.

**Sources** specify how to get the data that powers the layers. Multiple layers can take in a single source.

This library allows you to specify the **style** declaratively passing it into a specific element in your view function. However, the map element holds some internal state: mostly about the position of the viewport and all the event handling needed to manipulate it. In my experience this is mostly what you want - the default map interactions tend to be appropriate. So this library includes commands that tell the map to modify its internal state (including stuff like animations etc).

### How does this Work?

This is a hybrid library that consists both of Elm and JavaScript parts. It uses a combination of ports and custom elements for communication between them.

### Getting Started

To get going, install the package and the accompanying npm library:

    elm install gampleman/elm-mapbox
    npm install --save elm-mapbox

Microsoft Edge needs a polyfill to use custom elements. The polyfill provided by
webcomponents.org is known to work https://github.com/webcomponents/custom-elements:

    npm install --save @webcomponents/custom-elements

Then include the library into your page. How exactly to do this depends on how you are building your application. We recommend using [Parcel](https://parceljs.org/), since it is super easy to setup. Then you will want to make your `index.js` look something like this:

```javascript
// polyfill for custom elements. Optional, see https://caniuse.com/#feat=custom-elementsv1
import "@webcomponents/custom-elements";

import { registerCustomElement, registerPorts } from "elm-mapbox";

// This brings in mapbox required CSS
import "mapbox-gl/dist/mapbox-gl.css";

// Your Elm application
import { Elm } from "./src/Main.elm";

// A Mapbox API token. Register at https://mapbox.com to get one of these. It's free.
const token =
    "pk.eyJ1Ijovm,vedfg";

// This will add elm-mapbox custom element into the page's registry.
// This **must** happen before your application attempts to render a map.
registerCustomElement({
    token
});

// Initialize your Elm application. There are a few different ways
// to do this, whichever you choose doesn't matter.
var app = Elm.Main.init({ flags: {} });

// Register ports. You only need to do this if you use the port integration.
// I usually keep this commented out until I need it.
registerPorts(app);
```

Next, optionally, setup a ports module. The best way to do this is to to copy [this file](https://github.com/gampleman/elm-mapbox/blob/master/examples/MapCommands.elm) into your project. I usually name it `Map/Cmd.elm` This will allow you to easily use the commands to control parts of your map interactions imperatively - for example you can command your map to fly to a particular location.

Finally, you will need to setup a base style. You can copy some of the [example styles](https://github.com/gampleman/elm-mapbox/blob/master/examples/Styles), or you can use the (beta) [Style code generator](https://code.gampleman.eu/elm-mapbox/style-generator/) in conjunction with [Mapbox Studio](https://www.mapbox.com/mapbox-studio/).

### Example

See [Example01](https://github.com/gampleman/elm-geospatial/blob/master/examples/src/Example01.elm) for an example application.


### Support

This library is supported in all modern browsers. The `elmMapbox` library
has a `supported` function that can be injected via flags:

```javascript
import {supported} from "elm-mapbox";

var app = Elm.MyApp.fullscreen({
  mapboxSupported: supported({
    // If  true , the function will return  false if the performance of
    // Mapbox GL JS would be dramatically worse than expected (e.g. a
    // software WebGL renderer would be used).
    failIfMajorPerformanceCaveat: true
  })
});
```

### Customizing the JS side

The `registerCustomElement` function accepts an options object that takes the following options:

 - `token`: the Mapbox token. If you don't pass it here, you will need to use the `token` Elm attribute.
 - `onMount` a callback that gives you access to the mapbox instance whenever a map gets instantiated. Mostly useful for registering [plugins](https://www.mapbox.com/mapbox-gl-js/plugins).

Furthermore, the elm-mapbox element exposes its internal mapboxgl.js reference as a `map` property, which you can use if necessary (although, worth mentioning on slack if you are needing to do this).

The `registerPorts` function accepts an option object that takes the following options:

 - `easingFunctions`: an object whose values are easing functions (i.e. they take a number between 0..1 and return a number between 0..1). You can refer to these with the `easing` option in the Cmd.Option module.

### License

(c) Jakub Hampl 2018, 2019

MIT License
