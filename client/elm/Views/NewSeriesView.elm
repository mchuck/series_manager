module Views.NewSeriesView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, attribute)
import Html.Events exposing (onClick)

import Models exposing (Model, daysOfWeek)
import Messages exposing (Msg(..))
import Views.Components exposing (Breadcrumb, FormGroup, FormControl(..), breadcrumbsComponent, formGroupComponent)

view : Model -> Html Msg
view model =
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
                                 }
            , formGroupComponent { id = "description"
                                 , label = "Description"
                                 , controlType = ""
                                 , control = TextArea
                                 , options = []
                                 , action = NewSeriesDescChange
                                 }
            , formGroupComponent { id = "station"
                                 , label = "Station Name"
                                 , controlType = "text"
                                 , control = Input
                                 , options = []
                                 , action = NewSeriesStatChange
                                 }
            , formGroupComponent { id = "isFinished"
                                 , label = "Finished"
                                 , controlType = ""
                                 , control = CheckBox
                                 , options = []
                                 , action = NewSeriesFiniChange
                                 }
            , formGroupComponent { id = "duration"
                                 , label = "Duration (in minutes)"
                                 , controlType = "number"
                                 , control = Input
                                 , options = []
                                 , action = NewSeriesDuraChange
                                 }
            , formGroupComponent { id = "day"
                                 , label = "Day"
                                 , controlType = "text"
                                 , control = Option
                                 , options = daysOfWeek
                                 , action = NewSeriesDaysChange
                                 }
            , formGroupComponent { id = "time"
                                 , label = "Time"
                                 , controlType = "text"
                                 , control = Input
                                 , options = []
                                 , action = NewSeriesTimeChange
                                 }
            , div [ class "form-group" ]
                  [ div [ class "col-xs-12" ]
                        [ button [ attribute "type" "submit", class "btn btn-info col-xs-12", onClick SubmitNewSeries ]
                              [ text "Add series" ]
                        ]
                  ]
            ]
        ]
