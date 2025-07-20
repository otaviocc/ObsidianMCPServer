import Testing
import Foundation
import MicroClient
@testable import ObsidianNetworking

@Suite("ObsidianAPIFactory Tests")
struct ObsidianAPIFactoryTests {

    let factory = ObsidianAPIFactory()
    let testBaseURL = URL(string: "https://api.obsidian.test")! // swiftlint:disable:this force_unwrapping
    let testToken = "test-auth-token-123"

    // MARK: - Client Creation Tests

    @Test("It should create a NetworkClient that conforms to NetworkClientProtocol")
    func testMakeObsidianAPIClientReturnsCorrectType() {
        let tokenProvider: () -> String? = { self.testToken }

        let client = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        #expect(
            client is NetworkClient,
            "It should create a NetworkClient instance"
        )
    }

    @Test("It should create different client instances for each call")
    func testMakeObsidianAPIClientCreatesNewInstances() {
        let tokenProvider: () -> String? = { self.testToken }

        let client1 = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        let client2 = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        guard let networkClient1 = client1 as? NetworkClient,
              let networkClient2 = client2 as? NetworkClient else {
            Issue.record("Clients should be NetworkClient instances")
            return
        }

        #expect(
            networkClient1 !== networkClient2,
            "It should create different instances each time"
        )
    }

    @Test("It should handle different base URLs")
    func testMakeObsidianAPIClientWithDifferentBaseURLs() {
        let httpsURL = URL(string: "https://secure.obsidian.test")! // swiftlint:disable:this force_unwrapping
        let httpURL = URL(string: "http://local.obsidian.test:8080")! // swiftlint:disable:this force_unwrapping
        let tokenProvider: () -> String? = { self.testToken }

        let httpsClient = factory.makeObsidianAPIClient(baseURL: httpsURL, userToken: tokenProvider)
        let httpClient = factory.makeObsidianAPIClient(baseURL: httpURL, userToken: tokenProvider)

        guard let httpsNetworkClient = httpsClient as? NetworkClient,
              let httpNetworkClient = httpClient as? NetworkClient else {
            Issue.record("Clients should be NetworkClient instances")
            return
        }

        #expect(
            httpsNetworkClient !== httpNetworkClient,
            "It should create different instances for different URLs"
        )
    }

    @Test("It should handle base URLs with paths and query parameters")
    func testMakeObsidianAPIClientWithComplexBaseURL() {
        // swiftlint:disable:next force_unwrapping
        let complexURL = URL(string: "https://api.obsidian.test/v1/vault?version=2")!
        let tokenProvider: () -> String? = { self.testToken }

        let client = factory.makeObsidianAPIClient(
            baseURL: complexURL,
            userToken: tokenProvider
        )

        #expect(
            client is NetworkClient,
            "It should handle complex base URLs"
        )
    }

    // MARK: - Token Provider Tests

    @Test("It should accept token provider that returns a valid token")
    func testMakeObsidianAPIClientWithValidTokenProvider() {
        let tokenProvider: () -> String? = { "valid-token-123" }

        let client = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        #expect(
            client is NetworkClient,
            "It should create client with valid token provider"
        )
    }

    @Test("It should accept token provider that returns nil")
    func testMakeObsidianAPIClientWithNilTokenProvider() {
        let tokenProvider: () -> String? = { nil }

        let client = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        #expect(
            client is NetworkClient,
            "It should create client with nil token provider"
        )
    }

    @Test("It should accept token provider that returns empty string")
    func testMakeObsidianAPIClientWithEmptyTokenProvider() {
        let tokenProvider: () -> String? = { "" }

        let client = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        #expect(
            client is NetworkClient,
            "It should create client with empty token provider"
        )
    }

    @Test("It should handle dynamic token changes")
    func testMakeObsidianAPIClientWithDynamicTokenProvider() {
        var currentToken: String? = "initial-token"
        let tokenProvider: () -> String? = { currentToken }

        let client = factory.makeObsidianAPIClient(
            baseURL: testBaseURL,
            userToken: tokenProvider
        )

        #expect(
            client is NetworkClient,
            "It should create client with initial token"
        )

        currentToken = "updated-token"
        #expect(
            client is NetworkClient,
            "It should handle token updates"
        )

        currentToken = nil
        #expect(
            client is NetworkClient,
            "It should handle token removal"
        )
    }
}
