module Styles.Light exposing (style)

import Mapbox.Expression as E exposing (false, float, str, true)
import Mapbox.Layer as Layer
import Mapbox.Source as Source
import Mapbox.Style as Style exposing (Style(..))


style : Style
style =
    Style
        { transition = Style.defaultTransition
        , light = Style.defaultLight
        , layers =
            [ Layer.background "background" [ Layer.backgroundColor (E.rgba 245 245 243 1) ]
            , Layer.fill "landcover_wood"
                "composite"
                [ Layer.maxzoom 14
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "wood"))
                , Layer.sourceLayer "landcover"
                , Layer.fillColor (E.rgba 226 226 226 1)
                , Layer.fillOpacity (float 0.1)
                , Layer.fillAntialias false
                ]
            , Layer.fill "landcover_scrub"
                "composite"
                [ Layer.maxzoom 14
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "scrub"))
                , Layer.sourceLayer "landcover"
                , Layer.fillColor (E.rgba 226 226 226 1)
                , Layer.fillOpacity (float 0.1)
                , Layer.fillAntialias false
                ]
            , Layer.fill "landcover_grass"
                "composite"
                [ Layer.maxzoom 14
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "grass"))
                , Layer.sourceLayer "landcover"
                , Layer.fillColor (E.rgba 226 226 226 1)
                , Layer.fillOpacity (float 0.1)
                , Layer.fillAntialias false
                ]
            , Layer.fill "landcover_crop"
                "composite"
                [ Layer.maxzoom 14
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "crop"))
                , Layer.sourceLayer "landcover"
                , Layer.fillColor (E.rgba 226 226 226 1)
                , Layer.fillOpacity (float 0.1)
                , Layer.fillAntialias false
                ]
            , Layer.fill "national_park"
                "composite"
                [ Layer.sourceLayer "landuse_overlay"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "national_park"))
                , Layer.fillColor (E.rgba 236 238 237 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, float 0 ), ( 6, float 0.5 ) ])
                ]
            , Layer.fill "parks"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "park"))
                , Layer.fillColor (E.rgba 236 238 237 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, float 0 ), ( 6, float 0.75 ) ])
                ]
            , Layer.fill "pitch"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "pitch"))
                , Layer.fillColor (E.rgba 236 238 237 1)
                ]
            , Layer.fill "industrial"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "industrial"))
                , Layer.fillColor (E.rgba 236 238 237 1)
                ]
            , Layer.fill "sand"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "sand"))
                , Layer.fillColor (E.rgba 236 238 237 1)
                ]
            , Layer.fill "hillshade_highlight_bright"
                "composite"
                [ Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 94))
                , Layer.sourceLayer "hillshade"
                , Layer.fillColor (E.rgba 255 255 255 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.08 ), ( 16, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "hillshade_highlight_med"
                "composite"
                [ Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 90))
                , Layer.sourceLayer "hillshade"
                , Layer.fillColor (E.rgba 255 255 255 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.08 ), ( 16, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "hillshade_shadow_faint"
                "composite"
                [ Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 89))
                , Layer.sourceLayer "hillshade"
                , Layer.fillColor (E.rgba 89 89 89 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.033 ), ( 16, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "hillshade_shadow_med"
                "composite"
                [ Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 78))
                , Layer.sourceLayer "hillshade"
                , Layer.fillColor (E.rgba 89 89 89 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.033 ), ( 16, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "hillshade_shadow_dark"
                "composite"
                [ Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 67))
                , Layer.sourceLayer "hillshade"
                , Layer.fillColor (E.rgba 89 89 89 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.06 ), ( 16, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "hillshade_shadow_extreme"
                "composite"
                [ Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 56))
                , Layer.sourceLayer "hillshade"
                , Layer.fillColor (E.rgba 89 89 89 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.06 ), ( 16, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.line "waterway-river-canal"
                "composite"
                [ Layer.minzoom 8
                , Layer.filter
                    (E.any
                        [ E.conditionally
                            [ ( E.typeof (E.getProperty (str "class")) |> E.isEqual (str "string")
                              , E.getProperty (str "class") |> E.isEqual (str "canal")
                              )
                            ]
                            false
                        , E.conditionally
                            [ ( E.typeof (E.getProperty (str "class")) |> E.isEqual (str "string")
                              , E.getProperty (str "class") |> E.isEqual (str "river")
                              )
                            ]
                            false
                        ]
                    )
                , Layer.sourceLayer "waterway"
                , Layer.lineColor (E.rgba 203 211 212 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.3) [ ( 8.5, float 0.1 ), ( 20, float 8 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, float 0 ), ( 8.5, float 1 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapButt [ ( 11, E.lineCapRound ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.fill "water shadow"
                "composite"
                [ Layer.sourceLayer "water"
                , Layer.fillColor (E.rgba 181 190 190 1)
                , Layer.fillTranslate (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 7, E.floats [ 0, 0 ] ), ( 16, E.floats [ -1, -1 ] ) ])
                , Layer.fillTranslateAnchor E.anchorViewport
                , Layer.fillOpacity (float 1)
                ]
            , Layer.fill "water" "composite" [ Layer.sourceLayer "water", Layer.fillColor (E.rgba 202 210 210 1) ]
            , Layer.fill "barrier_line-land-polygon"
                "composite"
                [ Layer.sourceLayer "barrier_line"
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "Polygon"), E.getProperty (str "class") |> E.isEqual (str "land") ])
                , Layer.fillColor (E.rgba 240 245 243 1)
                ]
            , Layer.line "barrier_line-land-line"
                "composite"
                [ Layer.sourceLayer "barrier_line"
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "LineString"), E.getProperty (str "class") |> E.isEqual (str "land") ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.99) [ ( 14, float 0.75 ), ( 20, float 40 ) ])
                , Layer.lineColor (E.rgba 240 245 243 1)
                , Layer.lineCap E.lineCapRound
                ]
            , Layer.fill "aeroway-polygon"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter (E.all [ E.getProperty (str "type") |> E.notEqual (str "apron"), E.geometryType |> E.isEqual (str "Polygon") ])
                , Layer.sourceLayer "aeroway"
                , Layer.fillColor (E.rgba 247 247 247 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 0 ), ( 11.5, float 1 ) ])
                ]
            , Layer.line "aeroway-runway"
                "composite"
                [ Layer.minzoom 9
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "LineString"), E.getProperty (str "type") |> E.isEqual (str "runway") ])
                , Layer.sourceLayer "aeroway"
                , Layer.lineColor (E.rgba 242 242 242 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 9, float 1 ), ( 18, float 80 ) ])
                ]
            , Layer.line "aeroway-taxiway"
                "composite"
                [ Layer.minzoom 9
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "type") |> E.isEqual (str "taxiway")
                        ]
                    )
                , Layer.sourceLayer "aeroway"
                , Layer.lineColor (E.rgba 242 242 242 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10, float 0.5 ), ( 18, float 20 ) ])
                ]
            , Layer.fill "building"
                "composite"
                [ Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "type") |> E.notEqual (str "building:part")
                        , E.getProperty (str "underground") |> E.isEqual (str "false")
                        ]
                    )
                , Layer.sourceLayer "building"
                , Layer.fillColor (E.rgba 233 233 230 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15.5, float 0 ), ( 16, float 1 ) ])
                , Layer.fillOutlineColor (E.rgba 222 222 220 1)
                ]
            , Layer.line "tunnel-street-low"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11.5, float 0 ), ( 12, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-street_limited-low"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11.5, float 0 ), ( 12, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-service-link-track-case"
                "composite"
                [ Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "service", true ), ( "track", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 223 229 230 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-street_limited-case"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 223 229 230 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-street-case"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 223 229 230 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-secondary-tertiary-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "class") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 10, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineColor (E.rgba 223 229 230 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-primary-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "primary")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 223 229 230 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-trunk_link-case"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 223 229 230 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-motorway_link-case"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 223 229 230 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-trunk-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 223 229 230 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-motorway-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 223 229 230 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-construction"
                "composite"
                [ Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "construction")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 0.4, 0.8 ])
                            [ ( 15, E.floats [ 0.3, 0.6 ] )
                            , ( 16, E.floats [ 0.2, 0.3 ] )
                            , ( 17, E.floats [ 0.2, 0.25 ] )
                            , ( 18, E.floats [ 0.15, 0.15 ] )
                            ]
                    )
                , Layer.lineJoin E.lineJoinMiter
                ]
            , Layer.line "tunnel-path"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "steps")
                            , E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.75, 1 ] ), ( 16, E.floats [ 1, 0.75 ] ), ( 17, E.floats [ 1, 0.5 ] ) ]
                    )
                , Layer.lineColor (E.rgba 216 216 216 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0 ), ( 14.25, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-steps"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.isEqual (str "steps")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 216 216 216 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.75, 1 ] ), ( 16, E.floats [ 1, 0.75 ] ), ( 17, E.floats [ 0.3, 0.3 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0 ), ( 14.25, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-trunk_link"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-motorway_link"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-pedestrian"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.5, 0.4 ] ), ( 16, E.floats [ 1, 0.2 ] ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-service-link-track"
                "composite"
                [ Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "service", true ), ( "track", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-street_limited"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-street"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-secondary-tertiary"
                "composite"
                [ Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "class") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-primary"
                "composite"
                [ Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "primary")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-trunk"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "trunk")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-motorway"
                "composite"
                [ Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineOpacity (float 1)
                , Layer.lineColor (E.rgba 222 226 226 1)
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-pedestrian-case"
                "composite"
                [ Layer.minzoom 12
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 2 ), ( 18, float 14.5 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 219 224 222 1 ), ( 11, E.rgba 232 237 235 1 ) ])
                , Layer.lineGapWidth (float 0)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, float 0 ), ( 7, float 0.4 ), ( 9, float 0.5 ), ( 10, float 1 ) ]
                    )
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-street-low"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11, float 0 ), ( 11.25, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-street_limited-low"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11, float 0 ), ( 11.25, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-service-link-track-case"
                "composite"
                [ Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "service", true ), ( "track", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 219 224 222 1 ), ( 11, E.rgba 232 237 235 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, float 0 ), ( 7, float 0.4 ), ( 9, float 0.5 ), ( 10, float 1 ) ]
                    )
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-street_limited-case"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 219 224 222 1 ), ( 11, E.rgba 232 237 235 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, float 0 ), ( 7, float 0.4 ), ( 9, float 0.5 ), ( 10, float 1 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-street-case"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 219 224 222 1 ), ( 11, E.rgba 232 237 235 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, float 0 ), ( 7, float 0.4 ), ( 9, float 0.5 ), ( 10, float 1 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-main-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 10, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 219 224 222 1 ), ( 11, E.rgba 232 237 235 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, float 0 ), ( 7, float 0.4 ), ( 9, float 0.5 ), ( 10, float 1 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-primary-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "primary")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 219 224 222 1 ), ( 11, E.rgba 232 237 235 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, float 0 ), ( 7, float 0.4 ), ( 9, float 0.5 ), ( 10, float 1 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-motorway_link-case"
                "composite"
                [ Layer.minzoom 10
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 219 224 222 1 ), ( 11, E.rgba 232 237 235 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, float 0 ), ( 7, float 0.4 ), ( 9, float 0.5 ), ( 10, float 1 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-trunk_link-case"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 219 224 222 1 ), ( 11, E.rgba 232 237 235 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, float 0 ), ( 7, float 0.4 ), ( 9, float 0.5 ), ( 10, float 1 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-trunk-case"
                "composite"
                [ Layer.minzoom 5
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "trunk")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 7, float 0.5 ), ( 10, float 1 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 219 224 222 1 ), ( 11, E.rgba 232 237 235 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.5 ), ( 9, float 1.4 ), ( 18, float 32 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 6, float 0 ), ( 6.1, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-motorway-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "motorway")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 7, float 0.5 ), ( 10, float 1 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 219 224 222 1 ), ( 11, E.rgba 232 237 235 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-construction"
                "composite"
                [ Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "construction")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 0.4, 0.8 ])
                            [ ( 15, E.floats [ 0.3, 0.6 ] )
                            , ( 16, E.floats [ 0.2, 0.3 ] )
                            , ( 17, E.floats [ 0.2, 0.25 ] )
                            , ( 18, E.floats [ 0.15, 0.15 ] )
                            ]
                    )
                , Layer.lineJoin E.lineJoinMiter
                ]
            , Layer.line "road-sidewalks"
                "composite"
                [ Layer.minzoom 16
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.matchesStr [ ( "crossing", true ), ( "sidewalk", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.75, 1 ] ), ( 16, E.floats [ 1, 0.75 ] ), ( 17, E.floats [ 1, 0.5 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 0 ), ( 16.25, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-path"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "crossing", false ), ( "sidewalk", false ), ( "steps", false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "path")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.75, 1 ] ), ( 16, E.floats [ 1, 0.75 ] ), ( 17, E.floats [ 1, 0.5 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0 ), ( 14.25, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-steps"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.isEqual (str "steps")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.75, 1 ] ), ( 16, E.floats [ 1, 0.75 ] ), ( 17, E.floats [ 0.3, 0.3 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0 ), ( 14.25, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-trunk_link"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-motorway_link"
                "composite"
                [ Layer.minzoom 10
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-pedestrian"
                "composite"
                [ Layer.minzoom 12
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.5, 0.4 ] ), ( 16, E.floats [ 1, 0.2 ] ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-service-link-track"
                "composite"
                [ Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "service", true ), ( "track", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-street_limited"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-street"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-secondary-tertiary"
                "composite"
                [ Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 5, float 0 ), ( 5.5, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-primary"
                "composite"
                [ Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "primary")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 5, float 0 ), ( 5.5, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-trunk"
                "composite"
                [ Layer.minzoom 5
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "trunk")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.5 ), ( 9, float 1.4 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-motorway"
                "composite"
                [ Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "motorway")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-rail"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "class") |> E.matchesStr [ ( "major_rail", true ), ( "minor_rail", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 20, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-pedestrian-case"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 2 ), ( 18, float 14.5 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (float 0)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-street-low"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11.5, float 0 ), ( 12, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-street_limited-low"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11.5, float 0 ), ( 12, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-service-link-track-case"
                "composite"
                [ Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "service", true ), ( "track", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-street_limited-case"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-street-case"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-secondary-tertiary-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "class") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 10, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-primary-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "primary")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk_link-case"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10.99, float 0 ), ( 11, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway_link-case"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "layer") |> E.lessThanOrEqual (float 1)
                            , E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "trunk")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10, float 1 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 7, float 0.5 ), ( 10, float 1 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-construction"
                "composite"
                [ Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "construction")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 0.4, 0.8 ])
                            [ ( 15, E.floats [ 0.3, 0.6 ] )
                            , ( 16, E.floats [ 0.2, 0.3 ] )
                            , ( 17, E.floats [ 0.2, 0.25 ] )
                            , ( 18, E.floats [ 0.15, 0.15 ] )
                            ]
                    )
                , Layer.lineJoin E.lineJoinMiter
                ]
            , Layer.line "bridge-path"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "steps")
                            , E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.75, 1 ] ), ( 16, E.floats [ 1, 0.75 ] ), ( 17, E.floats [ 1, 0.5 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0 ), ( 14.25, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-steps"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.isEqual (str "steps")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.75, 1 ] ), ( 16, E.floats [ 1, 0.75 ] ), ( 17, E.floats [ 0.3, 0.3 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0 ), ( 14.25, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk_link"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "layer")
                                |> E.matchesFloat [ ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway_link"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "layer")
                                |> E.matchesFloat [ ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-pedestrian"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.5, 0.4 ] ), ( 16, E.floats [ 1, 0.2 ] ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-service-link-track"
                "composite"
                [ Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "service", true ), ( "track", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-street_limited"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-street"
                "composite"
                [ Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-secondary-tertiary"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 5, float 0 ), ( 5.5, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-primary"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.isEqual (str "primary")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 5, float 0 ), ( 5.5, float 1 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "layer")
                                |> E.matchesFloat [ ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "trunk")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "layer")
                                |> E.matchesFloat [ ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                            , E.getProperty (str "class") |> E.isEqual (str "motorway")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-rail"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "class") |> E.matchesStr [ ( "major_rail", true ), ( "minor_rail", true ) ] false
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 20, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk_link-2-case"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10.99, float 0 ), ( 11, float 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway_link-2-case copy"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk-2-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "trunk")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10, float 1 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway-2-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 7, float 0.5 ), ( 10, float 1 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 232 237 235 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk_link-2"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway_link-2"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk-2"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "trunk")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway-2"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "admin-3-4-boundaries-bg"
                "composite"
                [ Layer.sourceLayer "admin"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "maritime") |> E.isEqual (float 0)
                        , E.getProperty (str "admin_level") |> E.greaterThanOrEqual (float 3)
                        ]
                    )
                , Layer.lineColor (E.rgba 214 214 214 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 3.5 ), ( 10, float 8 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 4, float 0 ), ( 7, float 0.5 ), ( 8, float 0.75 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0 ), ( 8, float 3 ) ])
                , Layer.lineJoin E.lineJoinBevel
                ]
            , Layer.line "admin-2-boundaries-bg"
                "composite"
                [ Layer.minzoom 1
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.isEqual (float 2)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.sourceLayer "admin"
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 3.5 ), ( 10, float 10 ) ])
                , Layer.lineColor (E.rgba 214 214 214 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0 ), ( 4, float 0.5 ) ])
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0 ), ( 10, float 2 ) ])
                , Layer.lineJoin E.lineJoinMiter
                ]
            , Layer.line "admin-3-4-boundaries"
                "composite"
                [ Layer.sourceLayer "admin"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "maritime") |> E.isEqual (float 0)
                        , E.getProperty (str "admin_level") |> E.greaterThanOrEqual (float 3)
                        ]
                    )
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 2, 0 ]) [ ( 7, E.floats [ 2, 2, 6, 2 ] ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 0.75 ), ( 12, float 1.5 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 2, float 0 ), ( 3, float 1 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 4, E.rgba 204 204 204 1 ), ( 5, E.rgba 178 178 178 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                , Layer.lineCap E.lineCapRound
                ]
            , Layer.line "admin-2-boundaries"
                "composite"
                [ Layer.minzoom 1
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.isEqual (float 2)
                        , E.getProperty (str "disputed") |> E.isEqual (float 0)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.sourceLayer "admin"
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, E.rgba 178 178 178 1 ), ( 4, E.rgba 158 158 158 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0.5 ), ( 10, float 2 ) ])
                , Layer.lineJoin E.lineJoinRound
                , Layer.lineCap E.lineCapRound
                ]
            , Layer.line "admin-2-boundaries-dispute"
                "composite"
                [ Layer.minzoom 1
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.isEqual (float 2)
                        , E.getProperty (str "disputed") |> E.isEqual (float 1)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.sourceLayer "admin"
                , Layer.lineDasharray (E.floats [ 1.5, 1.5 ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, E.rgba 178 178 178 1 ), ( 4, E.rgba 158 158 158 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0.5 ), ( 10, float 2 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.symbol "waterway-label"
                "composite"
                [ Layer.minzoom 12
                , Layer.filter (E.getProperty (str "class") |> E.matchesStr [ ( "canal", true ), ( "river", true ) ] false)
                , Layer.sourceLayer "waterway_label"
                , Layer.textHaloWidth (float 0)
                , Layer.textHaloBlur (float 0)
                , Layer.textColor (E.rgba 120 136 138 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPitchAlignment E.anchorViewport
                , Layer.textMaxAngle (float 30)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 12 ), ( 18, float 16 ) ])
                ]
            , Layer.symbol "poi-scalerank3"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "maki")
                            |> E.matchesStr
                                [ ( "campsite", false )
                                , ( "cemetery", false )
                                , ( "dog-park", false )
                                , ( "garden", false )
                                , ( "golf", false )
                                , ( "park", false )
                                , ( "picnic-site", false )
                                , ( "playground", false )
                                , ( "zoo", false )
                                ]
                                true
                        , E.getProperty (str "scalerank") |> E.isEqual (float 3)
                        ]
                    )
                , Layer.textColor (E.rgba 148 148 148 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 11 ), ( 20, float 13 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 1)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "poi-parks-scalerank3"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "scalerank") |> E.isEqual (float 3)
                        , E.getProperty (str "maki")
                            |> E.matchesStr
                                [ ( "campsite", true )
                                , ( "cemetery", true )
                                , ( "dog-park", true )
                                , ( "garden", true )
                                , ( "golf", true )
                                , ( "park", true )
                                , ( "picnic-site", true )
                                , ( "playground", true )
                                , ( "zoo", true )
                                ]
                                false
                        ]
                    )
                , Layer.textHaloBlur (float 0)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textColor (E.rgba 148 148 148 1)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 11 ), ( 20, float 12 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "road-label-small"
                "composite"
                [ Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "class")
                            |> E.matchesStr
                                [ ( "ferry", false )
                                , ( "golf", false )
                                , ( "link", false )
                                , ( "motorway", false )
                                , ( "path", false )
                                , ( "pedestrian", false )
                                , ( "primary", false )
                                , ( "secondary", false )
                                , ( "street", false )
                                , ( "street_limited", false )
                                , ( "tertiary", false )
                                , ( "track", false )
                                , ( "trunk", false )
                                ]
                                true
                        , E.geometryType |> E.isEqual (str "LineString")
                        ]
                    )
                , Layer.sourceLayer "road_label"
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 10 ), ( 20, float 13 ) ])
                , Layer.textMaxAngle (float 30)
                , Layer.symbolSpacing (float 500)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.anchorMap
                , Layer.textPitchAlignment E.anchorViewport
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                ]
            , Layer.symbol "road-label-medium"
                "composite"
                [ Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "class")
                            |> E.matchesStr [ ( "link", true ), ( "pedestrian", true ), ( "street", true ), ( "street_limited", true ) ] false
                        ]
                    )
                , Layer.sourceLayer "road_label"
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 10 ), ( 20, float 14 ) ])
                , Layer.textMaxAngle (float 30)
                , Layer.symbolSpacing (float 500)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.anchorMap
                , Layer.textPitchAlignment E.anchorViewport
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                ]
            , Layer.symbol "road-label-large"
                "composite"
                [ Layer.minzoom 12
                , Layer.filter
                    (E.getProperty (str "class")
                        |> E.matchesStr [ ( "motorway", true ), ( "primary", true ), ( "secondary", true ), ( "tertiary", true ), ( "trunk", true ) ] false
                    )
                , Layer.sourceLayer "road_label"
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloColor (E.rgba 255 255 255 0.75)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, float 10 ), ( 20, float 16 ) ])
                , Layer.textMaxAngle (float 30)
                , Layer.symbolSpacing (float 400)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.anchorMap
                , Layer.textPitchAlignment E.anchorViewport
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                ]
            , Layer.symbol "poi-scalerank2"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "maki")
                            |> E.matchesStr
                                [ ( "campsite", false )
                                , ( "cemetery", false )
                                , ( "dog-park", false )
                                , ( "garden", false )
                                , ( "golf", false )
                                , ( "park", false )
                                , ( "picnic-site", false )
                                , ( "playground", false )
                                , ( "zoo", false )
                                ]
                                true
                        , E.getProperty (str "scalerank") |> E.isEqual (float 2)
                        ]
                    )
                , Layer.textColor (E.rgba 148 148 148 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 12 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "poi-parks-scalerank2"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "scalerank") |> E.isEqual (float 2)
                        , E.getProperty (str "maki")
                            |> E.matchesStr
                                [ ( "campsite", true )
                                , ( "cemetery", true )
                                , ( "dog-park", true )
                                , ( "garden", true )
                                , ( "golf", true )
                                , ( "park", true )
                                , ( "picnic-site", true )
                                , ( "playground", true )
                                , ( "zoo", true )
                                ]
                                false
                        ]
                    )
                , Layer.textColor (E.rgba 148 148 148 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 12 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "water-label"
                "composite"
                [ Layer.minzoom 5
                , Layer.filter (E.getProperty (str "area") |> E.greaterThan (float 10000))
                , Layer.sourceLayer "water_label"
                , Layer.textColor (E.rgba 120 136 138 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textMaxWidth (float 7)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 13 ), ( 18, float 18 ) ])
                ]
            , Layer.symbol "poi-parks-scalerank1"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 1)
                        , E.getProperty (str "maki")
                            |> E.matchesStr
                                [ ( "campsite", true )
                                , ( "cemetery", true )
                                , ( "dog-park", true )
                                , ( "garden", true )
                                , ( "golf", true )
                                , ( "park", true )
                                , ( "picnic-site", true )
                                , ( "playground", true )
                                , ( "zoo", true )
                                ]
                                false
                        ]
                    )
                , Layer.textColor (E.rgba 147 147 147 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 12 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "poi-scalerank1"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "maki")
                            |> E.matchesStr
                                [ ( "campsite", false )
                                , ( "cemetery", false )
                                , ( "dog-park", false )
                                , ( "garden", false )
                                , ( "golf", false )
                                , ( "park", false )
                                , ( "picnic-site", false )
                                , ( "playground", false )
                                , ( "zoo", false )
                                ]
                                true
                        , E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 1)
                        ]
                    )
                , Layer.textColor (E.rgba 147 147 147 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 12 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "airport-label"
                "composite"
                [ Layer.minzoom 10
                , Layer.filter (E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 2))
                , Layer.sourceLayer "airport_label"
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 12 ), ( 18, float 18 ) ])
                , Layer.iconImage
                    (E.zoom
                        |> E.step (E.getProperty (str "maki") |> E.append (str "-11")) [ ( 13, E.getProperty (str "maki") |> E.append (str "-15") ) ]
                    )
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0.75 ])
                , Layer.textAnchor E.positionTop
                , Layer.textField
                    (E.zoom
                        |> E.step (E.toFormattedText (E.getProperty (str "abbr"))) [ ( 14, E.toFormattedText (E.getProperty (str "name_en")) ) ]
                    )
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 9)
                ]
            , Layer.symbol "place-islets-archipelago-aboriginal"
                "composite"
                [ Layer.maxzoom 16
                , Layer.filter
                    (E.getProperty (str "type")
                        |> E.matchesStr [ ( "aboriginal_lands", true ), ( "archipelago", true ), ( "islet", true ) ] false
                    )
                , Layer.sourceLayer "place_label"
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.2)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 16 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "place-neighbourhood"
                "composite"
                [ Layer.minzoom 12
                , Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "neighbourhood"))
                , Layer.sourceLayer "place_label"
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textColor (E.rgba 158 158 158 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textTransform E.textTransformUppercase
                , Layer.textLetterSpacing (float 0.1)
                , Layer.textMaxWidth (float 7)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 3)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 11 ), ( 16, float 16 ) ])
                ]
            , Layer.symbol "place-suburb"
                "composite"
                [ Layer.minzoom 11
                , Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "suburb"))
                , Layer.sourceLayer "place_label"
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textColor (E.rgba 158 158 158 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textTransform E.textTransformUppercase
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textMaxWidth (float 7)
                , Layer.textPadding (float 3)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 11 ), ( 15, float 18 ) ])
                ]
            , Layer.symbol "place-hamlet"
                "composite"
                [ Layer.minzoom 10
                , Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "hamlet"))
                , Layer.sourceLayer "place_label"
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.textColor (E.rgba 158 158 158 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 11.5 ), ( 15, float 16 ) ])
                ]
            , Layer.symbol "place-village"
                "composite"
                [ Layer.minzoom 11
                , Layer.maxzoom 15
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "village"))
                , Layer.sourceLayer "place_label"
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.textColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, E.rgba 158 158 158 1 ), ( 11, E.rgba 140 140 140 1 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textMaxWidth (float 7)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11.5 ), ( 16, float 18 ) ])
                , Layer.textOffset (E.floats [ 0, 0 ])
                ]
            , Layer.symbol "place-town"
                "composite"
                [ Layer.minzoom 7
                , Layer.maxzoom 15
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "town"))
                , Layer.sourceLayer "place_label"
                , Layer.textColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, E.rgba 158 158 158 1 ), ( 11, E.rgba 140 140 140 1 ) ])
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 11.5 ), ( 15, float 20 ) ])
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 12, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-islands"
                "composite"
                [ Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "island"))
                , Layer.sourceLayer "place_label"
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.2)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 16 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-city-sm"
                "composite"
                [ Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "scalerank")
                            |> E.matchesFloat [ ( 0, false ), ( 1, false ), ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                        , E.getProperty (str "type") |> E.isEqual (str "city")
                        ]
                    )
                , Layer.sourceLayer "place_label"
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 6, float 12 ), ( 14, float 22 ) ])
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-city-md-s"
                "composite"
                [ Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "type") |> E.isEqual (str "city")
                        , E.getProperty (str "ldir")
                            |> E.matchesStr [ ( "E", true ), ( "S", true ), ( "SE", true ), ( "SW", true ) ] false
                        , E.getProperty (str "scalerank") |> E.matchesFloat [ ( 3, true ), ( 4, true ), ( 5, true ) ] false
                        ]
                    )
                , Layer.sourceLayer "place_label"
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloBlur (float 0)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 5, float 12 ), ( 12, float 22 ) ])
                , Layer.textAnchor E.positionTop
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, 0.1 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.iconImage (str "dot-10")
                ]
            , Layer.symbol "place-city-md-n"
                "composite"
                [ Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "type") |> E.isEqual (str "city")
                        , E.getProperty (str "ldir")
                            |> E.matchesStr [ ( "N", true ), ( "NE", true ), ( "NW", true ), ( "W", true ) ] false
                        , E.getProperty (str "scalerank") |> E.matchesFloat [ ( 3, true ), ( 4, true ), ( 5, true ) ] false
                        ]
                    )
                , Layer.sourceLayer "place_label"
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 5, float 12 ), ( 12, float 22 ) ])
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, -0.25 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textAnchor E.positionBottom
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                , Layer.iconImage (str "dot-10")
                ]
            , Layer.symbol "place-city-lg-s"
                "composite"
                [ Layer.minzoom 1
                , Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 2)
                        , E.getProperty (str "type") |> E.isEqual (str "city")
                        , E.getProperty (str "ldir")
                            |> E.matchesStr [ ( "E", true ), ( "S", true ), ( "SE", true ), ( "SW", true ) ] false
                        ]
                    )
                , Layer.sourceLayer "place_label"
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 4, float 12 ), ( 10, float 22 ) ])
                , Layer.iconImage (str "dot-11")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, 0.15 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.iconSize (float 1)
                , Layer.textAnchor (E.zoom |> E.step E.positionTop [ ( 8, E.positionCenter ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-city-lg-n"
                "composite"
                [ Layer.minzoom 1
                , Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 2)
                        , E.getProperty (str "type") |> E.isEqual (str "city")
                        , E.getProperty (str "ldir")
                            |> E.matchesStr [ ( "N", true ), ( "NE", true ), ( "NW", true ), ( "W", true ) ] false
                        ]
                    )
                , Layer.sourceLayer "place_label"
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textOpacity (float 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 4, float 12 ), ( 10, float 22 ) ])
                , Layer.iconImage (str "dot-11")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, -0.25 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.iconSize (float 1)
                , Layer.textAnchor (E.zoom |> E.step E.positionBottom [ ( 8, E.positionCenter ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "marine-label-sm-ln"
                "composite"
                [ Layer.minzoom 3
                , Layer.maxzoom 10
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "labelrank") |> E.greaterThanOrEqual (float 4)
                        ]
                    )
                , Layer.sourceLayer "marine_label"
                , Layer.textColor (E.rgba 120 136 138 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 12 ), ( 6, float 16 ) ])
                , Layer.symbolSpacing (E.zoom |> E.interpolate (E.Exponential 1) [ ( 4, float 100 ), ( 6, float 400 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPitchAlignment E.anchorViewport
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.1)
                , Layer.textMaxWidth (float 5)
                ]
            , Layer.symbol "marine-label-sm-pt"
                "composite"
                [ Layer.minzoom 3
                , Layer.maxzoom 10
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "Point")
                        , E.getProperty (str "labelrank") |> E.greaterThanOrEqual (float 4)
                        ]
                    )
                , Layer.sourceLayer "marine_label"
                , Layer.textColor (E.rgba 120 136 138 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 5)
                , Layer.textLetterSpacing (float 0.1)
                , Layer.textLineHeight (float 1.5)
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 12 ), ( 6, float 16 ) ])
                ]
            , Layer.symbol "marine-label-md-ln"
                "composite"
                [ Layer.minzoom 2
                , Layer.maxzoom 8
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "labelrank") |> E.matchesFloat [ ( 2, true ), ( 3, true ) ] false
                        ]
                    )
                , Layer.sourceLayer "marine_label"
                , Layer.textColor (E.rgba 120 136 138 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1.1) [ ( 2, float 12 ), ( 5, float 20 ) ])
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPitchAlignment E.anchorViewport
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textMaxWidth (float 5)
                ]
            , Layer.symbol "marine-label-md-pt"
                "composite"
                [ Layer.minzoom 2
                , Layer.maxzoom 8
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "Point")
                        , E.getProperty (str "labelrank") |> E.matchesFloat [ ( 2, true ), ( 3, true ) ] false
                        ]
                    )
                , Layer.sourceLayer "marine_label"
                , Layer.textColor (E.rgba 120 136 138 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 5)
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textLineHeight (float 1.5)
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1.1) [ ( 2, float 14 ), ( 5, float 20 ) ])
                ]
            , Layer.symbol "marine-label-lg-ln"
                "composite"
                [ Layer.minzoom 1
                , Layer.maxzoom 4
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "LineString"), E.getProperty (str "labelrank") |> E.isEqual (float 1) ])
                , Layer.sourceLayer "marine_label"
                , Layer.textColor (E.rgba 120 136 138 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 4)
                , Layer.textLetterSpacing (float 0.25)
                , Layer.textLineHeight (float 1.1)
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPitchAlignment E.anchorViewport
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 1, float 14 ), ( 4, float 30 ) ])
                ]
            , Layer.symbol "marine-label-lg-pt"
                "composite"
                [ Layer.minzoom 1
                , Layer.maxzoom 4
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "Point"), E.getProperty (str "labelrank") |> E.isEqual (float 1) ])
                , Layer.sourceLayer "marine_label"
                , Layer.textColor (E.rgba 120 136 138 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 4)
                , Layer.textLetterSpacing (float 0.25)
                , Layer.textLineHeight (float 1.5)
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 1, float 14 ), ( 4, float 30 ) ])
                ]
            , Layer.symbol "state-label-sm"
                "composite"
                [ Layer.minzoom 3
                , Layer.maxzoom 9
                , Layer.filter (E.getProperty (str "area") |> E.lessThan (float 20000))
                , Layer.sourceLayer "state_label"
                , Layer.textOpacity (float 1)
                , Layer.textColor (E.rgba 168 168 168 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 6, float 10 ), ( 9, float 14 ) ])
                , Layer.textTransform E.textTransformUppercase
                , Layer.textFont (E.strings [ "DIN Offc Pro Bold", "Arial Unicode MS Bold" ])
                , Layer.textField
                    (E.zoom
                        |> E.step (E.toFormattedText (E.getProperty (str "abbr"))) [ ( 6, E.toFormattedText (E.getProperty (str "name_en")) ) ]
                    )
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textMaxWidth (float 5)
                ]
            , Layer.symbol "state-label-md"
                "composite"
                [ Layer.minzoom 3
                , Layer.maxzoom 8
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "area") |> E.lessThan (float 80000)
                        , E.getProperty (str "area") |> E.greaterThanOrEqual (float 20000)
                        ]
                    )
                , Layer.sourceLayer "state_label"
                , Layer.textOpacity (float 1)
                , Layer.textColor (E.rgba 168 168 168 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, float 10 ), ( 8, float 16 ) ])
                , Layer.textTransform E.textTransformUppercase
                , Layer.textFont (E.strings [ "DIN Offc Pro Bold", "Arial Unicode MS Bold" ])
                , Layer.textField
                    (E.zoom
                        |> E.step (E.toFormattedText (E.getProperty (str "abbr"))) [ ( 5, E.toFormattedText (E.getProperty (str "name_en")) ) ]
                    )
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textMaxWidth (float 6)
                ]
            , Layer.symbol "state-label-lg"
                "composite"
                [ Layer.minzoom 3
                , Layer.maxzoom 7
                , Layer.filter (E.getProperty (str "area") |> E.greaterThanOrEqual (float 80000))
                , Layer.sourceLayer "state_label"
                , Layer.textOpacity (float 1)
                , Layer.textColor (E.rgba 168 168 168 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 4, float 10 ), ( 7, float 18 ) ])
                , Layer.textTransform E.textTransformUppercase
                , Layer.textFont (E.strings [ "DIN Offc Pro Bold", "Arial Unicode MS Bold" ])
                , Layer.textPadding (float 1)
                , Layer.textField
                    (E.zoom
                        |> E.step (E.toFormattedText (E.getProperty (str "abbr"))) [ ( 4, E.toFormattedText (E.getProperty (str "name_en")) ) ]
                    )
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textMaxWidth (float 6)
                ]
            , Layer.symbol "country-label-sm"
                "composite"
                [ Layer.minzoom 1
                , Layer.maxzoom 10
                , Layer.filter (E.getProperty (str "scalerank") |> E.greaterThanOrEqual (float 5))
                , Layer.sourceLayer "country_label"
                , Layer.textHaloWidth (float 1.25)
                , Layer.textHaloColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 2, E.rgba 255 255 255 0.75 ), ( 3, E.rgba 255 255 255 1 ) ]
                    )
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 6)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 5, float 14 ), ( 9, float 22 ) ])
                ]
            , Layer.symbol "country-label-md"
                "composite"
                [ Layer.minzoom 1
                , Layer.maxzoom 8
                , Layer.filter (E.getProperty (str "scalerank") |> E.matchesFloat [ ( 3, true ), ( 4, true ) ] false)
                , Layer.sourceLayer "country_label"
                , Layer.textHaloWidth (float 1.25)
                , Layer.textHaloColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 2, E.rgba 255 255 255 0.75 ), ( 3, E.rgba 255 255 255 1 ) ]
                    )
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField
                    (E.zoom
                        |> E.step (E.toFormattedText (E.getProperty (str "code"))) [ ( 2, E.toFormattedText (E.getProperty (str "name_en")) ) ]
                    )
                , Layer.textMaxWidth (float 6)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 10 ), ( 8, float 24 ) ])
                ]
            , Layer.symbol "country-label-lg"
                "composite"
                [ Layer.minzoom 1
                , Layer.maxzoom 7
                , Layer.filter (E.getProperty (str "scalerank") |> E.matchesFloat [ ( 1, true ), ( 2, true ) ] false)
                , Layer.sourceLayer "country_label"
                , Layer.textHaloWidth (float 1.25)
                , Layer.textHaloColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 2, E.rgba 255 255 255 0.75 ), ( 3, E.rgba 255 255 255 1 ) ]
                    )
                , Layer.textColor (E.rgba 107 107 107 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 0, float 5 ), ( 3, float 6 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 1, float 10 ), ( 6, float 24 ) ])
                ]
            ]
        , sources = [ Source.vectorFromUrl "composite" "mapbox://mapbox.mapbox-terrain-v2,mapbox.mapbox-streets-v7" ]
        , misc =
            [ Style.sprite "mapbox://sprites/mapbox/light-v9"
            , Style.glyphs "mapbox://fonts/mapbox/{fontstack}/{range}.pbf"
            , Style.name "Light"
            , Style.defaultZoomLevel 10
            ]
        }
