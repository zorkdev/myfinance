import SwiftUI
import FinanceMeKit

class HostingController: WKHostingController<AnyView> {
    private let appState = AppState()

    override var body: AnyView {
        AnyView(RootView(appState: appState))
    }
}
