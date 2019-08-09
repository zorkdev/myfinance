public protocol AppStateType: AnyObject,
NetworkServiceProvider
& SessionServiceProvider
& DataServiceProvider
& LoggingServiceProvider
& ConfigServiceProvider {}

public class AppState: AppStateType {
    public let networkService: NetworkService
    public let sessionService: SessionService
    public let dataService: DataService
    public let loggingService: LoggingService
    public let configService: ConfigService

    public init() {
        configService = DefaultConfigService()
        loggingService = DefaultLoggingService(configService: configService)
        dataService = KeychainDataService(configService: configService)
        sessionService = DefaultSessionService(dataService: dataService)
        networkService = DefaultNetworkService(networkRequestable: URLSession.shared,
                                               loggingService: loggingService,
                                               sessionService: sessionService)
    }

    public init(networkService: NetworkService,
                sessionService: SessionService,
                dataService: DataService,
                loggingService: LoggingService,
                configService: ConfigService) {
        self.networkService = networkService
        self.sessionService = sessionService
        self.dataService = dataService
        self.loggingService = loggingService
        self.configService = configService
    }
}