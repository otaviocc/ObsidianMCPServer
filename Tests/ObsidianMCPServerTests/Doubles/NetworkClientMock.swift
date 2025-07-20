import Combine
import Foundation
import MicroClient
import ObsidianNetworking

final class NetworkClientMock: NetworkClientProtocol {

    // MARK: - Mock State

    var runCallCount = 0
    var lastRequestPath: String?
    var lastRequestMethod: String?
    var mockError: Error?
    var mockResponses: [String: Any] = [:]

    // MARK: - NetworkClientProtocol

    required init(configuration: NetworkConfiguration) {}

    func run<Input: Encodable, Output: Decodable>(
        _ request: NetworkRequest<Input, Output>
    ) async throws -> NetworkResponse<Output> {
        runCallCount += 1
        lastRequestPath = request.path
        lastRequestMethod = request.method.rawValue

        // If mockError is set, throw it
        if let error = mockError {
            throw error
        }

        // For now, always throw error since NetworkResponse initializer is internal
        // This allows us to test request construction and error handling
        throw NetworkErrorMock.noMockResponse
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
        mockResponses.removeAll()
    }

    func setMockError(_ error: Error) {
        mockError = error
    }

    func setMockResponse<T>(
        for path: String,
        response: T
    ) {
        mockResponses[path] = response
        mockError = nil // Clear error when setting successful response
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
