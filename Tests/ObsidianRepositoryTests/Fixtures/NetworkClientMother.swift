import Foundation
import MicroClient

// swiftlint:disable force_unwrapping

enum NetworkClientMother {

    static func makeMockNetworkClient() -> NetworkClientMock {
        let configuration = NetworkConfiguration(
            session: URLSession.shared,
            defaultDecoder: JSONDecoder(),
            defaultEncoder: JSONEncoder(),
            baseURL: URL(string: "https://test.com")!
        )

        return NetworkClientMock(configuration: configuration)
    }
}

// swiftlint:enable force_unwrapping
