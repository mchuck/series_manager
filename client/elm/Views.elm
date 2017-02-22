module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, id, href, src, alt)
import WebData exposing (WebData(..))

import Models exposing (Model, SeriesCollection, Series, Route(..), getSingleSeries, getEpisode, newSeriesModel, newEpisodeModel)
import Messages exposing (Msg(..))

import Views.MenuView
import Views.SeriesSingleView
import Views.SeriesListView
import Views.NewSeriesView
import Views.EpisodeView
import Views.NewEpisodeView
import Views.AreYouSure

-- VIEW
        
view : Model -> Html Msg
view model =
    div [ class "elm-container" ]
        --[ Views.MenuView.view model
        --, page model
        [ page model
        ]

        
page : Model -> Html Msg
page model =
    case model.route of
        SeriesCollectionRoute ->
            Views.SeriesListView.view model.series

        SeriesRoute id ->
            let
                singleSeries = 
                    getSingleSeries model.series id
            in
                case singleSeries of
                    Just s ->
                        Views.SeriesSingleView.view s
                    Nothing ->
                        notFoundView

        NewSeriesRoute ->
            Views.NewSeriesView.view model -1

        EpisodeRoute seriesId episodeId ->
            let
                singleSeries = 
                    getSingleSeries model.series seriesId
                episode =
                    getEpisode singleSeries episodeId
            in
                case singleSeries of
                    Just s ->
                        case episode of
                            Just e ->
                                Views.EpisodeView.view s e
                            _ ->
                                notFoundView
                    Nothing ->
                        notFoundView

        NewEpisodeRoute seriesId ->
            let
                singleSeries = 
                    getSingleSeries model.series seriesId
            in
                case singleSeries of
                    Just s ->
                        Views.NewEpisodeView.view model s -1
                    Nothing ->
                        notFoundView
                            
        NotFoundRoute ->
            notFoundView

        DeleteEpisodeRoute seriesId episodeId ->
            let
                singleSeries = 
                    getSingleSeries model.series seriesId
            in
                case singleSeries of
                    Just s ->
                        Views.AreYouSure.view (DeleteEpisode s episodeId) (ChangeLocation (EpisodeRoute seriesId episodeId))
                    Nothing ->
                        notFoundView

        DeleteSeriesRoute seriesId ->
            Views.AreYouSure.view (DeleteSeries seriesId) (ChangeLocation (SeriesRoute seriesId))

        EditEpisodeRoute seriesId episodeId ->
             let
                singleSeries = 
                    getSingleSeries model.series seriesId
            in
                case singleSeries of
                    Just s ->
                        Views.NewEpisodeView.view model s episodeId
                    Nothing ->
                        notFoundView
                            
        EditSeriesRoute seriesId ->
            Views.NewSeriesView.view model seriesId
                       
notFoundView : Html Msg
notFoundView =
    div []
        [ text "not found"]
