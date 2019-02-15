module Styles.Outdoors exposing (style)

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
            [ Layer.background "background"
                [ Layer.backgroundColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, E.rgba 239 233 224 1 ), ( 13, E.rgba 230 227 223 1 ) ])
                ]
            , Layer.fill "landcover_crop"
                "composite"
                [ Layer.sourceLayer "landcover"
                , Layer.maxzoom 12
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "crop"))
                , Layer.fillColor (E.rgba 221 236 176 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 2, float 0.3 ), ( 12, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "landcover_grass"
                "composite"
                [ Layer.sourceLayer "landcover"
                , Layer.maxzoom 12
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "grass"))
                , Layer.fillColor (E.rgba 221 236 176 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 2, float 0.3 ), ( 12, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "landcover_scrub"
                "composite"
                [ Layer.sourceLayer "landcover"
                , Layer.maxzoom 12
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "scrub"))
                , Layer.fillColor (E.rgba 221 236 176 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 2, float 0.3 ), ( 12, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "landcover_wood"
                "composite"
                [ Layer.sourceLayer "landcover"
                , Layer.maxzoom 12
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "wood"))
                , Layer.fillColor (E.rgba 221 236 176 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 2, float 0.3 ), ( 12, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "landcover_snow"
                "composite"
                [ Layer.sourceLayer "landcover"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (E.rgba 255 250 250 1))
                , Layer.fillColor (E.rgba 255 255 255 1)
                , Layer.fillOpacity (float 0.2)
                , Layer.fillAntialias false
                ]
            , Layer.fill "national_park"
                "composite"
                [ Layer.sourceLayer "landuse_overlay"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "national_park"))
                , Layer.fillColor (E.rgba 181 229 157 1)
                , Layer.fillOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 5, float 0 ), ( 5.5, float 0.75 ), ( 9, float 0.75 ), ( 10, float 0.35 ) ]
                    )
                ]
            , Layer.fill "scrub"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.minzoom 9
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "scrub"))
                , Layer.fillColor (E.rgba 202 215 161 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, float 0 ), ( 15, float 0.2 ) ])
                ]
            , Layer.fill "grass"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.minzoom 9
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "grass"))
                , Layer.fillColor (E.rgba 202 215 161 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, float 0 ), ( 15, float 0.4 ) ])
                ]
            , Layer.fill "wood"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.minzoom 6
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "wood"))
                , Layer.fillColor (E.rgba 202 215 161 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 0 ), ( 15, float 0.5 ) ])
                ]
            , Layer.fill "agriculture"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.minzoom 11
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "agriculture"))
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 0 ), ( 14, float 0.75 ) ])
                , Layer.fillColor (E.rgba 215 224 188 1)
                , Layer.fillOutlineColor (E.rgba 186 199 147 1)
                ]
            , Layer.line "national_park-tint-band"
                "composite"
                [ Layer.sourceLayer "landuse_overlay"
                , Layer.minzoom 9
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "national_park"))
                , Layer.lineColor (E.rgba 174 229 147 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.4) [ ( 9, float 1 ), ( 14, float 8 ) ])
                , Layer.lineOffset (E.zoom |> E.interpolate (E.Exponential 1.4) [ ( 9, float 0 ), ( 14, float -2.5 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, float 0 ), ( 10, float 0.75 ) ])
                , Layer.lineBlur (float 3)
                , Layer.lineCap E.rounded
                ]
            , Layer.line "national_park-outline"
                "composite"
                [ Layer.sourceLayer "landuse_overlay"
                , Layer.minzoom 9
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "national_park"))
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, E.rgba 168 217 144 1 ), ( 14, E.rgba 159 204 137 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, float 0.75 ), ( 12, float 1 ) ])
                , Layer.lineOffset (float 0)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, float 0 ), ( 10, float 1 ) ])
                ]
            , Layer.fill "hospital"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "hospital"))
                , Layer.fillColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 15.5, E.rgba 234 209 217 1 ), ( 16, E.rgba 244 209 221 1 ) ]
                    )
                ]
            , Layer.fill "school"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "school"))
                , Layer.fillColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 15.5, E.rgba 229 221 183 1 ), ( 16, E.rgba 239 231 188 1 ) ]
                    )
                ]
            , Layer.fill "park"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "class") |> E.isEqual (str "park")
                        , E.getProperty (str "type")
                            |> E.matchesStr [ ( "garden", false ), ( "golf_course", false ), ( "playground", false ), ( "zoo", false ) ] true
                        ]
                    )
                , Layer.fillColor (E.rgba 181 229 157 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, float 0 ), ( 6, float 1 ) ])
                ]
            , Layer.fill "other-green-areas"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "class") |> E.isEqual (str "park")
                        , E.getProperty (str "type")
                            |> E.matchesStr [ ( "garden", true ), ( "golf_course", true ), ( "playground", true ), ( "zoo", true ) ] false
                        ]
                    )
                , Layer.fillColor (E.rgba 197 235 177 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, float 0 ), ( 6, float 1 ) ])
                ]
            , Layer.fill "glacier"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.minzoom 9
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "glacier"))
                , Layer.fillColor (E.rgba 224 243 249 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, float 0 ), ( 10, float 0.5 ) ])
                ]
            , Layer.fill "pitch"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "pitch"))
                , Layer.fillColor (E.rgba 170 224 142 1)
                ]
            , Layer.line "pitch-line"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.minzoom 15
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "pitch"))
                , Layer.lineColor (E.rgba 225 237 190 1)
                , Layer.lineJoin E.miter
                ]
            , Layer.fill "cemetery"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "cemetery"))
                , Layer.fillColor (E.rgba 215 224 188 1)
                ]
            , Layer.fill "industrial"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "industrial"))
                , Layer.fillColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 15.5, E.rgba 213 215 224 1 ), ( 16, E.rgba 218 221 235 1 ) ]
                    )
                ]
            , Layer.fill "sand"
                "composite"
                [ Layer.sourceLayer "landuse"
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "sand"))
                , Layer.fillColor (E.rgba 237 237 206 1)
                ]
            , Layer.line "contour-line"
                "composite"
                [ Layer.sourceLayer "contour"
                , Layer.minzoom 11
                , Layer.filter (E.getProperty (str "index") |> E.matchesFloat [ ( 5, false ), ( 10, false ) ] true)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 0.15 ), ( 12, float 0.3 ) ])
                , Layer.lineColor (E.rgba 33 102 0 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0.5 ), ( 16, float 0.8 ) ])
                , Layer.lineOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 1 ), ( 16, float 1.6 ) ])
                ]
            , Layer.line "contour-line-index"
                "composite"
                [ Layer.sourceLayer "contour"
                , Layer.minzoom 11
                , Layer.filter (E.getProperty (str "index") |> E.matchesFloat [ ( 5, true ), ( 10, true ) ] false)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 0.25 ), ( 12, float 0.5 ) ])
                , Layer.lineColor (E.rgba 33 102 0 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0.6 ), ( 16, float 1.2 ) ])
                , Layer.lineOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0.6 ), ( 16, float 1.2 ) ])
                ]
            , Layer.fill "hillshade_highlight_bright"
                "composite"
                [ Layer.sourceLayer "hillshade"
                , Layer.maxzoom 18
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 94))
                , Layer.fillColor (E.rgba 255 255 255 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 0.15 ), ( 18, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "hillshade_highlight_med"
                "composite"
                [ Layer.sourceLayer "hillshade"
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 90))
                , Layer.fillColor (E.rgba 255 255 255 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 0.15 ), ( 18, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "hillshade_shadow_faint"
                "composite"
                [ Layer.sourceLayer "hillshade"
                , Layer.maxzoom 17
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 89))
                , Layer.fillColor (E.rgba 89 84 23 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 0.07 ), ( 17, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "hillshade_shadow_med"
                "composite"
                [ Layer.sourceLayer "hillshade"
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 78))
                , Layer.fillColor (E.rgba 89 84 23 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 0.07 ), ( 17, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "hillshade_shadow_dark"
                "composite"
                [ Layer.sourceLayer "hillshade"
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 67))
                , Layer.fillColor (E.rgba 89 84 23 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 0.08 ), ( 17, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.fill "hillshade_shadow_extreme"
                "composite"
                [ Layer.sourceLayer "hillshade"
                , Layer.maxzoom 17
                , Layer.filter (E.getProperty (str "level") |> E.isEqual (float 56))
                , Layer.fillColor (E.rgba 89 84 23 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 0.08 ), ( 17, float 0 ) ])
                , Layer.fillAntialias false
                ]
            , Layer.line "waterway-river-canal-shadow"
                "composite"
                [ Layer.sourceLayer "waterway"
                , Layer.minzoom 8
                , Layer.filter (E.getProperty (str "class") |> E.matchesStr [ ( "canal", true ), ( "river", true ) ] false)
                , Layer.lineColor (E.rgba 109 164 242 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.3) [ ( 8.5, float 0.4 ), ( 20, float 8 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, float 0 ), ( 8.5, float 1 ) ])
                , Layer.lineTranslate (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 7, E.floats [ 0, 0 ] ), ( 16, E.floats [ -1, -1 ] ) ])
                , Layer.lineTranslateAnchor E.viewport
                , Layer.lineCap (E.zoom |> E.step E.butt [ ( 11, E.rounded ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "waterway-river-canal"
                "composite"
                [ Layer.sourceLayer "waterway"
                , Layer.minzoom 8
                , Layer.filter (E.getProperty (str "class") |> E.matchesStr [ ( "canal", true ), ( "river", true ) ] false)
                , Layer.lineColor (E.rgba 140 202 247 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.3) [ ( 8.5, float 0.4 ), ( 20, float 8 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, float 0 ), ( 8.5, float 1 ) ])
                , Layer.lineCap (E.zoom |> E.step E.butt [ ( 11, E.rounded ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "waterway-small"
                "composite"
                [ Layer.sourceLayer "waterway"
                , Layer.minzoom 13
                , Layer.filter (E.getProperty (str "class") |> E.matchesStr [ ( "canal", false ), ( "river", false ) ] true)
                , Layer.lineColor (E.rgba 140 202 247 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.35) [ ( 13.5, float 0.4 ), ( 20, float 3 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.5, float 1 ) ])
                , Layer.lineJoin E.rounded
                , Layer.lineCap E.rounded
                ]
            , Layer.fill "water-shadow"
                "composite"
                [ Layer.sourceLayer "water"
                , Layer.fillColor (E.rgba 109 164 242 1)
                , Layer.fillTranslate (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 7, E.floats [ 0, 0 ] ), ( 16, E.floats [ -1, -1 ] ) ])
                , Layer.fillTranslateAnchor E.viewport
                , Layer.fillOpacity (float 1)
                ]
            , Layer.fill "water" "composite" [ Layer.sourceLayer "water", Layer.fillColor (E.rgba 117 207 239 1) ]
            , Layer.fill "wetlands"
                "composite"
                [ Layer.sourceLayer "landuse_overlay"
                , Layer.filter (E.getProperty (str "class") |> E.matchesStr [ ( "wetland", true ), ( "wetland_noveg", true ) ] false)
                , Layer.fillColor (E.rgba 160 212 217 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 0.25 ), ( 10.5, float 0.15 ) ])
                ]
            , Layer.fill "wetlands-pattern"
                "composite"
                [ Layer.sourceLayer "landuse_overlay"
                , Layer.filter (E.getProperty (str "class") |> E.matchesStr [ ( "wetland", true ), ( "wetland_noveg", true ) ] false)
                , Layer.fillColor (E.rgba 160 212 217 1)
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 0 ), ( 10.5, float 1 ) ])
                , Layer.fillPattern (str "wetland")
                , Layer.fillTranslateAnchor E.viewport
                ]
            , Layer.fill "barrier_line-land-polygon"
                "composite"
                [ Layer.sourceLayer "barrier_line"
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "Polygon"), E.getProperty (str "class") |> E.isEqual (str "land") ])
                , Layer.fillColor (E.rgba 230 227 223 1)
                ]
            , Layer.line "barrier_line-land-line"
                "composite"
                [ Layer.sourceLayer "barrier_line"
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "LineString"), E.getProperty (str "class") |> E.isEqual (str "land") ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.99) [ ( 14, float 0.75 ), ( 20, float 40 ) ])
                , Layer.lineColor (E.rgba 230 227 223 1)
                , Layer.lineCap E.rounded
                ]
            , Layer.fill "aeroway-polygon"
                "composite"
                [ Layer.sourceLayer "aeroway"
                , Layer.minzoom 11
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "Polygon"), E.getProperty (str "type") |> E.notEqual (str "apron") ])
                , Layer.fillColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, E.rgba 198 202 219 1 ), ( 16, E.rgba 199 204 229 1 ) ])
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 0 ), ( 11.5, float 1 ) ])
                ]
            , Layer.line "aeroway-runway"
                "composite"
                [ Layer.sourceLayer "aeroway"
                , Layer.minzoom 9
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "LineString"), E.getProperty (str "type") |> E.isEqual (str "runway") ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, E.rgba 198 202 219 1 ), ( 16, E.rgba 199 204 229 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 9, float 1 ), ( 18, float 80 ) ])
                ]
            , Layer.line "aeroway-taxiway"
                "composite"
                [ Layer.sourceLayer "aeroway"
                , Layer.minzoom 9
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "type") |> E.isEqual (str "taxiway")
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, E.rgba 198 202 219 1 ), ( 16, E.rgba 199 204 229 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10, float 0.5 ), ( 18, float 20 ) ])
                ]
            , Layer.line "building-line"
                "composite"
                [ Layer.sourceLayer "building"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "type") |> E.notEqual (str "building:part")
                        , E.getProperty (str "underground") |> E.isEqual (str "false")
                        ]
                    )
                , Layer.lineColor (E.rgba 204 201 198 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 0.75 ), ( 20, float 3 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15.5, float 0 ), ( 16, float 1 ) ])
                ]
            , Layer.fill "building"
                "composite"
                [ Layer.sourceLayer "building"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "type") |> E.notEqual (str "building:part")
                        , E.getProperty (str "underground") |> E.isEqual (str "false")
                        ]
                    )
                , Layer.fillColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, E.rgba 227 224 221 1 ), ( 16, E.rgba 219 217 213 1 ) ])
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15.5, float 0 ), ( 16, float 1 ) ])
                , Layer.fillOutlineColor (E.rgba 204 201 198 1)
                ]
            , Layer.line "tunnel-street-low"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11.5, float 0 ), ( 12, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-street_limited-low"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11.5, float 0 ), ( 12, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-track-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "track")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 204 170 0 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 12 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-service-link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "link", true ), ( "service", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 179 183 203 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-street_limited-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 179 183 203 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-street-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 179 183 203 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-secondary-tertiary-case"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 10, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineColor (E.rgba 179 183 203 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineColor (E.rgba 179 183 203 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-trunk_link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-motorway_link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 3, 3 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-construction"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "construction")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
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
                , Layer.lineJoin E.miter
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
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "cycleway", false ), ( "piste", false ), ( "steps", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 4, 0.4 ]) [ ( 15, E.floats [ 3, 0.4 ] ), ( 16, E.floats [ 3, 0.35 ] ), ( 17, E.floats [ 3, 0.35 ] ) ]
                    )
                , Layer.lineColor (E.rgba 245 242 238 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-cycleway-piste"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.matchesStr [ ( "cycleway", true ), ( "piste", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 4, 0.4 ]) [ ( 15, E.floats [ 3, 0.4 ] ), ( 16, E.floats [ 3, 0.35 ] ), ( 17, E.floats [ 3, 0.35 ] ) ]
                    )
                , Layer.lineColor (E.rgba 245 242 238 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 16, float 1.6 ), ( 18, float 6 ) ])
                , Layer.lineColor (E.rgba 245 242 238 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 4, 0.4 ]) [ ( 15, E.floats [ 1.75, 0.4 ] ), ( 16, E.floats [ 0.75, 0.4 ] ), ( 17, E.floats [ 0.3, 0.3 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-trunk_link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.isEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 242 221 155 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-motorway_link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "motorway_link")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 242 201 170 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-pedestrian"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.5, 0.4 ] ), ( 16, E.floats [ 1, 0.2 ] ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-track"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "track")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-service-link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "link", true ), ( "service", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-street_limited"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 239 237 234 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "tunnel-street"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.symbol "tunnel-oneway-arrows-blue-minor"
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
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.symbolPlacement E.line
                , Layer.iconImage (E.zoom |> E.step (str "oneway-small") [ ( 18, str "oneway-large" ) ])
                , Layer.symbolSpacing (float 200)
                , Layer.iconPadding (float 2)
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
                , Layer.symbolPlacement E.line
                , Layer.iconImage (E.zoom |> E.step (str "oneway-small") [ ( 17, str "oneway-large" ) ])
                , Layer.symbolSpacing (float 200)
                , Layer.iconPadding (float 2)
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
                , Layer.lineColor (E.rgba 242 221 155 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineOpacity (float 1)
                , Layer.lineColor (E.rgba 242 201 170 1)
                , Layer.lineBlur (float 0)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.symbol "tunnel-oneway-arrows-white"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 16
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "link", true ), ( "trunk", true ) ] false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.isEqual (str "tunnel")
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "primary_link", false ), ( "secondary_link", false ), ( "tertiary_link", false ) ] true
                            ]
                        ]
                    )
                , Layer.iconOpacity (float 0.5)
                , Layer.symbolPlacement E.line
                , Layer.iconImage (E.zoom |> E.step (str "oneway-white-small") [ ( 17, str "oneway-white-large" ) ])
                , Layer.symbolSpacing (float 200)
                , Layer.iconPadding (float 2)
                ]
            , Layer.line "cliffs"
                "composite"
                [ Layer.sourceLayer "barrier_line"
                , Layer.minzoom 15
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "cliff"))
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 0 ), ( 15.25, float 1 ) ])
                , Layer.lineWidth (float 10)
                , Layer.linePattern (str "cliff")
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "ferry"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "LineString"), E.getProperty (str "type") |> E.isEqual (str "ferry") ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, E.rgba 91 172 229 1 ), ( 17, E.rgba 91 114 229 1 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 20, float 1 ) ])
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 1, 0 ]) [ ( 13, E.floats [ 12, 4 ] ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "ferry-auto"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "type") |> E.isEqual (str "ferry_auto")
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, E.rgba 91 172 229 1 ), ( 17, E.rgba 91 114 229 1 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 20, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-path-bg"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "corridor", false ), ( "crossing", false ), ( "piste", false ), ( "sidewalk", false ), ( "steps", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 2.5 ), ( 18, float 8 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineColor (E.rgba 204 170 0 1)
                , Layer.lineBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0 ), ( 17, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-piste-bg"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.isEqual (str "piste")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 2 ), ( 18, float 7 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineColor (E.rgba 99 123 242 1)
                , Layer.lineBlur (float 0)
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-sidewalk-corridor-bg"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 16
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "corridor", true ), ( "crossing", true ), ( "sidewalk", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 2 ), ( 18, float 7 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineColor (E.rgba 201 203 216 1)
                , Layer.lineBlur (float 0)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 0 ), ( 16.25, float 0.25 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-steps-bg"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 2.5 ), ( 18, float 8 ) ])
                , Layer.lineColor (E.rgba 204 170 0 1)
                , Layer.lineBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0 ), ( 17, float 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 0.25 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-pedestrian-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 12
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 2 ), ( 18, float 14.5 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (float 0)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-street-low"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11, float 0 ), ( 11.25, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-street_limited-low"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11, float 0 ), ( 11.25, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-track-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "track")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 204 170 0 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 12 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-service-link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "link", true ), ( "service", true ) ] false
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-street_limited-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street_limited")
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-street-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "street")
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-secondary-tertiary-case"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 10, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9.99, float 0 ), ( 10, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-primary-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "primary")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9.99, float 0 ), ( 10, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10.99, float 0 ), ( 11, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10.99, float 0 ), ( 11, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10, float 1 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 6, float 0 ), ( 6.1, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10, float 1 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-construction"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "construction")
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
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
                , Layer.lineJoin E.miter
                ]
            , Layer.line "road-sidewalk-corridor"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 16
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "corridor", true ), ( "crossing", true ), ( "sidewalk", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 4, 0.4 ]) [ ( 15, E.floats [ 3, 0.4 ] ), ( 16, E.floats [ 3, 0.35 ] ), ( 17, E.floats [ 3, 0.35 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 0 ), ( 16.25, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-path-smooth"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "bridleway", true ), ( "footway", true ), ( "path", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 4, 0.4 ]) [ ( 15, E.floats [ 3, 0.4 ] ), ( 16, E.floats [ 3, 0.35 ] ), ( 17, E.floats [ 3, 0.35 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-path-rough"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "hiking", true ), ( "mountain_bike", true ), ( "trail", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 4, 0.4 ]) [ ( 15, E.floats [ 1.75, 0.4 ] ), ( 16, E.floats [ 1, 0.4 ] ), ( 17, E.floats [ 1, 0.35 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-cycleway-piste"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.matchesStr [ ( "cycleway", true ), ( "piste", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 16, float 1.6 ), ( 18, float 6 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 4, 0.4 ]) [ ( 15, E.floats [ 1.75, 0.4 ] ), ( 16, E.floats [ 0.75, 0.4 ] ), ( 17, E.floats [ 0.3, 0.3 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 229 203 117 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 229 171 127 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.5, 0.4 ] ), ( 16, E.floats [ 1, 0.2 ] ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.fill "road-pedestrian-polygon-fill"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 12
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "Polygon")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "path", true ), ( "pedestrian", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.fillColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 16, E.rgba 237 238 242 1 ), ( 16.25, E.rgba 247 248 252 1 ) ]
                    )
                , Layer.fillOutlineColor (E.rgba 216 219 232 1)
                , Layer.fillOpacity (float 1)
                ]
            , Layer.fill "road-pedestrian-polygon-pattern"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 12
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "Polygon")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "path", true ), ( "pedestrian", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.fillColor (E.rgba 255 255 255 1)
                , Layer.fillOutlineColor (E.rgba 215 212 207 1)
                , Layer.fillPattern (str "pedestrian-polygon")
                , Layer.fillOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 0 ), ( 16.25, float 1 ) ])
                ]
            , Layer.fill "road-polygon"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 12
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "Polygon")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr [ ( "motorway", false ), ( "path", false ), ( "pedestrian", false ), ( "trunk", false ) ] true
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.fillColor (E.rgba 255 255 255 1)
                , Layer.fillOutlineColor (E.rgba 179 183 203 1)
                ]
            , Layer.line "road-track"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "track")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-service-link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "link", true ), ( "service", true ) ] false
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 239 237 234 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                            , E.getProperty (str "structure") |> E.isEqual E.none
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, E.rgba 239 233 224 1 ), ( 8, E.rgba 255 255 255 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 5, float 0 ), ( 5.5, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-primary"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "primary")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, E.rgba 239 233 224 1 ), ( 8, E.rgba 255 255 255 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 5, float 0 ), ( 5.5, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.symbolPlacement E.line
                , Layer.iconImage (E.zoom |> E.step (str "oneway-small") [ ( 18, str "oneway-large" ) ])
                , Layer.iconRotationAlignment E.map
                , Layer.iconPadding (float 2)
                , Layer.symbolSpacing (float 200)
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
                , Layer.symbolPlacement E.line
                , Layer.iconImage (E.zoom |> E.step (str "oneway-small") [ ( 17, str "oneway-large" ) ])
                , Layer.iconRotationAlignment E.map
                , Layer.iconPadding (float 2)
                , Layer.symbolSpacing (float 200)
                ]
            , Layer.line "road-trunk"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 6, E.rgba 255 255 255 1 ), ( 6.1, E.rgba 234 196 71 1 ), ( 9, E.rgba 229 203 117 1 ) ]
                    )
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 242 146 73 1 ), ( 9, E.rgba 229 171 127 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-rail"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "major_rail", true ), ( "minor_rail", true ) ] false
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, E.rgba 216 214 201 1 ), ( 16, E.rgba 182 184 195 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 20, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "road-rail-tracks"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "major_rail", true ), ( "minor_rail", true ) ] false
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, E.rgba 216 214 201 1 ), ( 16, E.rgba 182 184 195 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 4 ), ( 20, float 8 ) ])
                , Layer.lineDasharray (E.floats [ 0.1, 15 ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.75, float 0 ), ( 14, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.symbol "road-oneway-arrows-white"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 16
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "link", true ), ( "trunk", true ) ] false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.matchesStr [ ( "bridge", false ), ( "tunnel", false ) ] true
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "primary_link", false ), ( "secondary_link", false ), ( "tertiary_link", false ) ] true
                            ]
                        ]
                    )
                , Layer.iconOpacity (float 0.5)
                , Layer.symbolPlacement E.line
                , Layer.iconImage (E.zoom |> E.step (str "oneway-white-small") [ ( 17, str "oneway-white-large" ) ])
                , Layer.iconPadding (float 2)
                , Layer.symbolSpacing (float 200)
                ]
            , Layer.line "hedges"
                "composite"
                [ Layer.sourceLayer "barrier_line"
                , Layer.minzoom 16
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "hedge"))
                , Layer.lineColor (E.rgba 163 223 133 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 1 ), ( 20, float 3 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 1, 2, 5, 2, 1, 2 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "fences"
                "composite"
                [ Layer.sourceLayer "barrier_line"
                , Layer.minzoom 16
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "fence"))
                , Layer.lineColor (E.rgba 204 199 183 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 1 ), ( 20, float 3 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.floats [ 1, 2, 5, 2, 1, 2 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "gates"
                "composite"
                [ Layer.sourceLayer "barrier_line"
                , Layer.minzoom 17
                , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "gate"))
                , Layer.lineColor (E.rgba 204 199 183 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 1 ), ( 20, float 3 ) ])
                , Layer.lineOpacity (float 0.5)
                , Layer.lineDasharray (E.floats [ 1, 2, 5, 2, 1, 2 ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-path-bg"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.matchesStr [ ( "piste", false ), ( "steps", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 2.5 ), ( 18, float 8 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineColor (E.rgba 204 170 0 1)
                , Layer.lineBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0 ), ( 17, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-piste-bg"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.isEqual (str "piste")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 2 ), ( 18, float 7 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineColor (E.rgba 88 163 217 1)
                , Layer.lineBlur (float 0)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-steps-bg"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 2.5 ), ( 18, float 8 ) ])
                , Layer.lineColor (E.rgba 204 170 0 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 0 ), ( 17, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-pedestrian-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 2 ), ( 18, float 14.5 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (float 0)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-street-low"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11.5, float 0 ), ( 12, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-street_limited-low"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 11.5, float 0 ), ( 12, float 1 ), ( 14, float 1 ), ( 14.01, float 0 ) ]
                    )
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-track-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "track")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 204 170 0 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 12 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-service-link-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "link", true ), ( "service", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-street_limited-case"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-street-case"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 13, float 0 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-secondary-tertiary-case"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "secondary", true ), ( "tertiary", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.2) [ ( 10, float 0.75 ), ( 18, float 2 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 8.5, float 0.5 ), ( 10, float 0.75 ), ( 18, float 26 ) ])
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineColor (E.rgba 213 216 229 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-trunk_link-case"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10.99, float 0 ), ( 11, float 1 ) ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-construction"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "construction")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 213 216 229 1)
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
                , Layer.lineJoin E.miter
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
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "cycleway", false ), ( "piste", false ), ( "steps", false ) ] true
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 4, 0.4 ]) [ ( 15, E.floats [ 3, 0.4 ] ), ( 16, E.floats [ 3, 0.35 ] ), ( 17, E.floats [ 3, 0.35 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-cycleway-piste"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "path")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.matchesStr [ ( "cycleway", true ), ( "piste", true ) ] false
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 4 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 16, float 1.6 ), ( 18, float 6 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineDasharray
                    (E.zoom
                        |> E.step (E.floats [ 4, 0.4 ]) [ ( 15, E.floats [ 1.75, 0.4 ] ), ( 16, E.floats [ 0.75, 0.4 ] ), ( 17, E.floats [ 0.3, 0.3 ] ) ]
                    )
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 0 ), ( 13.25, float 1 ) ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 229 203 117 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 229 171 127 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-pedestrian"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "pedestrian")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (float 1)
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 1, 0 ]) [ ( 15, E.floats [ 1.5, 0.4 ] ), ( 16, E.floats [ 1, 0.2 ] ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-track"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.isEqual (str "track")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 15, float 1 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-service-link"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 14
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class")
                                |> E.matchesStr [ ( "link", true ), ( "service", true ), ( "track", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type") |> E.notEqual (str "trunk_link")
                            ]
                        ]
                    )
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 18, float 12 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 239 237 234 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12.5, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.99, float 0 ), ( 14, float 1 ) ])
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.symbol "bridge-oneway-arrows-blue-minor"
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
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.symbolPlacement E.line
                , Layer.iconImage (E.zoom |> E.step (str "oneway-small") [ ( 18, str "oneway-large" ) ])
                , Layer.symbolSpacing (float 200)
                , Layer.iconRotationAlignment E.map
                , Layer.iconPadding (float 2)
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
                , Layer.symbolPlacement E.line
                , Layer.iconImage (E.zoom |> E.step (str "oneway-small") [ ( 17, str "oneway-large" ) ])
                , Layer.symbolSpacing (float 200)
                , Layer.iconRotationAlignment E.map
                , Layer.iconPadding (float 2)
                ]
            , Layer.line "bridge-trunk"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 229 203 117 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 229 171 127 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-rail"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "major_rail", true ), ( "minor_rail", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, E.rgba 216 214 201 1 ), ( 16, E.rgba 182 184 195 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 20, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-rail-tracks"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "major_rail", true ), ( "minor_rail", true ) ] false
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            ]
                        ]
                    )
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, E.rgba 216 214 201 1 ), ( 16, E.rgba 182 184 195 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 4 ), ( 20, float 8 ) ])
                , Layer.lineDasharray (E.floats [ 0.1, 15 ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13.75, float 0 ), ( 20, float 1 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-trunk_link-2-case"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10.99, float 0 ), ( 11, float 1 ) ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.75 ), ( 20, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineOpacity (float 1)
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-trunk-2-case"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10, float 1 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "bridge-motorway-2-case"
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 10, float 1 ), ( 16, float 2 ) ])
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineGapWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 229 203 117 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 12, float 0.5 ), ( 14, float 2 ), ( 18, float 18 ) ])
                , Layer.lineColor (E.rgba 229 171 127 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 229 203 117 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 5, float 0.75 ), ( 18, float 32 ) ])
                , Layer.lineColor (E.rgba 229 171 127 1)
                , Layer.lineCap E.rounded
                , Layer.lineJoin E.rounded
                ]
            , Layer.symbol "bridge-oneway-arrows-white"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 16
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.all
                            [ E.getProperty (str "class") |> E.matchesStr [ ( "link", true ), ( "trunk", true ) ] false
                            , E.getProperty (str "oneway") |> E.isEqual (str "true")
                            , E.getProperty (str "structure") |> E.isEqual (str "bridge")
                            , E.getProperty (str "type")
                                |> E.matchesStr [ ( "primary_link", false ), ( "secondary_link", false ), ( "tertiary_link", false ) ] true
                            ]
                        ]
                    )
                , Layer.iconOpacity (float 0.5)
                , Layer.symbolPlacement E.line
                , Layer.iconImage (E.zoom |> E.step (str "oneway-white-small") [ ( 17, str "oneway-white-large" ) ])
                , Layer.symbolSpacing (float 200)
                , Layer.iconPadding (float 2)
                ]
            , Layer.line "aerialway-bg"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "class") |> E.isEqual (str "aerialway")
                        ]
                    )
                , Layer.lineColor (E.rgba 255 255 255 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 2.5 ), ( 20, float 3 ) ])
                , Layer.lineBlur (float 0.5)
                , Layer.lineJoin E.rounded
                ]
            , Layer.line "aerialway"
                "composite"
                [ Layer.sourceLayer "road"
                , Layer.minzoom 13
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "class") |> E.isEqual (str "aerialway")
                        ]
                    )
                , Layer.lineColor (E.rgba 70 71 76 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1.5) [ ( 14, float 0.5 ), ( 20, float 1 ) ])
                , Layer.lineJoin E.rounded
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
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 8, E.rgba 230 227 223 1 ), ( 16, E.rgba 217 221 241 1 ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 3.75 ), ( 12, float 5.5 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 0 ), ( 8, float 0.75 ) ])
                , Layer.lineDasharray (E.floats [ 1, 0 ])
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0 ), ( 8, float 3 ) ])
                , Layer.lineJoin E.bevel
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
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 3.5 ), ( 10, float 8 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 6, E.rgba 230 227 223 1 ), ( 8, E.rgba 217 221 241 1 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0 ), ( 4, float 0.5 ) ])
                , Layer.lineTranslate (E.floats [ 0, 0 ])
                , Layer.lineBlur (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0 ), ( 10, float 2 ) ])
                , Layer.lineJoin E.miter
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
                , Layer.lineDasharray (E.zoom |> E.step (E.floats [ 2, 0 ]) [ ( 7, E.floats [ 2, 2, 6, 2 ] ) ])
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 0.75 ), ( 12, float 1.5 ) ])
                , Layer.lineOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 2, float 0 ), ( 3, float 1 ) ])
                , Layer.lineColor (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, E.rgba 188 190 204 1 ), ( 7, E.rgba 150 152 165 1 ) ])
                , Layer.lineJoin E.rounded
                , Layer.lineCap E.rounded
                ]
            , Layer.line "admin-2-boundaries"
                "composite"
                [ Layer.sourceLayer "admin"
                , Layer.minzoom 1
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.isEqual (float 2)
                        , E.getProperty (str "disputed") |> E.isEqual (float 0)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.lineColor (E.rgba 120 123 140 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0.5 ), ( 10, float 2 ) ])
                , Layer.lineJoin E.rounded
                , Layer.lineCap E.rounded
                ]
            , Layer.line "admin-2-boundaries-dispute"
                "composite"
                [ Layer.sourceLayer "admin"
                , Layer.minzoom 1
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "admin_level") |> E.isEqual (float 2)
                        , E.getProperty (str "disputed") |> E.isEqual (float 1)
                        , E.getProperty (str "maritime") |> E.isEqual (float 0)
                        ]
                    )
                , Layer.lineDasharray (E.floats [ 1.5, 1.5 ])
                , Layer.lineColor (E.rgba 120 123 140 1)
                , Layer.lineWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 0.5 ), ( 10, float 2 ) ])
                , Layer.lineJoin E.rounded
                ]
            , Layer.symbol "housenum-label"
                "composite"
                [ Layer.sourceLayer "housenum_label"
                , Layer.minzoom 17
                , Layer.textColor (E.rgba 177 176 174 1)
                , Layer.textHaloColor (E.rgba 219 217 213 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0)
                , Layer.textField (E.toFormattedText (E.getProperty (str "house_num")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 4)
                , Layer.textMaxWidth (float 7)
                , Layer.textSize (float 9.5)
                ]
            , Layer.symbol "contour-label"
                "composite"
                [ Layer.sourceLayer "contour"
                , Layer.minzoom 11
                , Layer.filter (E.getProperty (str "index") |> E.matchesFloat [ ( 5, true ), ( 10, true ) ] false)
                , Layer.textColor (E.rgba 57 114 28 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 0)
                , Layer.textHaloColor (E.rgba 255 255 255 0.5)
                , Layer.textField (E.toFormattedText (E.getProperty (str "ele") |> E.append (str " m")))
                , Layer.symbolPlacement E.line
                , Layer.textMaxAngle (float 25)
                , Layer.textPadding (float 5)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 9.5 ), ( 20, float 12 ) ])
                ]
            , Layer.symbol "waterway-label"
                "composite"
                [ Layer.sourceLayer "waterway_label"
                , Layer.minzoom 12
                , Layer.filter (E.getProperty (str "class") |> E.matchesStr [ ( "canal", true ), ( "river", true ) ] false)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloColor (E.rgba 117 207 239 1)
                , Layer.textColor (E.rgba 58 76 166 1)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.line
                , Layer.textMaxAngle (float 30)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 13, float 12 ), ( 18, float 16 ) ])
                ]
            , Layer.symbol "poi-relevant-scalerank4-l15"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.minzoom 17
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "localrank") |> E.greaterThanOrEqual (float 15)
                        , E.getProperty (str "maki")
                            |> E.matchesStr
                                [ ( "amusement-park", true )
                                , ( "aquarium", true )
                                , ( "attraction", true )
                                , ( "bakery", true )
                                , ( "bank", true )
                                , ( "bar", true )
                                , ( "beer", true )
                                , ( "bus", true )
                                , ( "cafe", true )
                                , ( "castle", true )
                                , ( "college", true )
                                , ( "doctor", true )
                                , ( "fast-food", true )
                                , ( "ferry", true )
                                , ( "fire-station", true )
                                , ( "fuel", true )
                                , ( "grocery", true )
                                , ( "harbor", true )
                                , ( "hospital", true )
                                , ( "ice-cream", true )
                                , ( "lodging", true )
                                , ( "marker", true )
                                , ( "monument", true )
                                , ( "museum", true )
                                , ( "pharmacy", true )
                                , ( "police", true )
                                , ( "post", true )
                                , ( "restaurant", true )
                                , ( "rocket", true )
                                , ( "stadium", true )
                                , ( "swimming", true )
                                ]
                                false
                        , E.getProperty (str "scalerank") |> E.isEqual (float 4)
                        ]
                    )
                , Layer.textColor (E.rgba 102 78 61 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 11 ), ( 20, float 13 ) ])
                , Layer.iconImage (E.getProperty (str "maki") |> E.append (str "-11"))
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 1)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "poi-relevant-scalerank4-l1"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "localrank") |> E.lessThanOrEqual (float 14)
                        , E.getProperty (str "maki")
                            |> E.matchesStr
                                [ ( "amusement-park", true )
                                , ( "aquarium", true )
                                , ( "attraction", true )
                                , ( "bakery", true )
                                , ( "bank", true )
                                , ( "bar", true )
                                , ( "beer", true )
                                , ( "bus", true )
                                , ( "cafe", true )
                                , ( "castle", true )
                                , ( "college", true )
                                , ( "doctor", true )
                                , ( "fast-food", true )
                                , ( "ferry", true )
                                , ( "fire-station", true )
                                , ( "fuel", true )
                                , ( "grocery", true )
                                , ( "harbor", true )
                                , ( "hospital", true )
                                , ( "ice-cream", true )
                                , ( "lodging", true )
                                , ( "marker", true )
                                , ( "monument", true )
                                , ( "museum", true )
                                , ( "pharmacy", true )
                                , ( "police", true )
                                , ( "post", true )
                                , ( "restaurant", true )
                                , ( "rocket", true )
                                , ( "stadium", true )
                                , ( "swimming", true )
                                ]
                                false
                        , E.getProperty (str "scalerank") |> E.isEqual (float 4)
                        ]
                    )
                , Layer.textColor (E.rgba 102 78 61 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 11 ), ( 20, float 13 ) ])
                , Layer.iconImage (E.getProperty (str "maki") |> E.append (str "-11"))
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 1)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "poi-parks_scalerank4"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.minzoom 15
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
                , Layer.textColor (E.rgba 33 102 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 11 ), ( 20, float 13 ) ])
                , Layer.iconImage (E.getProperty (str "maki") |> E.append (str "-11"))
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 1)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
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
                , Layer.textColor (E.rgba 102 78 61 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 11 ), ( 20, float 13 ) ])
                , Layer.iconImage (E.getProperty (str "maki") |> E.append (str "-11"))
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 1)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
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
                , Layer.textColor (E.rgba 33 102 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 11 ), ( 20, float 13 ) ])
                , Layer.iconImage (E.getProperty (str "maki") |> E.append (str "-11"))
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "road-label-small"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.minzoom 15
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "class")
                            |> E.matchesStr
                                [ ( "aerialway", false )
                                , ( "link", false )
                                , ( "motorway", false )
                                , ( "path", false )
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
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.textHaloBlur (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 15, float 10 ), ( 20, float 13 ) ])
                , Layer.textMaxAngle (float 30)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.line
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.map
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                ]
            , Layer.symbol "road-label-medium"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.minzoom 11
                , Layer.filter
                    (E.all
                        [ E.geometryType |> E.isEqual (str "LineString")
                        , E.getProperty (str "class")
                            |> E.matchesStr
                                [ ( "aerialway", true )
                                , ( "link", true )
                                , ( "path", true )
                                , ( "pedestrian", true )
                                , ( "street", true )
                                , ( "street_limited", true )
                                ]
                                false
                        ]
                    )
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 10 ), ( 20, float 14 ) ])
                , Layer.textMaxAngle (float 30)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.line
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.map
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                ]
            , Layer.symbol "road-label-large"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.filter
                    (E.getProperty (str "class")
                        |> E.matchesStr [ ( "motorway", true ), ( "primary", true ), ( "secondary", true ), ( "tertiary", true ), ( "trunk", true ) ] false
                    )
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 0.75)
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloBlur (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 9, float 10 ), ( 20, float 16 ) ])
                , Layer.textMaxAngle (float 30)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.line
                , Layer.textPadding (float 1)
                , Layer.textRotationAlignment E.map
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                ]
            , Layer.symbol "road-shields-black"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "reflen") |> E.lessThanOrEqual (float 6)
                        , E.getProperty (str "shield")
                            |> E.matchesStr
                                [ ( "at-expressway", false )
                                , ( "at-motorway", false )
                                , ( "at-state-b", false )
                                , ( "bg-motorway", false )
                                , ( "bg-national", false )
                                , ( "ch-main", false )
                                , ( "ch-motorway", false )
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
                , Layer.textColor (E.rgba 74 81 114 1)
                , Layer.iconHaloColor (E.rgba 0 0 0 1)
                , Layer.iconHaloWidth (float 1)
                , Layer.textOpacity (float 1)
                , Layer.iconColor (E.rgba 255 255 255 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0)
                , Layer.textSize (float 9)
                , Layer.iconImage (E.getProperty (str "shield") |> E.append (str "-") |> E.append (E.getProperty (str "reflen")))
                , Layer.iconRotationAlignment E.viewport
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 150 ), ( 14, float 200 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Bold", "Arial Unicode MS Bold" ])
                , Layer.symbolPlacement (E.zoom |> E.step E.point [ ( 11, E.line ) ])
                , Layer.textPadding (float 2)
                , Layer.textRotationAlignment E.viewport
                , Layer.textField (E.toFormattedText (E.getProperty (str "ref")))
                , Layer.textLetterSpacing (float 0.05)
                , Layer.iconPadding (float 2)
                ]
            , Layer.symbol "road-shields-white"
                "composite"
                [ Layer.sourceLayer "road_label"
                , Layer.filter
                    (E.all
                        [ E.getProperty (str "reflen") |> E.lessThanOrEqual (float 6)
                        , E.getProperty (str "shield")
                            |> E.matchesStr
                                [ ( "at-expressway", true )
                                , ( "at-motorway", true )
                                , ( "at-state-b", true )
                                , ( "bg-motorway", true )
                                , ( "bg-national", true )
                                , ( "ch-main", true )
                                , ( "ch-motorway", true )
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
                , Layer.iconRotationAlignment E.viewport
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 150 ), ( 14, float 200 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Bold", "Arial Unicode MS Bold" ])
                , Layer.symbolPlacement (E.zoom |> E.step E.point [ ( 11, E.line ) ])
                , Layer.textPadding (float 2)
                , Layer.textRotationAlignment E.viewport
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
                , Layer.iconImage (str "motorway-exit-" |> E.append (E.getProperty (str "reflen")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Bold", "Arial Unicode MS Bold" ])
                ]
            , Layer.symbol "poi-outdoor-features"
                "composite"
                [ Layer.sourceLayer "poi_label"
                , Layer.filter
                    (E.getProperty (str "maki")
                        |> E.matchesStr
                            [ ( "bicycle", true )
                            , ( "bicycle-share", true )
                            , ( "drinking-water", true )
                            , ( "information", true )
                            , ( "picnic-site", true )
                            , ( "toilet", true )
                            ]
                            false
                    )
                , Layer.textColor (E.rgba 102 78 61 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 11 ), ( 20, float 13 ) ])
                , Layer.iconImage (E.getProperty (str "maki") |> E.append (str "-11"))
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "mountain-peak-label"
                "composite"
                [ Layer.sourceLayer "mountain_peak_label"
                , Layer.textColor (E.rgba 33 102 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 14 ) ])
                , Layer.iconImage (E.getProperty (str "maki") |> E.append (str "-15"))
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textAnchor E.top
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "mountain-peak-label-with-elevation"
                "composite"
                [ Layer.sourceLayer "mountain_peak_label"
                , Layer.filter (E.getProperty (str "elevation_m") |> E.greaterThan (float 0))
                , Layer.textColor (E.rgba 33 102 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 14 ) ])
                , Layer.iconImage (E.getProperty (str "maki") |> E.append (str "-15"))
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textAnchor E.top
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en") |> E.append (str ", ") |> E.append (E.getProperty (str "elevation_m")) |> E.append (str "m")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
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
                , Layer.textColor (E.rgba 102 78 61 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 14 ) ])
                , Layer.iconImage
                    (E.zoom
                        |> E.step (E.getProperty (str "maki") |> E.append (str "-11")) [ ( 15, E.getProperty (str "maki") |> E.append (str "-15") ) ]
                    )
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
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
                , Layer.textColor (E.rgba 33 102 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 14, float 11 ), ( 20, float 14 ) ])
                , Layer.iconImage
                    (E.zoom
                        |> E.step (E.getProperty (str "maki") |> E.append (str "-11")) [ ( 15, E.getProperty (str "maki") |> E.append (str "-15") ) ]
                    )
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0.65 ])
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "rail-label"
                "composite"
                [ Layer.sourceLayer "rail_station_label"
                , Layer.minzoom 12
                , Layer.filter (E.getProperty (str "maki") |> E.notEqual (str "entrance"))
                , Layer.textColor (E.rgba 58 76 166 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
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
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
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
                , Layer.textColor (E.rgba 58 76 166 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textMaxWidth (float 7)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 16, float 13 ), ( 20, float 16 ) ])
                ]
            , Layer.symbol "water-label"
                "composite"
                [ Layer.sourceLayer "water_label"
                , Layer.minzoom 5
                , Layer.filter (E.getProperty (str "area") |> E.greaterThan (float 10000))
                , Layer.textColor (E.rgba 58 76 166 1)
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
                , Layer.textColor (E.rgba 33 102 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
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
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
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
                , Layer.textColor (E.rgba 102 78 61 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
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
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 8)
                ]
            , Layer.symbol "airport-label"
                "composite"
                [ Layer.sourceLayer "airport_label"
                , Layer.minzoom 9
                , Layer.filter (E.getProperty (str "scalerank") |> E.lessThanOrEqual (float 2))
                , Layer.textColor (E.rgba 58 76 166 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 0.5)
                , Layer.textHaloBlur (float 0.5)
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
                , Layer.textRotationAlignment E.viewport
                , Layer.textAnchor E.top
                , Layer.textField
                    (E.zoom
                        |> E.step (E.toFormattedText (E.getProperty (str "ref"))) [ ( 12, E.toFormattedText (E.getProperty (str "name_en")) ) ]
                    )
                , Layer.textLetterSpacing (float 0.01)
                , Layer.textMaxWidth (float 9)
                ]
            , Layer.symbol "place-islet-archipelago-aboriginal"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.maxzoom 16
                , Layer.filter
                    (E.getProperty (str "type")
                        |> E.matchesStr [ ( "aboriginal_lands", true ), ( "archipelago", true ), ( "islet", true ) ] false
                    )
                , Layer.textColor (E.rgba 63 71 115 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textLineHeight (float 1.2)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 16 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textRotationAlignment E.viewport
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
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textColor (E.rgba 63 71 115 1)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textTransform E.uppercase
                , Layer.textLetterSpacing (float 0.1)
                , Layer.textMaxWidth (float 7)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 3)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 11 ), ( 16, float 16 ) ])
                ]
            , Layer.symbol "place-suburb"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 10
                , Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "suburb"))
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textColor (E.rgba 63 71 115 1)
                , Layer.textHaloBlur (float 0.5)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textTransform E.uppercase
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textLetterSpacing (float 0.15)
                , Layer.textMaxWidth (float 7)
                , Layer.textPadding (float 3)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 11, float 11 ), ( 15, float 18 ) ])
                ]
            , Layer.symbol "place-hamlet"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 10
                , Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "hamlet"))
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 12, float 11.5 ), ( 15, float 16 ) ])
                ]
            , Layer.symbol "place-village"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 8
                , Layer.maxzoom 15
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "village"))
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textMaxWidth (float 7)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11.5 ), ( 16, float 18 ) ])
                ]
            , Layer.symbol "place-town"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 6
                , Layer.maxzoom 15
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "town"))
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.iconImage (str "dot-9")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 12, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, E.floats [ 0, -0.15 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textAnchor (E.zoom |> E.step E.bottom [ ( 8, E.center ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7, float 11.5 ), ( 15, float 20 ) ])
                ]
            , Layer.symbol "place-island"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.maxzoom 16
                , Layer.filter (E.getProperty (str "type") |> E.isEqual (str "island"))
                , Layer.textColor (E.rgba 63 71 115 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textLineHeight (float 1.2)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 10, float 11 ), ( 18, float 16 ) ])
                , Layer.textMaxAngle (float 38)
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ])
                , Layer.textPadding (float 2)
                , Layer.textOffset (E.floats [ 0, 0 ])
                , Layer.textRotationAlignment E.viewport
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
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1.25)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 6, float 12 ), ( 14, float 22 ) ])
                , Layer.iconImage (str "dot-9")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, -0.2 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textAnchor (E.zoom |> E.step E.bottom [ ( 8, E.center ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
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
                , Layer.textHaloWidth (float 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloBlur (float 1)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.iconImage (str "dot-10")
                , Layer.textAnchor (E.zoom |> E.step E.top [ ( 8, E.center ) ])
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, 0.1 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 5, float 12 ), ( 12, float 22 ) ])
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
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 1)
                , Layer.iconImage (str "dot-10")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, -0.25 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textAnchor (E.zoom |> E.step E.bottom [ ( 8, E.center ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 5, float 12 ), ( 12, float 22 ) ])
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
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 1)
                , Layer.iconImage (str "dot-11")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, 0.15 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textAnchor (E.zoom |> E.step E.top [ ( 8, E.center ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 4, float 12 ), ( 10, float 22 ) ])
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
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textOpacity (float 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.iconOpacity (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, float 1 ), ( 8, float 0 ) ])
                , Layer.textHaloBlur (float 1)
                , Layer.iconImage (str "dot-11")
                , Layer.textFont
                    (E.zoom
                        |> E.step (E.strings [ "DIN Offc Pro Regular", "Arial Unicode MS Regular" ]) [ ( 8, E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ] ) ]
                    )
                , Layer.textOffset (E.zoom |> E.interpolate (E.Exponential 1) [ ( 7.99, E.floats [ 0, -0.25 ] ), ( 8, E.floats [ 0, 0 ] ) ])
                , Layer.textAnchor (E.zoom |> E.step E.bottom [ ( 8, E.center ) ])
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 7)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 0.9) [ ( 4, float 12 ), ( 10, float 22 ) ])
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
                , Layer.textColor (E.rgba 199 228 249 1)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 3, float 12 ), ( 6, float 16 ) ])
                , Layer.symbolSpacing (E.zoom |> E.interpolate (E.Exponential 1) [ ( 4, float 100 ), ( 6, float 400 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.line
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
                , Layer.textColor (E.rgba 199 228 249 1)
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
                , Layer.textColor (E.rgba 199 228 249 1)
                , Layer.textLineHeight (float 1.1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1.1) [ ( 2, float 12 ), ( 5, float 20 ) ])
                , Layer.symbolSpacing (float 250)
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.symbolPlacement E.line
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
                , Layer.textColor (E.rgba 199 228 249 1)
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
                , Layer.textColor (E.rgba 199 228 249 1)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (float 4)
                , Layer.textLetterSpacing (float 0.25)
                , Layer.textLineHeight (float 1.1)
                , Layer.symbolPlacement E.line
                , Layer.textFont (E.strings [ "DIN Offc Pro Italic", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 1, float 14 ), ( 4, float 30 ) ])
                ]
            , Layer.symbol "marine-label-lg-pt"
                "composite"
                [ Layer.sourceLayer "marine_label"
                , Layer.minzoom 1
                , Layer.maxzoom 4
                , Layer.filter (E.all [ E.geometryType |> E.isEqual (str "Point"), E.getProperty (str "labelrank") |> E.isEqual (float 1) ])
                , Layer.textColor (E.rgba 199 228 249 1)
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
                , Layer.textOpacity (float 1)
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 6, float 10 ), ( 9, float 14 ) ])
                , Layer.textTransform E.uppercase
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
                , Layer.textOpacity (float 1)
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 5, float 10 ), ( 8, float 16 ) ])
                , Layer.textTransform E.uppercase
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
                , Layer.textOpacity (float 1)
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor (E.rgba 255 255 255 1)
                , Layer.textHaloWidth (float 1)
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 4, float 10 ), ( 7, float 18 ) ])
                , Layer.textTransform E.uppercase
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
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 2, E.rgba 255 255 255 0.75 ), ( 3, E.rgba 255 255 255 1 ) ]
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
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 2, E.rgba 255 255 255 0.75 ), ( 3, E.rgba 255 255 255 1 ) ]
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
                , Layer.textColor (E.rgba 0 0 0 1)
                , Layer.textHaloColor
                    (E.zoom
                        |> E.interpolate (E.Exponential 1) [ ( 2, E.rgba 255 255 255 0.75 ), ( 3, E.rgba 255 255 255 1 ) ]
                    )
                , Layer.textHaloWidth (float 1.25)
                , Layer.textField (E.toFormattedText (E.getProperty (str "name_en")))
                , Layer.textMaxWidth (E.zoom |> E.interpolate (E.Exponential 1) [ ( 0, float 5 ), ( 3, float 6 ) ])
                , Layer.textFont (E.strings [ "DIN Offc Pro Medium", "Arial Unicode MS Regular" ])
                , Layer.textSize (E.zoom |> E.interpolate (E.Exponential 1) [ ( 1, float 10 ), ( 6, float 24 ) ])
                ]
            ]
        , sources = [ Source.vectorFromUrl "composite" "mapbox://mapbox.mapbox-terrain-v2,mapbox.mapbox-streets-v7" ]
        , misc =
            [ Style.sprite "mapbox://sprites/mapbox/outdoors-v9"
            , Style.glyphs "mapbox://fonts/mapbox/{fontstack}/{range}.pbf"
            , Style.name "Mapbox Outdoors"
            ]
        }
