module Mapbox.Source exposing
    ( Source, SourceOption
    , Id, Url
    , vector, vectorFromUrl, VectorSource
    , raster, tileSize, rasterFromUrl, RasterSource
    , rasterDEMMapbox, rasterDEMTerrarium
    , geoJSONFromUrl, geoJSONFromValue, GeoJSONSource, buffer, tolerance, cluster, clusterRadius, clusterProperties, lineMetrics, generateIds
    , Coords, image, video, staticCanvas, animatedCanvas
    , bounds, minzoom, maxzoom, attribution, scheme, Scheme(..)
    , encode, getId
    )

{-|


# Sources

@docs Source, SourceOption

@docs Id, Url


### Vector

@docs vector, vectorFromUrl, VectorSource


### Raster

@docs raster, tileSize, rasterFromUrl, RasterSource


### Raster DEM

@docs rasterDEMMapbox, rasterDEMTerrarium


### GeoJSON

@docs geoJSONFromUrl, geoJSONFromValue, GeoJSONSource, buffer, tolerance, cluster, clusterRadius, clusterProperties, lineMetrics, generateIds


### Image, Video & Canvas

@docs Coords, image, video, staticCanvas, animatedCanvas


### Tiled sources

Tiled sources can also take the following attributes:

@docs bounds, minzoom, maxzoom, attribution, scheme, Scheme


### Working with sources

@docs encode, getId

-}

import Internal
import Json.Encode exposing (Value)
import LngLat exposing (LngLat)
import Mapbox.Expression as Expression exposing (DataExpression, Expression)


{-| Every layer is identified by an id.
-}
type alias Id =
    String


{-| Represents a URL. For tiles hosted by Mapbox, the "url" value should be of the form mapbox://mapid.
-}
type alias Url =
    String


{-| Sources supply data to be shown on the map. Adding a source won't immediately make data appear on the map because sources don't contain styling details like color or width. Layers refer to a source and give it a visual representation. This makes it possible to style the same source in different ways, like differentiating between types of roads in a highways layer.
-}
type Source
    = Source String Value


{-| `XYZ`: Slippy map tilenames scheme.

`TMS`: OSGeo spec scheme.

-}
type Scheme
    = XYZ
    | TMS


{-| Marks attributes that are only applicable to vector sources
-}
type VectorSource
    = VectorSource


{-| Marks attributes that are only applicable to raster sources
-}
type RasterSource
    = RasterSource


{-| Marks attributes that are only applicable to GeoJSON sources
-}
type GeoJSONSource
    = GeoJSONSource


{-| Some sources can take options.
-}
type SourceOption sourceType
    = SourceOption String Value


{-| -}
encode : Source -> Value
encode (Source _ value) =
    value


{-| -}
getId : Source -> String
getId (Source k _) =
    k


{-| The longitude and latitude of the southwest and northeast corners of the source's bounding box. When this property is included in a source, no tiles outside of the given bounds are requested by Mapbox GL.
-}
bounds : LngLat -> LngLat -> SourceOption any
bounds sw ne =
    SourceOption "bounds" (Json.Encode.list Json.Encode.float [ sw.lng, sw.lat, ne.lng, ne.lat ])


{-| Minimum zoom level for which tiles are available, as in the TileJSON spec.
-}
minzoom : Float -> SourceOption any
minzoom z =
    SourceOption "minzoom" (Json.Encode.float z)


{-| Maximum zoom level for which tiles are available, as in the TileJSON spec. Data from tiles at the maxzoom are used when displaying the map at higher zoom levels.
-}
maxzoom : Float -> SourceOption any
maxzoom z =
    SourceOption "maxzoom" (Json.Encode.float z)


{-| Contains an attribution to be displayed when the map is shown to a user.
-}
attribution : String -> SourceOption any
attribution att =
    SourceOption "attribution" (Json.Encode.string att)


{-| The minimum visual size to display tiles for this layer.
-}
tileSize : Int -> SourceOption RasterSource
tileSize ts =
    SourceOption "minzoom" (Json.Encode.int ts)


{-| Size of the tile buffer on each side. A value of 0 produces no buffer. A value of 512 produces a buffer as wide as the tile itself. Larger values produce fewer rendering artifacts near tile edges and slower performance. Defaults to 128.
-}
buffer : Int -> SourceOption GeoJSONSource
buffer int =
    SourceOption "buffer" (Json.Encode.int int)


{-| Douglas-Peucker simplification tolerance (higher means simpler geometries and faster performance). Defaults to 0.375.
-}
tolerance : Float -> SourceOption GeoJSONSource
tolerance float =
    SourceOption "tolerance" (Json.Encode.float float)


