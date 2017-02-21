module App exposing (..)


import WebData exposing (WebData(..))
import WebData.Http
import Navigation exposing (Location)
import String exposing (toInt)

import Messages exposing (Msg(..))
import Models exposing (Model, Series, Route(..), singleSeriesEncoder, seriesDecoder, singleSeriesDecoder, initialModel, intFromDay)
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
                                          
            NewSeriesFiniChange newIsFinished ->
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

            SubmitNewSeries ->
                (model, submitSeries model.newSeries)

            AddedSeries series ->
                update GetSeries { model | route = SeriesCollectionRoute }
                    
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


