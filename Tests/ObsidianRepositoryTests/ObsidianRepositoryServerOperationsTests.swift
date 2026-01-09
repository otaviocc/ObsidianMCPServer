import Testing
@testable import ObsidianRepository

@Suite("ObsidianRepository Server Operations Tests")
struct ObsidianRepositoryServerOperationsTests {

    @Test("It should get server info and return mapped ServerInformation")
    func getServerInfo() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeServerInfoResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        let serverInfo = try await repository.getServerInfo()

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .get,
            "It should use GET method"
        )
        #expect(
            serverInfo.service == "obsidian-local-rest-api",
            "It should return the correct service name"
        )
        #expect(
            serverInfo.version == "1.2.3",
            "It should return the correct version"
        )
    }
}
