//
//  SUT: CatalogDetailsViewController
//
//  Collaborators:
//  CatalogDetailsInteractor
//

import Quick
import Nimble
import SafariServices

@testable import YARCH

class CatalogDetailsViewControllerTests: QuickSpec {
	override func spec() {
		var viewController: CatalogDetailsViewController!
		var interactorMock: CatalogDetailsInteractorMock!
        var initialState: CatalogDetails.ViewControllerState!
        var router: RouterMock!

		beforeEach {
            router = RouterMock()
            initialState = .initial(id: TestData.coinId)
			interactorMock = CatalogDetailsInteractorMock()
            viewController = CatalogDetailsViewController(interactor: interactorMock,
                                                          initialState: initialState,
                                                          loadingDataSource: LoadingTableViewDataSource(),
                                                          loadingTableDelegate: LoadingTableViewDelegate(),
                                                          router: router)
		}

		describe(".fetchDetailInfo") {
			it("should call fetchDetails in interactor") {
				// when
				viewController.fetchDetailInfo(coinId: TestData.coinId)

				// then
				expect(interactorMock.fetchDetailsDidCalled).to(equal(1))
				expect(interactorMock.fetchDetailsArguments).toNot(beNil())
			}
		}

        describe(".openExternalLink on delegate call") {
            beforeEach {
                viewController.loadView()
            }
            it("should call openExternalLink in interactor in case of website property") {
                // given
                viewController.state = TestData.resultState

                // when
                viewController.openExternalLink(.website)

                // then
                expect(interactorMock.openExternalLinkDidCalled).to(equal(1))
                expect(interactorMock.openExternalLinkArguments?.coinId).to(equal(TestData.coinId))
                expect(interactorMock.openExternalLinkArguments?.type).to(equal(.website))
            }
            it("should call openExternalLink in interactor in case of twitter property") {
                // given
                viewController.state = TestData.resultState

                // when
                viewController.openExternalLink(.twitter)

                // then
                expect(interactorMock.openExternalLinkDidCalled).to(equal(1))
                expect(interactorMock.openExternalLinkArguments?.coinId).to(equal(TestData.coinId))
                expect(interactorMock.openExternalLinkArguments?.type).to(equal(.twitter))
            }
            it("should not call openExternalLink in interactor in case of percentMined property") {
                // when
                viewController.openExternalLink(.percentMined)

                // then
                expect(interactorMock.openExternalLinkDidCalled).to(equal(0))
                expect(interactorMock.openExternalLinkArguments).to(beNil())
            }
            it("should not call openExternalLink in interactor in case of blockReward property") {
                // when
                viewController.openExternalLink(.blockReward)

                // then
                expect(interactorMock.openExternalLinkDidCalled).to(equal(0))
                expect(interactorMock.openExternalLinkArguments).to(beNil())
            }
        }

        describe("displayOpenExternalLink") {
            it("should present safari view controller on success") {
                // when
                viewController.displayOpenExtenalLink(viewModel: TestData.openExternalLinkViewModelSuccess)

                // then
                expect(router.presentDidCalled).to(equal(1))
                expect(router.presentArguments!).to(beAKindOf(SFSafariViewController.self))
            }
            it("should not present safari view controller on failure") {
                // when
                viewController.displayOpenExtenalLink(viewModel: TestData.openExternalLinkViewModelFailure)

                // then
                expect(router.presentDidCalled).to(equal(0))
                expect(router.presentArguments).to(beNil())
            }
        }
	}
}

extension CatalogDetailsViewControllerTests {
	enum TestData {
        static let fetchDetailsRequest = CatalogDetails.FetchDetails.Request(coinId: coinId)
        static let coinId = "1"
        static let exampleUrl = URL(string: "http://www.example.com")!
        static let websiteProperty = CoinSnapshotPropertyViewModel(type: .website, value: "http://www.example.com")
        static let twitterProperty = CoinSnapshotPropertyViewModel(type: .twitter, value: "http://www.twitter.com/jack")
        static let percentMinedProperty = CoinSnapshotPropertyViewModel(type: .percentMined, value: "80 %")
        static let blockRewardProperty = CoinSnapshotPropertyViewModel(type: .blockReward, value: "12.0")
        static let snapshotViewModel = CoinSnapshotFullViewModel(id: coinId,
                                                                 title: "title",
                                                                 image: UIImage(),
                                                                 properties: [websiteProperty!, twitterProperty!, percentMinedProperty!, blockRewardProperty!])
        static let resultState = CatalogDetails.ViewControllerState.result(snapshotViewModel: snapshotViewModel,
                                                                           infoRepresentable: [websiteProperty!, twitterProperty!, percentMinedProperty!, blockRewardProperty!])
        static let openLinkWebsiteRequest = CatalogDetails.OpenExternalLink.Request(coinId: coinId, type: .website)
        static let openLinkTwitterRequest = CatalogDetails.OpenExternalLink.Request(coinId: coinId, type: .twitter)
        static let openExternalLinkViewModelSuccess = CatalogDetails.OpenExternalLink.ViewModel(url: exampleUrl, error: nil)
        static let openExternalLinkViewModelFailure = CatalogDetails.OpenExternalLink.ViewModel(url: nil, error: CatalogDetailsError.otherLogicError)
	}
}

private class CatalogDetailsInteractorMock: CatalogDetailsBusinessLogic {
	var fetchDetailsDidCalled: Int = 0
	var fetchDetailsArguments: CatalogDetails.FetchDetails.Request?

    var openExternalLinkDidCalled: Int = 0
    var openExternalLinkArguments: CatalogDetails.OpenExternalLink.Request?

	func fetchDetails(request: CatalogDetails.FetchDetails.Request) {
		fetchDetailsDidCalled += 1
		fetchDetailsArguments = request
	}

    func openExternalLink(request: CatalogDetails.OpenExternalLink.Request) {
        openExternalLinkDidCalled += 1
        openExternalLinkArguments = request
    }
}

private class RouterMock: Router {

    var presentDidCalled: Int = 0
    var presentArguments: (UIViewController?)?

    override func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentDidCalled += 1
        presentArguments = viewController
    }
}
