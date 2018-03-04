//
//  SUT: CatalogDetailsPresenter
//
//  Collaborators:
//  CatalogDetailsViewController
//

import Quick
import Nimble

@testable import YARCH

class CatalogDetailsPresenterTests: QuickSpec {
	override func spec() {
		var presenter: CatalogDetailsPresenter!
		var viewControllerMock: CatalogDetailsViewControllerMock!

		beforeEach {
			presenter = CatalogDetailsPresenter()
			viewControllerMock = CatalogDetailsViewControllerMock()
			presenter.viewController = viewControllerMock
		}

		describe(".presentFetchedDetails") {
			context("successfull result") {
				it ("should prepare result view model and display it in view") {
                    // when
                    presenter.presentFetchedDetails(response: TestData.successResponse)

                    // then
                    expect(viewControllerMock.displayFetchedDetailsDidCalled).to(equal(1))
                    expect(viewControllerMock.displayFetchedDetailsArguments?.coinId).to(equal(TestData.expectedDisplayFetchedArguments.coinId))
                    expect(viewControllerMock.displayFetchedDetailsArguments?.error).to(beNil())
                    expect(viewControllerMock.displayFetchedDetailsArguments?.snapshotViewModel).to(equal(TestData.expectedDisplayFetchedArguments.snapshotViewModel))
                    expect(viewControllerMock.displayFetchedDetailsArguments?.infoRepresentable).to(equal(TestData.expectedDisplayFetchedArguments.infoRepresentable))
				}
			}

			context("failure result") {
				it ("should prepare error view model and display it in view") {
					// when
					presenter.presentFetchedDetails(response: TestData.failureResponse)

					// then
                    expect(viewControllerMock.displayFetchedDetailsDidCalled).to(equal(1))
                    expect(viewControllerMock.displayFetchedDetailsArguments?.coinId).to(equal(TestData.expectedDisplayFetchedArguments.coinId))
                    expect(viewControllerMock.displayFetchedDetailsArguments?.error).to(beAnInstanceOf(CatalogDetailsError.self))
                    expect(viewControllerMock.displayFetchedDetailsArguments?.snapshotViewModel).to(beNil())
                    expect(viewControllerMock.displayFetchedDetailsArguments?.infoRepresentable).to(beNil())
				}
			}
		}
        describe(".presentOpenExternalLink") {
            it("should pass successful viewModel in case of successful response") {
                // when
                presenter.presentOpenExternalLink(response: TestData.presentOpenExternalLinkSuccessfulResponse)

                // then
                expect(viewControllerMock.displayOpenExtenalLinkDidCalled).to(equal(1))
                expect(viewControllerMock.displayOpenExtenalLinkArguments?.url).to(equal(TestData.url))
                expect(viewControllerMock.displayOpenExtenalLinkArguments?.error).to(beNil())
            }
            it("should pass failure viewModel in case of failure") {
                // when
                presenter.presentOpenExternalLink(response: TestData.presentOpenExternalLinkFailureResponse)

                // then
                expect(viewControllerMock.displayOpenExtenalLinkDidCalled).to(equal(1))
                expect(viewControllerMock.displayOpenExtenalLinkArguments?.url).to(beNil())
                expect(viewControllerMock.displayOpenExtenalLinkArguments?.error).to(beAnInstanceOf(CatalogDetailsError.self))
            }
        }
	}
}

extension CatalogDetailsPresenterTests {
	enum TestData {
        static let model = CoinSnapshotFullResponseModelTests.TestData.constantUidModel
		static let successResponse = CatalogDetails.ShowDetails.Response(result: .success(model, Data()))
        static let failureResponse = CatalogDetails.ShowDetails.Response(result: .failure(id: model.uid, CatalogDetailsError.otherLogicError))
        static let websiteProperty = CoinSnapshotPropertyViewModel(type: .website, value: "Click here to open URL")
        static let twitterProperty = CatalogDetailsViewControllerTests.TestData.twitterProperty
        static let percentMinedProperty = CatalogDetailsViewControllerTests.TestData.percentMinedProperty
        static let blockRewardProperty = CatalogDetailsViewControllerTests.TestData.blockRewardProperty
        static let expectedCoinSnapshotViewModel = CoinSnapshotFullViewModel(uid: "1",
                                                                             title: "SomeCoin",
                                                                             image: nil,
                                                                             properties: [websiteProperty!, twitterProperty!, percentMinedProperty!, blockRewardProperty!])
        static let expectedDisplayFetchedArguments = CatalogDetails.ShowDetails.ViewModel(coinId: model.uid,
                                                                                           error: nil,
                                                                                           snapshotViewModel: expectedCoinSnapshotViewModel,
                                                                                           infoRepresentable: expectedCoinSnapshotViewModel.properties)
        static let url = URL(string: "http://www.example.com")!
        static let presentOpenExternalLinkSuccessfulResponse = CatalogDetails.OpenExternalLink.Response(result: .success(url))
        static let presentOpenExternalLinkFailureResponse = CatalogDetails.OpenExternalLink.Response(result: .failure(CatalogDetailsError.otherLogicError))
	}
}

private class CatalogDetailsViewControllerMock: CatalogDetailsDisplayLogic {

	var displayFetchedDetailsDidCalled: Int = 0
	var displayFetchedDetailsArguments: CatalogDetails.ShowDetails.ViewModel?

    var displayOpenExtenalLinkDidCalled: Int = 0
    var displayOpenExtenalLinkArguments: CatalogDetails.OpenExternalLink.ViewModel?

    func displayFetchedDetails(viewModel: CatalogDetails.ShowDetails.ViewModel) {
        displayFetchedDetailsDidCalled += 1
        displayFetchedDetailsArguments = viewModel
    }

    func displayOpenExtenalLink(viewModel: CatalogDetails.OpenExternalLink.ViewModel) {
        displayOpenExtenalLinkDidCalled += 1
        displayOpenExtenalLinkArguments = viewModel
    }
}
