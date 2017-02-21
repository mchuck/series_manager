module Messages exposing (..)

import Http exposing (Error)
import Navigation exposing (Location)
import WebData exposing (WebData)

import Models exposing (SeriesCollection, Series, Route)

type Msg
    = GetSeries
    | ReceiveSeries (WebData SeriesCollection)
    | OnLocationChange Location
    | ChangeLocation Route
    -- New Series
    | NewSeriesNameChange String
    | NewSeriesDescChange String
    | NewSeriesStatChange String
    | NewSeriesFiniChange String
    | NewSeriesDuraChange String
    | NewSeriesDaysChange String
    | NewSeriesTimeChange String
    | SubmitNewSeries
    | AddedSeries (WebData Series)
    -- New Episode
    | NewEpisodeDescChange String
    | NewEpisodeFiniChange String
    | NewEpisodeNumbChange String
    | NewEpisodeSeasChange String
    | SubmitNewEpisode Series
    | AddedEpisode (WebData Series)
    -- Delete
    | DeleteSeries Int
    | DeleteEpisode Series Int
    | OnDelete (Result Http.Error Route)
