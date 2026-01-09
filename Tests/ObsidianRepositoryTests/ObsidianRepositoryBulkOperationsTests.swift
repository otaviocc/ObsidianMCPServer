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

    @Test("It should handle partial failures when replacing frontmatter string")
    func bulkReplaceFrontmatterStringFromSearchPartialFailure() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)

        let searchResults = [
            ("note1.md", 0.95 as Float),
            ("note2.md", 0.87 as Float),
            ("note3.md", 0.75 as Float)
        ]
        let searchResponse = try NetworkResponseMother.makeSearchResponse(results: searchResults)
        let successResponse1 = try NetworkResponseMother.makeFrontmatterUpdateResponse()
        let failureResponse = try NetworkResponseMother.makeErrorResponse(statusCode: 404)
        let successResponse2 = try NetworkResponseMother.makeFrontmatterUpdateResponse()

        mockClient.addNetworkResponse(toReturn: searchResponse)
        mockClient.addNetworkResponse(toReturn: successResponse1)
        mockClient.addNetworkResponse(toReturn: failureResponse)
        mockClient.addNetworkResponse(toReturn: successResponse2)

        // When
        let result = try await repository.bulkReplaceFrontmatterStringFromSearch(
            query: "test query",
            key: "status",
            value: "completed"
        )

        // Then
        #expect(
            result.successful.count == 2,
            "It should have two successful operations"
        )
        #expect(
            result.failed.count == 1,
            "It should have one failed operation"
        )
        #expect(
            result.totalProcessed == 3,
            "It should process the correct total number of files"
        )
        #expect(
            result.successful.contains("note1.md"),
            "It should include the first successful note"
        )
        #expect(
            result.successful.contains("note3.md"),
            "It should include the third successful note"
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

    @Test("It should replace frontmatter string field for all files from search results")
    func bulkReplaceFrontmatterStringFromSearchSuccess() async throws {
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
        let result = try await repository.bulkReplaceFrontmatterStringFromSearch(
            query: "project",
            key: "status",
            value: "completed"
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

    @Test("It should handle partial failures when replacing frontmatter array")
    func bulkReplaceFrontmatterArrayFromSearchPartialFailure() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)

        let searchResults = [
            ("project1.md", 0.95 as Float),
            ("project2.md", 0.87 as Float)
        ]
        let searchResponse = try NetworkResponseMother.makeSearchResponse(results: searchResults)
        let successResponse = try NetworkResponseMother.makeFrontmatterUpdateResponse()
        let failureResponse = try NetworkResponseMother.makeErrorResponse(statusCode: 500)

        mockClient.addNetworkResponse(toReturn: searchResponse)
        mockClient.addNetworkResponse(toReturn: successResponse)
        mockClient.addNetworkResponse(toReturn: failureResponse)

        // When
        let result = try await repository.bulkReplaceFrontmatterArrayFromSearch(
            query: "project",
            key: "status",
            value: ["completed", "archived"]
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
            result.successful.contains("project1.md"),
            "It should include the successful note"
        )
        #expect(
            result.failed.first?.filename == "project2.md",
            "It should include the failed note in failures"
        )
        #expect(
            result.failed.first?.error.contains("500") == true,
            "It should include the error message"
        )
    }

    @Test("It should replace frontmatter array field for all files from search results")
    func bulkReplaceFrontmatterArrayFromSearchSuccess() async throws {
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
        let result = try await repository.bulkReplaceFrontmatterArrayFromSearch(
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

    @Test("It should handle partial failures when appending to frontmatter string")
    func bulkAppendToFrontmatterStringFromSearchPartialFailure() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)

        let searchResults = [
            ("meeting1.md", 0.95 as Float),
            ("meeting2.md", 0.87 as Float),
            ("meeting3.md", 0.75 as Float)
        ]
        let searchResponse = try NetworkResponseMother.makeSearchResponse(results: searchResults)
        let successResponse1 = try NetworkResponseMother.makeFrontmatterUpdateResponse()
        let failureResponse = try NetworkResponseMother.makeErrorResponse(statusCode: 403)
        let successResponse2 = try NetworkResponseMother.makeFrontmatterUpdateResponse()

        mockClient.addNetworkResponse(toReturn: searchResponse)
        mockClient.addNetworkResponse(toReturn: successResponse1)
        mockClient.addNetworkResponse(toReturn: failureResponse)
        mockClient.addNetworkResponse(toReturn: successResponse2)

        // When
        let result = try await repository.bulkAppendToFrontmatterStringFromSearch(
            query: "meeting",
            key: "description",
            value: "Additional notes"
        )

        // Then
        #expect(
            result.successful.count == 2,
            "It should have two successful operations"
        )
        #expect(
            result.failed.count == 1,
            "It should have one failed operation"
        )
        #expect(
            result.totalProcessed == 3,
            "It should process the correct total number of files"
        )
        #expect(
            result.successful.contains("meeting1.md"),
            "It should include the first successful note"
        )
        #expect(
            result.successful.contains("meeting3.md"),
            "It should include the third successful note"
        )
        #expect(
            result.failed.first?.filename == "meeting2.md",
            "It should include the failed note in failures"
        )
        #expect(
            result.failed.first?.error.contains("403") == true,
            "It should include the error message"
        )
    }

    @Test("It should append to frontmatter string field for all files from search results")
    func bulkAppendToFrontmatterStringFromSearchSuccess() async throws {
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
        let result = try await repository.bulkAppendToFrontmatterStringFromSearch(
            query: "meeting",
            key: "description",
            value: "Additional notes"
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

    @Test("It should handle partial failures when appending to frontmatter array")
    func bulkAppendToFrontmatterArrayFromSearchPartialFailure() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)

        let searchResults = [
            ("meeting1.md", 0.95 as Float),
            ("meeting2.md", 0.87 as Float)
        ]
        let searchResponse = try NetworkResponseMother.makeSearchResponse(results: searchResults)
        let successResponse = try NetworkResponseMother.makeFrontmatterUpdateResponse()
        let failureResponse = try NetworkResponseMother.makeErrorResponse(statusCode: 422)

        mockClient.addNetworkResponse(toReturn: searchResponse)
        mockClient.addNetworkResponse(toReturn: successResponse)
        mockClient.addNetworkResponse(toReturn: failureResponse)

        // When
        let result = try await repository.bulkAppendToFrontmatterArrayFromSearch(
            query: "meeting",
            key: "attendees",
            value: ["john.doe", "jane.smith"]
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
            result.successful.contains("meeting1.md"),
            "It should include the successful note"
        )
        #expect(
            result.failed.first?.filename == "meeting2.md",
            "It should include the failed note in failures"
        )
        #expect(
            result.failed.first?.error.contains("422") == true,
            "It should include the error message"
        )
    }

    @Test("It should append to frontmatter array field for all files from search results")
    func bulkAppendToFrontmatterArrayFromSearchSuccess() async throws {
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
        let result = try await repository.bulkAppendToFrontmatterArrayFromSearch(
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
