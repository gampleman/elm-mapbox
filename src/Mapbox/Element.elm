module Mapbox.Element exposing (..)

import Html exposing (Attribute, Html, node)
import Html.Attributes exposing (property, attribute)
import Json.Encode as Encode
import Mapbox.Style exposing (Style)


type MapboxAttr msg
    = MapboxAttr (Attribute msg)


type Control msg
    = Control (Html msg)


type Position
    = TopLeft
    | BottomLeft
    | TopRight
    | BottomRight


map : List (MapboxAttr msg) -> List (Control msg) -> Html msg
map attrs children =
    let
        props =
            (List.map (\(MapboxAttr attr) -> attr) attrs)
    in
        node "elm-mapbox-map" props []


css : Html msg
css =
    node "link" [ attribute "href" "https://api.tiles.mapbox.com/mapbox-gl-js/v0.45.0/mapbox-gl.css", attribute "rel" "stylesheet" ] []


style : Style -> MapboxAttr msg
style =
    Mapbox.Style.encode >> property "mapboxStyle" >> MapboxAttr


minZoom : Float -> MapboxAttr msg
minZoom =
    Encode.float >> property "minZoom" >> MapboxAttr


maxZoom : Float -> MapboxAttr msg
maxZoom =
    Encode.float >> property "maxZoom" >> MapboxAttr


token : String -> MapboxAttr msg
token =
    Encode.string >> property "token" >> MapboxAttr


id : String -> MapboxAttr msg
id =
    attribute "id" >> MapboxAttr


type alias LngLat =
    ( Float, Float )


{-| sw: lnglat, ne: lnglat
-}
maxBounds : ( LngLat, LngLat ) -> MapboxAttr msg
maxBounds =
    encodePair (encodePair Encode.float) >> property "maxBounds" >> MapboxAttr


renderWorldCopies : Bool -> MapboxAttr msg
renderWorldCopies =
    Encode.bool >> property "renderWorldCopies" >> MapboxAttr


encodePair encoder ( a, b ) =
    Encode.list [ encoder a, encoder b ]


encodePosition pos =
    case pos of
        TopLeft ->
            Encode.string "top-left"

        BottomLeft ->
            Encode.string "bottom-left"

        TopRight ->
            Encode.string "top-right"

        BottomRight ->
            Encode.string "bottom-right"



--- Controlled mode


{-| Note: this property will only take effect when the map is created.
-}
controlled : MapboxAttr msg
controlled =
    property "interactive" (Encode.bool False) |> MapboxAttr
