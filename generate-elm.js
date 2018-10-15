function generateProperties(spec) {
  const layouts = spec.layout;
  const paints = spec.paint;
  var codes = {};
  var docs = {};
  var enums = {};
  layouts.forEach(l => {
    const layerType = titleCase(l.split("_")[1]);
    docs[layerType] = [];
    codes[layerType] = [];
    Object.entries(spec[l]).forEach(([name, prop]) => {
      if (name == "visibility") return "";
      if (prop.type === "enum") {
        enums[name] = Object.keys(prop.values).join(" | ");
      }
      codes[layerType].push(
        generateElmProperty(name, prop, layerType, "Layout")
      );
      docs[layerType].push(camelCase(name));
    });
  });
  paints.forEach(l => {
    const layerType = titleCase(l.split("_")[1]);
    Object.entries(spec[l]).forEach(([name, prop]) => {
      if (name == "visibility") return "";
      if (prop.type === "enum") {
        enums[name] = Object.keys(prop.values).join(" | ");
      }
      codes[layerType].push(
        generateElmProperty(name, prop, layerType, "Paint")
      );
      docs[layerType].push(camelCase(name));
    });
  });
  Object.values(docs).forEach(d => d.sort());
  Object.values(codes).forEach(d => d.sort());
  return `
module Mapbox.Layer exposing (
  Layer, SourceId, Background, Fill, Symbol, Line, Raster, Circle, FillExtrusion, Heatmap, Hillshade, LayerAttr,
  encode,
  background, fill, symbol, line, raster, circle, fillExtrusion, heatmap, hillshade,
  metadata, sourceLayer, minzoom, maxzoom, filter, visible,
  ${Object.values(docs)
    .map(d => d.join(", "))
    .join(",\n  ")})
{-|
Layers specify what is actually rendered on the map and are rendered in order.

Except for layers of the background type, each layer needs to refer to a source. Layers take the data that they get from a source, optionally filter features, and then define how those features are styled.

There are two kinds of properties: *Layout* and *Paint* properties.

Layout properties are applied early in the rendering process and define how data for that layer is passed to the GPU. Changes to a layout property require an asynchronous "layout" step.

Paint properties are applied later in the rendering process. Changes to a paint property are cheap and happen synchronously.


### Working with layers

@docs Layer, SourceId, encode

### Layer Types

@docs background, fill, symbol, line, raster, circle, fillExtrusion, heatmap, hillshade
@docs Background, Fill, Symbol, Line, Raster, Circle, FillExtrusion, Heatmap, Hillshade

### General Attributes

@docs LayerAttr
@docs metadata, sourceLayer, minzoom, maxzoom, filter, visible

${Object.entries(docs)
    .map(
      ([section, docs]) =>
        `### ${section} Attributes\n\n@docs ${docs.join(", ")}`
    )
    .join("\n\n")}
-}

import Array exposing (Array)
import Json.Encode as Encode exposing (Value)
import Mapbox.Expression as Expression exposing (Anchor, Auto, CameraExpression, Color, DataExpression, Expression, LineCap, LineJoin, Position, RasterResampling, SymbolPlacement, TextFit, TextJustify, TextTransform, FormattedText, SymbolZOrder)

{-| Represents a layer. -}
type Layer
    = Layer Value

{-| All layers (except background layers) need a source -}
type alias SourceId = String

{-| -}
type Background
    = BackgroundLayer

{-| -}
type Fill
    = FillLayer

{-| -}
type Symbol
    = SymbolLayer

{-| -}
type Line
    = LineLayer

{-| -}
type Raster
    = RasterLayer

{-| -}
type Circle
    = CircleLayer

{-| -}
type FillExtrusion
    = FillExtrusionLayer

{-| -}
type Heatmap
    = HeatmapLayer

{-| -}
type Hillshade
    = HillshadeLayer

{-| Turns a layer into JSON -}
encode : Layer -> Value
encode (Layer value) =
    value


layerImpl tipe id source attrs =
    [ ( "type", Encode.string tipe )
    , ( "id", Encode.string id )
    , ( "source", Encode.string source)
    ]
        ++ encodeAttrs attrs
        |> Encode.object
        |> Layer


encodeAttrs attrs =
    let
        { top, layout, paint } =
            List.foldl
                (\\attr lists ->
                    case attr of
                        Top key val ->
                            { lists | top = ( key, val ) :: lists.top }

                        Paint key val ->
                            { lists | paint = ( key, val ) :: lists.paint }

                        Layout key val ->
                            { lists | layout = ( key, val ) :: lists.layout }
                )
                { top = [], layout = [], paint = [] }
                attrs
    in
        ( "layout", Encode.object layout ) :: ( "paint", Encode.object paint ) :: top

{-| The background color or pattern of the map. -}
background : String -> List (LayerAttr Background) -> Layer
background id attrs =
    [ ( "type", Encode.string "background" )
    , ( "id", Encode.string id )
    ]
        ++ encodeAttrs attrs
        |> Encode.object
        |> Layer

