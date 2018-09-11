module Color exposing (parse)

import Bitwise exposing (shiftLeftBy)
import Parser exposing ((|.), (|=), Parser, backtrackable, end, keyword, oneOf, spaces, succeed, symbol)


type alias Color =
    { r : Int, g : Int, b : Int, a : Float }


parser : Parser Color
parser =
    oneOf
        [ keywords
        , hsla

        -- , rgba
        -- , hex
        ]
        |. end


fromHSLA hue sat light alpha =
    let
        ( h, s, l ) =
            ( toFloat hue / 360, toFloat sat / 100, toFloat light / 100 )

        m2 =
            if l <= 0.5 then
                l * (s + 1)
            else
                l + s - l * s

        m1 =
            l * 2 - m2

        r =
            hueToRgb (h + 1 / 3)

        g =
            hueToRgb h

        b =
            hueToRgb (h - 1 / 3)

        hueToRgb h__ =
            let
                h_ =
                    if h__ < 0 then
                        h__ + 1
                    else if h__ > 1 then
                        h__ - 1
                    else
                        h__
            in
            if h_ * 6 < 1 then
                m1 + (m2 - m1) * h_ * 6
            else if h_ * 2 < 1 then
                m2
            else if h_ * 3 < 2 then
                m1 + (m2 - m1) * (2 / 3 - h_) * 6
            else
                m1
    in
    Color (r * 255 |> floor) (g * 255 |> floor) (b * 255 |> floor) alpha


hsla : Parser Color
hsla =
    succeed fromHSLA
        |. oneOf [ keyword "hsla", keyword "hsl" ]
        |. symbol "("
        |= angle
        |. spaces
        |. symbol ","
        |. spaces
        |= percentage
        |. spaces
        |. symbol ","
        |. spaces
        |= percentage
        |= oneOf
            [ succeed identity
                |. symbol ","
                |. spaces
                |= Parser.float
            , succeed 1
            ]
        |. symbol ")"


angle =
    Parser.map round Parser.float


percentage =
    Parser.map round Parser.float
        |. symbol "%"


fromHexString : String -> Parser Color
fromHexString hexString =
    case String.toList hexString of
        [ '#', r, g, b ] ->
            fromHex8 ( r, r ) ( g, g ) ( b, b ) ( 'f', 'f' )

        [ r, g, b ] ->
            fromHex8 ( r, r ) ( g, g ) ( b, b ) ( 'f', 'f' )

        [ '#', r, g, b, a ] ->
            fromHex8 ( r, r ) ( g, g ) ( b, b ) ( a, a )

        [ r, g, b, a ] ->
            fromHex8 ( r, r ) ( g, g ) ( b, b ) ( a, a )

        [ '#', r1, r2, g1, g2, b1, b2 ] ->
            fromHex8 ( r1, r2 ) ( g1, g2 ) ( b1, b2 ) ( 'f', 'f' )

        [ r1, r2, g1, g2, b1, b2 ] ->
            fromHex8 ( r1, r2 ) ( g1, g2 ) ( b1, b2 ) ( 'f', 'f' )

        [ '#', r1, r2, g1, g2, b1, b2, a1, a2 ] ->
            fromHex8 ( r1, r2 ) ( g1, g2 ) ( b1, b2 ) ( a1, a2 )

        [ r1, r2, g1, g2, b1, b2, a1, a2 ] ->
            fromHex8 ( r1, r2 ) ( g1, g2 ) ( b1, b2 ) ( a1, a2 )

        _ ->
            Parser.problem "Invalid color"


maybeToParser : Maybe a -> Parser a
maybeToParser aMaybe =
    case aMaybe of
        Just a ->
            succeed a

        Nothing ->
            Parser.problem "something went wrong"


fromHex8 : ( Char, Char ) -> ( Char, Char ) -> ( Char, Char ) -> ( Char, Char ) -> Parser Color
fromHex8 ( r1, r2 ) ( g1, g2 ) ( b1, b2 ) ( a1, a2 ) =
    Maybe.map4
        (\r g b a ->
            Color
                r
                g
                b
                (toFloat a / 255)
        )
        (hex2ToInt r1 r2)
        (hex2ToInt g1 g2)
        (hex2ToInt b1 b2)
        (hex2ToInt a1 a2)
        |> maybeToParser


hex2ToInt : Char -> Char -> Maybe Int
hex2ToInt c1 c2 =
    Maybe.map2 (\v1 v2 -> shiftLeftBy 4 v1 + v2) (hexToInt c1) (hexToInt c2)


hexToInt : Char -> Maybe Int
hexToInt char =
    case Char.toLower char of
        '0' ->
            Just 0

        '1' ->
            Just 1

        '2' ->
            Just 2

        '3' ->
            Just 3

        '4' ->
            Just 4

        '5' ->
            Just 5

        '6' ->
            Just 6

        '7' ->
            Just 7

        '8' ->
            Just 8

        '9' ->
            Just 9

        'a' ->
            Just 10

        'b' ->
            Just 11

        'c' ->
            Just 12

        'd' ->
            Just 13

        'e' ->
            Just 14

        'f' ->
            Just 15

        _ ->
            Nothing


