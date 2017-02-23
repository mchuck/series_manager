module Views.NewEpisodeView exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, attribute)

import Models exposing (Model, Series, Episode)
import Messages exposing (Msg(..))
import Views.Components exposing (breadcrumbsComponent, FormControl(..), formGroupComponent)

view : Model -> Series -> Int -> Html Msg
view model series episodeId =
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
                 , text = "New episode"
                 }
               ])
        , form [ class "col-xs-12 form-horizontal" ]
            [ formGroupComponent { id = "description"
                                 , label = "Description"
                                 , controlType = ""
                                 , control = TextArea
                                 , options = []
                                 , action = NewEpisodeDescChange
                                 , value = Just model.newEpisode.description                               
                                 }
            , formGroupComponent { id = "isFinished"
                                 , label = "Finished"
                                 , controlType = ""
                                 , control = CheckBox
                                 , options = []
                                 , action = NewEpisodeFiniChange
                                 , value =
                                     case model.newEpisode.isFinished of
                                         True ->
                                             Just "checked"
                                         _ ->
                                             Nothing
                                 }
            , formGroupComponent { id = "number"
                                 , label = "Number"
                                 , controlType = "number"
                                 , control = Input
                                 , options = []
                                 , action = NewEpisodeNumbChange
                                 , value = Just (toString model.newEpisode.number)
                                 }
            , formGroupComponent { id = "season"
                                 , label = "Season"
                                 , controlType = "number"
                                 , control = Input
                                 , options = []
                                 , action = NewEpisodeSeasChange
                                 , value = Just (toString model.newEpisode.season) 
                                 }
            , div [ class "form-group" ]
                  [ div [ class "col-xs-12" ]
                        [ button [ attribute "type" "submit"
                                 , class "btn btn-info col-xs-12"
                                 , onClick (SubmitEpisode series episodeId) ]
                              [ text "Add episode" ]
                        ]
                  ]
            ]
        ]
         
