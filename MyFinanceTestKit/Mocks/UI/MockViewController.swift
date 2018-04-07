import PromiseKit
@testable import MyFinanceKit

class MockViewController: ViewControllerType {

    var presented: ViewControllerType?

    #if os(iOS)
    var modalTransitionStyle: UIModalTransitionStyle = .coverVertical
    #endif

    func present(viewController: ViewControllerType, animated: Bool) {}
    func dismiss() -> Promise<Void> { return .value(Void()) }

}

class MockInjectableViewController: ViewControllerType & ViewModelInjectable {

    var presented: ViewControllerType?

    #if os(iOS)
    var modalTransitionStyle: UIModalTransitionStyle = .coverVertical
    #endif

    func present(viewController: ViewControllerType, animated: Bool) {}
    func dismiss() -> Promise<Void> { return .value(Void()) }

    var lastViewModel: ViewModelType?
    func inject(viewModel: ViewModelType) {
        lastViewModel = viewModel
    }

}
