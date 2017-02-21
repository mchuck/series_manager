namespace SeriesRestApi.Db

open System.Collections.Generic

open FSharp.Data.Sql

type Station = {
    Id : int64
    Name : string
}

type Episode = {
    Id : int64
    Description : string
    IsFinished : bool
    Number : int64
    Season : int64
}

type Series = {
    Id : int64
    Name : string
    Description : string
    Station : Station
    IsFinished : bool
    Duration : int64
    Day : int64
    Time : string
    Episodes : Episode seq
}

module Db =
    
    [<Literal>]
    let private connectionString = 
        "Data Source=" + 
        __SOURCE_DIRECTORY__ + @"/series.db;" + 
        "Version=3;foreign keys=true"

    type sql = SqlDataProvider<
                Common.DatabaseProviderTypes.SQLITE, 
                SQLiteLibrary = Common.SQLiteLibrary.MonoDataSQLite,
                ConnectionString = connectionString, 
                CaseSensitivityChange = Common.CaseSensitivityChange.ORIGINAL>

    let private ctx = sql.GetDataContext()

    let private seriesDb = ctx.Main.Series
    let private episodesDb = ctx.Main.Episodes
    let private stationsDb = ctx.Main.Stations

    let private stationById stationId =
        query {
            for station in stationsDb do
            where (station.Id = stationId)
            select (station)
        } |> Seq.head

    let private stationByName stationName =
        query {
            for station in stationsDb do
            where (station.Name = stationName)
            select (station)
        } |> Seq.first

    let private episodesBySeriesId id =
        query {
            for episode in episodesDb do
            where (episode.SeriesId = id)
            select (episode)
        } |> Seq.toList

    let private episodeByData seriesId (ep : Episode) =
        query {
            for episode in episodesDb do
            where (episode.SeriesId = seriesId &&
                   episode.Number = ep.Number &&
                   episode.Season = ep.Season)
            select (episode)
        } |> Seq.first

    let private seriesById id =
        query {
            for series in seriesDb do
            where (series.Id = id)
            select (series)
        } |> Seq.first

    let private stationIdByName name =
        let station =
            stationByName name

        match station with
            | Some s -> s.Id
            | _ -> 
                let newStation = stationsDb.Create()
                newStation.Name <- name
                ctx.SubmitUpdates()
                newStation.Id

    let private setSeriesModel (seriesModel : sql.dataContext.``main.SeriesEntity``) (series : Series) stationId =
        seriesModel.Name <- series.Name
        seriesModel.Description <- series.Description
        seriesModel.StationId <- stationId
        seriesModel.Finished <- if series.IsFinished then int64(1) else int64(0)
        seriesModel.Duration <- series.Duration
        seriesModel.Day <- series.Day
        seriesModel.Time <- series.Time
        seriesModel
                   
    let feedSeries (series : sql.dataContext.``main.SeriesEntity``) : Series =
     
        let episodes =
            episodesBySeriesId series.Id
            |> Seq.toList
            |> Seq.map(fun e -> {
                                    Id = e.Id
                                    Description = e.Description
                                    IsFinished = e.Finished <> int64(0)
                                    Number = e.Number
                                    Season = e.Season
                                })

        let station : Station =
            let s = stationById series.StationId
            {
                Id = s.Id
                Name = s.Name
            }
                
        let fedSeries = {
            Id = series.Id
            Name = series.Name
            Description = series.Description
            Station = station
            IsFinished = series.Finished <> int64(0)
            Duration = series.Duration
            Day = series.Day
            Time = series.Time
            Episodes = episodes
            }

        fedSeries                                  

    let getSeries() =
        seriesDb
        |> Seq.map(feedSeries)
    
    let createSeries series =
        let stationId =
            stationIdByName series.Station.Name
                
        let newSeries = seriesDb.Create()

        setSeriesModel newSeries series stationId |> ignore

        ctx.SubmitUpdates()

        feedSeries newSeries
        
    let private updateStation (station : Station) =
        stationIdByName station.Name

    let private updateEpisodes seriesId episodes =
        episodes
        |> Seq.iter(fun e ->
                    let episode = episodeByData seriesId e
                    let newEpisode = match episode with
                                         | Some e -> e
                                         | None -> episodesDb.Create()

                    newEpisode.Description <- e.Description
                    newEpisode.Finished <- if e.IsFinished then int64(1) else int64(0)
                    newEpisode.Number <- e.Number
                    newEpisode.Season <- e.Season        
                    )
        
        ctx.SubmitUpdates()

    let updateSeriesById seriesId seriesToBeUpdated =
        let series =
            seriesById seriesId

        match series with
            | None -> None
            | Some s ->
                let newStationId =
                    updateStation seriesToBeUpdated.Station
                updateEpisodes seriesId seriesToBeUpdated.Episodes |> ignore
                Some (feedSeries (setSeriesModel s seriesToBeUpdated newStationId))           

    let updateSeries seriesToBeUpdated =
        updateSeriesById seriesToBeUpdated.Id seriesToBeUpdated

    let deleteEpisodes seriesId =
        let episodes =
            episodesBySeriesId seriesId
            |> Seq.iter (fun e -> e.Delete())

        ctx.SubmitUpdates()

    let deleteSeries seriesId =
        let series =
            seriesById seriesId

        match series with
            | None -> ()
            | Some s ->
                deleteEpisodes s.Id
                s.Delete()

        ctx.SubmitUpdates()
        
    let getSeriesById id =
        let series =
            seriesById id

        match series with
            | Some s -> Some (feedSeries s)
            | _ -> None

    let isSeriesExists seriesId =
        let series =
            seriesById seriesId

        match series with
            | Some s -> true
            | _ -> false
      
