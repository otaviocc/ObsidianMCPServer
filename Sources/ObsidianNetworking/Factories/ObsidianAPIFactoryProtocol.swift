import Foundation
import MicroClient

public protocol ObsidianAPIFactoryProtocol {

    /// Creates a configured network client for communicating with the Obsidian API.
    /// - Parameters:
    ///   - baseURL: The base URL of the Obsidian server instance
    ///   - userToken: A closure that returns the authentication token when called,
    ///                or nil if no token is available
    /// - Returns: A `NetworkClientProtocol` instance configured for Obsidian API communication
    func makeObsidianAPIClient(
        baseURL: URL,
        userToken: @escaping @Sendable () async -> String?
    ) -> NetworkClientProtocol
}
