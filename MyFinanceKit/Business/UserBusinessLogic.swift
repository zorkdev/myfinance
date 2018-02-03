import PromiseKit

public struct UserBusinessLogic {

    public init() {}

    public func getCurrentUser() -> Promise<User> {
        guard let url = ZorkdevAPI.user.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return NetworkManager.shared.performRequest(api: .zorkdev,
                                                    method: .get,
                                                    url: url)
            .then { data in
                guard let user = JSONCoder.shared.decode(User.self, from: data) else {
                    return Promise(error: AppError.jsonParsingError)
                }

                DataManager.shared.allowance = user.allowance

                return Promise(value: user)
        }
    }

}
