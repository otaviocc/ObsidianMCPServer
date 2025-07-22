import Testing
import Foundation
import Combine
import MicroClient
import ObsidianNetworking
@testable import ObsidianRepository

@Suite("ObsidianRepository Search Operations Tests")
struct ObsidianRepositorySearchOperationsTests {

    @Test("It should search vault and return mapped SearchResults")
    func testSearchVault() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let expectedResults = [
            ("note1.md", 0.95 as Float),
            ("note2.md", 0.87 as Float),
            ("folder/note3.md", 0.73 as Float)
        ]
        let stubbedResponse = try NetworkResponseMother.makeSearchResponse(
            results: expectedResults
        )
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        let searchResults = try await repository.searchVault(
            query: "test search"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/search/simple/",
            "It should use the correct search path"
        )
        #expect(
            mockClient.lastRequestMethod == .post,
            "It should use POST method"
        )
        #expect(
            searchResults.count == 3,
            "It should return the correct number of results"
        )
        #expect(
            searchResults[0].path == "note1.md",
            "It should return the correct first result path"
        )
        #expect(
            searchResults[0].score == 0.95,
            "It should return the correct first result score"
        )
        #expect(
            searchResults[1].path == "note2.md",
            "It should return the correct second result path"
        )
        #expect(
            searchResults[1].score == 0.87,
            "It should return the correct second result score"
        )
        #expect(
            searchResults[2].path == "folder/note3.md",
            "It should return the correct third result path"
        )
        #expect(
            searchResults[2].score == 0.73,
            "It should return the correct third result score"
        )
    }
}
