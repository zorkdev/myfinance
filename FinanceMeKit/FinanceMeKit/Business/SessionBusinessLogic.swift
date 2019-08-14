import Combine

public protocol SessionBusinessLogicType {
    var isLoggedIn: AnyPublisher<Bool, Never> { get }
    func login(credentials: Credentials) -> AnyPublisher<Void, Error>
    func logOut()
}

class SessionBusinessLogic: SessionBusinessLogicType {
    private let networkService: NetworkService
    private let sessionService: SessionService

    @Published private var internalIsLoggedIn: Bool = false

    var isLoggedIn: AnyPublisher<Bool, Never> { $internalIsLoggedIn.eraseToAnyPublisher() }

    init(networkService: NetworkService, sessionService: SessionService) {
        self.networkService = networkService
        self.sessionService = sessionService
        self.internalIsLoggedIn = sessionService.hasSession
    }

    func login(credentials: Credentials) -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.login,
                     method: .post,
                     body: credentials)
            .tryMap { (session: Session) in
                if case .failure(let error) = self.sessionService.save(session: session) { throw error }
                self.internalIsLoggedIn = self.sessionService.hasSession
            }.eraseToAnyPublisher()
    }

    func logOut() {
        sessionService.logOut()
        internalIsLoggedIn = sessionService.hasSession
    }
}