keywords : Parser Color
keywords =
    oneOf
        [ fromHexString "#000000" |. keyword "black"
        , fromHexString "#c0c0c0" |. keyword "silver"
        , fromHexString "#808080" |. keyword "gray"
        , fromHexString "#ffffff" |. keyword "white"
        , fromHexString "#800000" |. keyword "maroon"
        , fromHexString "#ff0000" |. keyword "red"
        , fromHexString "#800080" |. keyword "purple"
        , fromHexString "#ff00ff" |. keyword "fuchsia"
        , fromHexString "#008000" |. keyword "green"
        , fromHexString "#00ff00" |. keyword "lime"
        , fromHexString "#808000" |. keyword "olive"
        , fromHexString "#ffff00" |. keyword "yellow"
        , fromHexString "#000080" |. keyword "navy"
        , fromHexString "#0000ff" |. keyword "blue"
        , fromHexString "#008080" |. keyword "teal"
        , fromHexString "#00ffff" |. keyword "aqua"
        , fromHexString "#ffa500" |. keyword "orange"
        , fromHexString "#f0f8ff" |. keyword "aliceblue"
        , fromHexString "#faebd7" |. keyword "antiquewhite"
        , fromHexString "#7fffd4" |. keyword "aquamarine"
        , fromHexString "#f0ffff" |. keyword "azure"
        , fromHexString "#f5f5dc" |. keyword "beige"
        , fromHexString "#ffe4c4" |. keyword "bisque"
        , fromHexString "#ffebcd" |. keyword "blanchedalmond"
        , fromHexString "#8a2be2" |. keyword "blueviolet"
        , fromHexString "#a52a2a" |. keyword "brown"
        , fromHexString "#deb887" |. keyword "burlywood"
        , fromHexString "#5f9ea0" |. keyword "cadetblue"
        , fromHexString "#7fff00" |. keyword "chartreuse"
        , fromHexString "#d2691e" |. keyword "chocolate"
        , fromHexString "#ff7f50" |. keyword "coral"
        , fromHexString "#6495ed" |. keyword "cornflowerblue"
        , fromHexString "#fff8dc" |. keyword "cornsilk"
        , fromHexString "#dc143c" |. keyword "crimson"
        , fromHexString "#00ffff" |. keyword "cyan"
        , fromHexString "#00008b" |. keyword "darkblue"
        , fromHexString "#008b8b" |. keyword "darkcyan"
        , fromHexString "#b8860b" |. keyword "darkgoldenrod"
        , fromHexString "#a9a9a9" |. keyword "darkgray"
        , fromHexString "#006400" |. keyword "darkgreen"
        , fromHexString "#a9a9a9" |. keyword "darkgrey"
        , fromHexString "#bdb76b" |. keyword "darkkhaki"
        , fromHexString "#8b008b" |. keyword "darkmagenta"
        , fromHexString "#556b2f" |. keyword "darkolivegreen"
        , fromHexString "#ff8c00" |. keyword "darkorange"
        , fromHexString "#9932cc" |. keyword "darkorchid"
        , fromHexString "#8b0000" |. keyword "darkred"
        , fromHexString "#e9967a" |. keyword "darksalmon"
        , fromHexString "#8fbc8f" |. keyword "darkseagreen"
        , fromHexString "#483d8b" |. keyword "darkslateblue"
        , fromHexString "#2f4f4f" |. keyword "darkslategray"
        , fromHexString "#2f4f4f" |. keyword "darkslategrey"
        , fromHexString "#00ced1" |. keyword "darkturquoise"
        , fromHexString "#9400d3" |. keyword "darkviolet"
        , fromHexString "#ff1493" |. keyword "deeppink"
        , fromHexString "#00bfff" |. keyword "deepskyblue"
        , fromHexString "#696969" |. keyword "dimgray"
        , fromHexString "#696969" |. keyword "dimgrey"
        , fromHexString "#1e90ff" |. keyword "dodgerblue"
        , fromHexString "#b22222" |. keyword "firebrick"
        , fromHexString "#fffaf0" |. keyword "floralwhite"
        , fromHexString "#228b22" |. keyword "forestgreen"
        , fromHexString "#dcdcdc" |. keyword "gainsboro"
        , fromHexString "#f8f8ff" |. keyword "ghostwhite"
        , fromHexString "#ffd700" |. keyword "gold"
        , fromHexString "#daa520" |. keyword "goldenrod"
        , fromHexString "#adff2f" |. keyword "greenyellow"
        , fromHexString "#808080" |. keyword "grey"
        , fromHexString "#f0fff0" |. keyword "honeydew"
        , fromHexString "#ff69b4" |. keyword "hotpink"
        , fromHexString "#cd5c5c" |. keyword "indianred"
        , fromHexString "#4b0082" |. keyword "indigo"
        , fromHexString "#fffff0" |. keyword "ivory"
        , fromHexString "#f0e68c" |. keyword "khaki"
        , fromHexString "#e6e6fa" |. keyword "lavender"
        , fromHexString "#fff0f5" |. keyword "lavenderblush"
        , fromHexString "#7cfc00" |. keyword "lawngreen"
        , fromHexString "#fffacd" |. keyword "lemonchiffon"
        , fromHexString "#add8e6" |. keyword "lightblue"
        , fromHexString "#f08080" |. keyword "lightcoral"
        , fromHexString "#e0ffff" |. keyword "lightcyan"
        , fromHexString "#fafad2" |. keyword "lightgoldenrodyellow"
        , fromHexString "#d3d3d3" |. keyword "lightgray"
        , fromHexString "#90ee90" |. keyword "lightgreen"
        , fromHexString "#d3d3d3" |. keyword "lightgrey"
        , fromHexString "#ffb6c1" |. keyword "lightpink"
        , fromHexString "#ffa07a" |. keyword "lightsalmon"
        , fromHexString "#20b2aa" |. keyword "lightseagreen"
        , fromHexString "#87cefa" |. keyword "lightskyblue"
        , fromHexString "#778899" |. keyword "lightslategray"
        , fromHexString "#778899" |. keyword "lightslategrey"
        , fromHexString "#b0c4de" |. keyword "lightsteelblue"
        , fromHexString "#ffffe0" |. keyword "lightyellow"
        , fromHexString "#32cd32" |. keyword "limegreen"
        , fromHexString "#faf0e6" |. keyword "linen"
        , fromHexString "#ff00ff" |. keyword "magenta"
        , fromHexString "#66cdaa" |. keyword "mediumaquamarine"
        , fromHexString "#0000cd" |. keyword "mediumblue"
        , fromHexString "#ba55d3" |. keyword "mediumorchid"
        , fromHexString "#9370db" |. keyword "mediumpurple"
        , fromHexString "#3cb371" |. keyword "mediumseagreen"
        , fromHexString "#7b68ee" |. keyword "mediumslateblue"
        , fromHexString "#00fa9a" |. keyword "mediumspringgreen"
        , fromHexString "#48d1cc" |. keyword "mediumturquoise"
        , fromHexString "#c71585" |. keyword "mediumvioletred"
        , fromHexString "#191970" |. keyword "midnightblue"
        , fromHexString "#f5fffa" |. keyword "mintcream"
        , fromHexString "#ffe4e1" |. keyword "mistyrose"
        , fromHexString "#ffe4b5" |. keyword "moccasin"
        , fromHexString "#ffdead" |. keyword "navajowhite"
        , fromHexString "#fdf5e6" |. keyword "oldlace"
        , fromHexString "#6b8e23" |. keyword "olivedrab"
        , fromHexString "#ff4500" |. keyword "orangered"
        , fromHexString "#da70d6" |. keyword "orchid"
        , fromHexString "#eee8aa" |. keyword "palegoldenrod"
        , fromHexString "#98fb98" |. keyword "palegreen"
        , fromHexString "#afeeee" |. keyword "paleturquoise"
        , fromHexString "#db7093" |. keyword "palevioletred"
        , fromHexString "#ffefd5" |. keyword "papayawhip"
        , fromHexString "#ffdab9" |. keyword "peachpuff"
        , fromHexString "#cd853f" |. keyword "peru"
        , fromHexString "#ffc0cb" |. keyword "pink"
        , fromHexString "#dda0dd" |. keyword "plum"
        , fromHexString "#b0e0e6" |. keyword "powderblue"
        , fromHexString "#bc8f8f" |. keyword "rosybrown"
        , fromHexString "#4169e1" |. keyword "royalblue"
        , fromHexString "#8b4513" |. keyword "saddlebrown"
        , fromHexString "#fa8072" |. keyword "salmon"
        , fromHexString "#f4a460" |. keyword "sandybrown"
        , fromHexString "#2e8b57" |. keyword "seagreen"
        , fromHexString "#fff5ee" |. keyword "seashell"
        , fromHexString "#a0522d" |. keyword "sienna"
        , fromHexString "#87ceeb" |. keyword "skyblue"
        , fromHexString "#6a5acd" |. keyword "slateblue"
        , fromHexString "#708090" |. keyword "slategray"
        , fromHexString "#708090" |. keyword "slategrey"
        , fromHexString "#fffafa" |. keyword "snow"
        , fromHexString "#00ff7f" |. keyword "springgreen"
        , fromHexString "#4682b4" |. keyword "steelblue"
        , fromHexString "#d2b48c" |. keyword "tan"
        , fromHexString "#d8bfd8" |. keyword "thistle"
        , fromHexString "#ff6347" |. keyword "tomato"
        , fromHexString "#40e0d0" |. keyword "turquoise"
        , fromHexString "#ee82ee" |. keyword "violet"
        , fromHexString "#f5deb3" |. keyword "wheat"
        , fromHexString "#f5f5f5" |. keyword "whitesmoke"
        , fromHexString "#9acd32" |. keyword "yellowgreen"
        , fromHexString "#663399" |. keyword "rebeccapurple"
        , succeed (Color 0 0 0 0) |. keyword "transparent"
        ]


parse : String -> Result String Color
parse string =
    Parser.run parser string |> Result.mapError Parser.deadEndsToString
