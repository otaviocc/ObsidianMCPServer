import Testing
import Foundation
import Combine
import MicroClient
import ObsidianNetworking
@testable import ObsidianRepository

@Suite("ObsidianRepository Vault Note Operations Tests")
// swiftlint:disable:next type_name
struct ObsidianRepositoryVaultNoteOperationsTests {

    @Test("It should get vault note and return mapped File")
    func testGetVaultNote() async throws {
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
    func testCreateOrUpdateVaultNote() async throws {
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
    func testAppendToVaultNote() async throws {
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
    func testDeleteVaultNote() async throws {
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
    func testSetVaultNoteFrontmatterField() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let testFilename = "note-with-frontmatter.md"
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.setVaultNoteFrontmatterField(
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
    func testAppendToVaultNoteFrontmatterField() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let testFilename = "note-with-frontmatter.md"
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToVaultNoteFrontmatterField(
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
}
