module App exposing (..)


import WebData exposing (WebData(..))
import WebData.Http
import Http exposing (send, emptyBody)
import Navigation exposing (Location)
import String exposing (toInt)

import Messages exposing (Msg(..))
import Models exposing (Model, Series, Route(..)
                       , singleSeriesEncoder
                       , seriesDecoder
                       , singleSeriesDecoder
                       , initialModel
                       , intFromDay
                       , newSeriesModel
                       , newEpisodeModel)
import Views exposing (..)
import Routing exposing (parseLocation)


-- INIT

init : Location -> (Model, Cmd Msg)
init location =
    let
        currentRoute =
            parseLocation location
    in
        (initialModel currentRoute, getSeries)

-- UPDATE



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let
        newS = model.newSeries
        newE = model.newEpisode
    in
        case msg of
            GetSeries ->
                (model, getSeries)
        
            ReceiveSeries (Success data) ->
                ({model | series = Success data}, Cmd.none)
                            
            ReceiveSeries (NotAsked) ->
                (model, Cmd.none)

            ReceiveSeries (Failure _) ->
                (model, Cmd.none)

            ReceiveSeries (Loading) ->
                (model, Cmd.none)

            OnLocationChange location ->
                let
                    newRoute =
                        parseLocation location
                in
                    ({ model | route = newRoute }, Cmd.none)

            ChangeLocation newRoute ->
                ({ model | route = newRoute }, Cmd.none)
                        
            NewSeriesNameChange newName ->
                let
                    updatedSeries = { newS | name = newName }
                in
                    ({ model | newSeries = updatedSeries }, Cmd.none)
                        
            NewSeriesDescChange newDescription ->
                let
                    updatedSeries = { newS | description = newDescription }
                in
                    ({ model | newSeries = updatedSeries }, Cmd.none)
                        
            NewSeriesStatChange newStation ->
                let
                    updatedSeries = { newS | station =
                                          { id = -1
                                          , name = newStation
                                          }
                                    }
                in
                    ({ model | newSeries = updatedSeries }, Cmd.none)
                                          
            NewSeriesFiniChange _ ->
                let
                    updatedSeries = { newS | isFinished = not newS.isFinished }
                in
                    ({ model | newSeries = updatedSeries }, Cmd.none)
                                          
            NewSeriesDuraChange newDuration ->
                let
                    durationInt = toInt newDuration
                    updatedSeries = case durationInt of
                                        Ok d ->
                                            { newS | duration = d }
                                        _ ->
                                            newS    
                in
                    ({ model | newSeries = updatedSeries }, Cmd.none)
                       
            NewSeriesDaysChange newDay ->
                let
                    updatedSeries = { newS | day = intFromDay newDay }
                in
                    ({ model | newSeries = updatedSeries }, Cmd.none)
                                          
            NewSeriesTimeChange newTime ->
                let
                    updatedSeries = { newS | time = newTime }
                in
                    ({ model | newSeries = updatedSeries }, Cmd.none)

            SubmitSeries seriesId->
                let
                    series = { newS | id = seriesId }
                in
                    case seriesId of
                        -1 ->
                            (model, submitSeries series)
                        _ ->
                            (model, updateSeries series)

            AddedSeries series ->
                update GetSeries { model | route = SeriesCollectionRoute }

            AddedEpisode series ->
                let
                    newRoute =
                        case series of
                            Success s->
                                SeriesRoute s.id
                            _ ->
                                SeriesCollectionRoute 
                in
                    update GetSeries { model | route = newRoute }

            NewEpisodeDescChange newDescription ->
                let
                    updatedEpisode = { newE | description = newDescription }
                in
                    ({model | newEpisode = updatedEpisode}, Cmd.none)

            NewEpisodeFiniChange _ ->
                let
                    updatedEpisode = { newE | isFinished = not newE.isFinished }
                in
                    ({model | newEpisode = updatedEpisode}, Cmd.none)       
                    
            NewEpisodeNumbChange newNumber ->
                let
                    numberInt = toInt newNumber
                    updatedEpisode = case numberInt of
                                        Ok n ->
                                            { newE | number = n }
                                        _ ->
                                            newE    
                in
                    ({model | newEpisode = updatedEpisode}, Cmd.none)

            NewEpisodeSeasChange newSeason ->
                let
                    seasonInt = toInt newSeason
                    updatedEpisode = case seasonInt of
                                        Ok s ->
                                            { newE | season = s }
                                        _ ->
                                            newE    
                in
                    ({model | newEpisode = updatedEpisode}, Cmd.none)

            SubmitEpisode series episodeId ->
                let
                    newEpisode = { newE | id = episodeId }
                    newEpisodes =
                        series.episodes
                            |> List.filter (\e -> e.id /= episodeId)
                    newSeries = { series | episodes = newEpisode :: newEpisodes }
                in
                    (model, updateSeries newSeries)

            DeleteSeries seriesId ->
                (model, deleteSeries seriesId SeriesCollectionRoute)

            DeleteEpisode series episodeId ->
                let
                    newEpisodes =
                        series.episodes
                            |> List.filter (\e -> e.id /= episodeId)
                    newSeries = { series | episodes = newEpisodes }
                in
                    (model, updateSeries newSeries)

            OnDelete (Ok callbackRoute) ->
                update GetSeries { model | route = callbackRoute }

            OnDelete (Err _) ->
               ({ model | route = SeriesCollectionRoute }, Cmd.none )


            EditSeries series ->
               let
                   seriesId = series.id
               in
                   ({ model | newSeries = series, route = (EditSeriesRoute seriesId)}, Cmd.none)

            EditEpisode series episode ->
                let
                    seriesId = series.id
                    episodeId = episode.id
                in
                    ({model | newEpisode = episode, route = (EditEpisodeRoute seriesId episodeId)}, Cmd.none)

            AddNewSeries ->
                ({ model | newSeries = newSeriesModel, route = NewSeriesRoute}, Cmd.none)

            AddNewEpisode seriesId ->
                ({ model | newEpisode = newEpisodeModel, route = (NewEpisodeRoute seriesId)}, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
                
            
-- HTTP

getSeries : Cmd Msg
getSeries =
    let
        url =
            "http://localhost:8080/series"
    in
        WebData.Http.get url ReceiveSeries seriesDecoder

submitSeries : Series -> Cmd Msg
submitSeries newSeries =
    let
        url =
            "http://localhost:8080/series"
    in
        WebData.Http.post url AddedSeries singleSeriesDecoder (singleSeriesEncoder newSeries)

updateSeries : Series -> Cmd Msg
updateSeries newSeries =
    let
        url =
            "http://localhost:8080/series"
    in
        WebData.Http.put url AddedEpisode singleSeriesDecoder (singleSeriesEncoder newSeries)
         
deleteSeries : Int -> Route -> Cmd Msg
deleteSeries seriesId callbackRoute =
    let
        url =
            "http://localhost:8080/series/" ++ (toString seriesId)
        request =
            Http.request
                { method = "delete"
                , headers = []
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectStringResponse (\r -> Ok callbackRoute)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send OnDelete request
        

