import Combine
import Foundation
import MicroClient

final class NetworkClientMock: NetworkClientProtocol {

    // MARK: - Mock State

    var runCallCount = 0
    var lastRequestPath: String?
    var lastRequestMethod: String?
    var mockError: Error = NetworkErrorMock.noMockResponse

    // MARK: - NetworkClientProtocol

    required init(configuration: NetworkConfiguration) {}

    func run<Input: Encodable, Output: Decodable>(
        _ request: NetworkRequest<Input, Output>
    ) async throws -> NetworkResponse<Output> {
        runCallCount += 1
        lastRequestPath = request.path
        lastRequestMethod = request.method.rawValue

        throw mockError
    }

    var status: AsyncStream<NetworkClientStatus> {
        AsyncStream { continuation in
            continuation.yield(.idle)
            continuation.finish()
        }
    }

    func statusPublisher() -> AnyPublisher<NetworkClientStatus, Never> {
        Just(.idle).eraseToAnyPublisher()
    }

    // MARK: - Mock Helpers

    func reset() {
        runCallCount = 0
        lastRequestPath = nil
        lastRequestMethod = nil
        mockError = NetworkErrorMock.noMockResponse
    }

    func setMockError(_ error: Error) {
        mockError = error
    }

    func verifyNoNetworkCalls() -> Bool {
        runCallCount == 0
    }

    func verifyNetworkCallMade(to path: String? = nil) -> Bool {
        if let expectedPath = path {
            return runCallCount > 0 && lastRequestPath == expectedPath
        }
        return runCallCount > 0
    }
}
