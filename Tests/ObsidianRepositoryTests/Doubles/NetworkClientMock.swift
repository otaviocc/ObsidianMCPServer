import Combine
import Foundation
import MicroClient
import ObsidianNetworking

final class NetworkClientMock: NetworkClientProtocol, @unchecked Sendable {

    // MARK: - Nested types

    enum NetworkClientMockError: Error {

        case stubMissingForRun
    }

    // MARK: - Properties

    private(set) var runCallCount = 0
    private(set) var lastRequestPath: String?
    private(set) var lastRequestMethod: HTTPMethod?
    private(set) var stubbedNetworkResponse: Any?
    private(set) var stubbedNetworkResponses: [Any] = []

    // MARK: - Life cycle

    init(configuration _: NetworkConfiguration) {}

    init() {}

    // MARK: - Public

    func run<ResponseModel>(
        _ networkRequest: NetworkRequest<some Any, ResponseModel>
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
}

extension NetworkClientMock {

    // MARK: - Stubs

    func stubNetworkResponse(
        toReturn networkResponse: NetworkResponse<some Decodable>
    ) {
        stubbedNetworkResponse = networkResponse
    }

    func stubNetworkResponses(
        toReturn networkResponses: [NetworkResponse<some Decodable>]
    ) {
        stubbedNetworkResponses = networkResponses
    }

    func addNetworkResponse(
        toReturn networkResponse: NetworkResponse<some Decodable>
    ) {
        stubbedNetworkResponses.append(networkResponse)
    }
}
