module Models exposing (..)

import Json.Decode exposing (Decoder, int, string, bool, list)
import Json.Encode
import Json.Decode.Pipeline exposing (required, decode)
import Http exposing (Error)
import WebData exposing (WebData(..))
import List
import List.Extra

type Route
    = SeriesCollectionRoute
    | SeriesRoute SeriesId
    | NewSeriesRoute
    | NotFoundRoute
    | EpisodeRoute SeriesId EpisodeId
    | NewEpisodeRoute SeriesId
    | DeleteEpisodeRoute SeriesId EpisodeId
    | DeleteSeriesRoute SeriesId
      
type alias Model =
    { series : WebData (SeriesCollection)
    , newSeries : Series
    , newEpisode : Episode
    , route : Route
    } 

initialModel : Route -> Model
initialModel route =
    { series = WebData.Loading
    , newSeries =
          { id = -1
          , name = ""
          , description = ""
          , station =
              { id = -1
              , name = ""
              }
          , isFinished = False
          , duration = 0
          , day = 0
          , time = ""
          , episodes = []
          }
    , newEpisode =
        { id = -1
        , description = ""
        , isFinished = False
        , season = -1
        , number = -1
        }                   
    , route = route
    }
        
    
type alias SeriesId =
    Int

type alias EpisodeId =
    Int

type alias StationId =
    Int
    
type alias Station =
    { id : StationId
    , name : String
    }

type alias Episode =
    { id : EpisodeId
    , description : String
    , isFinished : Bool
    , number : Int
    , season : Int
    }                      

type alias Series =
    { id : SeriesId
    , name : String
    , description : String
    , station : Station
    , isFinished : Bool
    , duration : Int
    , day : Int
    , time : String
    , episodes : List Episode
    }

type alias SeriesCollection = (List Series)

episodeDecoder : Decoder Episode
episodeDecoder =
    decode Episode
        |> required "id" int
        |> required "description" string
        |> required "isFinished" bool
        |> required "number" int
        |> required "season" int

stationDecoder : Decoder Station
stationDecoder =
    decode Station
        |> required "id" int
        |> required "name" string

singleSeriesDecoder : Decoder Series
singleSeriesDecoder =
    decode Series
        |> required "id" int
        |> required "name" string
        |> required "description" string
        |> required "station" stationDecoder
        |> required "isFinished" bool
        |> required "duration" int
        |> required "day" int
        |> required "time" string
        |> required "episodes" (list episodeDecoder)

seriesDecoder :  Decoder SeriesCollection
seriesDecoder =
    list singleSeriesDecoder

singleSeriesEncoder : Series -> Json.Encode.Value
singleSeriesEncoder series =
    Json.Encode.object
        [ ("id",  Json.Encode.int <| series.id)
        , ("name",  Json.Encode.string <| series.name)
        , ("description",  Json.Encode.string <| series.description)
        , ("station",  stationEncoder <| series.station)
        , ("isFinished",  Json.Encode.bool <| series.isFinished)
        , ("duration",  Json.Encode.int <| series.duration)
        , ("day",  Json.Encode.int <| series.day)
        , ("time",  Json.Encode.string <| series.time)
        , ("episodes",  Json.Encode.list <| List.map episodeEncoder <| series.episodes)
        ]
        
stationEncoder : Station -> Json.Encode.Value
stationEncoder station =
    Json.Encode.object
        [ ("id",  Json.Encode.int <| station.id)
        , ("name",  Json.Encode.string <| station.name)
        ]

episodeEncoder : Episode -> Json.Encode.Value
episodeEncoder episode =
    Json.Encode.object
        [ ("id",  Json.Encode.int <| episode.id)
        , ("description", Json.Encode.string <| episode.description)
        , ("isFinished",  Json.Encode.bool <| episode.isFinished)
        , ("number",  Json.Encode.int <| episode.number)
        , ("season",  Json.Encode.int <| episode.season)
        ]

daysOfWeek : List String
daysOfWeek =
    [ "Monday"
    , "Tuesday"
    , "Wednesday"
    , "Thursday"
    , "Friday"
    , "Saturday"
    , "Sunday"
    ]


getSingleSeries : (WebData SeriesCollection) -> Int -> Maybe Series
getSingleSeries seriesCollection id =
    case seriesCollection of
        Success collection ->
            collection
                |> List.filter (\s -> s.id == id)
                |> List.head
        _ ->
            Nothing

getEpisode : Maybe Series -> Int -> Maybe Episode
getEpisode series episodeId =
    case series of
        Nothing ->
            Nothing
        Just s ->
            s.episodes
                |> List.filter (\e -> e.id == episodeId)
                |> List.head
             
dayFromInt : Int -> String
dayFromInt day =
    let
        dayString = List.Extra.getAt day daysOfWeek
    in
        case dayString of
            Just s ->
                s
            _ ->
                ""

intFromDay : String -> Int
intFromDay day =
    let
        dayNumber = List.Extra.elemIndex day daysOfWeek
    in
        case dayNumber of
            Just n ->
                n
            _ ->
                -1
