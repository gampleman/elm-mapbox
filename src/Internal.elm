module Internal exposing (Expression(..), Layer(..), Source(..), Style(..), Supported, styleProperties)

import Dict exposing (Dict)
import Html exposing (Attribute)
import Html.Attributes exposing (property)
import Json.Encode as Encode exposing (Value)


type Expression exprType resultType
    = Expression Value


type Supported
    = Supported


type Layer msg
    = Layer
        { id : String
        , source : Maybe Source
        , tipe : String
        , properties : List ( String, Value )
        , events : List (Attribute msg)
        }


type Source
    = Source String Value


type Style msg
    = Style (List (Layer msg)) (List ( String, Value ))
    | FromUrl String (List ( String, Layer msg ))


sourceId : Source -> String
sourceId (Source id _) =
    id


gatherLayers : List ( String, Layer msg ) -> List ( String, List (Layer msg) )
gatherLayers list =
    let
        helper scattered gathered =
            case scattered of
                [] ->
                    List.reverse gathered

                ( insertionKey, layer ) :: population ->
                    let
                        ( gathering, remaining ) =
                            List.partition (\( secondKey, _ ) -> insertionKey == secondKey) population
                    in
                    helper remaining <| ( insertionKey, layer :: List.map Tuple.second gathering ) :: gathered
    in
    helper list []


tag : String -> Value -> Value
tag key val =
    Encode.object [ ( "type", Encode.string key ), ( "value", val ) ]


styleProperties : Style msg -> List (Attribute msg)
styleProperties style =
    case style of
        Style layers attrs ->
            let
                ( eventListeners, sources ) =
                    extractEventsAndSources (List.reverse layers)
            in
            ([ ( "version", Encode.int 8 )
             , ( "sources", Encode.object <| List.map (\source -> ( sourceId source, encodeSource source )) <| Dict.values <| sources )
             , ( "layers", Encode.list encodeLayer layers )
             ]
                ++ attrs
                |> Encode.object
                |> tag "literal-style"
                |> property "mapboxStyle"
            )
                :: eventListeners

        FromUrl url additional ->
            let
                organizedLayers =
                    gatherLayers additional

                ( eventListeners, sources ) =
                    extractEventsAndSources (List.map Tuple.second additional)
            in
            ([ ( "url", Encode.string url )
             , ( "sources", Encode.object <| List.map (\source -> ( sourceId source, encodeSource source )) <| Dict.values <| sources )
             , ( "layers", Encode.object (List.map (Tuple.mapSecond (Encode.list encodeLayer)) organizedLayers) )
             ]
                |> Debug.log "fromURL"
                |> Encode.object
                |> tag "remote-style"
                |> property "mapboxStyle"
            )
                :: eventListeners


extractEventsAndSources : List (Layer msg) -> ( List (Attribute msg), Dict String Source )
extractEventsAndSources layers =
    List.foldl
        (\(Layer { source, events }) ( eventList, sourceDict ) ->
            ( eventList ++ events
            , case source of
                Just s ->
                    Dict.insert (sourceId s) s sourceDict

                Nothing ->
                    sourceDict
            )
        )
        ( [], Dict.empty )
        layers


{-| Turns a layer into JSON
-}
encodeLayer : Layer msg -> Value
encodeLayer (Layer value) =
    [ ( "type", Encode.string value.tipe )
    , ( "id", Encode.string value.id )
    ]
        ++ value.properties
        |> prependMaybe (Maybe.map (sourceId >> Encode.string >> Tuple.pair "source") value.source)
        |> Encode.object


prependMaybe : Maybe a -> List a -> List a
prependMaybe a xs =
    case a of
        Just x ->
            x :: xs

        Nothing ->
            xs


{-| -}
encodeSource : Source -> Value
encodeSource (Source _ value) =
    value
