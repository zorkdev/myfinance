public protocol BaseNavigatorType {

    var window: WindowType? { get set }
    var viewControllers: [ViewControllerType] { get set }

    init(window: WindowType)
    func createNavigationStack(viewModel: ViewModelType)
    @discardableResult func dismiss() -> Promise<Void>
    func inject(viewController: ViewControllerType, viewModel: ViewModelType)

}

public extension BaseNavigatorType {

    public func inject(viewController: ViewControllerType, viewModel: ViewModelType) {
        if let injectableViewController = viewController as? ViewModelInjectable {
            injectableViewController.inject(viewModel: viewModel)
        }

        viewModel.inject(delegate: viewController)
    }

}