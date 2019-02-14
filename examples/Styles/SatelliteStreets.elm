module Styles.SatelliteStreets exposing (style)

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
            [ Layer.background "background" [ Layer.backgroundColor (E.rgba 4 7 14 1) ]
            , Layer.raster "mapbox-mapbox-satellite" "mapbox://mapbox.satellite" []
            , Layer.line "tunnel-secondary-tertiary case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.5, float 0.5 ), ( 16, float 0.75 ), ( 18, float 0.35 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineBlur (float 0)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 12 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-street_limited case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.5, float 0.5 ), ( 16, float 0.75 ), ( 18, float 0.35 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineBlur (float 0)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 12 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-street case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 242 232 232 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.5, float 0.5 ), ( 16, float 0.75 ), ( 18, float 0.35 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineBlur (float 0)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
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
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.5, float 0.5 ), ( 16, float 0.75 ), ( 18, float 0.35 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineBlur (float 0)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 18 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-trunk_link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 242 232 232 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.5, float 0.5 ), ( 16, float 0.75 ), ( 18, float 0.35 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineBlur (float 0)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-motorway_link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.5, float 0.5 ), ( 16, float 0.75 ), ( 18, float 0.35 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 16, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineBlur (float 0)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 18 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-trunk-case"
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
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 16, float 0.5 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineBlur (float 0)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 18 ) ])
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
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 16, float 0.5 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineBlur (float 0)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 18 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-path"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.notEqual (str "steps")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 219 219 219 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.25 ), ( 15, float 0.4 ), ( 16, float 0.75 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 1 ), ( 18, float 2.5 ) ])
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.75, 1 ] ), ( 16, E.floats [ 1, 0.75 ] ), ( 17, E.floats [ 1, 0.5 ] ) ]
                    )
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-trunk_link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 242 232 232 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-motorway_link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 5, E.rgba 163 131 96 1 ), ( 14.5, E.rgba 208 145 76 1 ), ( 18, E.rgba 209 210 208 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-pedestrian case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 249 247 244 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 16, float 0.5 ) ])
                , Layer.lineWidth (float 1)
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.5, 1 ] ), ( 16, E.floats [ 1, 2 ] ) ])
                , Layer.lineBlur (float 0)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-service-link-track case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "service", true ), ( "track", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, E.rgba 143 141 141 1 ), ( 10, E.rgba 191 191 191 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 16, float 0.5 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 12 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-street_limited"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 43 42 42 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 0 ), ( 14, float 0.5 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10.5, float 0.5 ), ( 12, float 4 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-street"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 43 42 42 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 0 ), ( 14, float 0.5 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10.5, float 0.5 ), ( 12, float 4 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-secondary-tertiary"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 43 42 42 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 11.5, float 0 ), ( 12.5, float 0.65 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 12 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-primary"
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
                , Layer.lineColor (E.rgba 212 210 210 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.symbol "tunnel-oneway-arrows-blue-minor"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "path", true ), ( "pedestrian", true ), ( "service", true ), ( "track", true ) ] false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.iconImage (str "oneway-spaced-white-large")
                ]
            , Layer.symbol "tunnel-oneway-arrows-blue-major"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr
                                    [ ( "primary", true )
                                    , ( "secondary", true )
                                    , ( "street", true )
                                    , ( "street_limited", true )
                                    , ( "tertiary", true )
                                    ]
                                    false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.iconImage (str "oneway-spaced-white-large")
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
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, E.rgba 206 193 68 1 ), ( 18, E.rgba 209 210 208 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "tunnel-motorway"
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
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 5, E.rgba 163 131 96 1 ), ( 14.5, E.rgba 208 145 76 1 ), ( 18, E.rgba 209 210 208 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.75 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.symbol "tunnel-oneway-arrows-white"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "motorway", true ), ( "motorway_link", true ), ( "trunk", true ) ] false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "primary_link", false ), ( "secondary_link", false ), ( "tertiary_link", false ) ] true
                            ]
                        ]
                    )
                , Layer.iconImage (str "oneway-spaced-white-large")
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.symbolSpacing (float 150)
                , Layer.iconPadding (float 2)
                ]
            , Layer.line "ferry"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "LineString"), E.getProperty (str "type") |> E.isEqual (str "ferry") ])
                , Layer.lineColor (E.rgba 219 219 219 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.5, float 0 ), ( 8, float 0.15 ), ( 16, float 0.5 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 18, float 2.5 ) ])
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 3.5, 2 ]) [ ( 14, E.floats [ 2, 1 ] ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "ferry, auto"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "type") |> E.isEqual (str "ferry_auto")
                        ]
                    )
                , Layer.lineColor (E.rgba 219 219 219 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.5, float 0 ), ( 8, float 0.15 ), ( 16, float 0.5 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 18, float 2.5 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.symbol "ferry-label"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "ferry"))
                , Layer.textColor (E.rgba 247 248 252 1)
                , Layer.textOpacity (float 1)
                , Layer.textHaloColor (E.rgba 7 7 7 1)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textHaloWidth (float 1.75)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 11 ), ( 20, float 13 ) ])
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textLineHeight (float 1.1)
                , Layer.textMaxWidth (float 7)
                , Layer.symbolPlacement E.symbolPlacementLine
                ]
            , Layer.line "road-link case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "link")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, E.rgba 143 141 141 1 ), ( 10, E.rgba 191 191 191 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-motorway_link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 10
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ), ( 15, E.rgba 64 63 63 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 16, float 2 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-primary-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.maxzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "primary")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11, E.rgba 43 42 42 1 ), ( 14, E.rgba 137 137 132 1 ), ( 18, E.rgba 33 32 32 1 ) ]
                    )
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 7, float 0 ), ( 10, float 0.5 ), ( 14, float 1 ), ( 16, float 0 ) ]
                    )
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-trunk_link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ), ( 15, E.rgba 64 63 63 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 0.75 ), ( 12, float 0.65 ), ( 18, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 14, float 2 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-trunk-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "trunk")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, float 0.5 ), ( 18, float 2 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 11, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-motorway-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ), ( 15, E.rgba 64 63 63 1 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 11, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-path"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "crossing", false ), ( "piste", false ), ( "sidewalk", false ), ( "steps", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 219 219 219 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 1 ), ( 18, float 2.5 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.25 ), ( 15, float 0.4 ), ( 16, float 0.75 ) ])
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.75, 1 ] ), ( 16, E.floats [ 1, 0.75 ] ), ( 17, E.floats [ 1, 0.5 ] ) ]
                    )
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-trunk_link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, E.rgba 184 172 64 1 ), ( 18, E.rgba 209 210 208 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-motorway_link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 10
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 5, E.rgba 163 131 96 1 ), ( 14.5, E.rgba 208 145 76 1 ), ( 18, E.rgba 209 210 208 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-pedestrian"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 12
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 219 219 219 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 1 ), ( 18, float 2.5 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.25 ), ( 15, float 0.4 ), ( 16, float 0.75 ) ])
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.5, 1 ] ), ( 16, E.floats [ 1, 2 ] ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "link")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.notEqual (str "o")
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, E.rgba 143 141 141 1 ), ( 10, E.rgba 191 191 191 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-street_limited"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 43 42 42 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 0 ), ( 14, float 0.25 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10.5, float 0.5 ), ( 12, float 4 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-street"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual E.textFitNone
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 43 42 42 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 0 ), ( 14, float 0.5 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10.5, float 0.5 ), ( 12, float 4 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-secondary-tertiary"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 43 42 42 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 11.5, float 0 ), ( 12.5, float 0.65 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 16, float 2 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-primary"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "link", true ), ( "primary", true ) ] false
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 244 244 244 1 ), ( 10, E.rgba 212 210 210 1 ) ])
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, float 0.25 ), ( 8, float 0.6 ), ( 14, float 1 ), ( 16, float 0 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.5 ), ( 12, float 1.75 ), ( 18, float 1 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.symbol "road-oneway-arrows-blue-minor"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 16
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "path", true ), ( "pedestrian", true ), ( "service", true ), ( "track", true ) ] false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.iconImage (E.zoom |> E.step (str "oneway-spaced-small") [ ( 17, str "oneway-spaced-large" ) ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.symbolSpacing (float 200)
                , Layer.iconPadding (float 2)
                , Layer.iconRotationAlignment E.anchorMap
                ]
            , Layer.symbol "road-oneway-arrows-blue-major"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr
                                    [ ( "primary", true )
                                    , ( "secondary", true )
                                    , ( "street", true )
                                    , ( "street_limited", true )
                                    , ( "tertiary", true )
                                    ]
                                    false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.iconImage (E.zoom |> E.step (str "oneway-spaced-small") [ ( 17, str "oneway-spaced-large" ) ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.symbolSpacing (float 200)
                , Layer.iconPadding (float 2)
                , Layer.iconRotationAlignment E.anchorMap
                ]
            , Layer.line "road-trunk"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 5
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "trunk")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, E.rgba 206 193 68 1 ), ( 18, E.rgba 209 210 208 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road-motorway"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 5, E.rgba 163 131 96 1 ), ( 14.5, E.rgba 208 145 76 1 ), ( 18, E.rgba 209 210 208 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.symbol "road-oneway-arrows-white"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "motorway", true ), ( "motorway_link", true ), ( "trunk", true ) ] false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "primary_link", false ), ( "secondary_link", false ), ( "tertiary_link", false ) ] true
                            ]
                        ]
                    )
                , Layer.iconImage (E.zoom |> E.step (str "oneway-spaced-small") [ ( 17, str "oneway-spaced-large" ) ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.symbolSpacing (float 200)
                , Layer.iconPadding (float 2)
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
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11, E.rgba 43 42 42 1 ), ( 14, E.rgba 137 137 132 1 ), ( 18, E.rgba 33 32 32 1 ) ]
                    )
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 7, float 0 ), ( 10, float 0.5 ), ( 14, float 1 ), ( 16, float 0 ) ]
                    )
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk_link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.maxzoom 15
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
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ), ( 15, E.rgba 64 63 63 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 0.75 ), ( 12, float 0.65 ), ( 18, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 14, float 2 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway_link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "layer")
                                |> E.matchesFloat [ ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ), ( 15, E.rgba 64 63 63 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 16, float 2 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
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
                            , E.getProperty (str "layer")
                                |> E.matchesFloat [ ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, float 0.5 ), ( 18, float 2 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 11, E.lineCapButt ) ])
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
                            , E.getProperty (str "layer")
                                |> E.matchesFloat [ ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ), ( 15, E.rgba 64 63 63 1 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-path"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.notEqual (str "steps")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 219 219 219 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 1 ), ( 18, float 2.5 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.25 ), ( 15, float 0.4 ), ( 16, float 0.75 ) ])
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.75, 1 ] ), ( 16, E.floats [ 1, 0.75 ] ), ( 17, E.floats [ 1, 0.5 ] ) ]
                    )
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk_link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, E.rgba 184 172 64 1 ), ( 18, E.rgba 209 210 208 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway_link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "layer")
                                |> E.matchesFloat [ ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 5, E.rgba 163 131 96 1 ), ( 14.5, E.rgba 208 145 76 1 ), ( 18, E.rgba 209 210 208 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-street_limited"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 43 42 42 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 0 ), ( 14, float 0.25 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10.5, float 0.5 ), ( 12, float 4 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-street"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 43 42 42 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 0 ), ( 14, float 0.5 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10.5, float 0.5 ), ( 12, float 4 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
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
                , Layer.lineColor (E.rgba 43 42 42 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 11.5, float 0 ), ( 12.5, float 0.65 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 16, float 2 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-primary"
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
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 244 244 244 1 ), ( 10, E.rgba 212 210 210 1 ) ])
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, float 0.25 ), ( 8, float 0.6 ), ( 14, float 1 ), ( 16, float 0 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.5 ), ( 12, float 1.75 ), ( 18, float 1 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.symbol "bridge-oneway-arrows-blue-minor"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "path", true ), ( "pedestrian", true ), ( "service", true ), ( "track", true ) ] false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.iconImage (E.zoom |> E.step (str "oneway-spaced-small") [ ( 17, str "oneway-spaced-large" ) ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.symbolSpacing (float 200)
                , Layer.iconPadding (float 2)
                , Layer.iconRotationAlignment E.anchorMap
                ]
            , Layer.symbol "bridge-oneway-arrows-blue-major"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr
                                    [ ( "primary", true )
                                    , ( "secondary", true )
                                    , ( "street", true )
                                    , ( "street_limited", true )
                                    , ( "tertiary", true )
                                    ]
                                    false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.iconImage (E.zoom |> E.step (str "oneway-spaced-small") [ ( 17, str "oneway-spaced-large" ) ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.symbolSpacing (float 200)
                , Layer.iconPadding (float 2)
                , Layer.iconRotationAlignment E.anchorMap
                ]
            , Layer.line "bridge-trunk"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 5
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "trunk")
                            , E.getProperty (str "layer")
                                |> E.matchesFloat [ ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, E.rgba 206 193 68 1 ), ( 18, E.rgba 209 210 208 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway")
                            , E.getProperty (str "layer")
                                |> E.matchesFloat [ ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 5, E.rgba 163 131 96 1 ), ( 14.5, E.rgba 208 145 76 1 ), ( 18, E.rgba 209 210 208 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk_link-2-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.maxzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ), ( 15, E.rgba 64 63 63 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 0.75 ), ( 12, float 0.65 ), ( 18, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 14, float 2 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway_link-2-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ), ( 15, E.rgba 64 63 63 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 16, float 2 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk-2-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.maxzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "trunk")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1.2) [ ( 5, float 0 ), ( 5.5, float 0.5 ), ( 8, float 0.85 ), ( 14, float 0.2 ), ( 16, float 0 ) ]
                    )
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway-2-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.maxzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 66 65 65 1 ), ( 12, E.rgba 79 78 78 1 ), ( 15, E.rgba 64 63 63 1 ) ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-trunk_link-2"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, E.rgba 184 172 64 1 ), ( 18, E.rgba 209 210 208 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge-motorway_link-2"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 5, E.rgba 163 131 96 1 ), ( 14.5, E.rgba 208 145 76 1 ), ( 18, E.rgba 209 210 208 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
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
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, E.rgba 206 193 68 1 ), ( 18, E.rgba 209 210 208 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
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
                            , E.getProperty (str "layer") |> E.greaterThanOrEqual (float 2)
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 5, E.rgba 163 131 96 1 ), ( 14.5, E.rgba 208 145 76 1 ), ( 18, E.rgba 209 210 208 1 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 16, float 0 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 1 ), ( 12, float 2 ), ( 18, float 1 ) ])
                , Layer.lineCap (E.zoom |> E.step E.lineCapRound [ ( 12, E.lineCapButt ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.symbol "bridge-oneway-arrows-white"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 16
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "motorway", true ), ( "motorway_link", true ), ( "trunk", true ) ] false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "primary_link", false ), ( "secondary_link", false ), ( "tertiary_link", false ) ] true
                            ]
                        ]
                    )
                , Layer.iconImage (E.zoom |> E.step (str "oneway-spaced-small") [ ( 17, str "oneway-spaced-large" ) ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.symbolSpacing (float 200)
                , Layer.iconPadding (float 2)
                ]
            , Layer.line "aerialway-bg"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 12
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.any
                            [ E.conditionally
                                [ ( E.typeof (E.getProperty (str "class")) |> E.isEqual (str "string")
                                  , E.getProperty (str "class") |> E.isEqual (str "aerialway")
                                  )
                                ]
                                false
                            , E.conditionally
                                [ ( E.typeof (E.getProperty (str "type")) |> E.isEqual (str "string")
                                  , E.getProperty (str "type") |> E.isEqual (str "piste")
                                  )
                                ]
                                false
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 115 113 113 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12.5, float 0 ), ( 14, float 0.25 ), ( 16, float 0.75 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0.5 ), ( 18, float 2.5 ) ])
                , Layer.lineBlur (float 1)
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "aerialway"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 12
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.any
                            [ E.conditionally
                                [ ( E.typeof (E.getProperty (str "class")) |> E.isEqual (str "string")
                                  , E.getProperty (str "class") |> E.isEqual (str "aerialway")
                                  )
                                ]
                                false
                            , E.conditionally
                                [ ( E.typeof (E.getProperty (str "type")) |> E.isEqual (str "string")
                                  , E.getProperty (str "type") |> E.isEqual (str "piste")
                                  )
                                ]
                                false
                            ]
                        ]
                    )
                , Layer.lineColor (E.rgba 219 219 219 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 0 ), ( 12.5, float 0.25 ), ( 16, float 0.75 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1 ), ( 18, float 2.5 ) ])
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 3.5, 2 ]) [ ( 22, E.floats [ 2, 1 ] ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "admin-3-4-boundaries-bg"
                "composite"
                [ Layer.sourceLayer "admin"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.greaterThanOrEqual (float 3)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 0, E.rgba 155 183 132 0.77 ), ( 6, E.rgba 155 183 132 0.77 ), ( 8, E.rgba 57 99 22 0.77 ) ]
                    )
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 4, float 0.2 ), ( 8, float 0.35 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 2.5 ), ( 10, float 4.5 ) ])
                , Layer.lineBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0 ), ( 8, float 3 ) ])
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineJoin E.lineJoinBevel
                ]
            , Layer.line "admin-2-boundaries-bg"
                "composite"
                [ Layer.sourceLayer "admin"
                , Layer.minzoom 1
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.isEqual (float 2)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.lineColor (E.rgba 242 242 242 0.77)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 3.5 ), ( 10, float 10 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 4, float 0.1 ), ( 8, float 0.35 ) ])
                , Layer.lineBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0 ), ( 10, float 2 ) ])
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineJoin E.lineJoinMiter
                ]
            , Layer.line "admin-3-4-boundaries"
                "composite"
                [ Layer.sourceLayer "admin"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.greaterThanOrEqual (float 3)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.lineColor (E.rgba 0 0 0 0.72)
                , Layer.lineDasharray (E.floats [ 5, 2.5 ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 0, float 1 ), ( 12, float 0.5 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 4, float 1 ), ( 9, float 1.75 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "admin-2-boundaries"
                "composite"
                [ Layer.sourceLayer "admin"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.isEqual (float 2)
                        , E.getProperty (str "disputed") |> E.isEqual (float 0)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.lineColor (E.rgba 0 0 0 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 0, float 0.5 ), ( 6, float 0.75 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 0, float 0.75 ), ( 4, float 3 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "admin-2-boundaries offset"
                "composite"
                [ Layer.sourceLayer "admin"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.isEqual (float 2)
                        , E.getProperty (str "disputed") |> E.isEqual (float 0)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.lineColor (E.rgba 235 233 233 0.72)
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 0, float 0.5 ), ( 4, float 0.75 ), ( 9, float 1.5 ), ( 12, float 2 ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 0, float 0.25 ), ( 4, float 0.5 ), ( 8, float 0.75 ) ])
                , Layer.lineBlur (float 0)
                , Layer.lineOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 0, float 1.5 ), ( 4, float 0.75 ) ])
                , Layer.lineCap E.lineCapRound
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "admin-2-boundaries-dispute"
                "composite"
                [ Layer.sourceLayer "admin"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.isEqual (float 2)
                        , E.getProperty (str "disputed") |> E.isEqual (float 1)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.lineColor (E.rgba 0 0 0 1)
                , Layer.lineDasharray (E.floats [ 4, 8 ])
                , Layer.lineWidth (float 0.75)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 0, float 1 ), ( 12, float 0.75 ), ( 16, float 0 ) ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.symbol "waterway-label"
                "composite"
                [ Layer.sourceLayer "waterway_label"
                , Layer.minzoom 12
                , Layer.filter
                    (E.getProperty (str "class")
                        |> E.matchesStr [ ( "canal", true ), ( "river", true ), ( "stream", true ) ] false
                    )
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 0.5 ), ( 14, float 1.5 ) ])
                , Layer.textHaloColor (E.rgba 22 22 22 1)
                , Layer.textColor (E.rgba 117 207 240 1)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textMaxAngle (float 30)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 12 ), ( 18, float 16 ) ])
                ]
            , Layer.symbol "poi-scalerank4-l15"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "localrank") |> E.greaterThanOrEqual (float 15)
                        , E.getProperty (str "maki")
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
                        , E.getProperty (str "scalerank") |> E.isEqual (float 4)
                        ]
                    )
                , Layer.textColor (E.rgba 234 234 234 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 42 39 39 1 ) ])
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 14 ) ])
                , Layer.iconImage
                    (E.zoom
                        |> E.step (E.getProperty (str "maki") |> E.append (str "-11")) [ ( 14, E.getProperty (str "maki") |> E.append (str "-15") ) ]
                    )
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "poi-scalerank4-l1"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "localrank") |> E.lessThan (float 14)
                        , E.getProperty (str "maki")
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
                        , E.getProperty (str "scalerank") |> E.isEqual (float 4)
                        ]
                    )
                , Layer.textColor (E.rgba 234 234 234 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 42 39 39 1 ) ])
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 14 ) ])
                , Layer.iconImage
                    (E.zoom
                        |> E.step (E.getProperty (str "maki") |> E.append (str "-11")) [ ( 14, E.getProperty (str "maki") |> E.append (str "-15") ) ]
                    )
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "poi-parks-scalerank4"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "maki")
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
                        , E.getProperty (str "scalerank") |> E.isEqual (float 4)
                        ]
                    )
                , Layer.textColor (E.rgba 135 204 101 1)
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 46 45 45 1 ) ])
                , Layer.iconOpacity (float 1)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 14 ) ])
                , Layer.iconImage (E.zoom |> E.step (str "") [ ( 14, E.getProperty (str "maki") |> E.append (str "-15") ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium Italic", "Arial Unicode MS Regular" ])
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "poi-scalerank3"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "localrank") |> E.lessThanOrEqual (float 3)
                        , E.getProperty (str "maki")
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
                , Layer.textColor (E.rgba 234 234 234 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 42 39 39 1 ) ])
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 14 ) ])
                , Layer.iconImage
                    (E.zoom
                        |> E.step (E.getProperty (str "maki") |> E.append (str "-11")) [ ( 14, E.getProperty (str "maki") |> E.append (str "-15") ) ]
                    )
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "poi-parks-scalerank3"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "maki")
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
                        , E.getProperty (str "scalerank") |> E.isEqual (float 3)
                        ]
                    )
                , Layer.textColor (E.rgba 135 204 101 1)
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 46 45 45 1 ) ])
                , Layer.iconOpacity (float 1)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 14 ) ])
                , Layer.iconImage (E.zoom |> E.step (str "") [ ( 14, E.getProperty (str "maki") |> E.append (str "-15") ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium Italic", "Arial Unicode MS Regular" ])
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "road-label-small"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "class")
                            |> E.matchesStr
                                [ ( "ferry", false )
                                , ( "link", false )
                                , ( "motorway", false )
                                , ( "pedestrian", false )
                                , ( "primary", false )
                                , ( "secondary", false )
                                , ( "street", false )
                                , ( "street_limited", false )
                                , ( "tertiary", false )
                                , ( "trunk", false )
                                ]
                                true
                        ]
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 41 39 39 1 ) ])
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 10 ), ( 20, float 13 ) ])
                , Layer.textMaxAngle (float 30)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 14, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.anchorMap
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                ]
            , Layer.symbol "road-label-medium"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.minzoom 12
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "class")
                            |> E.matchesStr [ ( "link", true ), ( "pedestrian", true ), ( "street", true ), ( "street_limited", true ) ] false
                        ]
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 41 39 39 1 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 10 ), ( 20, float 14 ) ])
                , Layer.textMaxAngle (float 30)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.anchorMap
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                ]
            , Layer.symbol "road-label-large"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.minzoom 12
                , Layer.filter (E.getProperty (str "class") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false)
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 41 39 39 1 ) ])
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, float 10 ), ( 20, float 16 ) ])
                , Layer.textMaxAngle (float 30)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.anchorMap
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                ]
            , Layer.symbol "road-label-xlarge"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.filter
                    (E.getProperty (str "class")
                        |> E.matchesStr [ ( "motorway", true ), ( "primary", true ), ( "trunk", true ) ] false
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 41 39 39 1 ) ])
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, float 10 ), ( 20, float 16 ) ])
                , Layer.textMaxAngle (float 30)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Bold", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.anchorMap
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                ]
            , Layer.symbol "road-shields-black"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "class")
                            |> E.matchesStr
                                [ ( "motorway", true )
                                , ( "motorway_link", true )
                                , ( "primary", true )
                                , ( "secondary", true )
                                , ( "trunk", true )
                                ]
                                false
                        , E.getProperty (str "localrank") |> E.matchesFloat [ ( 1, true ), ( 2, true ) ] false
                        , E.getProperty (str "reflen") |> E.lessThanOrEqual (float 6)
                        , E.getProperty (str "shield")
                            |> E.matchesStr
                                [ ( "at-expressway", false )
                                , ( "at-motorway", false )
                                , ( "at-state-b", false )
                                , ( "bg-motorway", false )
                                , ( "bg-national", false )
                                , ( "ch-main", false )
                                , ( "ch-motorway", false )
                                , ( "cz-expressway", false )
                                , ( "cz-motorway", false )
                                , ( "cz-road", false )
                                , ( "de-motorway", false )
                                , ( "e-road", false )
                                , ( "fi-main", false )
                                , ( "gr-motorway", false )
                                , ( "gr-national", false )
                                , ( "hr-motorway", false )
                                , ( "hr-state", false )
                                , ( "hu-main", false )
                                , ( "hu-motorway", false )
                                , ( "nz-state", false )
                                , ( "pl-expressway", false )
                                , ( "pl-motorway", false )
                                , ( "pl-national", false )
                                , ( "ro-county", false )
                                , ( "ro-motorway", false )
                                , ( "ro-national", false )
                                , ( "rs-motorway", false )
                                , ( "rs-state-1b", false )
                                , ( "se-main", false )
                                , ( "si-expressway", false )
                                , ( "si-motorway", false )
                                , ( "sk-highway", false )
                                , ( "sk-road", false )
                                , ( "us-interstate", false )
                                , ( "us-interstate-business", false )
                                , ( "us-interstate-duplex", false )
                                , ( "us-interstate-truck", false )
                                , ( "za-metropolitan", false )
                                , ( "za-national", false )
                                , ( "za-provincial", false )
                                , ( "za-regional", false )
                                ]
                                true
                        ]
                    )
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.iconHaloColor (E.rgba 0 0 0 1)
                , Layer.iconHaloWidth (float 1)
                , Layer.textOpacity (float 1)
                , Layer.iconColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0)
                , Layer.textSize (float 9)
                , Layer.iconImage (E.getProperty (str "shield") |> E.append (str "-") |> E.append (E.getProperty (str "reflen")))
                , Layer.iconRotationAlignment E.anchorViewport
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 150 ), ( 14, float 200 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Bold", "Arial Unicode MS Bold" ])
                , Layer.symbolPlacement (E.zoom |> E.step E.symbolPlacementPoint [ ( 11, E.symbolPlacementLine ) ])
                , Layer.textPadding (float 2)
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textField (E.toFormattedText (E.getProperty (str "ref")))
                , Layer.textLetterSpacing (float 0.05)
                , Layer.iconPadding (float 2)
                ]
            , Layer.symbol "road-shields-white"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "class")
                            |> E.matchesStr
                                [ ( "motorway", true )
                                , ( "motorway_link", true )
                                , ( "primary", true )
                                , ( "secondary", true )
                                , ( "trunk", true )
                                ]
                                false
                        , E.getProperty (str "reflen") |> E.lessThanOrEqual (float 6)
                        , E.getProperty (str "shield")
                            |> E.matchesStr
                                [ ( "at-expressway", true )
                                , ( "at-motorway", true )
                                , ( "at-state-b", true )
                                , ( "bg-motorway", true )
                                , ( "bg-national", true )
                                , ( "ch-main", true )
                                , ( "ch-motorway", true )
                                , ( "cz-expressway", true )
                                , ( "cz-motorway", true )
                                , ( "cz-road", true )
                                , ( "de-motorway", true )
                                , ( "e-road", true )
                                , ( "fi-main", true )
                                , ( "gr-motorway", true )
                                , ( "gr-national", true )
                                , ( "hr-motorway", true )
                                , ( "hr-state", true )
                                , ( "hu-main", true )
                                , ( "hu-motorway", true )
                                , ( "nz-state", true )
                                , ( "pl-expressway", true )
                                , ( "pl-motorway", true )
                                , ( "pl-national", true )
                                , ( "ro-county", true )
                                , ( "ro-motorway", true )
                                , ( "ro-national", true )
                                , ( "rs-motorway", true )
                                , ( "rs-state-1b", true )
                                , ( "se-main", true )
                                , ( "si-expressway", true )
                                , ( "si-motorway", true )
                                , ( "sk-highway", true )
                                , ( "sk-road", true )
                                , ( "us-interstate", true )
                                , ( "us-interstate-business", true )
                                , ( "us-interstate-duplex", true )
                                , ( "us-interstate-truck", true )
                                , ( "za-metropolitan", true )
                                , ( "za-national", true )
                                , ( "za-provincial", true )
                                , ( "za-regional", true )
                                ]
                                false
                        ]
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.iconHaloColor (E.rgba 0 0 0 1)
                , Layer.iconHaloWidth (float 1)
                , Layer.textOpacity (float 1)
                , Layer.iconColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0)
                , Layer.textSize (float 9)
                , Layer.iconImage (E.getProperty (str "shield") |> E.append (str "-") |> E.append (E.getProperty (str "reflen")))
                , Layer.iconRotationAlignment E.anchorViewport
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 150 ), ( 14, float 200 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Bold", "Arial Unicode MS Bold" ])
                , Layer.symbolPlacement (E.zoom |> E.step E.symbolPlacementPoint [ ( 11, E.symbolPlacementLine ) ])
                , Layer.textPadding (float 2)
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textField (E.toFormattedText (E.getProperty (str "ref")))
                , Layer.textLetterSpacing (float 0.05)
                , Layer.iconPadding (float 2)
                ]
            , Layer.symbol "motorway-junction"
                "composite"
                [ Layer.sourceLayer "motorway_junction"
                , Layer.minzoom 14
                , Layer.filter (E.getProperty (str "reflen") |> E.greaterThan (float 0))
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textTranslate (E.floats [ 0, 0 ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "ref")))
                , Layer.textSize (float 9)
                , Layer.textFont (E.strings [ "DIN Offc Pro Bold", "Arial Unicode MS Regular" ])
                , Layer.iconImage (str "motorway-exit-" |> E.append (E.getProperty (str "reflen")))
                ]
            , Layer.symbol "poi-scalerank2"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "localrank") |> E.lessThanOrEqual (float 3)
                        , E.getProperty (str "maki")
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
                , Layer.textColor (E.rgba 234 234 234 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 42 39 39 1 ) ])
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 14 ) ])
                , Layer.iconImage
                    (E.zoom
                        |> E.step (E.getProperty (str "maki") |> E.append (str "-11")) [ ( 14, E.getProperty (str "maki") |> E.append (str "-15") ) ]
                    )
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "poi-parks-scalerank2"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "maki")
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
                        , E.getProperty (str "scalerank") |> E.isEqual (float 2)
                        ]
                    )
                , Layer.textColor (E.rgba 135 204 101 1)
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 46 45 45 1 ) ])
                , Layer.iconOpacity (float 1)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 14 ) ])
                , Layer.iconImage (E.zoom |> E.step (str "") [ ( 14, E.getProperty (str "maki") |> E.append (str "-15") ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium Italic", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "rail-label"
                "composite"
                [ Layer.sourceLayer "rail_station_label"
                , Layer.minzoom 12
                , Layer.filter (E.getProperty (str "maki") |> E.notEqual (str "entrance"))
                , Layer.textColor (E.rgba 234 234 234 1)
                , Layer.textHaloColor (E.rgba 63 63 63 1)
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 0.5 ), ( 16, float 1.5 ) ])
                , Layer.iconHaloWidth (float 4)
                , Layer.iconHaloColor (E.rgba 255 255 255 1)
                , Layer.textOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 11 ), ( 20, float 13 ) ])
                , Layer.iconImage (E.toString (E.getProperty (str "network")))
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textOffset (E.floats [ 0, 0.85 ])
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.zoom |> E.step (E.toFormattedText (str "")) [ ( 13, E.toFormattedText (E.getProperty (str "name_en")) ) ])
                , Layer.textLetterSpacing (float 0.01)
                , Layer.iconPadding (float 0)
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "water-label-sm"
                "composite"
                [ Layer.sourceLayer "water_label"
                , Layer.minzoom 15
                , Layer.filter (E.getProperty (str "area") |> E.lessThanOrEqual (float 10000))
                , Layer.textColor (E.rgba 117 207 240 1)
                , Layer.textHaloColor (E.rgba 22 22 22 1)
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0.5 ), ( 14, float 1 ) ])
                , Layer.textHaloBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 0.5 ), ( 15, float 1 ) ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 13 ), ( 20, float 16 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textMaxWidth (float 7)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                ]
            , Layer.symbol "water-label"
                "composite"
                [ Layer.sourceLayer "water_label"
                , Layer.minzoom 5
                , Layer.filter (E.getProperty (str "area") |> E.greaterThan (float 10000))
                , Layer.textColor (E.rgba 117 207 240 1)
                , Layer.textHaloColor (E.rgba 22 22 22 1)
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0.5 ), ( 14, float 1 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 13 ), ( 18, float 18 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textMaxWidth (float 7)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                ]
            , Layer.symbol "poi-parks-scalerank1"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "maki")
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
                        , E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 1)
                        ]
                    )
                , Layer.textColor (E.rgba 135 204 101 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 46 45 45 1 ) ])
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.iconOpacity (float 1)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 14 ) ])
                , Layer.iconImage (E.zoom |> E.step (str "") [ ( 14, E.getProperty (str "maki") |> E.append (str "-15") ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium Italic", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textAnchor E.positionTop
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
                , Layer.textColor (E.rgba 234 234 234 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 25 25 25 1 ), ( 16, E.rgba 42 39 39 1 ) ])
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 1.25 ), ( 15, float 1.5 ) ])
                , Layer.textHaloBlur (float 0)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 14 ) ])
                , Layer.iconImage
                    (E.zoom
                        |> E.step (E.getProperty (str "maki") |> E.append (str "-11")) [ ( 14, E.getProperty (str "maki") |> E.append (str "-15") ) ]
                    )
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "airport-label"
                "composite"
                [ Layer.sourceLayer "airport_label"
                , Layer.minzoom 9
                , Layer.filter (E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 2))
                , Layer.textColor (E.rgba 234 234 234 1)
                , Layer.textHaloColor (E.rgba 63 63 63 1)
                , Layer.textHaloWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 0.5 ), ( 16, float 1.5 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.iconOpacity (float 0.8)
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
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textAnchor E.positionTop
                , Layer.textField
                    (E.zoom
                        |> E.step (E.toFormattedText (E.getProperty (str "ref"))) [ ( 12, E.toFormattedText (E.getProperty (str "name_en")) ) ]
                    )
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 7 ), ( 12, float 8 ), ( 16, float 10 ) ])
                ]
            , Layer.symbol "place-islets"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "islet"))
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.2)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 16 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "place-neighbourhood"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 10
                , Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "neighbourhood"))
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textLineHeight (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 11 ), ( 16, float 16 ) ])
                , Layer.textTransform E.textTransformUppercase
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 3)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.1)
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-suburb"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 10
                , Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "suburb"))
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textLineHeight (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 11 ), ( 15, float 18 ) ])
                , Layer.textTransform E.textTransformUppercase
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 3)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-hamlet"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 10
                , Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "hamlet"))
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textLineHeight (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 11.5 ), ( 15, float 16 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 3)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.1)
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-village"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 8
                , Layer.maxzoom 15
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "localrank") |> E.lessThanOrEqual (float 12)
                        , E.getProperty (str "type") |> E.isEqual (str "village")
                        ]
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloWidth (float 1)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 0.9 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11.5 ), ( 16, float 18 ) ])
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 6, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, E.floats [ 0, -0.15 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.iconSize (float 1)
                , Layer.textAnchor (E.zoom |> E.step E.positionBottom [ ( 8, E.positionCenter ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-town"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 6
                , Layer.maxzoom 15
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "localrank") |> E.lessThanOrEqual (float 12)
                        , E.getProperty (str "type") |> E.isEqual (str "town")
                        ]
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloWidth (float 1)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 0.9 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 11.5 ), ( 15, float 20 ) ])
                , Layer.iconImage (str "dot-9")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 6, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, E.floats [ 0, -0.15 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.iconSize (float 1)
                , Layer.textAnchor (E.zoom |> E.step E.positionBottom [ ( 8, E.positionCenter ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-islands"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "island"))
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.2)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 16 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textRotationAlignment E.anchorViewport
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-city-sm"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "scalerank")
                            |> E.matchesFloat [ ( 0, false ), ( 1, false ), ( 2, false ), ( 3, false ), ( 4, false ), ( 5, false ) ] true
                        , E.getProperty (str "type") |> E.isEqual (str "city")
                        ]
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloWidth (float 1.75)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 0.9 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 6, float 12 ), ( 14, float 22 ) ])
                , Layer.iconImage (str "dot-9")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 6, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, -0.2 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.iconSize (float 1)
                , Layer.textAnchor (E.zoom |> E.step E.positionBottom [ ( 8, E.positionCenter ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, float 0.02 ), ( 6, float 0.07 ) ])
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-city-md-s"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "ldir")
                            |> E.matchesStr [ ( "E", true ), ( "S", true ), ( "SE", true ), ( "SW", true ) ] false
                        , E.getProperty (str "scalerank") |> E.matchesFloat [ ( 3, true ), ( 4, true ), ( 5, true ) ] false
                        , E.getProperty (str "type") |> E.isEqual (str "city")
                        ]
                    )
                , Layer.textHaloWidth (float 1.5)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloBlur (float 0.5)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 0.9 ), ( 8, float 0 ) ])
                , Layer.textOpacity (float 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.iconImage (str "dot-10")
                , Layer.textAnchor (E.zoom |> E.step E.positionTop [ ( 8, E.positionCenter ) ])
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, 0.1 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 5, float 12 ), ( 12, float 22 ) ])
                , Layer.iconSize (float 1)
                ]
            , Layer.symbol "place-city-md-n"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "ldir")
                            |> E.matchesStr [ ( "N", true ), ( "NE", true ), ( "NW", true ), ( "W", true ) ] false
                        , E.getProperty (str "scalerank") |> E.matchesFloat [ ( 3, true ), ( 4, true ), ( 5, true ) ] false
                        , E.getProperty (str "type") |> E.isEqual (str "city")
                        ]
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloWidth (float 1.5)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 0.9 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textOpacity (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 5, float 12 ), ( 12, float 22 ) ])
                , Layer.iconImage (str "dot-10")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, -0.25 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textAnchor (E.zoom |> E.step E.positionBottom [ ( 8, E.positionCenter ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-city-lg-s"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 1
                , Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "ldir")
                            |> E.matchesStr [ ( "E", true ), ( "S", true ), ( "SE", true ), ( "SW", true ) ] false
                        , E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 2)
                        , E.getProperty (str "type") |> E.isEqual (str "city")
                        ]
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloWidth (float 1.5)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 0.9 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textTranslate (E.floats [ 0, -0.75 ])
                , Layer.textOpacity (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 4, float 12 ), ( 10, float 22 ) ])
                , Layer.iconImage (str "dot-11")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, 0.15 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textAnchor (E.zoom |> E.step E.positionTop [ ( 8, E.positionCenter ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "place-city-lg-n"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 1
                , Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "ldir")
                            |> E.matchesStr [ ( "N", true ), ( "NE", true ), ( "NW", true ), ( "W", true ) ] false
                        , E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 2)
                        , E.getProperty (str "type") |> E.isEqual (str "city")
                        ]
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textOpacity (float 1)
                , Layer.textHaloColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, E.rgba 45 45 45 1 ), ( 12, E.rgba 36 34 34 1 ) ])
                , Layer.textHaloWidth (float 1.5)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 0.5)
                , Layer.textTranslate (E.floats [ 0, 0 ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 4, float 12 ), ( 10, float 22 ) ])
                , Layer.iconImage (str "dot-11")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, -0.25 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textAnchor (E.zoom |> E.step E.positionBottom [ ( 8, E.positionCenter ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                ]
            , Layer.symbol "marine-label-sm-ln"
                "composite"
                [ Layer.sourceLayer "marine_label"
                , Layer.minzoom 3
                , Layer.maxzoom 10
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "labelrank") |> E.greaterThanOrEqual (float 4)
                        ]
                    )
                , Layer.textColor (E.rgba 72 88 131 1)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 12 ), ( 6, float 16 ) ])
                , Layer.symbolSpacing (E.zoom |> E.interpolate (E.Exponential 1) [ ( 4, float 100 ), ( 6, float 400 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.1)
                , Layer.textMaxWidth (float 5)
                ]
            , Layer.symbol "marine-label-sm-pt"
                "composite"
                [ Layer.sourceLayer "marine_label"
                , Layer.minzoom 3
                , Layer.maxzoom 10
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "Point")
                        , E.getProperty (str "labelrank") |> E.greaterThanOrEqual (float 4)
                        ]
                    )
                , Layer.textColor (E.rgba 72 88 131 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 5)
                , Layer.textLetterSpacing (float 0.1)
                , Layer.textLineHeight (float 1.5)
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 12 ), ( 6, float 16 ) ])
                ]
            , Layer.symbol "marine-label-md-ln"
                "composite"
                [ Layer.sourceLayer "marine_label"
                , Layer.minzoom 2
                , Layer.maxzoom 8
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "labelrank") |> E.matchesFloat [ ( 2, true ), ( 3, true ) ] false
                        ]
                    )
                , Layer.textColor (E.rgba 72 88 131 1)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1.1) [ ( 2, float 12 ), ( 5, float 20 ) ])
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textMaxWidth (float 5)
                ]
            , Layer.symbol "marine-label-md-pt"
                "composite"
                [ Layer.sourceLayer "marine_label"
                , Layer.minzoom 2
                , Layer.maxzoom 8
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "Point")
                        , E.getProperty (str "labelrank") |> E.matchesFloat [ ( 2, true ), ( 3, true ) ] false
                        ]
                    )
                , Layer.textColor (E.rgba 72 88 131 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 5)
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textLineHeight (float 1.5)
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1.1) [ ( 2, float 14 ), ( 5, float 20 ) ])
                ]
            , Layer.symbol "marine-label-lg-ln"
                "composite"
                [ Layer.sourceLayer "marine_label"
                , Layer.minzoom 1
                , Layer.maxzoom 4
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "LineString"), E.getProperty (str "labelrank") |> E.isEqual (float 1) ])
                , Layer.textColor (E.rgba 72 88 131 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 4)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 1, float 14 ), ( 4, float 30 ) ])
                , Layer.textLineHeight (float 1.1)
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textLetterSpacing (float 0.25)
                ]
            , Layer.symbol "marine-label-lg-pt"
                "composite"
                [ Layer.sourceLayer "marine_label"
                , Layer.minzoom 1
                , Layer.maxzoom 4
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "Point"), E.getProperty (str "labelrank") |> E.isEqual (float 1) ])
                , Layer.textColor (E.rgba 72 88 131 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 4)
                , Layer.textLetterSpacing (float 0.25)
                , Layer.textLineHeight (float 1.5)
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 1, float 14 ), ( 4, float 30 ) ])
                ]
            , Layer.symbol "state-label-sm"
                "composite"
                [ Layer.sourceLayer "state_label"
                , Layer.minzoom 3
                , Layer.maxzoom 9
                , Layer.filter (E.getProperty (str "area") |> E.lessThan (float 20000))
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.rgba 44 45 46 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textOpacity (float 1)
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
                [ Layer.sourceLayer "state_label"
                , Layer.minzoom 3
                , Layer.maxzoom 8
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "area") |> E.lessThan (float 80000)
                        , E.getProperty (str "area") |> E.greaterThanOrEqual (float 20000)
                        ]
                    )
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.rgba 44 45 46 1)
                , Layer.textHaloWidth (float 2)
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
                [ Layer.sourceLayer "state_label"
                , Layer.minzoom 3
                , Layer.maxzoom 7
                , Layer.filter (E.getProperty (str "area") |> E.greaterThanOrEqual (float 80000))
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.rgba 44 45 46 1)
                , Layer.textOpacity (float 1)
                , Layer.textHaloWidth (float 2)
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
                [ Layer.sourceLayer "country_label"
                , Layer.minzoom 1
                , Layer.maxzoom 10
                , Layer.filter (E.getProperty (str "scalerank") |> E.greaterThanOrEqual (float 5))
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 0, E.rgba 44 45 46 1 ), ( 4, E.rgba 30 30 30 1 ), ( 8, E.rgba 5 5 5 1 ) ]
                    )
                , Layer.textHaloWidth (float 1.25)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 6)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 5, float 14 ), ( 9, float 22 ) ])
                ]
            , Layer.symbol "country-label-md"
                "composite"
                [ Layer.sourceLayer "country_label"
                , Layer.minzoom 1
                , Layer.maxzoom 8
                , Layer.filter (E.getProperty (str "scalerank") |> E.matchesFloat [ ( 3, true ), ( 4, true ) ] false)
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 0, E.rgba 44 45 46 1 ), ( 4, E.rgba 30 30 30 1 ), ( 8, E.rgba 5 5 5 1 ) ]
                    )
                , Layer.textHaloWidth (float 1.25)
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
                [ Layer.sourceLayer "country_label"
                , Layer.minzoom 1
                , Layer.maxzoom 7
                , Layer.filter (E.getProperty (str "scalerank") |> E.matchesFloat [ ( 1, true ), ( 2, true ) ] false)
                , Layer.textHaloColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 0, E.rgba 44 45 46 1 ), ( 4, E.rgba 30 30 30 1 ), ( 8, E.rgba 5 5 5 1 ) ]
                    )
                , Layer.textHaloWidth (float 1.25)
                , Layer.textColor (E.rgba 255 255 255 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 0, float 5 ), ( 3, float 6 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 1, float 10 ), ( 6, float 24 ) ])
                ]
            ]
        , sources =
            [ Source.vectorFromUrl "composite" "mapbox://mapbox.mapbox-streets-v7"
            , Source.rasterFromUrl "mapbox://mapbox.satellite" "mapbox://mapbox.satellite"
            ]
        , misc =
            [ Style.sprite "mapbox://sprites/mapbox/satellite-streets-v9"
            , Style.glyphs "mapbox://fonts/mapbox/{fontstack}/{range}.pbf"
            , Style.name "Mapbox Satellite Streets"
            ]
        }
