open Suave                 // always open suave
open Suave.Successful      // for OK-result
open Suave.Web             // for config
open SeriesRestApi.Rest
open SeriesRestApi.Db

[<EntryPoint>]
let main argv =
    let seriesWebPart = rest "series" {
        GetAll = Db.getSeries
        Create = Db.createSeries
        Update = Db.updateSeries
        Delete = Db.deleteSeries
        UpdateById = Db.updateSeriesById
        GetById = Db.getSeriesById
        IsExists = Db.isSeriesExists
       }
    startWebServer defaultConfig seriesWebPart
    0
