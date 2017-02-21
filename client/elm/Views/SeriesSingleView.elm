module Views.SeriesSingleView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import List.Extra
import List

import Messages exposing (Msg(..))
import Models exposing (Series, Episode, dayFromInt)
import Views.Components exposing (Breadcrumb, breadcrumbsComponent, finishedClass, finishedText)

finishedButtonClass : Bool -> String
finishedButtonClass isFinished =
    case isFinished of
        True -> "btn-success"
        False -> "btn-warning"

seasons : Series -> List Int
seasons series =
    series.episodes
        |> List.map (\e -> e.season)
        |> List.Extra.unique
        |> List.sort

seasonEpisodes : Int -> Series -> List Episode
seasonEpisodes season series =
    series.episodes
        |> List.filter (\e -> e.season == season)
        |> List.sortBy .number
           
view : Series -> Html Msg
view model =
    div []
        [ (breadcrumbsComponent
               [ { active = False
                 , href = "#series"
                 , text = "Series"
                 }
               , { active = True
                 , href = ""
                 , text = model.name
                 }
               ])                
        , div [ class "col-xs-6" ]
              [ h3 [ class "pull-left" ]
                    [ text model.name ]
              , h4 [ class (finishedClass model.isFinished), class "finished-text" ]
                    [ text (finishedText model.isFinished) ]
              ]
        , div [ class "col-xs-6" ]   
              [ h3 [ class "pull-right" ]
                    [ text model.station.name ]
              ]
        , div [ class "col-xs-12" ]
              [ h4 []
                    [ text ((dayFromInt model.day) ++ " " ++ model.time ++ " / " ++ (toString model.duration) ++ "min" ) ]
              ]
        , div [ class "col-xs-12" ]
              [ p []
                    [ text model.description ]
              ]
        , div [ class "col-xs-12" ]
              (List.map (\s -> seasonView s model) (seasons model))
        , div [ class "col-xs-12 top-margin-20" ]
              [ div [ class "col-xs-12 top-margin-20" ]
                    [ div [ class "col-xs-6" ]
                          [ a [ class "col-xs-12 btn btn-info", href ("#series/" ++ (toString model.id) ++ "/newEpisode") ]
                                [ text "Add new episode" ]
                          ]
                    , div [ class "col-xs-6" ]
                        [ a [ class "col-xs-12 btn btn-danger", href ("#series/" ++ (toString model.id) ++ "/delete") ]
                              [ text "Delete this series" ]
                        ]
                    ]
              ]
        ]

seasonView : Int -> Series -> Html Msg
seasonView season model =
    div []
        [ div [ class "col-xs-12" ]
              [ p []
                    [ text ("Season " ++ (toString season) ) ]
              ]
        , div [ class "col-xs-12" ]
              (episodesView (seasonEpisodes season model) model)
        ]

episodesView : List Episode -> Series -> List (Html Msg)
episodesView episodes series =
    episodes
        |> List.map (\e ->
                         div [ class "col-xs-2 episode-btn" ]
                         [ a
                               [ class "col-xs-12 btn btn-sm"
                               , class (finishedButtonClass e.isFinished)
                               , href ("#series/" ++ (toString series.id) ++ "/episode/" ++ (toString e.id))
                               ]
                               [ text ("Ep " ++ (toString e.number))]
                         ]
                    )

         
        
       
