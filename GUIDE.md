# YARCH components

## Builder
Builder is responsible for the assembly of the module. It creates all necessary entities and shows dependencies.

## DataFlow
Description of objects for data transfer (DTO - Data Transfer Objects) within one use case (UseCase). Consists of:
* *Request* - structure for transferring data from ViewController to Interactor
* *Response* - structure for transferring data from Interactor to Presenter
* *ViewModel* - structure for transferring data from Presenter to ViewController
The Request, Response, ViewModel structures are declared inside the enum with the module name for the allocated namespace. DataFlow should clearly describe the business tasks and provide visual information about the data transmitted within the module.

## Interactor
Interactor contains the business logic of the module. It shouldn't make any network requests, access the database, etc. It acts as an aggregator of business logic. For example it calls the Provider to get data, various Workers to perform any data actions, etc. When the data occurred, Interactor sends it to the Presenter. Interactor receives a request for an operation on data from the ViewController with the Request and submits the data to the Presenter using Response.

## Worker
Worker should implement business logic that can be reused in another module (for example: algorithm for data filtering).

## Presenter
Presenter contains the logic for preparing data for display (for example: data formatting (phone number, sum), localization, etc.) and passes it to ViewController via ViewModel.

## ViewController
ViewController is responsible for displaying the ViewModel received from Presenter and interacting with the user. ViewController contains only one view, which is created in the loadView () method. It doesn't control the location of the view and it's layout. All necessary layout should be configured in a separately implemented view. However, ViewController acts as a delegate for the entire view layer. It knows when the text in UITextField was changed or the user clicked on the cell.

```swift
override func loadView () {
    view = CatalogListView (delegate: self)
}
```

## Provider
Provider is an abstraction responsible for accessing data. It encapsulates calls to Service to retrieve data from the network (or other sources) and/or DataStore if the data should be cached.

## DataStore
Object abstracting long-term data storage.

```swift
class CatalogDataStore {
    static let shared = CatalogDataStore ()

    var catalogModels: [CatalogObjectType: [CatalogModel]] = [:]
}
```

## ViewModel
ViewModel contains completely prepared data for display. ViewModel is a DTO and does not contain any logic.

# Data transfer between modules
You should specify the id of the model to be transmitted in order to transfer data between modules A and B. Module B should access the shared storage itself and obtain the required model. It is not desirable to directly transfer data from one module to another.