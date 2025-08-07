import Combine
import Foundation
import MicroClient
import ObsidianNetworking

final class NetworkClientMock: NetworkClientProtocol {

    // MARK: - Nested types

    enum NetworkClientMockError: Error {
        case stubMissingForRun
    }

    // MARK: - Properties

    private(set) var runCallCount = 0
    private(set) var lastRequestPath: String?
    private(set) var lastRequestMethod: HTTPMethod?
    private(set) var stubbedNetworkResponse: Any?
    private(set) var stubbedStatus: NetworkClientStatus?
    private(set) var stubbedNetworkResponses: [Any] = []

    // MARK: - Life cycle

    init(configuration: NetworkConfiguration) {}

    // MARK: - Public

    func run<RequestModel, ResponseModel>(
        _ networkRequest: NetworkRequest<RequestModel, ResponseModel>
    ) async throws -> NetworkResponse<ResponseModel> {
        runCallCount += 1
        lastRequestPath = networkRequest.path
        lastRequestMethod = networkRequest.method

        // Check if we have multiple responses queued
        if !stubbedNetworkResponses.isEmpty {
            let nextResponse = stubbedNetworkResponses.removeFirst()
            if let stubbedResponse = nextResponse as? NetworkResponse<ResponseModel> {
                return stubbedResponse
            }
        }

        // Fall back to single response behavior
        if let stubbedResponse = stubbedNetworkResponse as? NetworkResponse<ResponseModel> {
            return stubbedResponse
        }

        throw NetworkClientMockError.stubMissingForRun
    }

    func statusPublisher() -> AnyPublisher<NetworkClientStatus, Never> {
        Just(stubbedStatus ?? .idle).eraseToAnyPublisher()
    }
}

extension NetworkClientMock {

    // MARK: - Stubs

    func stubStatus(
        toReturn status: NetworkClientStatus
    ) {
        stubbedStatus = status
    }

    func stubNetworkResponse<ResponseModel: Decodable>(
        toReturn networkResponse: NetworkResponse<ResponseModel>
    ) {
        stubbedNetworkResponse = networkResponse
    }

    func stubNetworkResponses<ResponseModel: Decodable>(
        toReturn networkResponses: [NetworkResponse<ResponseModel>]
    ) {
        stubbedNetworkResponses = networkResponses
    }

    func addNetworkResponse<ResponseModel: Decodable>(
        toReturn networkResponse: NetworkResponse<ResponseModel>
    ) {
        stubbedNetworkResponses.append(networkResponse)
    }
}
