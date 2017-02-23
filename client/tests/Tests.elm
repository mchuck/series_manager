module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String

import Models exposing (..)
import Json.Decode exposing (..)

mockEpisode1 : Episode
mockEpisode1 =
        { id = 1
        , description = "Desc 1"
        , isFinished = False
        , season = 1
        , number = 1
        }

mockEpisode2 : Episode
mockEpisode2 =
        { id = 2
        , description = "Desc 2"
        , isFinished = False
        , season = 1
        , number = 2
        }
    
mockSeries : Series
mockSeries =
          { id = 1
          , name = "Name"
          , description = "Desc"
          , station =
              { id = 1
              , name = "Station 1"
              }
          , isFinished = False
          , duration = 60
          , day = 1
          , time = "19:00"
          , episodes =
                [ mockEpisode1
                , mockEpisode2]
          }

all : Test
all =
    describe "Model test suite"
        
            [ test "Encoding" <|
                \() ->
                    Expect.equal (Ok mockSeries) (decodeValue singleSeriesDecoder (singleSeriesEncoder mockSeries))
            , test "Getting Episode 1" <|
                \() ->
                    Expect.equal (getEpisode (Just mockSeries) 1) (Just mockEpisode1)
            , test "Getting Episode 2" <|
                \() ->
                    Expect.equal (getEpisode (Just mockSeries) 2) (Just mockEpisode2)
            , test "Seek for episode which doesn't exist" <|
                \() ->
                    Expect.equal (getEpisode (Just mockSeries) 5) (Nothing)
            , test "Get day from string" <|
                \() ->
                    Expect.equal (intFromDay "Monday") 0
            , test "Get day from random string" <|
                \() ->
                    Expect.equal (intFromDay "sadsa") -1
            , test "Get day string from int" <|
                \() ->
                    Expect.equal (dayFromInt 2) "Wednesday"
            , test "Get day string from random int" <|
                \() ->
                    Expect.equal (dayFromInt 12321) ""
            ]

        
