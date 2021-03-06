import Combine

protocol UserBusinessLogicType {
    var user: AnyPublisher<User?, Never> { get }
    func fetchUser()
    #if !os(tvOS)
    func getUser() -> AnyPublisher<Void, Error>
    #endif
    #if os(iOS) || os(macOS)
    func update(user: User) -> AnyPublisher<Void, Error>
    #endif
}

final class UserBusinessLogic: UserBusinessLogicType {
    private let networkService: NetworkService
    private let dataService: DataService
    private var cancellables: Set<AnyCancellable> = []

    @Published private var internalUser: User?

    var user: AnyPublisher<User?, Never> { $internalUser.removeDuplicates().eraseToAnyPublisher() }

    init(networkService: NetworkService, dataService: DataService) {
        self.networkService = networkService
        self.dataService = dataService
        self.internalUser = User.load(dataService: dataService)
    }

    func fetchUser() {
        getUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellables)
    }

    func getUser() -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.user,
                     method: .get,
                     body: nil)
            .tryMap { (user: User) in
                if case .failure(let error) = user.save(dataService: self.dataService) { throw error }
                self.internalUser = user
            }.eraseToAnyPublisher()
    }

    #if os(iOS) || os(macOS)
    func update(user: User) -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.user,
                     method: .patch,
                     body: user)
            .tryMap { (user: User) in
                if case .failure(let error) = user.save(dataService: self.dataService) { throw error }
                self.internalUser = user
            }.eraseToAnyPublisher()
    }
    #endif
}

#if DEBUG
extension Stub {
    final class StubUserBusinessLogic: UserBusinessLogicType {
        let user: AnyPublisher<User?, Never> = Just(User(
            name: "Name",
            payday: 10,
            startDate: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
            largeTransaction: 10,
            allowance: 100.22,
            balance: 211.20)).eraseToAnyPublisher()
        func fetchUser() {}
        #if !os(tvOS)
        func getUser() -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
        #endif
        #if os(iOS) || os(macOS)
        func update(user: User) -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
        #endif
    }
}
#endif