{-| If the data is a collection of point features, setting this clusters the points by radius into groups.

Cluster groups become new Point features in the source with additional properties:

  - `cluster` Is `True` if the point is a cluster
  - `cluster_id` A unqiue id for the cluster.
  - `point_count` Number of original points grouped into this cluster
  - `point_count_abbreviated` An abbreviated point count

-}
cluster : SourceOption GeoJSONSource
cluster =
    Json.Encode.bool True |> SourceOption "cluster"


{-| Radius of each cluster if clustering is enabled. A value of 512 indicates a radius equal to the width of a tile.
-}
clusterRadius : Float -> SourceOption GeoJSONSource
clusterRadius =
    Json.Encode.float >> SourceOption "clusterRadius"


{-| Max zoom on which to cluster points if clustering is enabled. Defaults to one zoom less than maxzoom (so that last zoom features are not clustered).
-}
clusterMaxZoom : Float -> SourceOption GeoJSONSource
clusterMaxZoom =
    Json.Encode.float >> SourceOption "clusterMaxZoom"


{-| When clustering, you may want to aggregate values from the points included in the cluster. This function allows you to associate a name that will be the property name with a fold that computes the aggregation. For example:

    clusterProperties
        [ ( "sum", E.plus, E.getProperty (str "scalerank") )
        , ( "max", \point aggregate -> E.max aggregate point, E.getProperty (str "scalerank") )
        ]

Would produce clusters with two additional properties: `sum` and `max`, which you could then further use in data driven styling.

-}
clusterProperties : List ( String, Expression DataExpression a -> Expression DataExpression b -> Expression DataExpression b, Expression DataExpression a ) -> SourceOption GeoJSONSource
clusterProperties =
    List.map
        (\( name, fold, map ) ->
            ( name
            , Json.Encode.list identity
                [ Expression.encode <| fold (Expression.getProperty (Expression.str name)) (Internal.Expression (Json.Encode.list Json.Encode.string [ "accumulated" ]))
                , Expression.encode <| map
                ]
            )
        )
        >> Json.Encode.object
        >> SourceOption "clusterProperties"


{-| Whether to calculate line distance metrics. This is required for line layers that specify `lineGradient` values.
-}
lineMetrics : Bool -> SourceOption GeoJSONSource
lineMetrics =
    Json.Encode.bool >> SourceOption "lineMetrics"


{-| When set, the feature.id property will be auto assigned based on its index in the features array, over-writing any previous values.
-}
generateIds : SourceOption GeoJSONSource
generateIds =
    Json.Encode.bool True |> SourceOption "generateId"


{-| Influences the y direction of the tile coordinates. The global-mercator (aka Spherical Mercator) profile is assumed.
-}
scheme : Scheme -> SourceOption any
scheme s =
    case s of
        XYZ ->
            SourceOption "scheme" (Json.Encode.string "xyz")

        TMS ->
            SourceOption "scheme" (Json.Encode.string "tms")


