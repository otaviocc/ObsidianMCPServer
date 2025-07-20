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
        let delegate = InsecureURLSessionDelegate()

        let session = URLSession(
            configuration: .default,
            delegate: delegate,
            delegateQueue: nil
        )

        let configuration = NetworkConfiguration(
            session: session,
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

// MARK: - URLSessionDelegate

final class InsecureURLSessionDelegate: NSObject, URLSessionDelegate {

    // MARK: - Public

    /// Handles server trust authentication challenges by accepting self-signed certificates.
    ///
    /// This method is specifically used to ignore the self-signed certificate of the Obsidian REST API community plugin,
    /// allowing connections to proceed without standard certificate validation. This is necessary for development or
    /// community plugin environments where a trusted certificate authority is not used.
    ///
    /// - Parameters:
    ///   - session: The URL session containing the task that received the authentication challenge.
    ///   - challenge: The authentication challenge that needs to be handled.
    ///   - completionHandler: A closure that your handler must call, providing information about how to handle the challenge.
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        let credential = challenge.protectionSpace.serverTrust.flatMap(URLCredential.init)
        completionHandler(.useCredential, credential)
    }
}
