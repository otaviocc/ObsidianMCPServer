import Testing
import Foundation
import Combine
import MicroClient
import ObsidianNetworking
@testable import ObsidianRepository

@Suite("ObsidianRepository Active Note Operations Tests")
// swiftlint:disable:next type_name
struct ObsidianRepositoryActiveNoteOperationsTests {

    @Test("It should get active note and return mapped File")
    func testGetActiveNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeNoteJSONResponse(
            path: "test-active.md",
            content: "# Active Content"
        )
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        let file = try await repository.getActiveNote()

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/active/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .get,
            "It should use GET method"
        )
        #expect(
            file.filename == "test-active.md",
            "It should return the correct filename"
        )
        #expect(
            file.content == "# Active Content",
            "It should return the correct content"
        )
    }

    @Test("It should update active note")
    func testUpdateActiveNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.updateActiveNote(content: "# Updated Content")

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/active/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .put,
            "It should use PUT method"
        )
    }

    @Test("It should delete active note")
    func testDeleteActiveNote() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.deleteActiveNote()

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/active/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should set active note frontmatter field")
    func testSetActiveNoteFrontmatterField() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.setActiveNoteFrontmatterField(key: "tags", value: "important")

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/active/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .patch,
            "It should use PATCH method"
        )
    }

    @Test("It should append to active note frontmatter field")
    func testAppendToActiveNoteFrontmatterField() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let stubbedResponse = try NetworkResponseMother.makeVoidResponse()
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        try await repository.appendToActiveNoteFrontmatterField(key: "tags", value: "urgent")

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/active/",
            "It should use the correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == .patch,
            "It should use PATCH method"
        )
    }
}
