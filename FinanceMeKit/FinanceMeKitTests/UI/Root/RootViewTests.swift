import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class RootViewTests: XCTestCase {
    func testView() {
        assert(view: RootView(appState: MockAppState()), previews: RootViewPreviews.self)
    }
}
