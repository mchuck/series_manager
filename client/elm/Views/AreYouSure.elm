module Views.AreYouSure exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Messages exposing (Msg)

view : Msg -> Msg -> Html Msg
view okAction noAction =
    div [ ]
        [ div [ class "col-xs-12" ]
              [ h3 [ class "text-center" ]
                    [ text "Are you sure?" ]
              ]
        , div [ class "col-xs-12 top-margin-20" ]
              [ div [ class "col-xs-6" ]
                    [ span [ class "btn btn-success col-xs-12", onClick okAction ]
                          [ text "Yes" ]
                    ]
              ,div [ class "col-xs-6" ]
                    [ span [ class "btn btn-danger col-xs-12", onClick noAction ]
                          [ text "No" ]
                    ]
              ]
        ]
                    
