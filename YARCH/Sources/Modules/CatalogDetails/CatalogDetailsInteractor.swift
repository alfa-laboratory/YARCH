//  Класс для описания бизнес-логики модуля CatalogDetails

import UIKit

protocol CatalogDetailsBusinessLogic {
	func fetchDetails(request: CatalogDetails.FetchDetails.Request)
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

    init(presenter: CatalogDetailsPresentationLogic, provider: CatalogDetailsProviderProtocol = CatalogDetailsProvider(), imageProvider: ImageProvider = ImageProvider.shared) {
		self.presenter = presenter
		self.provider = provider
        self.imageProvider = imageProvider
	}

    // MARK: Fetch Details

    func fetchDetails(request: CatalogDetails.FetchDetails.Request) {
        provider.fetchDetails(coinId: request.coinId) { [weak self] result in
            switch result {
            case let .success(coinModel):
                self?.downloadImage(coinModel.imageUrlString, completion: { data in
                    let catalogResult: CatalogDetails.FetchDetails.Response = .init(result: .success(coinModel, data))
                    DispatchQueue.main.async {
                        self?.presenter.presentFetchedDetails(response: catalogResult)
                    }
                })
                let catalogResult: CatalogDetails.FetchDetails.Response = .init(result: .success(coinModel, nil))
                self?.presenter.presentFetchedDetails(response: catalogResult)
            case let .failure(error as CatalogDetailsError):
                let response: CatalogDetails.FetchDetails.Response = .init(result: .failure(id: request.coinId, error))
                self?.presenter.presentFetchedDetails(response: response)
            case let .failure(error):
                let error = CatalogDetailsError.networkError(error.localizedDescription)
                self?.presenter.presentFetchedDetails(response: CatalogDetails.FetchDetails.Response(result: .failure(id: request.coinId, error)))
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
                let viewModel: CatalogDetails.FetchDetails.Response = .init(result: .failure(id: request.coinId, error))
                self?.presenter.presentFetchedDetails(response: viewModel)
            case let .failure(error):
                let error = CatalogDetailsError.networkError(error.localizedDescription)
                self?.presenter.presentFetchedDetails(response: CatalogDetails.FetchDetails.Response(result: .failure(id: request.coinId, error)))
            }
        }
    }

    func performOpenExternalLink(_ coinModel: CoinSnapshotFullModel, externalLinkType: CatalogDetails.OpenExternalLink.ExternalLinkType) {
        var response: CatalogDetails.OpenExternalLink.Response = .init(result: .failure(CatalogDetailsError.otherLogicError))
        var url: URL? = nil
        switch externalLinkType {
        case .website:
            url = coinModel.website.extractURLs().first
        case .twitter:
            url = URL(string: "\(Configuration.twitterBaseUrlString)\(coinModel.twitter)")
        }
        if let url = url {
            response = .init(result: .success(url))
        } else {
            response = .init(result: .failure(CatalogDetailsError.externalURLError))
        }
        presenter.presentOpenExternalLink(response: response)
    }
}
