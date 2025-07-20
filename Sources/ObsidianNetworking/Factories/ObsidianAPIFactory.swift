import Foundation
import MicroClient

public struct ObsidianAPIFactory: ObsidianAPIFactoryProtocol {

    // MARK: - Life cycle

    public init() {}

    // MARK: - Public

    public func makeObsidianAPIClient(
        baseURL: URL,
        userToken: @escaping () -> String?
    ) -> NetworkClientProtocol {
        let configuration = NetworkConfiguration(
            session: URLSession.shared,
            defaultDecoder: JSONDecoder(),
            defaultEncoder: JSONEncoder(),
            baseURL: baseURL
        )

        configuration.interceptor = { request in
            var modifiedRequest = request
            if let token = userToken() {
                modifiedRequest.setValue(
                    "Bearer \(token)",
                    forHTTPHeaderField: "Authorization"
                )
            }
            return modifiedRequest
        }

        return NetworkClient(configuration: configuration)
    }
}
