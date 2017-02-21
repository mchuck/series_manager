module Messages exposing (..)

import Http exposing (Error)
import Navigation exposing (Location)
import WebData exposing (WebData)

import Models exposing (SeriesCollection, Series)

type Msg
    = GetSeries
    | ReceiveSeries (WebData SeriesCollection)
    | OnLocationChange Location
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

