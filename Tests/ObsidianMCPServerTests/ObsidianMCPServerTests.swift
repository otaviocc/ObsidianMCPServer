import Testing
import Foundation
@testable import ObsidianMCPServer

@Suite("ObsidianMCPServer Tests")
struct ObsidianMCPServerTests {

    // MARK: - Test Helper

    private func makeServerWithMock() -> (ObsidianMCPServer, ObsidianRepositoryMock) {
        let repositoryMock = ObsidianRepositoryMock()
        let server = ObsidianMCPServer(repository: repositoryMock)
        return (server, repositoryMock)
    }

    // MARK: - Server Information Tests

    @Test("It should get server information")
    func testGetServerInfo() async throws {
        // Given
        let (server, mock) = makeServerWithMock()

        // When
        let result = try await server.getServerInfo()

        // Then
        #expect(
            mock.getServerInfoCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            result.service == "mock-obsidian-api",
            "It should return the mock service name"
        )
        #expect(
            result.version == "1.0.0",
            "It should return the mock version"
        )
    }

    @Test("It should handle server info errors")
    func testGetServerInfoError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.getServerInfo()
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.getServerInfoCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    // MARK: - Active Note Tests

    @Test("It should get active note")
    func testGetActiveNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()

        // When
        let result = try await server.getActiveNote()

        // Then
        #expect(
            mock.getActiveNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            result.filename == "MockNote.md",
            "It should return the mock filename"
        )
        #expect(
            result.content == "# Mock Note Content",
            "It should return the mock content"
        )
    }

    @Test("It should update active note")
    func testUpdateActiveNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testContent = "# Updated Content\n\nThis is new content."

        // When
        let result = try await server.updateActiveNote(content: testContent)

        // Then
        #expect(
            mock.updateActiveNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastUpdateActiveNoteContent == testContent,
            "It should pass the correct content"
        )
        #expect(
            result == "Active note updated successfully.",
            "It should return success message"
        )
    }

    @Test("It should handle update active note errors")
    func testUpdateActiveNoteError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.shouldThrowErrorOnUpdateActiveNote = true

        // When/Then
        do {
            _ = try await server.updateActiveNote(content: "test")
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.updateActiveNoteCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    @Test("It should delete active note")
    func testDeleteActiveNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()

        // When
        let result = try await server.deleteActiveNote()

        // Then
        #expect(
            mock.deleteActiveNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            result == "Active note deleted successfully.",
            "It should return success message"
        )
    }

    // MARK: - Vault Note Tests

    @Test("It should get vault note")
    func testGetNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "test-note.md"

        // When
        let result = try await server.getNote(filename: testFilename)

        // Then
        #expect(
            mock.getVaultNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastGetVaultNoteFilename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            result.filename == "MockVaultNote.md",
            "It should return the mock vault note filename"
        )
        #expect(
            result.content == "# Mock Vault Note Content",
            "It should return the mock vault note content"
        )
    }

    @Test("It should create or update note")
    func testCreateOrUpdateNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "new-note.md"
        let testContent = "# New Note\n\nThis is a new note."

        // When
        let result = try await server.createOrUpdateNote(filename: testFilename, content: testContent)

        // Then
        #expect(
            mock.createOrUpdateVaultNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastCreateOrUpdateVaultNoteFile?.filename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            mock.lastCreateOrUpdateVaultNoteFile?.content == testContent,
            "It should pass the correct content"
        )
        #expect(
            result == "Note 'new-note.md' created/updated successfully.",
            "It should return success message with filename"
        )
    }

    @Test("It should append to note")
    func testAppendToNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "existing-note.md"
        let testContent = "\n\n## Additional Section\n\nAppended content."

        // When
        let result = try await server.appendToNote(filename: testFilename, content: testContent)

        // Then
        #expect(
            mock.appendToVaultNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastAppendToVaultNoteFile?.filename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            mock.lastAppendToVaultNoteFile?.content == testContent,
            "It should pass the correct content"
        )
        #expect(
            result == "Content appended to 'existing-note.md' successfully.",
            "It should return success message with filename"
        )
    }

    @Test("It should delete vault note")
    func testDeleteNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "note-to-delete.md"

        // When
        let result = try await server.deleteNote(filename: testFilename)

        // Then
        #expect(
            mock.deleteVaultNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastDeleteVaultNoteFilename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            result == "Note 'note-to-delete.md' deleted successfully.",
            "It should return success message with filename"
        )
    }

    // MARK: - Vault Operations Tests

    @Test("It should list directory with default path")
    func testListDirectoryDefault() async throws {
        // Given
        let (server, mock) = makeServerWithMock()

        // When
        let result = try await server.listDirectory()

        // Then
        #expect(
            mock.listVaultDirectoryCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastListVaultDirectoryPath?.isEmpty == true,
            "It should pass empty string for default directory"
        )
        #expect(
            result.contains("/vault/note1.md"),
            "It should return the mock directory contents"
        )
        #expect(
            result.contains("/vault/note2.md"),
            "It should return the mock directory contents"
        )
        #expect(
            result.contains("/vault/folder/note3.md"),
            "It should return the mock directory contents"
        )
    }

    @Test("It should list directory with specific path")
    func testListDirectoryWithPath() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testDirectory = "subfolder"

        // When
        let result = try await server.listDirectory(directory: testDirectory)

        // Then
        #expect(
            mock.listVaultDirectoryCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastListVaultDirectoryPath == testDirectory,
            "It should pass the correct directory path"
        )
        #expect(
            result.contains("\n"),
            "It should join paths with newlines"
        )
    }

    // MARK: - Frontmatter Tests

    @Test("It should set active note frontmatter")
    func testSetActiveNoteFrontmatter() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testKey = "tags"
        let testValue = "important"

        // When
        let result = try await server.setActiveNoteFrontmatter(key: testKey, value: testValue)

        // Then
        #expect(
            mock.setActiveNoteFrontmatterCalled == true,
            "It should call the repository method"
        )
        #expect(
            mock.lastActiveNoteFrontmatterKey == testKey,
            "It should pass the correct key"
        )
        #expect(
            mock.lastActiveNoteFrontmatterValue == testValue,
            "It should pass the correct value"
        )
        #expect(
            result == "Active note frontmatter field 'tags' set successfully.",
            "It should return success message with key"
        )
    }

    @Test("It should append to active note frontmatter")
    func testAppendToActiveNoteFrontmatter() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testKey = "categories"
        let testValue = "project"

        // When
        let result = try await server.appendToActiveNoteFrontmatter(key: testKey, value: testValue)

        // Then
        #expect(
            mock.appendToActiveNoteFrontmatterCalled == true,
            "It should call the repository method"
        )
        #expect(
            mock.lastActiveNoteFrontmatterKey == testKey,
            "It should pass the correct key"
        )
        #expect(
            mock.lastActiveNoteFrontmatterValue == testValue,
            "It should pass the correct value"
        )
        #expect(
            result == "Value appended to active note frontmatter field 'categories' successfully.",
            "It should return success message with key"
        )
    }

    @Test("It should set vault note frontmatter")
    func testSetNoteFrontmatter() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "project-notes.md"
        let testKey = "status"
        let testValue = "completed"

        // When
        let result = try await server.setNoteFrontmatter(filename: testFilename, key: testKey, value: testValue)

        // Then
        #expect(
            mock.setVaultNoteFrontmatterCalled == true,
            "It should call the repository method"
        )
        #expect(
            mock.lastVaultNoteFrontmatterFilename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            mock.lastVaultNoteFrontmatterKey == testKey,
            "It should pass the correct key"
        )
        #expect(
            mock.lastVaultNoteFrontmatterValue == testValue,
            "It should pass the correct value"
        )
        #expect(
            result == "Note 'project-notes.md' frontmatter field 'status' set successfully.",
            "It should return success message with filename and key"
        )
    }

    @Test("It should append to vault note frontmatter")
    func testAppendToNoteFrontmatter() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "research.md"
        let testKey = "tags"
        let testValue = "literature-review"

        // When
        let result = try await server.appendToNoteFrontmatter(filename: testFilename, key: testKey, value: testValue)

        // Then
        #expect(
            mock.appendToVaultNoteFrontmatterCalled == true,
            "It should call the repository method"
        )
        #expect(
            mock.lastVaultNoteFrontmatterFilename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            mock.lastVaultNoteFrontmatterKey == testKey,
            "It should pass the correct key"
        )
        #expect(
            mock.lastVaultNoteFrontmatterValue == testValue,
            "It should pass the correct value"
        )
        #expect(
            result == "Value appended to note 'research.md' frontmatter field 'tags' successfully.",
            "It should return success message with filename and key"
        )
    }

    @Test("It should handle frontmatter errors")
    func testSetActiveNoteFrontmatterError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.setActiveNoteFrontmatter(key: "test", value: "value")
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.setActiveNoteFrontmatterCalled == true,
                "It should call the repository method"
            )
        }
    }

    // MARK: - Search Tests

    @Test("It should search vault with default parameters")
    func testSearchDefault() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testQuery = "test search"

        // When
        let result = try await server.search(query: testQuery)

        // Then
        #expect(
            mock.searchVaultCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastSearchVaultQuery == testQuery,
            "It should pass the correct query"
        )
        #expect(
            mock.lastSearchVaultIgnoreCase == true,
            "It should use default ignoreCase value"
        )
        #expect(
            mock.lastSearchVaultWholeWord == false,
            "It should use default wholeWord value"
        )
        #expect(
            mock.lastSearchVaultIsRegex == false,
            "It should use default isRegex value"
        )
        #expect(
            result.count == 3,
            "It should return the mock search results"
        )
        #expect(
            result.first?.path == "note1.md",
            "It should return the first mock result"
        )
        #expect(
            result.first?.score == 0.95,
            "It should return the correct score"
        )
    }

    @Test("It should search vault with custom parameters")
    func testSearchWithCustomParameters() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testQuery = "regex.*pattern"

        // When
        let result = try await server.search(
            query: testQuery,
            ignoreCase: false,
            wholeWord: true,
            isRegex: true
        )

        // Then
        #expect(
            mock.searchVaultCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastSearchVaultQuery == testQuery,
            "It should pass the correct query"
        )
        #expect(
            mock.lastSearchVaultIgnoreCase == false,
            "It should pass the correct ignoreCase value"
        )
        #expect(
            mock.lastSearchVaultWholeWord == true,
            "It should pass the correct wholeWord value"
        )
        #expect(
            mock.lastSearchVaultIsRegex == true,
            "It should pass the correct isRegex value"
        )
        #expect(
            result.count == 3,
            "It should return the mock search results"
        )
    }

    // MARK: - Error Handling Tests

    @Test("It should handle vault note operation errors")
    func testVaultNoteOperationErrors() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.shouldThrowErrorOnCreateOrUpdateVaultNote = true
        mock.shouldThrowErrorOnAppendToVaultNote = true
        mock.shouldThrowErrorOnDeleteVaultNote = true

        // When/Then - Test create/update error
        do {
            _ = try await server.createOrUpdateNote(filename: "test.md", content: "content")
            #expect(Bool(false), "It should throw an error for create/update")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }

        // When/Then - Test append error
        do {
            _ = try await server.appendToNote(filename: "test.md", content: "content")
            #expect(Bool(false), "It should throw an error for append")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }

        // When/Then - Test delete error
        do {
            _ = try await server.deleteNote(filename: "test.md")
            #expect(Bool(false), "It should throw an error for delete")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }
    }

    @Test("It should handle search operation errors")
    func testSearchOperationErrors() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.searchVaultResult = .failure(MockError.updateFailed)

        // When/Then - Test search vault error
        do {
            _ = try await server.search(query: "test")
            #expect(Bool(false), "It should throw an error for search vault")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }
    }

    // MARK: - Integration Tests

    @Test("It should maintain repository isolation")
    func testRepositoryIsolation() async throws {
        // Given
        let (server1, mock1) = makeServerWithMock()
        let (server2, mock2) = makeServerWithMock()

        // When
        _ = try await server1.getServerInfo()
        _ = try await server2.getActiveNote()

        // Then
        #expect(
            mock1.getServerInfoCallCount == 1,
            "It should track calls to first mock"
        )
        #expect(
            mock1.getActiveNoteCallCount == 0,
            "It should not affect first mock's other calls"
        )
        #expect(
            mock2.getServerInfoCallCount == 0,
            "It should not affect second mock's calls"
        )
        #expect(
            mock2.getActiveNoteCallCount == 1,
            "It should track calls to second mock"
        )
    }
}
