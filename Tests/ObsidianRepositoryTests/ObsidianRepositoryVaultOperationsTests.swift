import Testing
import Foundation
import Combine
import MicroClient
import ObsidianNetworking
@testable import ObsidianRepository

@Suite("ObsidianRepository Vault Operations Tests")
struct ObsidianRepositoryVaultOperationsTests {

    @Test("It should list vault directory and return file paths")
    func testListVaultDirectory() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let expectedFiles = ["note1.md", "note2.md", "note3.md"]
        let stubbedResponse = try NetworkResponseMother.makeDirectoryListingResponse(
            files: expectedFiles
        )
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        let files = try await repository.listVaultDirectory()

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/vault/",
            "It should use the correct vault directory path"
        )
        #expect(
            mockClient.lastRequestMethod == .get,
            "It should use GET method"
        )
        #expect(
            files == expectedFiles,
            "It should return the correct file paths"
        )
    }
}
