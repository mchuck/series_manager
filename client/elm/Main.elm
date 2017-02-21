module Main exposing (..)

import Html exposing (Html)
import Navigation


import App exposing (init, update, subscriptions)
import Models exposing (Model)
import Messages exposing (Msg(..))
import Views exposing (view)


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
        

        
