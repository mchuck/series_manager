module Views.MenuView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, attribute, href, id)

import Models exposing (Model)
import Messages exposing (Msg)

view : Model -> Html Msg
view model =
    nav [ class "navbar navbar-default navbar-fixed-top" ]
        [ div [ class "container" ]
              [ div  [class "navbar-header" ]
                    [ button [ class "navbar-toggle collapsed", attribute "data-toggle" "collapse", attribute "data-target" "#navbar" ]
                          [ span [ class "sr-only" ]
                                [ text "Toggle navigation" ]
                          , span [ class "icon-bar" ] []
                          , span [ class "icon-bar" ] []
                          , span [ class "icon-bar" ] []
                          ]     
                    , a [ class "navbar-brand", href "#" ]
                        [ text "Series Manager" ]
                    ]
              , div [ id "navbar", class "collapse navbar-collapse"]
                  [ ul [ class "nav navbar-nav" ]
                        [ li [ class "active" ]
                              [ a [ href "#" ]
                                    [ text "Home" ]
                              ]
                        ,li [ ]
                            [ a [ href "#" ]
                                  [ text "Home" ]
                            ]
                        ,li [ ]
                            [ a [ href "#" ]
                                  [ text "Home" ]
                            ]
                        ]
                  ]
              ]
        ]
