// MIT License
//
// Copyright (c) 2026 Otávio C.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
