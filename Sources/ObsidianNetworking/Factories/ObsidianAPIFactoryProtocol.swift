import Foundation
import MicroClient

public protocol ObsidianAPIFactoryProtocol {

    func makeObsidianAPIClient(
        baseURL: URL,
        userToken: @escaping () -> String?
    ) -> NetworkClientProtocol
}
