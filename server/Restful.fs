namespace SeriesRestApi.Rest

open Newtonsoft.Json
open Newtonsoft.Json.Serialization
open Newtonsoft.Json
open Suave.Writers
open Suave
open Suave.Successful
open Suave.Filters
open Suave.Operators

[<AutoOpen>]
module RestFul =
    
    type RestResource<'a> = {
        GetAll : unit -> 'a seq
        Create : 'a -> 'a
        Update : 'a -> 'a option
        Delete : int64 -> unit
        GetById : int64 -> 'a option
        UpdateById : int64 -> 'a -> 'a option
        IsExists : int64 -> bool
    }

    let JSON v =
        let jsonSerializerSettings = new JsonSerializerSettings()
        jsonSerializerSettings.ContractResolver <- new CamelCasePropertyNamesContractResolver()
        
        JsonConvert.SerializeObject(v, jsonSerializerSettings)
        |> OK
        >=> Writers.setMimeType "application/json; charset=utf-8"

    let fromJson<'a> json =
        JsonConvert.DeserializeObject(json, typeof<'a>) :?> 'a

    let getResourceFromReq<'a> (req : HttpRequest) =
        let getString rawForm =
            System.Text.Encoding.UTF8.GetString(rawForm)
        req.rawForm |> getString |> fromJson<'a>

    let rest resourceName resource =
        let resourcePath = "/" + resourceName
        let resourceIdPath =
            new PrintfFormat<(int -> string), unit, string, string, int64>(resourcePath + "/%d")
        let badRequest = RequestErrors.BAD_REQUEST "Resource not found"
        let notFound = RequestErrors.NOT_FOUND "Resource not found"

        let getAll = warbler (fun _ -> resource.GetAll() |> JSON)
        
        let handleResource requestError = function
            | Some r -> r |> JSON
            | _ -> requestError

        let deleteResourceById id =
            resource.Delete id
            NO_CONTENT

        let getResourceById =
            resource.GetById >> handleResource notFound

        let updateResourceById id =
            request (getResourceFromReq >> (resource.UpdateById id) >> handleResource badRequest)

        let isResourceExists id =
            if resource.IsExists id then OK "" else notFound

        choose [
            
            path resourcePath >=> choose [
                GET  >=>
                    getAll
                POST >=>
                    request (getResourceFromReq >> resource.Create >> JSON)
                PUT  >=>
                    request (getResourceFromReq >> resource.Update >> handleResource badRequest)
            ]
            DELETE >=> pathScan resourceIdPath deleteResourceById
            PUT    >=> pathScan resourceIdPath updateResourceById
            GET    >=> pathScan resourceIdPath getResourceById
            HEAD   >=> pathScan resourceIdPath isResourceExists
        ]

