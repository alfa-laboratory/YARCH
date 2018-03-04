//
//  SUT: CatalogDetailsInteractor
//
//  Collaborators:
//  CatalogDetailsProvider
//  CatalogDetailsPresenter
//

import Quick
import Nimble

@testable import YARCH

class CatalogDetailsInteractorTests: QuickSpec {
	override func spec() {
		var interactor: CatalogDetailsInteractor!
		var presenterMock: CatalogDetailsPresenterMock!
		var providerMock: CatalogDetailsProviderMock!

		beforeEach {
			providerMock = CatalogDetailsProviderMock()
			presenterMock = CatalogDetailsPresenterMock()
			interactor = CatalogDetailsInteractor(presenter: presenterMock, provider: providerMock)
		}

		describe(".fetchDetails") {
			it("should get data from provider") {
				// when
				interactor.fetchDetails(request: TestData.request)

				// then
				expect(providerMock.fetchDetailsDidCalled).to(equal(1))
			}

			context("getItems successfull") {
				it("should prepare success response and call presenter") {
					// given
					providerMock.fetchDetailsCompletionStub = .success(TestData.responseModel)

					// when
					interactor.fetchDetails(request: TestData.request)

					// then
					expect(presenterMock.presentFetchedDetailsDidCalled).to(equal(1))
					expect(presenterMock.presentFetchedDetailsArguments).toNot(beNil())
					expect { if case .success(_)? = presenterMock.presentFetchedDetailsArguments?.result { return true }; return false }.to(beTrue())
				}
			}

			context("getItems failed") {
				it("should prepare failed response and call presenter") {
					// given
					providerMock.fetchDetailsCompletionStub = .failure(CatalogDetailsError.otherLogicError)

					// when
					interactor.fetchDetails(request: TestData.request)

					// then
					expect(presenterMock.presentFetchedDetailsDidCalled).to(equal(1))
					expect(presenterMock.presentFetchedDetailsArguments).toNot(beNil())
					expect { if case .failure(_)? = presenterMock.presentFetchedDetailsArguments?.result { return true }; return false }.to(beTrue())
				}
			}
		}
	}
}

extension CatalogDetailsInteractorTests {
	enum TestData {
        static let coinId = "1"
        static let uid = UUID().uuidString
        static let title = "SomeCoin"
        static let otherTitle = "OtherCoin"
        static let imageUrlString = "http://www.example.com/image.png"
        static let website = "http://www.example.com"
        static let twitter = "http://www.twitter.com/jack"
        static let totalSupply = "10000000"
        static let totalMined = 80.0
        static let blockReward = 12.0
        static let model = CoinSnapshotFullModel(uid: uid,
                                                 title: title,
                                                 imageUrlString: imageUrlString,
                                                 website: website,
                                                 twitter: twitter,
                                                 totalSupply: totalSupply,
                                                 totalMined: totalMined,
                                                 blockReward: blockReward)
		static let request = CatalogDetails.ShowDetails.Request(coinId: coinId)
        static let responseModel = CoinSnapshotFullResponseModelTests.TestData.model
		static let models = CoinSnapshotFullResponseModelTests.TestData.entitiesCollection()
	}
}

private class CatalogDetailsProviderMock: CatalogDetailsProviderProtocol {

    var fetchDetailsDidCalled: Int = 0
	var fetchDetailsArguments: (String)?
    var fetchDetailsCompletionStub: (Result<CoinSnapshotFullModel>) = (Result.failure(CatalogDetailsError.otherLogicError))

    func fetchDetails(coinId: String, completion: @escaping (Result<CoinSnapshotFullModel>) -> Void) {
        fetchDetailsDidCalled += 1
        fetchDetailsArguments = coinId
        completion(fetchDetailsCompletionStub)
    }
}

private class CatalogDetailsPresenterMock: CatalogDetailsPresentationLogic {

    var presentFetchedDetailsDidCalled: Int = 0
	var presentFetchedDetailsArguments: CatalogDetails.ShowDetails.Response?

    var presentOpenExternalLinkDidCalled: Int = 0
    var presentOpenExternalLinkArguments: CatalogDetails.OpenExternalLink.Response?

	func presentFetchedDetails(response: CatalogDetails.ShowDetails.Response) {
		presentFetchedDetailsDidCalled += 1
		presentFetchedDetailsArguments = response
	}

    func presentOpenExternalLink(response: CatalogDetails.OpenExternalLink.Response) {
        presentOpenExternalLinkDidCalled += 1
        presentOpenExternalLinkArguments = response
    }
}
