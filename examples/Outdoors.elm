module Outdoors exposing (style)

import Mapbox.Expression as E exposing (false, float, int, str, true)
import Mapbox.Layer as Layer
import Mapbox.Source as Source
import Mapbox.Style as Style exposing (Style(..))


style : Style
style =
    Style
        { transition = Style.defaultTransition
        , light = Style.defaultLight
        , layers =
            [ Layer.background "background"
                [ Layer.backgroundColor
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 5, E.rgba 239 230 214 1 )
                            , ( 7, E.rgba 236 223 202 1 )
                            ]
                    )
                ]
            , Layer.fill "national_park"
                "mapbox-streets"
                [ Layer.sourceLayer "landuse_overlay"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "national_park"))
                , Layer.fillColor (E.rgba 200 221 151 1)
                , Layer.fillOpacity
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 5, float 0 )
                            , ( 6, float 0.5 )
                            ]
                    )
                ]
            , Layer.fill "landuse"
                "mapbox-streets"
                [ Layer.sourceLayer "landuse"
                , Layer.filter
                    (E.any
                        [ E.getProperty (str "class") |> E.isEqual (str "hospital")
                        , E.getProperty (str "class") |> E.isEqual (str "park")
                        , E.getProperty (str "class") |> E.isEqual (str "pitch")
                        , E.getProperty (str "class") |> E.isEqual (str "school")
                        ]
                    )
                , Layer.fillColor
                    (E.getProperty (str "class")
                        |> E.matchesStr
                            [ ( "park", E.rgba 200 221 151 1 )
                            , ( "pitch", E.rgba 200 221 151 1 )
                            , ( "hospital", E.rgba 242 211 211 1 )
                            , ( "school", E.rgba 233 213 199 1 )
                            ]
                            (E.rgba 0 0 0 0)
                    )
                , Layer.fillOpacity
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 5, float 0 )
                            , ( 6, float 1 )
                            ]
                    )
                ]
            , Layer.line "waterway"
                "mapbox-streets"
                [ Layer.minzoom 8
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.any
                            [ E.getProperty (str "class") |> E.isEqual (str "canal")
                            , E.getProperty (str "class") |> E.isEqual (str "river")
                            ]
                        ]
                    )
                , Layer.sourceLayer "waterway"
                , Layer.lineColor (E.rgba 120 188 236 1)
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate (E.Exponential 1.3)
                            [ ( 8.5, float 0.1 )
                            , ( 20, float 8 )
                            ]
                    )
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 8, float 0 )
                            , ( 8.5, float 1 )
                            ]
                    )
                , Layer.lineJoin E.lineJoinRound
                , Layer.lineCap E.lineCapRound
                ]
            , Layer.fill "water"
                "mapbox-streets"
                [ Layer.sourceLayer "water"
                , Layer.fillColor
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 5, E.rgba 106 181 234 1 )
                            , ( 7, E.rgba 120 188 236 1 )
                            ]
                    )
                ]
            , Layer.fill "aeroway-polygon"
                "mapbox-streets"
                [ Layer.sourceLayer "aeroway"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "Polygon")
                        , E.any
                            [ E.getProperty (str "type") |> E.isEqual (str "helipad")
                            , E.getProperty (str "type") |> E.isEqual (str "runway")
                            , E.getProperty (str "type") |> E.isEqual (str "taxiway")
                            ]
                        ]
                    )
                , Layer.fillColor (E.rgba 196 196 196 1)
                ]
            , Layer.line "aeroway-line"
                "mapbox-streets"
                [ Layer.sourceLayer "aeroway"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.any
                            [ E.getProperty (str "type") |> E.isEqual (str "runway")
                            , E.getProperty (str "type") |> E.isEqual (str "taxiway")
                            ]
                        ]
                    )
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate (E.Exponential 1.5)
                            [ ( 10, float 0.5 )
                            , ( 18, float 20 )
                            ]
                    )
                , Layer.lineColor (E.rgba 196 196 196 1)
                ]
            , Layer.fill "building"
                "mapbox-streets"
                [ Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "type") |> E.notEqual (str "building:part")
                        , E.getProperty (str "underground") |> E.isEqual (str "false")
                        ]
                    )
                , Layer.sourceLayer "building"
                , Layer.fillColor (E.rgba 212 200 179 1)
                , Layer.fillOpacity
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 15.5, float 0 )
                            , ( 16, float 1 )
                            ]
                    )
                ]
            , Layer.line "pedestrian-path"
                "mapbox-streets"
                [ Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "platform")
                            , E.any
                                [ E.getProperty (str "class") |> E.isEqual (str "path")
                                , E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                                ]
                            ]
                        ]
                    )
                , Layer.sourceLayer "road"
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate (E.Exponential 1.5)
                            [ ( 14
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "pedestrian", float 1 )
                                        , ( "path", float 0.75 )
                                        ]
                                        (float 0.75)
                              )
                            , ( 20
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "pedestrian", float 8 )
                                        , ( "path", float 5 )
                                        ]
                                        (float 5)
                              )
                            ]
                    )
                , Layer.lineColor
                    (E.getProperty (str "type")
                        |> E.matchesStr
                            [ ( "sidewalk", E.rgba 221 208 186 1 )
                            , ( "crossing", E.rgba 221 208 186 1 )
                            ]
                            (E.rgba 199 184 157 1)
                    )
                , Layer.lineJoin E.lineJoinRound
                , Layer.lineCap E.lineCapRound
                ]
            , Layer.line "tunnel"
                "mapbox-streets"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "service:parking_aisle")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.any
                                [ E.getProperty (str "class") |> E.isEqual (str "link")
                                , E.getProperty (str "class") |> E.isEqual (str "motorway")
                                , E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                                , E.getProperty (str "class") |> E.isEqual (str "primary")
                                , E.getProperty (str "class") |> E.isEqual (str "secondary")
                                , E.getProperty (str "class") |> E.isEqual (str "service")
                                , E.getProperty (str "class") |> E.isEqual (str "street")
                                , E.getProperty (str "class") |> E.isEqual (str "street_limited")
                                , E.getProperty (str "class") |> E.isEqual (str "tertiary")
                                , E.getProperty (str "class") |> E.isEqual (str "track")
                                , E.getProperty (str "class") |> E.isEqual (str "trunk")
                                ]
                            ]
                        ]
                    )
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate (E.Exponential 1.5)
                            [ ( 5
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 0.5 )
                                        , ( "trunk", float 0.5 )
                                        , ( "primary", float 0.5 )
                                        , ( "secondary", float 0.01 )
                                        , ( "tertiary", float 0.01 )
                                        , ( "street", float 0 )
                                        , ( "street_limited", float 0 )
                                        , ( "motorway_link", float 0 )
                                        , ( "service", float 0 )
                                        , ( "track", float 0 )
                                        , ( "link", float 0 )
                                        ]
                                        (float 0)
                              )
                            , ( 12
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 3 )
                                        , ( "trunk", float 3 )
                                        , ( "primary", float 3 )
                                        , ( "secondary", float 2 )
                                        , ( "tertiary", float 2 )
                                        , ( "street", float 0.5 )
                                        , ( "street_limited", float 0.5 )
                                        , ( "motorway_link", float 0.5 )
                                        , ( "service", float 0 )
                                        , ( "track", float 0 )
                                        , ( "link", float 0 )
                                        ]
                                        (float 0)
                              )
                            , ( 18
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 30 )
                                        , ( "trunk", float 30 )
                                        , ( "primary", float 30 )
                                        , ( "secondary", float 24 )
                                        , ( "tertiary", float 24 )
                                        , ( "street", float 12 )
                                        , ( "street_limited", float 12 )
                                        , ( "motorway_link", float 12 )
                                        , ( "service", float 10 )
                                        , ( "track", float 10 )
                                        , ( "link", float 10 )
                                        ]
                                        (float 10)
                              )
                            ]
                    )
                , Layer.lineColor
                    (E.getProperty (str "class")
                        |> E.matchesStr
                            [ ( "street", E.rgba 255 251 244 1 )
                            , ( "street_limited", E.rgba 255 251 244 1 )
                            , ( "service", E.rgba 255 251 244 1 )
                            , ( "track", E.rgba 255 251 244 1 )
                            , ( "link", E.rgba 255 251 244 1 )
                            ]
                            (E.rgba 255 255 255 1)
                    )
                , Layer.lineDasharray (E.floats [ 0.2, 0.2 ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "road"
                "mapbox-streets"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "service:parking_aisle")
                            , E.all
                                [ E.getProperty (str "structure") |> E.notEqual (str "bridge")
                                , E.getProperty (str "structure") |> E.notEqual (str "tunnel")
                                ]
                            , E.any
                                [ E.getProperty (str "class") |> E.isEqual (str "link")
                                , E.getProperty (str "class") |> E.isEqual (str "motorway")
                                , E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                                , E.getProperty (str "class") |> E.isEqual (str "primary")
                                , E.getProperty (str "class") |> E.isEqual (str "secondary")
                                , E.getProperty (str "class") |> E.isEqual (str "service")
                                , E.getProperty (str "class") |> E.isEqual (str "street")
                                , E.getProperty (str "class") |> E.isEqual (str "street_limited")
                                , E.getProperty (str "class") |> E.isEqual (str "tertiary")
                                , E.getProperty (str "class") |> E.isEqual (str "track")
                                , E.getProperty (str "class") |> E.isEqual (str "trunk")
                                ]
                            ]
                        ]
                    )
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate (E.Exponential 1.5)
                            [ ( 5
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 0.5 )
                                        , ( "trunk", float 0.5 )
                                        , ( "primary", float 0.5 )
                                        , ( "secondary", float 0.01 )
                                        , ( "tertiary", float 0.01 )
                                        , ( "street", float 0 )
                                        , ( "street_limited", float 0 )
                                        , ( "motorway_link", float 0 )
                                        , ( "service", float 0 )
                                        , ( "track", float 0 )
                                        , ( "link", float 0 )
                                        ]
                                        (float 0)
                              )
                            , ( 12
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 3 )
                                        , ( "trunk", float 3 )
                                        , ( "primary", float 3 )
                                        , ( "secondary", float 2 )
                                        , ( "tertiary", float 2 )
                                        , ( "street", float 0.5 )
                                        , ( "street_limited", float 0.5 )
                                        , ( "motorway_link", float 0.5 )
                                        , ( "service", float 0 )
                                        , ( "track", float 0 )
                                        , ( "link", float 0 )
                                        ]
                                        (float 0)
                              )
                            , ( 18
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 30 )
                                        , ( "trunk", float 30 )
                                        , ( "primary", float 30 )
                                        , ( "secondary", float 24 )
                                        , ( "tertiary", float 24 )
                                        , ( "street", float 12 )
                                        , ( "street_limited", float 12 )
                                        , ( "motorway_link", float 12 )
                                        , ( "service", float 10 )
                                        , ( "track", float 10 )
                                        , ( "link", float 10 )
                                        ]
                                        (float 10)
                              )
                            ]
                    )
                , Layer.lineColor
                    (E.getProperty (str "class")
                        |> E.matchesStr
                            [ ( "street", E.rgba 255 251 244 1 )
                            , ( "street_limited", E.rgba 255 251 244 1 )
                            , ( "service", E.rgba 255 251 244 1 )
                            , ( "track", E.rgba 255 251 244 1 )
                            , ( "link", E.rgba 255 251 244 1 )
                            ]
                            (E.rgba 255 255 255 1)
                    )
                , Layer.lineJoin E.lineJoinRound
                , Layer.lineCap E.lineCapRound
                ]
            , Layer.line "bridge-case"
                "mapbox-streets"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "service:parking_aisle")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.any
                                [ E.getProperty (str "class") |> E.isEqual (str "link")
                                , E.getProperty (str "class") |> E.isEqual (str "motorway")
                                , E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                                , E.getProperty (str "class") |> E.isEqual (str "primary")
                                , E.getProperty (str "class") |> E.isEqual (str "secondary")
                                , E.getProperty (str "class") |> E.isEqual (str "service")
                                , E.getProperty (str "class") |> E.isEqual (str "street")
                                , E.getProperty (str "class") |> E.isEqual (str "street_limited")
                                , E.getProperty (str "class") |> E.isEqual (str "tertiary")
                                , E.getProperty (str "class") |> E.isEqual (str "track")
                                , E.getProperty (str "class") |> E.isEqual (str "trunk")
                                ]
                            ]
                        ]
                    )
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate (E.Exponential 1.5)
                            [ ( 10, float 1 )
                            , ( 16, float 2 )
                            ]
                    )
                , Layer.lineColor (E.rgba 236 223 202 1)
                , Layer.lineGapWidth
                    (E.zoom
                        |> E.interpolate (E.Exponential 1.5)
                            [ ( 5
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 0.5 )
                                        , ( "trunk", float 0.5 )
                                        , ( "primary", float 0.5 )
                                        , ( "secondary", float 0.01 )
                                        , ( "tertiary", float 0.01 )
                                        , ( "street", float 0 )
                                        , ( "street_limited", float 0 )
                                        , ( "motorway_link", float 0 )
                                        , ( "service", float 0 )
                                        , ( "track", float 0 )
                                        , ( "link", float 0 )
                                        ]
                                        (float 0)
                              )
                            , ( 12
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 3 )
                                        , ( "trunk", float 3 )
                                        , ( "primary", float 3 )
                                        , ( "secondary", float 2 )
                                        , ( "tertiary", float 2 )
                                        , ( "street", float 0.5 )
                                        , ( "street_limited", float 0.5 )
                                        , ( "motorway_link", float 0.5 )
                                        , ( "service", float 0 )
                                        , ( "track", float 0 )
                                        , ( "link", float 0 )
                                        ]
                                        (float 0)
                              )
                            , ( 18
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 30 )
                                        , ( "trunk", float 30 )
                                        , ( "primary", float 30 )
                                        , ( "secondary", float 24 )
                                        , ( "tertiary", float 24 )
                                        , ( "street", float 12 )
                                        , ( "street_limited", float 12 )
                                        , ( "motorway_link", float 12 )
                                        , ( "service", float 10 )
                                        , ( "track", float 10 )
                                        , ( "link", float 10 )
                                        ]
                                        (float 10)
                              )
                            ]
                    )
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.line "bridge"
                "mapbox-streets"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "type") |> E.notEqual (str "service:parking_aisle")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.any
                                [ E.getProperty (str "class") |> E.isEqual (str "link")
                                , E.getProperty (str "class") |> E.isEqual (str "motorway")
                                , E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                                , E.getProperty (str "class") |> E.isEqual (str "primary")
                                , E.getProperty (str "class") |> E.isEqual (str "secondary")
                                , E.getProperty (str "class") |> E.isEqual (str "service")
                                , E.getProperty (str "class") |> E.isEqual (str "street")
                                , E.getProperty (str "class") |> E.isEqual (str "street_limited")
                                , E.getProperty (str "class") |> E.isEqual (str "tertiary")
                                , E.getProperty (str "class") |> E.isEqual (str "track")
                                , E.getProperty (str "class") |> E.isEqual (str "trunk")
                                ]
                            ]
                        ]
                    )
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate (E.Exponential 1.5)
                            [ ( 5
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 0.5 )
                                        , ( "trunk", float 0.5 )
                                        , ( "primary", float 0.5 )
                                        , ( "secondary", float 0.01 )
                                        , ( "tertiary", float 0.01 )
                                        , ( "street", float 0 )
                                        , ( "street_limited", float 0 )
                                        , ( "motorway_link", float 0 )
                                        , ( "service", float 0 )
                                        , ( "track", float 0 )
                                        , ( "link", float 0 )
                                        ]
                                        (float 0)
                              )
                            , ( 12
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 3 )
                                        , ( "trunk", float 3 )
                                        , ( "primary", float 3 )
                                        , ( "secondary", float 2 )
                                        , ( "tertiary", float 2 )
                                        , ( "street", float 0.5 )
                                        , ( "street_limited", float 0.5 )
                                        , ( "motorway_link", float 0.5 )
                                        , ( "service", float 0 )
                                        , ( "track", float 0 )
                                        , ( "link", float 0 )
                                        ]
                                        (float 0)
                              )
                            , ( 18
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 30 )
                                        , ( "trunk", float 30 )
                                        , ( "primary", float 30 )
                                        , ( "secondary", float 24 )
                                        , ( "tertiary", float 24 )
                                        , ( "street", float 12 )
                                        , ( "street_limited", float 12 )
                                        , ( "motorway_link", float 12 )
                                        , ( "service", float 10 )
                                        , ( "track", float 10 )
                                        , ( "link", float 10 )
                                        ]
                                        (float 10)
                              )
                            ]
                    )
                , Layer.lineColor
                    (E.getProperty (str "class")
                        |> E.matchesStr
                            [ ( "street", E.rgba 255 251 244 1 )
                            , ( "street_limited", E.rgba 255 251 244 1 )
                            , ( "service", E.rgba 255 251 244 1 )
                            , ( "track", E.rgba 255 251 244 1 )
                            , ( "link", E.rgba 255 251 244 1 )
                            ]
                            (E.rgba 255 255 255 1)
                    )
                , Layer.lineJoin E.lineJoinRound
                , Layer.lineCap E.lineCapRound
                ]
            , Layer.line "admin-state-province"
                "mapbox-streets"
                [ Layer.minzoom 2
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "maritime") |> E.isEqual (float 0)
                        , E.getProperty (str "admin_level") |> E.greaterThanOrEqual (float 3)
                        ]
                    )
                , Layer.sourceLayer "admin"
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step
                            (E.floats
                                [ 2
                                , 0
                                ]
                            )
                            [ ( 7
                              , E.floats
                                    [ 2
                                    , 2
                                    , 6
                                    , 2
                                    ]
                              )
                            ]
                    )
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 7, float 0.75 )
                            , ( 12, float 1.5 )
                            ]
                    )
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 2, float 0 )
                            , ( 3, float 1 )
                            ]
                    )
                , Layer.lineColor (E.zoom |> E.step (E.rgba 204 204 204 1) [ ( 4, E.rgba 165 165 165 1 ) ])
                , Layer.lineJoin E.lineJoinRound
                , Layer.lineCap E.lineCapRound
                ]
            , Layer.line "admin-country"
                "mapbox-streets"
                [ Layer.minzoom 1
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.lessThanOrEqual (float 2)
                        , E.getProperty (str "disputed") |> E.isEqual (float 0)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.sourceLayer "admin"
                , Layer.lineColor (E.rgba 127 127 127 1)
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 3, float 0.5 )
                            , ( 10, float 2 )
                            ]
                    )
                , Layer.lineJoin E.lineJoinRound
                , Layer.lineCap E.lineCapRound
                ]
            , Layer.line "admin-country-disputed"
                "mapbox-streets"
                [ Layer.minzoom 1
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.lessThanOrEqual (float 2)
                        , E.getProperty (str "disputed") |> E.isEqual (float 1)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.sourceLayer "admin"
                , Layer.lineColor (E.rgba 127 127 127 1)
                , Layer.lineWidth
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 3, float 0.5 )
                            , ( 10, float 2 )
                            ]
                    )
                , Layer.lineDasharray (E.floats [ 1.5, 1.5 ])
                , Layer.lineJoin E.lineJoinRound
                ]
            , Layer.symbol "road-label"
                "mapbox-streets"
                [ Layer.minzoom 12
                , Layer.filter
                    (E.any
                        [ E.getProperty (str "class") |> E.isEqual (str "link")
                        , E.getProperty (str "class") |> E.isEqual (str "motorway")
                        , E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                        , E.getProperty (str "class") |> E.isEqual (str "primary")
                        , E.getProperty (str "class") |> E.isEqual (str "secondary")
                        , E.getProperty (str "class") |> E.isEqual (str "street")
                        , E.getProperty (str "class") |> E.isEqual (str "street_limited")
                        , E.getProperty (str "class") |> E.isEqual (str "tertiary")
                        , E.getProperty (str "class") |> E.isEqual (str "trunk")
                        ]
                    )
                , Layer.sourceLayer "road_label"
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textSize
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 9
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 10 )
                                        , ( "trunk", float 10 )
                                        , ( "primary", float 10 )
                                        , ( "secondary", float 10 )
                                        , ( "tertiary", float 10 )
                                        ]
                                        (float 9)
                              )
                            , ( 20
                              , E.getProperty (str "class")
                                    |> E.matchesStr
                                        [ ( "motorway", float 15 )
                                        , ( "trunk", float 15 )
                                        , ( "primary", float 15 )
                                        , ( "secondary", float 15 )
                                        , ( "tertiary", float 15 )
                                        ]
                                        (float 14)
                              )
                            ]
                    )
                , Layer.textMaxAngle (float 30)
                , Layer.textFont
                    (E.strings
                        [ "Roboto Regular"
                        , "Arial Unicode MS Regular"
                        ]
                    )
                , Layer.symbolPlacement E.symbolPlacementLine
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.anchorMap
                , Layer.textPitchAlignment E.anchorViewport
                , Layer.textField (E.getProperty (str "name_en"))
                ]
            , Layer.symbol "poi-label"
                "mapbox-streets"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter (E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 3))
                , Layer.textColor (E.rgba 88 77 59 1)
                , Layer.textHaloColor (E.rgba 255 255 255 0.75)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 10, float 11 )
                            , ( 18, float 13 )
                            ]
                    )
                , Layer.iconImage (E.getProperty (str "maki") |> E.append (str "-11"))
                , Layer.textMaxAngle (float 38)
                , Layer.textFont
                    (E.strings
                        [ "Roboto Regular"
                        , "Arial Unicode MS Regular"
                        ]
                    )
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0.75 ])
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.getProperty (str "name_en"))
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "airport-label"
                "mapbox-streets"
                [ Layer.sourceLayer "airport_label"
                , Layer.filter (E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 2))
                , Layer.textColor (E.rgba 88 77 59 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 10, float 12 )
                            , ( 18, float 18 )
                            ]
                    )
                , Layer.iconImage
                    (E.zoom
                        |> E.step (E.getProperty (str "maki") |> E.append (str "-11"))
                            [ ( 13, E.getProperty (str "maki") |> E.append (str "-15") ) ]
                    )
                , Layer.textFont
                    (E.strings
                        [ "Roboto Regular"
                        , "Arial Unicode MS Regular"
                        ]
                    )
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0.75 ])
                , Layer.textAnchor E.positionTop
                , Layer.textField (E.zoom |> E.step (E.getProperty (str "ref")) [ ( 14, E.getProperty (str "name_en") ) ])
                , Layer.textMaxWidth (float 9)
                ]
            , Layer.symbol "place-neighborhood-suburb-label"
                "mapbox-streets"
                [ Layer.minzoom 12
                , Layer.maxzoom 15
                , Layer.filter
                    (E.any
                        [ E.getProperty (str "type") |> E.isEqual (str "neighbourhood")
                        , E.getProperty (str "type") |> E.isEqual (str "suburb")
                        ]
                    )
                , Layer.sourceLayer "place_label"
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textColor (E.rgba 86 62 20 1)
                , Layer.textField (E.getProperty (str "name_en"))
                , Layer.textTransform E.textTransformUppercase
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textMaxWidth (float 8)
                , Layer.textFont
                    (E.strings
                        [ "Roboto Regular"
                        , "Arial Unicode MS Regular"
                        ]
                    )
                , Layer.textPadding (float 3)
                , Layer.textSize
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 12, float 11 )
                            , ( 16, float 16 )
                            ]
                    )
                ]
            , Layer.symbol "place-town-village-hamlet-label"
                "mapbox-streets"
                [ Layer.minzoom 6
                , Layer.maxzoom 14
                , Layer.filter
                    (E.any
                        [ E.getProperty (str "type") |> E.isEqual (str "hamlet")
                        , E.getProperty (str "type") |> E.isEqual (str "town")
                        , E.getProperty (str "type") |> E.isEqual (str "village")
                        ]
                    )
                , Layer.sourceLayer "place_label"
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textSize
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 5, E.getProperty (str "type") |> E.matchesStr [ ( "town", float 9.5 ) ] (float 8) )
                            , ( 16, E.getProperty (str "type") |> E.matchesStr [ ( "town", float 20 ) ] (float 16) )
                            ]
                    )
                , Layer.textFont
                    (E.zoom
                        |> E.step
                            (E.strings
                                [ "Roboto Regular"
                                , "Arial Unicode MS Regular"
                                ]
                            )
                            [ ( 12
                              , E.getProperty (str "type")
                                    |> E.matchesStr
                                        [ ( "town"
                                          , E.strings
                                                [ "Roboto Medium"
                                                , "Arial Unicode MS Regular"
                                                ]
                                          )
                                        ]
                                        (E.strings
                                            [ "Roboto Regular"
                                            , "Arial Unicode MS Regular"
                                            ]
                                        )
                              )
                            ]
                    )
                , Layer.textMaxWidth (float 7)
                , Layer.textField (E.getProperty (str "name_en"))
                ]
            , Layer.symbol "place-city-label-minor"
                "mapbox-streets"
                [ Layer.minzoom 1
                , Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.not (E.hasProperty (str "scalerank"))
                        , E.getProperty (str "type") |> E.isEqual (str "city")
                        ]
                    )
                , Layer.sourceLayer "place_label"
                , Layer.textColor
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 5, E.rgba 84 84 84 1 )
                            , ( 6, E.rgba 0 0 0 1 )
                            ]
                    )
                , Layer.textHaloBlur (float 0.5)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.textSize
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 5, float 12 )
                            , ( 16, float 22 )
                            ]
                    )
                , Layer.textFont
                    (E.strings
                        [ "Roboto Medium"
                        , "Arial Unicode MS Regular"
                        ]
                    )
                , Layer.textMaxWidth (float 10)
                , Layer.textField (E.getProperty (str "name_en"))
                ]
            , Layer.symbol "place-city-label-major"
                "mapbox-streets"
                [ Layer.minzoom 1
                , Layer.maxzoom 14
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "type") |> E.isEqual (str "city")
                        , E.hasProperty (str "scalerank")
                        ]
                    )
                , Layer.sourceLayer "place_label"
                , Layer.textColor
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 5, E.rgba 84 84 84 1 )
                            , ( 6, E.rgba 0 0 0 1 )
                            ]
                    )
                , Layer.textHaloBlur (float 0.5)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.textSize
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 5, E.getProperty (str "scalerank") |> E.step (float 14) [ ( 4, float 12 ) ] )
                            , ( 16, E.getProperty (str "scalerank") |> E.step (float 30) [ ( 4, float 22 ) ] )
                            ]
                    )
                , Layer.textFont
                    (E.zoom
                        |> E.step
                            (E.strings
                                [ "Roboto Medium"
                                , "Arial Unicode MS Regular"
                                ]
                            )
                            [ ( 10
                              , E.getProperty (str "scalerank")
                                    |> E.step
                                        (E.strings
                                            [ "Roboto Bold"
                                            , "Arial Unicode MS Bold"
                                            ]
                                        )
                                        [ ( 5
                                          , E.strings
                                                [ "Roboto Medium"
                                                , "Arial Unicode MS Regular"
                                                ]
                                          )
                                        ]
                              )
                            ]
                    )
                , Layer.textMaxWidth (float 10)
                , Layer.textField (E.getProperty (str "name_en"))
                ]
            , Layer.symbol "state-label"
                "mapbox-streets"
                [ Layer.sourceLayer "state_label"
                , Layer.minzoom 4
                , Layer.maxzoom 8
                , Layer.textColor (E.rgba 169 164 156 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textLineHeight (float 1.2)
                , Layer.textSize
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 4
                              , E.getProperty (str "area")
                                    |> E.step (float 8)
                                        [ ( 20000, float 9 )
                                        , ( 80000, float 10 )
                                        ]
                              )
                            , ( 9
                              , E.getProperty (str "area")
                                    |> E.step (float 14)
                                        [ ( 20000, float 18 )
                                        , ( 80000, float 23 )
                                        ]
                              )
                            ]
                    )
                , Layer.textTransform E.textTransformUppercase
                , Layer.textFont
                    (E.strings
                        [ "Roboto Black"
                        , "Arial Unicode MS Bold"
                        ]
                    )
                , Layer.textPadding (float 1)
                , Layer.textField (E.zoom |> E.step (E.getProperty (str "area") |> E.step (E.getProperty (str "abbr")) [ ( 80000, E.getProperty (str "name_en") ) ]) [ ( 5, E.getProperty (str "name_en") ) ])
                , Layer.textLetterSpacing (float 0.2)
                , Layer.textMaxWidth (float 6)
                ]
            , Layer.symbol "country-label"
                "mapbox-streets"
                [ Layer.sourceLayer "country_label"
                , Layer.minzoom 1
                , Layer.maxzoom 8
                , Layer.textHaloWidth (float 1.5)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textField (E.getProperty (str "name_en"))
                , Layer.textMaxWidth
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 0, float 5 )
                            , ( 3, float 6 )
                            ]
                    )
                , Layer.textFont
                    (E.zoom
                        |> E.step
                            (E.strings
                                [ "Roboto Medium"
                                , "Arial Unicode MS Regular"
                                ]
                            )
                            [ ( 4
                              , E.strings
                                    [ "Roboto Bold"
                                    , "Arial Unicode MS Bold"
                                    ]
                              )
                            ]
                    )
                , Layer.textSize
                    (E.zoom
                        |> E.interpolate E.Linear
                            [ ( 2
                              , E.getProperty (str "scalerank")
                                    |> E.step (float 13)
                                        [ ( 3, float 11 )
                                        , ( 5, float 9 )
                                        ]
                              )
                            , ( 9
                              , E.getProperty (str "scalerank")
                                    |> E.step (float 35)
                                        [ ( 3, float 27 )
                                        , ( 5, float 22 )
                                        ]
                              )
                            ]
                    )
                ]
            ]
        , sources = [ Source.vectorFromUrl "mapbox-streets" "mapbox://mapbox.mapbox-streets-v7" ]
        , misc =
            [ Style.glyphs "mapbox://fonts/mapbox/{fontstack}/{range}.pbf"
            , Style.sprite "mapbox://sprites/astrosat/cjlnn5red6a2o2sqtzzyg7prr"
            ]
        }
