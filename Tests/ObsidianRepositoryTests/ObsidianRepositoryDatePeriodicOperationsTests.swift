import Testing

@testable import ObsidianRepository

@Suite("ObsidianRepository Date-Specific Periodic Note Operations Tests")
struct ObsidianRepositoryDatePeriodicOperationsTests {

    @Test("It should delete daily note for specific date")
    func deleteDailyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.deleteDailyNote(
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
            mockClient.lastRequestPath == "/periodic/daily/2024/1/15/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should append to monthly note for specific date")
    func appendToMonthlyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToMonthlyNote(
            year: 2024,
            month: 3,
            day: 20,
            content: "## New Monthly Entry"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/monthly/2024/3/20/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .post,
            "It should use POST method"
        )
    }

    @Test("It should create or update yearly note for specific date")
    func createOrUpdateYearlyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.createOrUpdateYearlyNote(
            year: 2024,
            month: 12,
            day: 31,
            content: "# Year 2024 Review"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/yearly/2024/12/31/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .put,
            "It should use PUT method"
        )
    }

    @Test("It should handle all periodic types with date-specific operations")
    func handleAllPeriodicTypesWithDateSpecificOperations() async throws {
        let periods = ["daily", "weekly", "monthly", "quarterly", "yearly"]
        let year = 2024
        let month = 6
        let day = 15

        for periodType in periods {
            // Given
            let mockClient = NetworkClientMother.makeMockNetworkClient()
            let repository = ObsidianRepository(client: mockClient)
            let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
            mockClient.stubNetworkResponse(toReturn: stubbedResponse)

            // When & Then
            switch periodType {
            case "daily": try await repository.deleteDailyNote(year: year, month: month, day: day)
            case "weekly": try await repository.deleteWeeklyNote(year: year, month: month, day: day)
            case "monthly": try await repository.deleteMonthlyNote(year: year, month: month, day: day)
            case "quarterly": try await repository.deleteQuarterlyNote(year: year, month: month, day: day)
            case "yearly": try await repository.deleteYearlyNote(year: year, month: month, day: day)
            default: break
            }

            #expect(
                mockClient.lastRequestPath == "/periodic/\(periodType)/\(year)/\(month)/\(day)/",
                "It should use the correct path for \(periodType) period"
            )
            #expect(
                mockClient.lastRequestMethod == .delete,
                "It should use DELETE method for \(periodType) period"
            )
        }
    }

    @Test("It should append to weekly note for specific date")
    func appendToWeeklyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToWeeklyNote(
            year: 2024,
            month: 2,
            day: 3,
            content: "Append"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/weekly/2024/2/3/",
            "It should use correct path"
        )
        #expect(
            mockClient.lastRequestMethod == .post,
            "It should use POST method"
        )
    }

    @Test("It should append to quarterly note for specific date")
    func appendToQuarterlyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToQuarterlyNote(
            year: 2024,
            month: 4,
            day: 10,
            content: "Append"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/quarterly/2024/4/10/",
            "It should use correct path"
        )
        #expect(
            mockClient.lastRequestMethod == .post,
            "It should use POST method"
        )
    }

    @Test("It should append to yearly note for specific date")
    func appendToYearlyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToYearlyNote(
            year: 2024,
            month: 12,
            day: 31,
            content: "Append"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/yearly/2024/12/31/",
            "It should use correct path"
        )
        #expect(
            mockClient.lastRequestMethod == .post,
            "It should use POST method"
        )
    }

    @Test("It should append to daily note for specific date")
    func appendToDailyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToDailyNote(
            year: 2024,
            month: 1,
            day: 15,
            content: "Append"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/daily/2024/1/15/",
            "It should use correct path"
        )
        #expect(
            mockClient.lastRequestMethod == .post,
            "It should use POST method"
        )
    }

    @Test("It should create or update daily note for specific date")
    func createOrUpdateDailyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.createOrUpdateDailyNote(
            year: 2024,
            month: 1,
            day: 15,
            content: "# Daily"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/daily/2024/1/15/",
            "It should use correct path"
        )
        #expect(
            mockClient.lastRequestMethod == .put,
            "It should use PUT method"
        )
    }

    @Test("It should create or update weekly note for specific date")
    func createOrUpdateWeeklyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.createOrUpdateWeeklyNote(
            year: 2024,
            month: 2,
            day: 3,
            content: "# Weekly"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/weekly/2024/2/3/",
            "It should use correct path"
        )
        #expect(
            mockClient.lastRequestMethod == .put,
            "It should use PUT method"
        )
    }

    @Test("It should create or update monthly note for specific date")
    func createOrUpdateMonthlyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.createOrUpdateMonthlyNote(
            year: 2024,
            month: 3,
            day: 20,
            content: "# Monthly"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/monthly/2024/3/20/",
            "It should use correct path"
        )
        #expect(
            mockClient.lastRequestMethod == .put,
            "It should use PUT method"
        )
    }

    @Test("It should create or update quarterly note for specific date")
    func createOrUpdateQuarterlyNoteForSpecificDate() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.createOrUpdateQuarterlyNote(
            year: 2024,
            month: 4,
            day: 10,
            content: "# Quarterly"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/periodic/quarterly/2024/4/10/",
            "It should use correct path"
        )
        #expect(
            mockClient.lastRequestMethod == .put,
            "It should use PUT method"
        )
    }
}
