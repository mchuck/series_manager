module Views.Components exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, attribute, id, for, required)
import Html.Events exposing (onInput, onClick)
import List

import Messages exposing (Msg(..))

type alias Breadcrumb =
    { active : Bool
    , href : String
    , text : String
    }

finishedClass : Bool -> String
finishedClass isFinished =
    case isFinished of
        True -> "text-danger"
        False -> "text-success"

finishedText : Bool -> String
finishedText isFinished =
    case isFinished of
        True -> "FINISHED"
        False -> "ONGOING"

breadcrumbsComponent : List Breadcrumb -> Html Msg
breadcrumbsComponent breadcrumbs =
    ol [ class "breadcrumb" ]
        (List.map (\b -> breadcrumb b) breadcrumbs)

bcClass : Bool -> String
bcClass active =
    case active of
        True ->
            "active"
        _ ->
            ""

            
breadcrumb : Breadcrumb -> Html Msg
breadcrumb bc =
    li [ class "breadcrumb-item", class (bcClass bc.active) ]
        [ case bc.active of
              False ->
                  a [ href bc.href ]
                      [ text bc.text ]
              True ->
                  text bc.text
        ]

type FormControl
    = Input
    | TextArea
    | CheckBox
    | Option
        
type alias FormGroup =
    { id : String
    , label : String
    , controlType : String
    , control : FormControl
    , options : List String
    , action : String -> Msg
    }

formGroupComponent : FormGroup -> Html Msg
formGroupComponent fg =
    div [ class "form-group" ]
        [ case fg.control of
              CheckBox ->
                  span [] []
              _ ->
                  label [ class "control-label col-xs-2", for fg.id ]
                      [ text fg.label ]
        , div [ class "col-xs-10", class (case fg.control of
                                              CheckBox ->
                                                  "col-sm-offset-2"
                                              _ ->
                                                  ""
                                         ) ]
              [ case fg.control of
                    Input ->
                        input [ attribute "type" fg.controlType, class "form-control", id fg.id, required True, onInput fg.action ]
                            []
                    TextArea ->
                        textarea [ class "form-control", id fg.id, required True, onInput fg.action  ] []
                    CheckBox ->
                        div [ class "checkbox" ]
                            [ label [ for fg.id ]
                                  [ input [ attribute "type" "checkbox", required True, onClick (fg.action "")  ] []
                                  , text fg.label
                                  ]
                            ]
                    Option ->
                        select [ class "form-control", id fg.id, required True, onInput fg.action  ]
                            (List.map (\i -> option [] [ text i ] ) fg.options)
              ]
        ]
            