{-| A filled polygon with an optional stroked border. -}
fill : String -> SourceId -> List (LayerAttr Fill) -> Layer
fill =
    layerImpl "fill"

{-| A stroked line. -}
line : String  -> SourceId -> List (LayerAttr Line) -> Layer
line =
    layerImpl "line"

{-| An icon or a text label. -}
symbol : String  -> SourceId -> List (LayerAttr Symbol) -> Layer
symbol =
    layerImpl "symbol"

{-| Raster map textures such as satellite imagery. -}
raster : String -> SourceId -> List (LayerAttr Raster) -> Layer
raster =
    layerImpl "raster"

{-| A filled circle. -}
circle : String -> SourceId -> List (LayerAttr Circle) -> Layer
circle =
    layerImpl "circle"

{-| An extruded (3D) polygon. -}
fillExtrusion : String -> SourceId -> List (LayerAttr FillExtrusion) -> Layer
fillExtrusion =
    layerImpl "fill-extrusion"

{-| A heatmap. -}
heatmap : String -> SourceId -> List (LayerAttr Heatmap) -> Layer
heatmap =
    layerImpl "heatmap"

{-| Client-side hillshading visualization based on DEM data. Currently, the implementation only supports Mapbox Terrain RGB and Mapzen Terrarium tiles. -}
hillshade : String -> SourceId -> List (LayerAttr Hillshade) -> Layer
hillshade =
    layerImpl "hillshade"

{-| -}
type LayerAttr tipe
    = Top String Value
    | Paint String Value
    | Layout String Value



-- General Attributes

{-| Arbitrary properties useful to track with the layer, but do not influence rendering. Properties should be prefixed to avoid collisions, like 'mapbox:'. -}
metadata : Value -> LayerAttr all
metadata =
    Top "metadata"


{-| Layer to use from a vector tile source. Required for vector tile sources; prohibited for all other source types, including GeoJSON sources. -}
sourceLayer : String -> LayerAttr all
sourceLayer =
    Encode.string >> Top "source-layer"

{-| The minimum zoom level for the layer. At zoom levels less than the minzoom, the layer will be hidden. A number between 0 and 24 inclusive. -}
minzoom : Float -> LayerAttr all
minzoom =
    Encode.float >> Top "minzoom"

{-| The maximum zoom level for the layer. At zoom levels equal to or greater than the maxzoom, the layer will be hidden. A number between 0 and 24 inclusive. -}
maxzoom : Float -> LayerAttr all
maxzoom =
    Encode.float >> Top "maxzoom"

{-| A expression specifying conditions on source features. Only features that match the filter are displayed. -}
filter : Expression any Bool -> LayerAttr all
filter =
    Expression.encode >> Top "filter"

{-| Whether this layer is displayed. -}
visible : Expression CameraExpression Bool -> LayerAttr any
visible vis =
    Layout "visibility" <| Expression.encode <| Expression.ifElse vis (Expression.str "visible") (Expression.str "none")

${Object.entries(codes)
    .map(([section, codes]) => `-- ${section}\n\n${codes.join("\n")}`)
    .join("\n\n")}
`;
}

function codeSnippet(name, type) {
  return "`" + camelCase(name, type) + "`";
}

function requires(req) {
  if (typeof req === "string") {
    return `Requires ${codeSnippet(req)}.`;
  } else if (req["!"]) {
    return `Disabled by ${codeSnippet(req["!"])}.`;
  } else if (req["<="]) {
    return `Must be less than or equal to \`${camelCase(req["<="])}\`.`;
  } else {
    const [name, value] = Object.entries(req)[0];
    if (Array.isArray(value)) {
      return `Requires ${codeSnippet(name)} to be ${value.slice(1).reduce(
        (prev, curr) => prev + ", or " + codeSnippet(curr), codeSnippet(value[0])
      )}.`;
    } else {
      return `Requires ${codeSnippet(name)} to be \`${value}\`.`;
    }
  }
}

function generateElmProperty(name, prop, layerType, position) {
  if (name == "visibility") return "";
  if (prop["property-type"] === "constant")
    throw "Constant property type not supported";
  const elmName = camelCase(name);
  const exprKind =
    prop["sdk-support"]["data-driven styling"] &&
    prop["sdk-support"]["data-driven styling"].js
      ? "any"
      : "CameraExpression";
  const exprType = getElmType(prop);
  let bounds = "";
  if ("minimum" in prop && "maximum" in prop) {
    bounds = `\n\nShould be between \`${prop.minimum}\` and \`${
      prop.maximum
    }\` inclusive. `;
  } else if ("minimum" in prop) {
    bounds = `\n\nShould be greater than or equal to \`${prop.minimum}\`. `;
  } else if ("maximum" in prop) {
    bounds = `\n\nShould be less than or equal to \`${prop.maximum}\`. `;
  }
  let valueHelp = "";
  if (exprType == "(Anchor Never)" || exprType == "(Anchor Auto)") {
    valueHelp = Object.entries(prop.values)
      .map(
        ([value, { doc }]) =>
          `\n- ${codeSnippet(value, exprType)}: ${docify(doc)}`
      )
      .join("");
  }
  return `
{-| ${docify(prop.doc, elmName)} ${position} property. ${bounds}${
    prop.units ? `\nUnits in ${prop.units}. ` : ""
  }${prop.default !== undefined && elmName !== 'heatmapColor' && elmName !== 'textFont' ? "Defaults to `" + camelCase(prop.default.toString(), exprType) + "`. " : ""}${
    prop.requires ? prop.requires.map(requires).join(" ") : ""
  }${valueHelp}
-}
${elmName} : Expression ${exprKind} ${exprType} -> LayerAttr ${layerType}
${elmName} =
    Expression.encode >> ${position} "${name}"`;
}

