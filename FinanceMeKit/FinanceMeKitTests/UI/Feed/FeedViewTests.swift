import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class FeedViewTests: XCTestCase {
    func testView() {
        assert(view: FeedView(appState: MockAppState(), loadingState: LoadingState(), errorViewModel: ErrorViewModel()),
               previews: FeedViewPreviews.self)
    }
}
