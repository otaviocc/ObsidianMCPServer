import Foundation
import MicroClient

enum NetworkClientMother {

    static func makeMockNetworkClient() -> NetworkClientMock {
        let configuration = NetworkConfiguration(
            session: URLSession.shared,
            defaultDecoder: JSONDecoder(),
            defaultEncoder: JSONEncoder(),
            baseURL: URL(string: "https://test.com")!,
            interceptors: []
        )

        return NetworkClientMock(configuration: configuration)
    }
}
