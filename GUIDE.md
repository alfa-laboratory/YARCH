# YARCH components

## Builder
Responsible for the assembly of the module. It creates the necessary entities and shows dependencies.

## DataFlow
Description of objects for data transfer (DTO - Data Transfer Objects) within one use case (UseCase). Consists of:
* * Request * - structure for transferring data from ViewController to Interactor
* * Response * - structure for transferring data from Interactor to Presenter
* * ViewModel * - structure for transferring data from Presenter to ViewController
The Request, Response, ViewModel structures are declared inside the enum with the module name for the allocated namespace. DataFlow should clearly describe the business tasks and provide visual information about the data transmitted within the module.

## Interactor
Contains the business logic of the module. Interactor should not make network requests, access the database, etc. It acts as an aggregator of business logic. So, for example, to get data, it calls the Provider, to various Workers to perform any data actions, and then sends the prepared data further to the Presenter, etc.
Interactor receives a request for an operation on data from the ViewController with the Request and submits the data to the Presenter using Response.

## Worker
Implements the reused part of the business logic (for example: algorithm for data filtering).

## Presenter
Contains the logic for preparing data for display (for example: data formatting (phone number, sum), localization, etc.) and passes them to ViewController via ViewModel.

## ViewController
Responsible for displaying the status received from Presenter and interacting with the user. ViewController contains only one view, which is created in the loadView () method. It does not control the location of the view. All necessary layout should be already presented in a separately implemented view. However, ViewController acts as a delegate for the entire view layer. So it knows when the Text in TextField was changed or the user clicked on the cell.

```
override func loadView () {
    view = CatalogListView (delegate: self)
}
```

## Provider
Abstraction responsible for accessing data. Encapsulates a call to Service to retrieve data from the network (or other sources) and/or DataStore if the data should be cached.

## DataStore
Object abstracting long-term data storage.

```
class CatalogDataStore {
    static let shared = CatalogDataStore ()

    var catalogModels: [CatalogObjectType: [CatalogModel]] = [:]
}
```

## ViewModel
Contains completely prepared for display data for View (each separate subview). ViewModel is a DTO and does not contain any logic.

# Data transfer between modules
You should specify the id of the model to be transmitted in order to transfer data between modules A and B. Module B should access the shared storage itself and obtain the required model. It is not desirable to directly transfer data from one module to another.