const enumMap = {
  "map | viewport | auto": "(Anchor Auto)",
  "map | viewport": "(Anchor Never)",
  "left | center | right": "TextJustify",
  "center | left | right | top | bottom | top-left | top-right | bottom-left | bottom-right":
    "Position",
  "none | width | height | both": "TextFit",
  "butt | round | square": "LineCap",
  "bevel | round | miter": "LineJoin",
  "point | line | line-center": "SymbolPlacement",
  "none | uppercase | lowercase": "TextTransform",
  "linear | nearest": "RasterResampling",
  "viewport-y | source" : "SymbolZOrder"
};

const flatEnumMap = Object.assign(Object.entries(enumMap).reduce((res, [values, tipe]) => values.split(' | ').reduce((obj, value) => Object.assign({}, obj, {[value]: tipe}), res), {}), {
  map: 'Anchor',
  viewport: 'Anchor',
  auto: "Anchor"
});

const reverseEnumMap = Object.entries(enumMap).reduce((res, [values, tipe]) => tipe ==="(Anchor Auto)" || tipe === "(Anchor Never)" ? res : Object.assign({}, res, {[tipe]: values.split(' | ')}), {})

console.error(reverseEnumMap)

function docify(str, name) {
  switch (name) {
    case "lineGradient":
    case "lineDasharray":
      return str;
    case "heatmapColor":
      return `Defines the color of each pixel based on its density value in a heatmap. The value should be an Expression that uses \`heatmapDensity\` as input. Defaults to:

      E.heatmapDensity
      |> E.interpolate E.Linear
        [ (0.0, rgba 0 0 255 0)
        , (0.1, rgba 65 105 225 1)
        , (0.3, rgba 0 255 255 1)
        , (0.5, rgba 0 255 0 1)
        , (0.7, rgba 255 255 0 1)
        , (1.0, rgba 255 0 0 1)]`
    case "textField":
      return `Value to use for a text label.`;
  }
  ///`(\w+\-.+?)`/g
  return str.replace(
      /`(.+?)`/g,
      (str, match) => "`" + camelCase(match) + "`"
    )
}

function getElmType({ type, value, values }) {
  switch (type) {
    case "number":
      return "Float";
    case "boolean":
      return "Bool";
    case "string":
      return "String";
    case "color":
      return "Color";
    case "array":
      switch (value) {
        case "number":
          return "(Array Float)";
        case "string":
          return "(Array String)";
      }
    case "formatted":
      return "FormattedText";
    case "enum":
      const res = enumMap[Object.keys(values).join(" | ")];
      if (res) return res;
  }
  throw `Unknown type ${type}, ${value}, ${values && Object.keys(values)}`;
}

function titleCase(str) {
  return str
    .replace(/\-/, " ")
    .replace(/\w\S*/g, function(txt) {
      return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    })
    .replace(/\s/, "");
}

function camelCase(str, type) {
  if (type &&  type === 'SymbolZOrder') {
    str = 'order ' + str;
  } else if (type && reverseEnumMap[type]) {
    str = type + ' ' + str;
  } else if (flatEnumMap[str] && str !== 'source') {
    str = flatEnumMap[str] + ' ' + str;
  } else if (str === "rgba(0, 0, 0, 0)") {
    return "rgba 0 0 0 0"
  }
  return str
    .replace(/(?:^\w|[A-Z]|\b\w|\-\w)/g, function(letter, index) {
      return index == 0 ? letter.toLowerCase() : letter.toUpperCase();
    })
    .replace(/(?:\s|\-)+/g, "");
}

function makeSignatures(name, constants) {
  return `{-| -}
type ${name} = ${name}

  ${constants
    .split(" | ")
    .map(
      c => `
{-| -}
${camelCase(name + " " + c)} : Expression exprType ${name}
${camelCase(name + " " + c)} = Expression (Json.Encode.string "${c}")
`
    )
    .join("\n")}`;
}

/// --- NODEJS STUFF

var stdin = process.stdin,
  stdout = process.stdout,
  inputChunks = [];

stdin.resume();
stdin.setEncoding("utf8");

stdin.on("data", function(chunk) {
  inputChunks.push(chunk);
});

stdin.on("end", function() {
  var inputJSON = inputChunks.join(""),
    parsedData = JSON.parse(inputJSON),
    output = generateProperties(parsedData);
  stdout.write(output);
  stdout.write("\n");
});
