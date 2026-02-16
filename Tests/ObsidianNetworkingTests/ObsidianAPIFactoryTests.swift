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

import Foundation
import MicroClient
import Testing
@testable import ObsidianNetworking

@Suite("ObsidianAPIFactory Tests")
struct ObsidianAPIFactoryTests {

    let factory = ObsidianAPIFactory()
    let testBaseURL = URL(string: "https://api.obsidian.test")! // swiftlint:disable:this force_unwrapping

    // MARK: - Client Creation Tests

    @Test("It should create a NetworkClient that conforms to NetworkClientProtocol")
    func makeObsidianAPIClientReturnsCorrectType() {
        // Given
        let tokenProvider: @Sendable () -> String? = { "test-auth-token-123" }

        // When
        let client = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        // Then
        #expect(
            client is NetworkClient,
            "It should create a NetworkClient instance"
        )
    }

    @Test("It should create different client instances for each call")
    func makeObsidianAPIClientCreatesNewInstances() {
        // Given
        let tokenProvider: @Sendable () -> String? = { "test-auth-token-123" }

        // When
        let client1 = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        let client2 = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        // Then
        guard let networkClient1 = client1 as? NetworkClient,
              let networkClient2 = client2 as? NetworkClient
        else {
            Issue.record("Clients should be NetworkClient instances")
            return
        }

        #expect(
            networkClient1 !== networkClient2,
            "It should create different instances each time"
        )
    }

    @Test("It should handle different base URLs")
    func makeObsidianAPIClientWithDifferentBaseURLs() throws {
        let httpsURL = try #require(URL(string: "https://secure.obsidian.test"))
        let httpURL = try #require(URL(string: "http://local.obsidian.test:8080"))
        let tokenProvider: @Sendable () -> String? = { "test-auth-token-123" }

        let httpsClient = factory.makeObsidianAPIClient(baseURL: httpsURL, userToken: tokenProvider)
        let httpClient = factory.makeObsidianAPIClient(baseURL: httpURL, userToken: tokenProvider)

        guard let httpsNetworkClient = httpsClient as? NetworkClient,
              let httpNetworkClient = httpClient as? NetworkClient
        else {
            Issue.record("Clients should be NetworkClient instances")
            return
        }

        #expect(
            httpsNetworkClient !== httpNetworkClient,
            "It should create different instances for different URLs"
        )
    }

    @Test("It should handle base URLs with paths and query parameters")
    func makeObsidianAPIClientWithComplexBaseURL() throws {
        // Given
        let complexURL = try #require(URL(string: "https://api.obsidian.test/v1/vault?version=2"))
        let tokenProvider: @Sendable () -> String? = { "test-auth-token-123" }

        // When
        let client = factory.makeObsidianAPIClient(
            baseURL: complexURL,
            userToken: tokenProvider
        )

        // Then
        #expect(
            client is NetworkClient,
            "It should handle complex base URLs"
        )
    }

    // MARK: - Token Provider Tests

    @Test("It should accept token provider that returns a valid token")
    func makeObsidianAPIClientWithValidTokenProvider() {
        // Given
        let tokenProvider: @Sendable () -> String? = { "test-auth-token-123" }

        // When
        let client = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        // Then
        #expect(
            client is NetworkClient,
            "It should create client with valid token provider"
        )
    }

    @Test("It should accept token provider that returns nil")
    func makeObsidianAPIClientWithNilTokenProvider() {
        // Given
        let tokenProvider: @Sendable () -> String? = { nil }

        // When
        let client = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        // Then
        #expect(
            client is NetworkClient,
            "It should create client with nil token provider"
        )
    }

    @Test("It should accept token provider that returns empty string")
    func makeObsidianAPIClientWithEmptyTokenProvider() {
        // Given
        let tokenProvider: @Sendable () -> String? = { "" }

        // When
        let client = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        // Then
        #expect(
            client is NetworkClient,
            "It should create client with empty token provider"
        )
    }
}
