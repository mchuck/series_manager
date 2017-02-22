module Views.EpisodeView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Views.Components exposing (breadcrumbsComponent, finishedClass, finishedText)
import Models exposing (Series, Episode, getEpisode)
import Messages exposing (Msg(..))


view : Series -> Episode -> Html Msg
view series episode =
    div []
        [ (breadcrumbsComponent
               [ { active = False
                 , href = "#series"
                 , text = "Series"
                 }
               , { active = False
                 , href = "#series/" ++ (toString series.id)
                 , text = series.name
                 }
               , { active = True
                 , href = ""
                 , text = "Ep " ++ (toString episode.number)
                 }
               ])
        , div [ class "col-xs-12" ]
              [ h3 [ class "pull-left" ]
                    [ text ("Episode " ++ (toString episode.number)) ]
              , h4 [ class (finishedClass episode.isFinished), class "finished-text" ]
                    [ text (finishedText episode.isFinished) ]
              ]
        , div [ class "col-xs-12" ]
              [ h4 []
                    [ text ("Season " ++ (toString episode.season)) ]
              ]
        , div [ class "col-xs-12" ]
              [ p []
                    [ text episode.description ]
              ]
        , div [ class "col-xs-12 top-margin-20" ]
              [ div [ class "col-xs-6" ]
                    [ span
                      [ class "col-xs-12 btn btn-warning"
                      , onClick (EditEpisode series episode)
                      ]
                      [ text "Edit episode" ]
                    ]
              , div [ class "col-xs-6" ]
                    [ a
                      [ class "col-xs-12 btn btn-danger"
                      , href ("#series/" ++ (toString series.id) ++ "/episode/" ++ (toString episode.id) ++ "/delete")
                      ]
                      [ text "Delete episode" ]
                    ]
              ]
        ]
                                     
        
