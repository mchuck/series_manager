module Messages exposing (..)

import Http exposing (Error)
import Navigation exposing (Location)
import WebData exposing (WebData)

import Models exposing (SeriesCollection, Series, Episode, Route)

type Msg
    = GetSeries
    | ReceiveSeries (WebData SeriesCollection)
    | OnLocationChange Location
    | ChangeLocation Route
    -- New Series
    | AddNewSeries
    | NewSeriesNameChange String
    | NewSeriesDescChange String
    | NewSeriesStatChange String
    | NewSeriesFiniChange String
    | NewSeriesDuraChange String
    | NewSeriesDaysChange String
    | NewSeriesTimeChange String
    | SubmitSeries Int
    | AddedSeries (WebData Series)
    -- EditSeries
    | EditSeries Series
    -- New Episode
    | AddNewEpisode Int
    | NewEpisodeDescChange String
    | NewEpisodeFiniChange String
    | NewEpisodeNumbChange String
    | NewEpisodeSeasChange String
    | SubmitEpisode Series Int
    | AddedEpisode (WebData Series)
    -- Edit Episode
    | EditEpisode Series Episode
    -- Delete
    | DeleteSeries Int
    | DeleteEpisode Series Int
    | OnDelete (Result Http.Error Route)