{-| A vector tile source. Tiles must be in [Mapbox Vector Tile format](https://www.mapbox.com/developers/vector-tiles/). All geometric coordinates in vector tiles must be between `-1 * extent` and `(extent * 2) - 1` inclusive. All layers that use a vector source must specify a `sourceLayer` value.

The first argument is the layers id, the second is a url to a [TileJSON specification](https://github.com/mapbox/tilejson-spec) that configures the source.

-}
vectorFromUrl : Id -> Url -> Source
vectorFromUrl id url =
    Source id (Json.Encode.object [ ( "type", Json.Encode.string "vector" ), ( "url", Json.Encode.string url ) ])


{-| A vector tile source. Tiles must be in [Mapbox Vector Tile format](https://www.mapbox.com/developers/vector-tiles/). All geometric coordinates in vector tiles must be between `-1 * extent` and `(extent * 2) - 1` inclusive. All layers that use a vector source must specify a `sourceLayer` value.

This takes an array of one or more tile source URLs, as in the TileJSON spec.

-}
vector : Id -> List Url -> List (SourceOption VectorSource) -> Source
vector id urls options =
    ( "tiles", Json.Encode.list Json.Encode.string urls )
        :: ( "type", Json.Encode.string "vector" )
        :: List.map (\(SourceOption k v) -> ( k, v )) options
        |> Json.Encode.object
        |> Source id


{-| A raster tile source configured from a TileJSON spec.
-}
rasterFromUrl : Id -> Url -> Source
rasterFromUrl id url =
    Source id (Json.Encode.object [ ( "type", Json.Encode.string "raster" ), ( "url", Json.Encode.string url ) ])


{-| A raster tile source. Takes a list of one or more tile source URLs, as in the TileJSON spec.
-}
raster : Id -> List Url -> List (SourceOption RasterSource) -> Source
raster id urls options =
    ( "tiles", Json.Encode.list Json.Encode.string urls )
        :: ( "type", Json.Encode.string "raster" )
        :: List.map (\(SourceOption k v) -> ( k, v )) options
        |> Json.Encode.object
        |> Source id


{-| The [Mapbox Terrain RGB](https://blog.mapbox.com/global-elevation-data-6689f1d0ba65) DEM source.
-}
rasterDEMMapbox : Id -> Source
rasterDEMMapbox id =
    Source id
        (Json.Encode.object
            [ ( "type", Json.Encode.string "raster-dem" )
            , ( "url", Json.Encode.string "mapbox://mapbox.terrain-rgb" )
            , ( "encoding", Json.Encode.string "mapbox" )
            ]
        )


{-| A raster DEM source in the Terarrium format.
-}
rasterDEMTerrarium : Id -> Url -> List (SourceOption RasterSource) -> Source
rasterDEMTerrarium id url options =
    ( "type", Json.Encode.string "raster-dem" )
        :: ( "url", Json.Encode.string url )
        :: ( "encoding", Json.Encode.string "terrarium" )
        :: List.map (\(SourceOption k v) -> ( k, v )) options
        |> Json.Encode.object
        |> Source id


{-| A remote GeoJSON source.
-}
geoJSONFromUrl : Id -> Url -> List (SourceOption GeoJSONSource) -> Source
geoJSONFromUrl id url options =
    ( "data", Json.Encode.string url )
        :: ( "type", Json.Encode.string "geojson" )
        :: List.map (\(SourceOption k v) -> ( k, v )) options
        |> Json.Encode.object
        |> Source id


{-| A GeoJSON source from some local data.
-}
geoJSONFromValue : Id -> List (SourceOption GeoJSONSource) -> Value -> Source
geoJSONFromValue id options data =
    ( "data", data )
        :: ( "type", Json.Encode.string "geojson" )
        :: List.map (\(SourceOption k v) -> ( k, v )) options
        |> Json.Encode.object
        |> Source id


{-| `(longitude, latitude)` pairs for the corners. You can use the type alias constructor in clockwise order: top left, top right, bottom right, bottom left.
-}
type alias Coords =
    { topLeft : LngLat
    , topRight : LngLat
    , bottomRight : LngLat
    , bottomLeft : LngLat
    }


encodeCoordinates : Coords -> Value
encodeCoordinates { topLeft, topRight, bottomRight, bottomLeft } =
    Json.Encode.list LngLat.encodeAsPair
        [ topLeft
        , topRight
        , bottomRight
        , bottomLeft
        ]


{-| An image source
-}
image : Id -> Url -> Coords -> Source
image id url coordinates =
    [ ( "type", Json.Encode.string "image" )
    , ( "url", Json.Encode.string url )
    , ( "coordinates", encodeCoordinates coordinates )
    ]
        |> Json.Encode.object
        |> Source id


{-| A video source. For each URL in the list, a video element source will be created, in order to support same media in multiple formats supported by different browsers.
-}
video : Id -> List Url -> Coords -> Source
video id urls coordinates =
    [ ( "type", Json.Encode.string "video" )
    , ( "urls", Json.Encode.list Json.Encode.string urls )
    , ( "coordinates", encodeCoordinates coordinates )
    ]
        |> Json.Encode.object
        |> Source id


{-| A data source containing the contents of an HTML canvas. The second argument must be the DOM ID of the canvas element. This method is only appropriate with a static Canvas (i.e. one that doesn't change), as it will be cached to improve performance.
-}
staticCanvas : Id -> String -> Coords -> Source
staticCanvas id domid coordinates =
    [ ( "type", Json.Encode.string "canvas" )
    , ( "animate", Json.Encode.bool False )
    , ( "canvas", Json.Encode.string domid )
    , ( "coordinates", encodeCoordinates coordinates )
    ]
        |> Json.Encode.object
        |> Source id


{-| A data source containing the contents of an HTML canvas. The second argument must be the DOM ID of the canvas element. This method is only appropriate with an animated Canvas (i.e. one that changes over time).
-}
animatedCanvas : Id -> String -> Coords -> Source
animatedCanvas id domid coordinates =
    [ ( "type", Json.Encode.string "canvas" )
    , ( "animate", Json.Encode.bool True )
    , ( "canvas", Json.Encode.string domid )
    , ( "coordinates", encodeCoordinates coordinates )
    ]
        |> Json.Encode.object
        |> Source id
