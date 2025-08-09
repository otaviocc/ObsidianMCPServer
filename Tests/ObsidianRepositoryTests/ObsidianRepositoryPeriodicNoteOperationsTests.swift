import Testing

@testable import ObsidianRepository

@Suite("ObsidianRepository Periodic Note Operations Tests")
struct ObsidianRepositoryPeriodicNoteOperationsTests {

    @Test("It should get periodic note and return mapped File")
    func getPeriodicNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeNoteJSONResponse(
            path: "2024-01-15.md",
            content: "# Daily Note - Complete project"
        )
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        let file = try await repository.getPeriodicNote(period: "daily")

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/daily/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .get,
            "It should use GET method"
        )
        #expect(
            file.filename == "2024-01-15.md",
            "It should return the correct filename"
        )
        #expect(
            file.content == "# Daily Note - Complete project",
            "It should return the correct content"
        )
    }

    @Test("It should get periodic note for different periods")
    func getPeriodicNoteForDifferentPeriods() async throws {
        let periods = ["daily", "weekly", "monthly", "quarterly", "yearly"]

        for period in periods {
            // Given
            let mockClient = NetworkClientMother.makeMockNetworkClient()
            let repository = ObsidianRepository(client: mockClient)
            let stubbedResponse = try NetworkResponseMother.makeNoteJSONResponse(
                path: "\(period)-note.md",
                content: "# \(period.capitalized) Note"
            )
            mockClient.stubNetworkResponse(toReturn: stubbedResponse)

            // When
            let file = try await repository.getPeriodicNote(period: period)

            // Then
            #expect(
                mockClient.lastRequestPath == "/periodic/\(period)/",
                "It should use the correct path for \(period) period"
            )
            #expect(
                file.filename == "\(period)-note.md",
                "It should return the correct filename for \(period) period"
            )
        }
    }

    @Test("It should create or update periodic note")
    func createOrUpdatePeriodicNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.createOrUpdatePeriodicNote(period: "weekly", content: "# Weekly Review")

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/weekly/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .put,
            "It should use PUT method"
        )
    }

    @Test("It should append to periodic note")
    func appendToPeriodicNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToPeriodicNote(period: "monthly", content: "\n\n## New Entry")

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/monthly/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .post,
            "It should use POST method"
        )
    }

    @Test("It should delete periodic note")
    func deletePeriodicNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.deletePeriodicNote(period: "quarterly")

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/quarterly/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .delete,
            "It should use DELETE method"
        )
    }

    // MARK: - Date-Specific Periodic Note Operations Tests

    @Test("It should get periodic note for specific date")
    func getPeriodicNoteForDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeNoteJSONResponse(
            path: "2024-01-15.md",
            content: "# Daily Note - January 15, 2024"
        )
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        let file = try await repository.getPeriodicNote(
            period: "daily",
            year: 2024,
            month: 1,
            day: 15
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/daily/2024/01/15/",
            "It should use the correct request path with date"
        )
        #expect(
            mockClient.lastRequestMethod == .get,
            "It should use GET method"
        )
        #expect(
            file.filename == "2024-01-15.md",
            "It should return the correct filename"
        )
        #expect(
            file.content == "# Daily Note - January 15, 2024",
            "It should return the correct content"
        )
    }

    @Test("It should create or update periodic note for specific date")
    func createOrUpdatePeriodicNoteForDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.createOrUpdatePeriodicNote(
            period: "weekly",
            content: "# Week 3 of 2024",
            year: 2024,
            month: 1,
            day: 15
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/weekly/2024/01/15/",
            "It should use the correct request path with date"
        )
        #expect(
            mockClient.lastRequestMethod == .put,
            "It should use PUT method"
        )
    }

    @Test("It should append to periodic note for specific date")
    func appendToPeriodicNoteForDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToPeriodicNote(
            period: "monthly",
            content: "\n\n## New Achievement for March",
            year: 2024,
            month: 3,
            day: 1
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/monthly/2024/03/01/",
            "It should use the correct request path with date"
        )
        #expect(
            mockClient.lastRequestMethod == .post,
            "It should use POST method"
        )
    }

    @Test("It should delete periodic note for specific date")
    func deletePeriodicNoteForDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.deletePeriodicNote(
            period: "yearly",
            year: 2023,
            month: 12,
            day: 31
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/yearly/2023/12/31/",
            "It should use the correct request path with date"
        )
        #expect(
            mockClient.lastRequestMethod == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should handle get periodic note errors for specific date")
    func getPeriodicNoteForDateError() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let errorResponse = try NetworkResponseMother.makeErrorResponse(statusCode: 404)
        mockClient.stubNetworkResponse(toReturn: errorResponse)

        // When/Then
        await #expect(throws: Error.self) {
            _ = try await repository.getPeriodicNote(
                period: "daily",
                year: 2024,
                month: 2,
                day: 29
            )
        }

        #expect(
            mockClient.runCallCount == 1,
            "It should attempt the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/daily/2024/02/29/",
            "It should use the correct request path"
        )
    }
}
