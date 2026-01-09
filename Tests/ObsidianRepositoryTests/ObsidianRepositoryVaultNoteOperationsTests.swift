import Testing
@testable import ObsidianRepository

@Suite("ObsidianRepository Vault Note Operations Tests")
struct ObsidianRepositoryVaultNoteOperationsTests {

    @Test("It should get vault note and return mapped File")
    func getVaultNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let testFilename = "test-note.md"
        let stubbedResponse = try NetworkResponseMother.makeNoteJSONResponse(
            path: testFilename,
            content: "# Vault Note Content"
        )
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        let file = try await repository.getVaultNote(filename: testFilename)

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/vault/\(testFilename)",
            "It should use the correct vault path"
        )
        #expect(
            mockClient.lastRequestMethod == .get,
            "It should use GET method"
        )
        #expect(
            file.filename == testFilename,
            "It should return the correct filename"
        )
        #expect(
            file.content == "# Vault Note Content",
            "It should return the correct content"
        )
    }

    @Test("It should create or update vault note")
    func createOrUpdateVaultNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let testFile = File(filename: "new-note.md", content: "# New Note")
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.createOrUpdateVaultNote(file: testFile)

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/vault/\(testFile.filename)",
            "It should use the correct vault path"
        )
        #expect(
            mockClient.lastRequestMethod == .put,
            "It should use PUT method"
        )
    }

    @Test("It should append to vault note")
    func appendToVaultNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let testFile = File(filename: "existing-note.md", content: "\n\nAppended content")
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToVaultNote(file: testFile)

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/vault/\(testFile.filename)",
            "It should use the correct vault path"
        )
        #expect(
            mockClient.lastRequestMethod == .post,
            "It should use POST method"
        )
    }

    @Test("It should delete vault note")
    func deleteVaultNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let testFilename = "note-to-delete.md"
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.deleteVaultNote(filename: testFilename)

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/vault/\(testFilename)",
            "It should use the correct vault path"
        )
        #expect(
            mockClient.lastRequestMethod == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should set vault note frontmatter field")
    func setVaultNoteFrontmatterStringField() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let testFilename = "note-with-frontmatter.md"
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.setVaultNoteFrontmatterStringField(
            filename: testFilename,
            key: "category",
            value: "work"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/vault/\(testFilename)",
            "It should use the correct vault path"
        )
        #expect(
            mockClient.lastRequestMethod == .patch,
            "It should use PATCH method"
        )
    }

    @Test("It should append to vault note frontmatter field")
    func appendToVaultNoteFrontmatterStringField() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let testFilename = "note-with-frontmatter.md"
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToVaultNoteFrontmatterStringField(
            filename: testFilename,
            key: "tags",
            value: "important"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/vault/\(testFilename)",
            "It should use the correct vault path"
        )
        #expect(
            mockClient.lastRequestMethod == .patch,
            "It should use PATCH method"
        )
    }

    @Test("It should set vault note frontmatter array field")
    func setVaultNoteFrontmatterArrayField() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let testFilename = "note-with-frontmatter.md"
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.setVaultNoteFrontmatterArrayField(
            filename: testFilename,
            key: "categories",
            value: ["work", "project", "documentation"]
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/vault/\(testFilename)",
            "It should use the correct vault path"
        )
        #expect(
            mockClient.lastRequestMethod == .patch,
            "It should use PATCH method"
        )
    }

    @Test("It should append to vault note frontmatter array field")
    func appendToVaultNoteFrontmatterArrayField() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let testFilename = "note-with-frontmatter.md"
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToVaultNoteFrontmatterArrayField(
            filename: testFilename,
            key: "tags",
            value: ["urgent", "high-priority"]
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/vault/\(testFilename)",
            "It should use the correct vault path"
        )
        #expect(
            mockClient.lastRequestMethod == .patch,
            "It should use PATCH method"
        )
    }
}
