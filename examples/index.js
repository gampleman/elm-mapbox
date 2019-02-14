import { registerCustomElement, registerPorts } from "elm-mapbox";
import "mapbox-gl/dist/mapbox-gl.css";
import { Elm } from "./Example02.elm";

const token = process.env.MAPBOX_TOKEN;

registerCustomElement({token});
var app = Elm.Example02.init({node: document.body});
// registerPorts(app);
