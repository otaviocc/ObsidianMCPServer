import Testing

@testable import ObsidianRepository

@Suite("ObsidianRepository Bulk Operations Tests")
struct ObsidianRepositoryBulkOperationsTests {

    @Test("It should apply tags to all files from search results")
    func bulkApplyTagsFromSearchSuccess() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        
        let searchResults = [
            ("note1.md", 0.95 as Float),
            ("note2.md", 0.87 as Float)
        ]
        let searchResponse = try NetworkResponseMother.makeSearchResponse(results: searchResults)
        let frontmatterResponse1 = try NetworkResponseMother.makeFrontmatterUpdateResponse()
        let frontmatterResponse2 = try NetworkResponseMother.makeFrontmatterUpdateResponse()
        
        mockClient.addNetworkResponse(toReturn: searchResponse)
        mockClient.addNetworkResponse(toReturn: frontmatterResponse1)
        mockClient.addNetworkResponse(toReturn: frontmatterResponse2)

        // When
        let result = try await repository.bulkApplyTagsFromSearch(
            query: "test query",
            tags: ["project", "important"]
        )

        // Then
        #expect(
            result.successful.count == 2,
            "It should successfully process both files"
        )
        #expect(
            result.failed.isEmpty,
            "It should have no failures"
        )
        #expect(
            result.totalProcessed == 2,
            "It should process the correct total number of files"
        )
        #expect(
            result.query == "test query",
            "It should preserve the original query"
        )
        #expect(
            result.successful.contains("note1.md"),
            "It should include the first note in successful results"
        )
        #expect(
            result.successful.contains("note2.md"),
            "It should include the second note in successful results"
        )
        #expect(
            mockClient.runCallCount == 3,
            "It should make one search call and two frontmatter update calls"
        )
    }

    @Test("It should handle partial failures when applying tags")
    func bulkApplyTagsFromSearchPartialFailure() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        
        let searchResults = [
            ("note1.md", 0.95 as Float),
            ("note2.md", 0.87 as Float)
        ]
        let searchResponse = try NetworkResponseMother.makeSearchResponse(results: searchResults)
        let successResponse = try NetworkResponseMother.makeFrontmatterUpdateResponse()
        let failureResponse = try NetworkResponseMother.makeErrorResponse(statusCode: 404)
        
        mockClient.addNetworkResponse(toReturn: searchResponse)
        mockClient.addNetworkResponse(toReturn: successResponse)
        mockClient.addNetworkResponse(toReturn: failureResponse)

        // When
        let result = try await repository.bulkApplyTagsFromSearch(
            query: "test query",
            tags: ["project"]
        )

        // Then
        #expect(
            result.successful.count == 1,
            "It should have one successful operation"
        )
        #expect(
            result.failed.count == 1,
            "It should have one failed operation"
        )
        #expect(
            result.totalProcessed == 2,
            "It should process the correct total number of files"
        )
        #expect(
            result.successful.contains("note1.md"),
            "It should include the successful note"
        )
        #expect(
            result.failed.first?.filename == "note2.md",
            "It should include the failed note in failures"
        )
        #expect(
            result.failed.first?.error.contains("404") == true,
            "It should include the error message"
        )
    }

    @Test("It should replace frontmatter field for all files from search results")
    func bulkReplaceFrontmatterFromSearchSuccess() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        
        let searchResults = [
            ("project1.md", 0.95 as Float),
            ("project2.md", 0.87 as Float)
        ]
        let searchResponse = try NetworkResponseMother.makeSearchResponse(results: searchResults)
        let frontmatterResponse1 = try NetworkResponseMother.makeFrontmatterUpdateResponse()
        let frontmatterResponse2 = try NetworkResponseMother.makeFrontmatterUpdateResponse()
        
        mockClient.addNetworkResponse(toReturn: searchResponse)
        mockClient.addNetworkResponse(toReturn: frontmatterResponse1)
        mockClient.addNetworkResponse(toReturn: frontmatterResponse2)

        // When
        let result = try await repository.bulkReplaceFrontmatterFromSearch(
            query: "project",
            key: "status",
            value: ["completed"]
        )

        // Then
        #expect(
            result.successful.count == 2,
            "It should successfully process both files"
        )
        #expect(
            result.failed.isEmpty,
            "It should have no failures"
        )
        #expect(
            result.totalProcessed == 2,
            "It should process the correct total number of files"
        )
        #expect(
            result.query == "project",
            "It should preserve the original query"
        )
        #expect(
            mockClient.runCallCount == 3,
            "It should make one search call and two frontmatter update calls"
        )
    }

    @Test("It should append to frontmatter field for all files from search results")
    func bulkAppendToFrontmatterFromSearchSuccess() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        
        let searchResults = [
            ("meeting1.md", 0.95 as Float)
        ]
        let searchResponse = try NetworkResponseMother.makeSearchResponse(results: searchResults)
        let frontmatterResponse = try NetworkResponseMother.makeFrontmatterUpdateResponse()
        
        mockClient.addNetworkResponse(toReturn: searchResponse)
        mockClient.addNetworkResponse(toReturn: frontmatterResponse)

        // When
        let result = try await repository.bulkAppendToFrontmatterFromSearch(
            query: "meeting",
            key: "attendees",
            value: ["john.doe", "jane.smith"]
        )

        // Then
        #expect(
            result.successful.count == 1,
            "It should successfully process the file"
        )
        #expect(
            result.failed.isEmpty,
            "It should have no failures"
        )
        #expect(
            result.totalProcessed == 1,
            "It should process the correct total number of files"
        )
        #expect(
            result.successful.first == "meeting1.md",
            "It should include the meeting note in successful results"
        )
        #expect(
            mockClient.runCallCount == 2,
            "It should make one search call and one frontmatter update call"
        )
    }

    @Test("It should handle empty search results gracefully")
    func bulkOperationsWithEmptySearchResults() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        
        let emptySearchResponse = try NetworkResponseMother.makeSearchResponse(results: [])
        mockClient.stubNetworkResponse(toReturn: emptySearchResponse)

        // When
        let result = try await repository.bulkApplyTagsFromSearch(
            query: "nonexistent",
            tags: ["test"]
        )

        // Then
        #expect(
            result.successful.isEmpty,
            "It should have no successful operations"
        )
        #expect(
            result.failed.isEmpty,
            "It should have no failed operations"
        )
        #expect(
            result.totalProcessed == 0,
            "It should process zero files"
        )
        #expect(
            result.query == "nonexistent",
            "It should preserve the original query"
        )
        #expect(
            mockClient.runCallCount == 1,
            "It should only make the search call"
        )
    }

    @Test("It should handle search operation failure")
    func bulkOperationsWithSearchFailure() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        
        let searchErrorResponse = try NetworkResponseMother.makeErrorResponse(statusCode: 500)
        mockClient.stubNetworkResponse(toReturn: searchErrorResponse)

        // When/Then
        await #expect(throws: Error.self) {
            try await repository.bulkApplyTagsFromSearch(
                query: "test",
                tags: ["tag"]
            )
        }
        
        #expect(
            mockClient.runCallCount == 1,
            "It should only make the search call before failing"
        )
    }
}