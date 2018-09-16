// Отвечает за отображение данных модуля CatalogDetails

import UIKit

protocol CatalogDetailsPresentationLogic {
    func presentFetchedDetails(response: CatalogDetails.ShowDetails.Response)
    func presentOpenExternalLink(response: CatalogDetails.OpenExternalLink.Response)
}

class CatalogDetailsPresenter: CatalogDetailsPresentationLogic {

	weak var viewController: CatalogDetailsDisplayLogic?

    let numberFormatterWorker: NumberFormatterWorker

    init(numberFormatterWorker: NumberFormatterWorker = NumberFormatterWorker()) {
        self.numberFormatterWorker = numberFormatterWorker
    }

	// MARK: Present Fetched Details

	func presentFetchedDetails(response: CatalogDetails.ShowDetails.Response) {
		var viewModel: CatalogDetails.ShowDetails.ViewModel

        switch response.result {
        case let .success(model, imageData):
            let coinSnapshotViewModel = makeCoinSnapshotViewModel(model, imageData: imageData)
            viewModel = CatalogDetails.ShowDetails.ViewModel(coinId: model.uid, error: nil, snapshotViewModel: coinSnapshotViewModel, infoRepresentable: coinSnapshotViewModel.properties)
        case let .failure(id, error):
            viewModel = CatalogDetails.ShowDetails.ViewModel(coinId: id, error: error, snapshotViewModel: nil, infoRepresentable: nil)
        }
        viewController?.displayFetchedDetails(viewModel: viewModel)
	}

    // MARK: Present Open External Link

    func presentOpenExternalLink(response: CatalogDetails.OpenExternalLink.Response) {
        switch response.result {
        case let .success(url):
            viewController?.displayOpenExtenalLink(viewModel: CatalogDetails.OpenExternalLink.ViewModel(url: url, error: nil))
        case let .failure(error):
            viewController?.displayOpenExtenalLink(viewModel: CatalogDetails.OpenExternalLink.ViewModel(url: nil, error: error))
        }
    }

    func makeCoinSnapshotViewModel(_ model: CoinSnapshotFullModel, imageData: Data?) -> CoinSnapshotFullViewModel {
        let title = model.title
        let image = UIImage(data: imageData ?? Data())
        let websiteAnnotationMessage = "Click here to open URL"
        let website = CoinSnapshotPropertyViewModel(type: .website, value: websiteAnnotationMessage)
        let twitter = CoinSnapshotPropertyViewModel(type: .twitter, value: model.twitter)
        var percentMined: CoinSnapshotPropertyViewModel?
        if let totalSupply = Double(model.totalSupply) {
            let mined = model.totalMined / totalSupply
            let percent = numberFormatterWorker.getPercentIntegerPart(mined)
            percentMined = CoinSnapshotPropertyViewModel(type: .percentMined, value: percent)
        }
        let blockReward = CoinSnapshotPropertyViewModel(type: .blockReward, value: String(model.blockReward))
        let properties = [website, twitter, percentMined, blockReward].compactMap { $0 }
        return CoinSnapshotFullViewModel(uid: model.uid, title: title, image: image, properties: properties)
    }
}
