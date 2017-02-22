module Views.SeriesListView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, id, href, src, alt)
import Html.Events exposing (onClick)
import WebData exposing (WebData(..))

import Models exposing (Model, SeriesCollection, Series)
import Messages exposing (Msg(..))
import Views.Components exposing (Breadcrumb, breadcrumbsComponent)

view : (WebData SeriesCollection) -> Html Msg
view model =
    div []
        [ (breadcrumbsComponent
               [ { active = True
                 , href = ""
                 , text = "Series"
                 }            
               ])
        , div [ class "container" ]
            [ div [ class "row" ]
                [ span [ class "btn btn-info col-xs-12", onClick AddNewSeries ]
                      [ text "New series" ]      
                ]
            , baseView model       
            ]
        ]

baseView : (WebData SeriesCollection) -> Html Msg
baseView series =
    case series of
        Success s ->
            div [ class "top-margin-20" ]
               ( seriesCollectionView s )
        Loading ->
            div []
                [ text "Loading..." ]
        _ ->
            div [] []

seriesCollectionView : SeriesCollection -> List (Html Msg)
seriesCollectionView seriesCollection =
        List.map (\s -> seriesCard s) seriesCollection
   
seriesCard : Series -> Html Msg
seriesCard series =
    let
        episodesCount = List.length series.episodes
        episodesEnd =
            case episodesCount of
                1 -> ""
                _ -> "s"
    in
        div [ class "row" ]
            [ div [ class "thumbnail" ]
                  --[ img [ src "", alt "image" ] []
                  --, div [ class "caption" ]
                  [ div [ class "caption" ]
                      [ h4 []
                            [ text series.name ]
                      , p []
                          [ text series.description ]
                      , p []
                          [ a [ class "btn btn-info btn-sm", href ("#series/" ++ (toString series.id)) ]
                                [ text ("Open (" ++ toString episodesCount ++ " episode" ++ episodesEnd ++ ")") ]
                          ]
                      ]
                  ]
            ]
