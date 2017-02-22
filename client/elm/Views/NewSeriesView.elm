module Views.NewSeriesView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, attribute)
import Html.Events exposing (onClick)

import Models exposing (Model, Series, daysOfWeek, dayFromInt)
import Messages exposing (Msg(..))
import Views.Components exposing (Breadcrumb, FormGroup, FormControl(..), breadcrumbsComponent, formGroupComponent)

view : Model -> Int -> Html Msg
view model seriesId =
    div [ ]
        [ (breadcrumbsComponent
               [ { active = False
                 , href = "#series"
                 , text = "Series"
                 }
               , { active = True
                 , href = ""
                 , text = "New series"
                 }
               ])
        , div [ class "col-xs-12" ]
              [ h3 [ class "text-info" ]
                    [ text "New series" ]
              ]
        , form [ class "col-xs-12 form-horizontal" ]
            [ formGroupComponent { id = "name"
                                 , label = "Name"
                                 , controlType = "text"
                                 , control = Input
                                 , options = []
                                 , action = NewSeriesNameChange
                                 , value = Just model.newSeries.name
                                 }
            , formGroupComponent { id = "description"
                                 , label = "Description"
                                 , controlType = ""
                                 , control = TextArea
                                 , options = []
                                 , action = NewSeriesDescChange
                                 , value = Just model.newSeries.description
                                 }
            , formGroupComponent { id = "station"
                                 , label = "Station Name"
                                 , controlType = "text"
                                 , control = Input
                                 , options = []
                                 , action = NewSeriesStatChange
                                 , value = Just model.newSeries.station.name
                                 }
            , formGroupComponent { id = "isFinished"
                                 , label = "Finished"
                                 , controlType = ""
                                 , control = CheckBox
                                 , options = []
                                 , action = NewSeriesFiniChange
                                 , value =
                                     case model.newSeries.isFinished of
                                         True ->
                                             Just "checked"
                                         _ ->
                                             Nothing
                                 }
            , formGroupComponent { id = "duration"
                                 , label = "Duration (in minutes)"
                                 , controlType = "number"
                                 , control = Input
                                 , options = []
                                 , action = NewSeriesDuraChange
                                 , value = Just (toString model.newSeries.duration)
                                 }
            , formGroupComponent { id = "day"
                                 , label = "Day"
                                 , controlType = "text"
                                 , control = Option
                                 , options = daysOfWeek
                                 , action = NewSeriesDaysChange
                                 , value = Just (dayFromInt model.newSeries.day)
                                 }
            , formGroupComponent { id = "time"
                                 , label = "Time"
                                 , controlType = "text"
                                 , control = Input
                                 , options = []
                                 , action = NewSeriesTimeChange
                                 , value = Just model.newSeries.time
                                 }
            , div [ class "form-group" ]
                  [ div [ class "col-xs-12" ]
                        [ button [ attribute "type" "submit", class "btn btn-info col-xs-12", onClick (SubmitSeries seriesId) ]
                              [ text "Save" ]
                        ]
                  ]
            ]
        ]
