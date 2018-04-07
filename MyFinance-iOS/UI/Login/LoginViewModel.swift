protocol LoginViewModelDelegate: ViewModelDelegate & MessagePresentable {

    func clearFields()

}

protocol LoginViewModelType: ViewModelType {

    func shouldEnableLoginButton(displayModel: LoginDisplayModel) -> Bool
    func loginButtonTapped(with displayModel: LoginDisplayModel)
    func validate(email: String) -> Bool

}

class LoginViewModel {

    typealias ServiceProvider = NavigatorProvider & NetworkServiceProvider & DataServiceProvider
    let serviceProvider: ServiceProvider

    private let userBusinessLogic: UserBusinessLogic

    private weak var delegate: LoginViewModelDelegate?

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
        self.userBusinessLogic = UserBusinessLogic(networkService: serviceProvider.networkService,
                                                   dataService: serviceProvider.dataService)
    }

}

// MARK: - Interface

extension LoginViewModel: LoginViewModelType {

    func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? LoginViewModelDelegate else { return }
        self.delegate = delegate
    }

    func shouldEnableLoginButton(displayModel: LoginDisplayModel) -> Bool {
        guard displayModel.email.components(separatedBy: .whitespaces).joined() != "",
            displayModel.password.components(separatedBy: .whitespaces).joined() != "",
            validate(fullEmail: displayModel.email) else { return false }

        return  true
    }

    func loginButtonTapped(with displayModel: LoginDisplayModel) {
        let credentials = Credentials(email: displayModel.email,
                                      password: displayModel.password)
        login(credentials: credentials)
    }

    func validate(email: String) -> Bool {
        //return Validators.validate(amount: amount)
        return true
    }

}

// MARK: - Private methods

extension LoginViewModel {

    private func validate(fullEmail: String) -> Bool {
        return true
    }

    private func login(credentials: Credentials) {
        delegate?.showSpinner()
        userBusinessLogic.getSession(credentials: credentials)
            .done { _ in
                self.serviceProvider.navigator.popToRoot()
                self.delegate?.clearFields()
            }.catch { error in
                self.delegate?.showError(message: error.localizedDescription)
            }.finally {
                self.delegate?.hideSpinner()
        }
    }

}