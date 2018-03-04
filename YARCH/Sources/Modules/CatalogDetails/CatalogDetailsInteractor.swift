//  Класс для описания бизнес-логики модуля CatalogDetails

import UIKit

protocol CatalogDetailsBusinessLogic {
    func fetchDetails(request: CatalogDetails.ShowDetails.Request)
    func openExternalLink(request: CatalogDetails.OpenExternalLink.Request)
}

extension CatalogDetailsInteractor {
    enum Configuration {
        static let twitterBaseUrlString = "https://twitter.com/"
    }
}

class CatalogDetailsInteractor: CatalogDetailsBusinessLogic {
	let presenter: CatalogDetailsPresentationLogic
	let provider: CatalogDetailsProviderProtocol

    let imageProvider: ImageProvider

    init(presenter: CatalogDetailsPresentationLogic,
         provider: CatalogDetailsProviderProtocol = CatalogDetailsProvider(),
         imageProvider: ImageProvider = ImageProvider.shared) {
        self.presenter = presenter
        self.provider = provider
        self.imageProvider = imageProvider
    }

    // MARK: Fetch Details

    func fetchDetails(request: CatalogDetails.ShowDetails.Request) {
        provider.fetchDetails(coinId: request.coinId) { [weak self] result in
            switch result {
            case let .success(coinModel):
                self?.downloadImage(coinModel.imageUrlString) { data in
                    let catalogResult: CatalogDetails.ShowDetails.Response = .init(result: .success(coinModel, data))
                    DispatchQueue.main.async {
                        self?.presenter.presentFetchedDetails(response: catalogResult)
                    }
                }
                self?.presenter.presentFetchedDetails(response: .init(result: .success(coinModel, nil)))
            case let .failure(error as CatalogDetailsError):
                self?.presenter.presentFetchedDetails(response: .init(result: .failure(id: request.coinId, error)))
            case let .failure(error):
                self?.presenter.presentFetchedDetails(response: CatalogDetails.ShowDetails.Response(result: .failure(id: request.coinId, .networkError(error.localizedDescription))))
            }
        }
    }

    func downloadImage(_ urlString: String, completion: @escaping ((Data) -> Void)) {
        imageProvider.loadImageData(urlString, completion: completion)
    }

    // MARK: Open External Link

    func openExternalLink(request: CatalogDetails.OpenExternalLink.Request) {
        provider.fetchDetails(coinId: request.coinId) { [weak self] result in
            switch result {
            case let .success(coinModel):
                self?.performOpenExternalLink(coinModel, externalLinkType: request.type)
            case let .failure(error as CatalogDetailsError):
                self?.presenter.presentFetchedDetails(response: .init(result: .failure(id: request.coinId, error)))
            case let .failure(error):
                self?.presenter.presentFetchedDetails(response: CatalogDetails.ShowDetails.Response(result: .failure(id: request.coinId, .networkError(error.localizedDescription))))
            }
        }
    }

    func performOpenExternalLink(_ coinModel: CoinSnapshotFullModel, externalLinkType: CatalogDetails.OpenExternalLink.ExternalLinkType) {
        let response: CatalogDetails.OpenExternalLink.Response
        defer { presenter.presentOpenExternalLink(response: response) }
        let url: URL?
        switch externalLinkType {
        case .website:
            url = coinModel.website.extractURLs().first
        case .twitter:
            url = URL(string: "\(Configuration.twitterBaseUrlString)\(coinModel.twitter)")
        }
        guard let unwrappedURL = url else {
            response = .init(result: .failure(CatalogDetailsError.externalURLError))
            return
        }
        response = .init(result: .success(unwrappedURL))
    }
}
