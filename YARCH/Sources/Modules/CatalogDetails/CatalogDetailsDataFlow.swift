//  Модуль детальной информации

import UIKit

// swiftlint:disable nesting
enum CatalogDetails {

	// MARK: Use cases
    enum ShowDetails {
        struct Request {
            let coinId: String
        }

        struct Response {
            let result: CatalogDetailsRequestResult
        }

        struct ViewModel {
            let coinId: String
            let error: CatalogDetailsError?
            let snapshotViewModel: CoinSnapshotFullViewModel?
            let infoRepresentable: [CoinSnapshotPropertyViewModel]?
        }
    }

    enum OpenExternalLink {
        struct Request {
            let coinId: String
            let type: ExternalLinkType
        }

        struct Response {
            let result: OpenExternalLinkResult
        }

        struct ViewModel {
            let url: URL?
            let error: CatalogDetailsError?
        }

        enum ExternalLinkType {
            case website
            case twitter
        }

        enum OpenExternalLinkResult {
            case success(URL)
            case failure(CatalogDetailsError)
        }
    }

    enum CatalogDetailsRequestResult {
        case success(CoinSnapshotFullModel, Data?)
        case failure(id: UniqueIdentifier, CatalogDetailsError)
    }

    enum ViewControllerState {
        case initial(id: UniqueIdentifier)
        case loading
        case result(snapshotViewModel: CoinSnapshotFullViewModel, infoRepresentable: [CatalogDetailsCellRepresentable])
        case emptyResult(id: UniqueIdentifier)
        case error(id: UniqueIdentifier, message: String)
    }
}
