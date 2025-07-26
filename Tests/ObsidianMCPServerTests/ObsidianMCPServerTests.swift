import Foundation
import ObsidianPrompt
import ObsidianRepository
import Testing

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
        let result = try await server.setActiveNoteFrontmatterString(key: testKey, value: testValue)

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
            result == "Active note frontmatter string field 'tags' set successfully.",
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
        let result = try await server.appendToActiveNoteFrontmatterString(key: testKey, value: testValue)

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
            result == "String value appended to active note frontmatter field 'categories' successfully.",
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
        let result = try await server.setNoteFrontmatterString(filename: testFilename, key: testKey, value: testValue)

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
            result == "Note 'project-notes.md' frontmatter string field 'status' set successfully.",
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
        let result = try await server.appendToNoteFrontmatterString(filename: testFilename, key: testKey, value: testValue)

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
            result == "String value appended to note 'research.md' frontmatter field 'tags' successfully.",
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
            _ = try await server.setActiveNoteFrontmatterString(key: "test", value: "value")
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

    @Test("It should set active note frontmatter array")
    func testSetActiveNoteFrontmatterArray() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testKey = "tags"
        let testValues = ["important", "work", "urgent"]

        // When
        let result = try await server.setActiveNoteFrontmatterArray(key: testKey, values: testValues)

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
            mock.lastActiveNoteFrontmatterValue == testValues.joined(separator: ","),
            "It should pass the correct values"
        )
        #expect(
            result == "Active note frontmatter array field 'tags' set successfully with 3 values.",
            "It should return success message with key and count"
        )
    }

    @Test("It should append to active note frontmatter array")
    func testAppendToActiveNoteFrontmatterArray() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testKey = "categories"
        let testValues = ["development", "testing"]

        // When
        let result = try await server.appendToActiveNoteFrontmatterArray(key: testKey, values: testValues)

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
            mock.lastActiveNoteFrontmatterValue == testValues.joined(separator: ","),
            "It should pass the correct values"
        )
        #expect(
            result == "2 values appended to active note frontmatter field 'categories' successfully.",
            "It should return success message with count and key"
        )
    }

    @Test("It should set vault note frontmatter array")
    func testSetNoteFrontmatterArray() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "project-notes.md"
        let testKey = "status"
        let testValues = ["in-progress", "high-priority"]

        // When
        let result = try await server.setNoteFrontmatterArray(filename: testFilename, key: testKey, values: testValues)

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
            mock.lastVaultNoteFrontmatterValue == testValues.joined(separator: ","),
            "It should pass the correct values"
        )
        #expect(
            result == "Note 'project-notes.md' frontmatter array field 'status' set successfully with 2 values.",
            "It should return success message with filename, key, and count"
        )
    }

    @Test("It should append to vault note frontmatter array")
    func testAppendToNoteFrontmatterArray() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "research.md"
        let testKey = "tags"
        let testValues = ["review", "published", "peer-reviewed"]

        // When
        let result = try await server.appendToNoteFrontmatterArray(filename: testFilename, key: testKey, values: testValues)

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
            mock.lastVaultNoteFrontmatterValue == testValues.joined(separator: ","),
            "It should pass the correct values"
        )
        #expect(
            result == "3 values appended to note 'research.md' frontmatter field 'tags' successfully.",
            "It should return success message with count, filename, and key"
        )
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
            mock.lastSearchQuery == testQuery,
            "It should pass the correct query"
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
            query: testQuery
        )

        // Then
        #expect(
            mock.searchVaultCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastSearchQuery == testQuery,
            "It should pass the correct query"
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

    // MARK: - MCP Prompt Tests

    @Test("It should analyze note with general focus")
    func testAnalyzeNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "research-notes.md"
        let testContent = "# Research Notes\n\nThis is important research content."
        mock.vaultNoteToReturn = File(filename: testFilename, content: testContent)

        // When
        let result = try await server.analyzeNote(filename: testFilename, focus: .general)

        // Then
        #expect(
            mock.getVaultNoteCallCount == 1,
            "It should call getVaultNote once"
        )
        #expect(
            mock.lastGetVaultNoteFilename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            result.contains(testFilename),
            "It should include the filename in the prompt"
        )
        #expect(
            result.contains(testContent),
            "It should include the note content in the prompt"
        )
        #expect(
            result.contains("Comprehensive analysis"),
            "It should include general analysis instructions"
        )
    }

    @Test("It should analyze note with action items focus")
    func testAnalyzeNoteWithActionItemsFocus() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "project-tasks.md"
        let testContent = "- [ ] Task 1\n- [ ] Task 2\n- [x] Completed task"
        mock.vaultNoteToReturn = File(filename: testFilename, content: testContent)

        // When
        let result = try await server.analyzeNote(filename: testFilename, focus: .actionItems)

        // Then
        #expect(
            mock.getVaultNoteCallCount == 1,
            "It should call getVaultNote once"
        )
        #expect(
            result.contains("Extract tasks, deadlines, and next steps"),
            "It should include action items focus instructions"
        )
    }

    @Test("It should analyze note with tone focus")
    func testAnalyzeNoteWithToneFocus() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "journal-entry.md"
        mock.vaultNoteToReturn = File(filename: testFilename, content: "I'm excited about this project!")

        // When
        let result = try await server.analyzeNote(filename: testFilename, focus: .tone)

        // Then
        #expect(
            result.contains("mood, attitude, and emotional context"),
            "It should include tone analysis instructions"
        )
    }

    @Test("It should analyze active note with general focus")
    func testAnalyzeActiveNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeNoteContent = "# Active Note\n\nThis is the currently active note content."
        mock.activeNoteToReturn = File(filename: "ActiveNote.md", content: activeNoteContent)

        // When
        let result = try await server.analyzeActiveNote(focus: .general)

        // Then
        #expect(
            mock.getActiveNoteCallCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("ActiveNote.md"),
            "It should include the active note filename in the prompt"
        )
        #expect(
            result.contains(activeNoteContent),
            "It should include the active note content in the prompt"
        )
        #expect(
            result.contains("Comprehensive analysis"),
            "It should include general analysis instructions"
        )
    }

    @Test("It should analyze active note with action items focus")
    func testAnalyzeActiveNoteWithActionItemsFocus() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.activeNoteToReturn = File(filename: "ActiveTasks.md", content: "- [ ] Important task")

        // When
        let result = try await server.analyzeActiveNote(focus: .actionItems)

        // Then
        #expect(
            result.contains("Extract tasks, deadlines, and next steps"),
            "It should include action items focus instructions"
        )
    }

    @Test("It should generate follow-up questions with default count")
    func testGenerateFollowUpQuestionsDefault() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "discussion-notes.md"
        let testContent = "We discussed the project requirements and next steps."
        mock.vaultNoteToReturn = File(filename: testFilename, content: testContent)

        // When
        let result = try await server.generateFollowUpQuestions(filename: testFilename)

        // Then
        #expect(
            mock.getVaultNoteCallCount == 1,
            "It should call getVaultNote once"
        )
        #expect(
            mock.lastGetVaultNoteFilename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            result.contains("5 thought-provoking"),
            "It should include default question count of 5"
        )
        #expect(
            result.contains(testContent),
            "It should include the note content in the prompt"
        )
    }

    @Test("It should generate follow-up questions with custom count")
    func testGenerateFollowUpQuestionsCustomCount() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "brainstorm.md"
        let customCount = 3
        mock.vaultNoteToReturn = File(filename: testFilename, content: "Brainstorming session content")

        // When
        let result = try await server.generateFollowUpQuestions(filename: testFilename, questionCount: customCount)

        // Then
        #expect(
            result.contains("3 thought-provoking"),
            "It should include custom question count of 3"
        )
    }

    @Test("It should suggest tags with default count")
    func testSuggestTagsDefault() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "article.md"
        let testContent = "This article discusses machine learning and artificial intelligence."
        mock.vaultNoteToReturn = File(filename: testFilename, content: testContent)

        // When
        let result = try await server.suggestTags(filename: testFilename)

        // Then
        #expect(
            mock.getVaultNoteCallCount == 1,
            "It should call getVaultNote once"
        )
        #expect(
            mock.lastGetVaultNoteFilename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            result.contains("8 relevant tags"),
            "It should include default tag count of 8"
        )
        #expect(
            result.contains(testContent),
            "It should include the note content in the prompt"
        )
        #expect(
            result.contains("appendToNoteFrontmatterArray"),
            "It should include MCP commands for applying tags"
        )
    }

    @Test("It should suggest tags with custom count")
    func testSuggestTagsCustomCount() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "tutorial.md"
        let customCount = 5
        mock.vaultNoteToReturn = File(filename: testFilename, content: "Tutorial content")

        // When
        let result = try await server.suggestTags(filename: testFilename, maxTags: customCount)

        // Then
        #expect(
            result.contains("5 relevant tags"),
            "It should include custom tag count of 5"
        )
    }

    @Test("It should suggest active note tags with default count")
    func testSuggestActiveNoteTagsDefault() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "This is a project management note with important tasks."
        mock.activeNoteToReturn = File(filename: "ProjectNotes.md", content: activeContent)

        // When
        let result = try await server.suggestActiveNoteTags()

        // Then
        #expect(
            mock.getActiveNoteCallCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("ProjectNotes.md"),
            "It should include the active note filename in the prompt"
        )
        #expect(
            result.contains(activeContent),
            "It should include the active note content in the prompt"
        )
        #expect(
            result.contains("8 relevant tags"),
            "It should include default tag count of 8"
        )
        #expect(
            result.contains("appendToActiveNoteFrontmatterArray"),
            "It should include MCP commands for applying tags to active note"
        )
    }

    @Test("It should suggest active note tags with custom count")
    func testSuggestActiveNoteTagsCustomCount() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let customCount = 6
        mock.activeNoteToReturn = File(filename: "ActiveNote.md", content: "Active note content")

        // When
        let result = try await server.suggestActiveNoteTags(maxTags: customCount)

        // Then
        #expect(
            result.contains("6 relevant tags"),
            "It should include custom tag count of 6"
        )
    }

    @Test("It should extract metadata from note")
    func testExtractMetadata() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "meeting-notes.md"
        let testContent = "Meeting with John Smith on 2024-01-15 about project deadlines."
        mock.vaultNoteToReturn = File(filename: testFilename, content: testContent)

        // When
        let result = try await server.extractMetadata(filename: testFilename)

        // Then
        #expect(
            mock.getVaultNoteCallCount == 1,
            "It should call getVaultNote once"
        )
        #expect(
            mock.lastGetVaultNoteFilename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            result.contains(testFilename),
            "It should include the filename in the prompt"
        )
        #expect(
            result.contains(testContent),
            "It should include the note content in the prompt"
        )
        #expect(
            result.contains("setNoteFrontmatterString"),
            "It should include MCP commands for setting metadata"
        )
        #expect(
            result.contains("[[Name]]"),
            "It should include instructions for Obsidian link formatting"
        )
    }

    @Test("It should rewrite active note with emoji style")
    func testRewriteActiveNoteEmoji() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "This is a serious business document."
        mock.activeNoteToReturn = File(filename: "BusinessDoc.md", content: activeContent)

        // When
        let result = try await server.rewriteActiveNote(style: .emoji)

        // Then
        #expect(
            mock.getActiveNoteCallCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("BusinessDoc.md"),
            "It should include the active note filename in the prompt"
        )
        #expect(
            result.contains(activeContent),
            "It should include the active note content in the prompt"
        )
        #expect(
            result.contains("emoji") || result.contains("🎯") || result.contains("emojis"),
            "It should include emoji style instructions"
        )
        #expect(
            result.contains("Rewritten Content"),
            "It should include instructions for providing rewritten content"
        )
    }

    @Test("It should rewrite active note with formal style")
    func testRewriteActiveNoteFormal() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.activeNoteToReturn = File(filename: "CasualNote.md", content: "Hey, this is pretty cool!")

        // When
        let result = try await server.rewriteActiveNote(style: .formal)

        // Then
        #expect(
            result.contains("formal") || result.contains("professional"),
            "It should include formal style instructions"
        )
    }

    @Test("It should rewrite active note with ELI5 style")
    func testRewriteActiveNoteELI5() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.activeNoteToReturn = File(filename: "ComplexDoc.md", content: "Complex technical content")

        // When
        let result = try await server.rewriteActiveNote(style: .eli5)

        // Then
        #expect(
            result.contains("explain like I'm 5") || result.contains("simple") || result.contains("easy"),
            "It should include ELI5 style instructions"
        )
    }

    @Test("It should generate frontmatter structure")
    func testGenerateFrontmatter() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testFilename = "project-plan.md"
        let testContent = "# Project Plan\n\nThis document outlines the project timeline and requirements."
        mock.vaultNoteToReturn = File(filename: testFilename, content: testContent)

        // When
        let result = try await server.generateFrontmatter(filename: testFilename)

        // Then
        #expect(
            mock.getVaultNoteCallCount == 1,
            "It should call getVaultNote once"
        )
        #expect(
            mock.lastGetVaultNoteFilename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            result.contains(testFilename),
            "It should include the filename in the prompt"
        )
        #expect(
            result.contains(testContent),
            "It should include the note content in the prompt"
        )
        #expect(
            result.contains("YAML frontmatter"),
            "It should include YAML frontmatter instructions"
        )
        #expect(
            result.contains("setNoteFrontmatterString") || result.contains("setNoteFrontmatterArray"),
            "It should include MCP commands for setting frontmatter"
        )
    }

    @Test("It should propagate errors for analyze note")
    func testAnalyzeNoteError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.analyzeNote(filename: "test.md", focus: .general)
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.getVaultNoteCallCount == 1,
                "It should call getVaultNote once"
            )
        }
    }

    @Test("It should propagate errors for analyze active note")
    func testAnalyzeActiveNoteError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.analyzeActiveNote(focus: .general)
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.getActiveNoteCallCount == 1,
                "It should call getActiveNote once"
            )
        }
    }

    @Test("It should propagate errors for follow-up questions")
    func testGenerateFollowUpQuestionsError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.generateFollowUpQuestions(filename: "test.md")
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }
    }

    @Test("It should propagate errors for suggest tags")
    func testSuggestTagsError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.suggestTags(filename: "test.md")
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }
    }

    @Test("It should propagate errors for suggest active note tags")
    func testSuggestActiveNoteTagsError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.suggestActiveNoteTags()
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }
    }

    @Test("It should propagate errors for extract metadata")
    func testExtractMetadataError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.extractMetadata(filename: "test.md")
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }
    }

    @Test("It should propagate errors for rewrite active note")
    func testRewriteActiveNoteError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.rewriteActiveNote(style: .formal)
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }
    }

    @Test("It should translate active note to Portuguese")
    func testTranslateActiveNoteToPortuguese() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "This is the active note content that needs translation."
        mock.activeNoteToReturn = File(filename: "MyNote.md", content: activeContent)

        // When
        let result = try await server.translateActiveNote(language: .portuguese)

        // Then
        #expect(
            mock.getActiveNoteCallCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("MyNote.md"),
            "It should include the active note filename in the prompt"
        )
        #expect(
            result.contains(activeContent),
            "It should include the active note content in the prompt"
        )
        #expect(
            result.contains("Portuguese (Português)"),
            "It should include the Portuguese language description"
        )
        #expect(
            result.contains("Use Brazilian Portuguese specifically"),
            "It should include Brazilian Portuguese instructions"
        )
        #expect(
            result.contains("Use \"tu\" for second person"),
            "It should include the tu instruction"
        )
        #expect(
            result.contains("avoid excessive gerund forms"),
            "It should include proper verb conjugation instructions"
        )
        #expect(
            result.contains("Translated Content"),
            "It should include instructions for providing translated content"
        )
    }

    @Test("It should translate active note to Spanish")
    func testTranslateActiveNoteToSpanish() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "# Project Overview\n\nThis document contains [[Related Notes]] and #project-tag."
        mock.activeNoteToReturn = File(filename: "ProjectDoc.md", content: activeContent)

        // When
        let result = try await server.translateActiveNote(language: .spanish)

        // Then
        #expect(
            mock.getActiveNoteCallCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("ProjectDoc.md"),
            "It should include the active note filename in the prompt"
        )
        #expect(
            result.contains("# Project Overview"),
            "It should include the note content with markdown"
        )
        #expect(
            result.contains("Spanish (Español)"),
            "It should include the Spanish language description"
        )
        #expect(
            result.contains("Use Latin American Spanish"),
            "It should include Latin American Spanish instructions"
        )
        #expect(
            result.contains("Preserve [[Page Name]]"),
            "It should include instructions for preserving Obsidian links"
        )
        #expect(
            result.contains("#tag-name"),
            "It should include instructions for preserving hashtags"
        )
    }

    @Test("It should translate active note to Japanese")
    func testTranslateActiveNoteToJapanese() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "Technical documentation with code examples and API references."
        mock.activeNoteToReturn = File(filename: "TechDoc.md", content: activeContent)

        // When
        let result = try await server.translateActiveNote(language: .japanese)

        // Then
        #expect(
            result.contains("Japanese (日本語)"),
            "It should include the Japanese language description"
        )
        #expect(
            result.contains("appropriate levels of politeness"),
            "It should include Japanese politeness instructions"
        )
        #expect(
            result.contains("katakana for foreign technical terms"),
            "It should include katakana usage instructions"
        )
        #expect(
            result.contains("コンピュータ"),
            "It should include katakana examples"
        )
    }

    @Test("It should translate active note to French")
    func testTranslateActiveNoteToFrench() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.activeNoteToReturn = File(filename: "BusinessNote.md", content: "Business requirements document.")

        // When
        let result = try await server.translateActiveNote(language: .french)

        // Then
        #expect(
            result.contains("French (Français)"),
            "It should include the French language description"
        )
        #expect(
            result.contains("appropriate formal/informal register"),
            "It should include French register instructions"
        )
        #expect(
            result.contains("ordinateur"),
            "It should include French technical term examples"
        )
    }

    @Test("It should propagate errors for translate active note")
    func testTranslateActiveNoteError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.translateActiveNote(language: .portuguese)
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }
    }

    @Test("It should generate active note abstract with standard length")
    func testGenerateActiveNoteAbstractStandard() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "Research findings on artificial intelligence and machine learning applications in healthcare."
        mock.activeNoteToReturn = File(filename: "ResearchPaper.md", content: activeContent)

        // When
        let result = try await server.generateActiveNoteAbstract(length: .standard)

        // Then
        #expect(
            mock.getActiveNoteCallCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("ResearchPaper.md"),
            "It should include the active note filename in the prompt"
        )
        #expect(
            result.contains(activeContent),
            "It should include the active note content in the prompt"
        )
        #expect(
            result.contains("Standard abstract (1 paragraph)"),
            "It should include the standard length description"
        )
        #expect(
            result.contains("3-5 sentences or 75-150 words"),
            "It should include standard length instructions"
        )
        #expect(
            result.contains("Generated Abstract"),
            "It should include instructions for providing generated content"
        )
    }

    @Test("It should generate active note abstract with brief length")
    func testGenerateActiveNoteAbstractBrief() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "Quick summary of the weekly team meeting and action items."
        mock.activeNoteToReturn = File(filename: "WeeklyMeeting.md", content: activeContent)

        // When
        let result = try await server.generateActiveNoteAbstract(length: .brief)

        // Then
        #expect(
            result.contains("Brief summary (1-2 sentences)"),
            "It should include the brief length description"
        )
        #expect(
            result.contains("under 50 words"),
            "It should include brief length instructions"
        )
        #expect(
            result.contains("most essential point"),
            "It should include brief-specific guidance"
        )
    }

    @Test("It should generate active note abstract with detailed length")
    func testGenerateActiveNoteAbstractDetailed() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "Comprehensive analysis of market trends, competitive landscape, and strategic recommendations."
        mock.activeNoteToReturn = File(filename: "MarketAnalysis.md", content: activeContent)

        // When
        let result = try await server.generateActiveNoteAbstract(length: .detailed)

        // Then
        #expect(
            result.contains("Detailed summary (2-3 paragraphs)"),
            "It should include the detailed length description"
        )
        #expect(
            result.contains("150-300 words"),
            "It should include detailed length instructions"
        )
        #expect(
            result.contains("methodology, findings, and implications"),
            "It should include detailed-specific guidance"
        )
    }

    @Test("It should generate active note outline with hierarchical style")
    func testGenerateActiveNoteOutlineHierarchical() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "# Project Overview\n\n## Phase 1\n- Research\n- Planning\n\n## Phase 2\n- Implementation\n- Testing"
        mock.activeNoteToReturn = File(filename: "ProjectPlan.md", content: activeContent)

        // When
        let result = try await server.generateActiveNoteOutline(style: .hierarchical)

        // Then
        #expect(
            mock.getActiveNoteCallCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("ProjectPlan.md"),
            "It should include the active note filename in the prompt"
        )
        #expect(
            result.contains("Phase 1"),
            "It should include the active note content in the prompt"
        )
        #expect(
            result.contains("Hierarchical academic format"),
            "It should include the hierarchical style description"
        )
        #expect(
            result.contains("Roman numerals for major sections"),
            "It should include hierarchical style instructions"
        )
        #expect(
            result.contains("Generated Outline"),
            "It should include instructions for providing generated content"
        )
    }

    @Test("It should generate active note outline with bullets style")
    func testGenerateActiveNoteOutlineBullets() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "Meeting agenda with discussion topics and action items for team review."
        mock.activeNoteToReturn = File(filename: "MeetingAgenda.md", content: activeContent)

        // When
        let result = try await server.generateActiveNoteOutline(style: .bullets)

        // Then
        #expect(
            result.contains("Bullet point format"),
            "It should include the bullets style description"
        )
        #expect(
            result.contains("simple bullet points"),
            "It should include bullets style instructions"
        )
        #expect(
            result.contains("Maximum 3-4 levels"),
            "It should include bullets-specific formatting guidance"
        )
    }

    @Test("It should generate active note outline with numbered style")
    func testGenerateActiveNoteOutlineNumbered() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let activeContent = "Step-by-step procedure documentation with multiple sections and detailed instructions."
        mock.activeNoteToReturn = File(filename: "ProcedureDoc.md", content: activeContent)

        // When
        let result = try await server.generateActiveNoteOutline(style: .numbered)

        // Then
        #expect(
            result.contains("Numbered list format"),
            "It should include the numbered style description"
        )
        #expect(
            result.contains("numbers for main sections"),
            "It should include numbered style instructions"
        )
        #expect(
            result.contains("letters for sub-sections"),
            "It should include numbered formatting details"
        )
    }

    @Test("It should propagate errors for generate active note abstract")
    func testGenerateActiveNoteAbstractError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.generateActiveNoteAbstract(length: .standard)
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }
    }

    @Test("It should propagate errors for generate active note outline")
    func testGenerateActiveNoteOutlineError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.generateActiveNoteOutline(style: .hierarchical)
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
        }
    }

    @Test("It should propagate errors for generate frontmatter")
    func testGenerateFrontmatterError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.generateFrontmatter(filename: "test.md")
            #expect(Bool(false), "It should throw an error")
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
