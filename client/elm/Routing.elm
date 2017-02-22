module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)

import Models exposing (Route(..))

matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map SeriesCollectionRoute top
        , map SeriesRoute (s "series" </> int)
        , map SeriesCollectionRoute (s "series")
        , map NewSeriesRoute (s "newSeries")
        , map EpisodeRoute (s "series" </> int </> s "episode" </> int)
        , map NewEpisodeRoute (s "series" </> int </> s "newEpisode")
        , map DeleteEpisodeRoute (s "series" </> int </> s "episode" </> int </> s "delete")
        , map DeleteSeriesRoute (s "series" </> int </> s "delete")
        , map EditEpisodeRoute (s "series" </> int </> s "episode" </> int </> s "edit")
        , map EditSeriesRoute (s "series" </> int </> s "edit")
        ]

parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
    
