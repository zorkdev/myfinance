public enum AppError: Error, LocalizedError, Equatable {
    case unknownError
    case apiPathInvalid
    case urlQueryInvalid
    case jsonParsingError

    public var errorDescription: String? {
        return "Sorry, something went wrong. Please try again."
    }
}

public enum APIError: Int, Error, LocalizedError, Equatable {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500

    public var errorDescription: String? {
        return "Sorry, something went wrong. Please try again."
    }

    init?(httpError: PMKHTTPError) {
        guard case let .badStatusCode(statusCode, _, _) = httpError,
            let apiError = APIError(rawValue: statusCode) else {
                return nil
        }

        self = apiError
    }
}
