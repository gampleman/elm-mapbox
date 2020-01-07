import { registerCustomElement, registerPorts } from "elm-mapbox";
import "mapbox-gl/dist/mapbox-gl.css";
import { Elm } from "./Example04.elm";

const token = "pk.eyJ1IjoiZW...";


registerCustomElement({token});
var app = Elm.Example04.init({node: document.body});

registerPorts(app);
