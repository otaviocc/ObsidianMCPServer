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
    func getServerInfo() async throws {
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
    func getServerInfoError() async throws {
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
    func getActiveNote() async throws {
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
    func updateActiveNote() async throws {
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
    func updateActiveNoteError() async throws {
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
    func deleteActiveNote() async throws {
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
    func getNote() async throws {
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
    func createOrUpdateNote() async throws {
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
    func appendToNote() async throws {
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
    func deleteNote() async throws {
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
    func listDirectoryDefault() async throws {
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
    func listDirectoryWithPath() async throws {
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
    func setActiveNoteFrontmatter() async throws {
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
    func appendToActiveNoteFrontmatter() async throws {
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
    func setNoteFrontmatter() async throws {
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
    func appendToNoteFrontmatter() async throws {
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
    func setActiveNoteFrontmatterError() async throws {
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
    func setActiveNoteFrontmatterArray() async throws {
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
    func appendToActiveNoteFrontmatterArray() async throws {
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
    func setNoteFrontmatterArray() async throws {
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
    func appendToNoteFrontmatterArray() async throws {
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
    func searchDefault() async throws {
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
    func searchWithCustomParameters() async throws {
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
    func vaultNoteOperationErrors() async throws {
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
    func searchOperationErrors() async throws {
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
    func analyzeNote() async throws {
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
    func analyzeNoteWithActionItemsFocus() async throws {
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
    func analyzeNoteWithToneFocus() async throws {
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
    func analyzeActiveNote() async throws {
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
    func analyzeActiveNoteWithActionItemsFocus() async throws {
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
    func generateFollowUpQuestionsDefault() async throws {
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
    func generateFollowUpQuestionsCustomCount() async throws {
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
    func suggestTagsDefault() async throws {
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
    func suggestTagsCustomCount() async throws {
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
    func suggestActiveNoteTagsDefault() async throws {
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
    func suggestActiveNoteTagsCustomCount() async throws {
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
    func extractMetadata() async throws {
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
    func rewriteActiveNoteEmoji() async throws {
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
    func rewriteActiveNoteFormal() async throws {
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
    func rewriteActiveNoteELI5() async throws {
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
    func generateFrontmatter() async throws {
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
    func analyzeNoteError() async throws {
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
    func analyzeActiveNoteError() async throws {
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
    func generateFollowUpQuestionsError() async throws {
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
    func suggestTagsError() async throws {
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
    func suggestActiveNoteTagsError() async throws {
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
    func extractMetadataError() async throws {
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
    func rewriteActiveNoteError() async throws {
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
    func translateActiveNoteToPortuguese() async throws {
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
    func translateActiveNoteToSpanish() async throws {
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
    func translateActiveNoteToJapanese() async throws {
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
    func translateActiveNoteToFrench() async throws {
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
    func translateActiveNoteError() async throws {
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
    func generateActiveNoteAbstractStandard() async throws {
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
    func generateActiveNoteAbstractBrief() async throws {
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
    func generateActiveNoteAbstractDetailed() async throws {
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
    func generateActiveNoteOutlineHierarchical() async throws {
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
    func generateActiveNoteOutlineBullets() async throws {
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
    func generateActiveNoteOutlineNumbered() async throws {
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
    func generateActiveNoteAbstractError() async throws {
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
    func generateActiveNoteOutlineError() async throws {
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
    func generateFrontmatterError() async throws {
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

    // MARK: - Bulk Operations Tests

    @Test("It should bulk apply tags from search")
    func bulkApplyTagsFromSearch() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testQuery = "project"
        let testTags = ["important", "work"]
        let expectedResult = BulkOperationResult(
            successful: ["note1.md", "note2.md"],
            failed: [],
            totalProcessed: 2,
            query: testQuery
        )
        mock.bulkOperationResultToReturn = expectedResult

        // When
        let result = try await server.bulkApplyTagsFromSearch(query: testQuery, tags: testTags)

        // Then
        #expect(
            mock.bulkApplyTagsFromSearchCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastBulkApplyTagsQuery == testQuery,
            "It should pass the correct query"
        )
        #expect(
            mock.lastBulkApplyTags == testTags,
            "It should pass the correct tags"
        )
        #expect(
            result.successful == ["note1.md", "note2.md"],
            "It should return the successful operations"
        )
        #expect(
            result.totalProcessed == 2,
            "It should return the correct total processed count"
        )
        #expect(
            result.query == testQuery,
            "It should return the original query"
        )
    }

    @Test("It should handle bulk apply tags errors")
    func bulkApplyTagsFromSearchError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.bulkApplyTagsFromSearch(query: "test", tags: ["tag1"])
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.bulkApplyTagsFromSearchCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    @Test("It should bulk replace frontmatter string from search")
    func bulkReplaceFrontmatterStringFromSearch() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testQuery = "status:draft"
        let testKey = "status"
        let testValue = "published"
        let expectedResult = BulkOperationResult(
            successful: ["draft1.md", "draft2.md"],
            failed: [],
            totalProcessed: 2,
            query: testQuery
        )
        mock.bulkOperationResultToReturn = expectedResult

        // When
        let result = try await server.bulkReplaceFrontmatterStringFromSearch(
            query: testQuery,
            key: testKey,
            value: testValue
        )

        // Then
        #expect(
            mock.bulkReplaceFrontmatterStringFromSearchCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastBulkReplaceFrontmatterStringQuery == testQuery,
            "It should pass the correct query"
        )
        #expect(
            mock.lastBulkReplaceFrontmatterStringKey == testKey,
            "It should pass the correct key"
        )
        #expect(
            mock.lastBulkReplaceFrontmatterStringValue == testValue,
            "It should pass the correct value"
        )
        #expect(
            result.successful == ["draft1.md", "draft2.md"],
            "It should return the successful operations"
        )
        #expect(
            result.query == testQuery,
            "It should return the original query"
        )
    }

    @Test("It should handle bulk replace frontmatter string errors")
    func bulkReplaceFrontmatterStringFromSearchError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.bulkReplaceFrontmatterStringFromSearch(
                query: "test",
                key: "key",
                value: "value"
            )
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.bulkReplaceFrontmatterStringFromSearchCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    @Test("It should bulk replace frontmatter array from search")
    func bulkReplaceFrontmatterArrayFromSearch() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testQuery = "type:meeting"
        let testKey = "attendees"
        let testValues = ["Alice", "Bob", "Charlie"]
        let expectedResult = BulkOperationResult(
            successful: ["meeting1.md", "meeting2.md"],
            failed: [],
            totalProcessed: 2,
            query: testQuery
        )
        mock.bulkOperationResultToReturn = expectedResult

        // When
        let result = try await server.bulkReplaceFrontmatterArrayFromSearch(
            query: testQuery,
            key: testKey,
            value: testValues
        )

        // Then
        #expect(
            mock.bulkReplaceFrontmatterArrayFromSearchCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastBulkReplaceFrontmatterArrayQuery == testQuery,
            "It should pass the correct query"
        )
        #expect(
            mock.lastBulkReplaceFrontmatterArrayKey == testKey,
            "It should pass the correct key"
        )
        #expect(
            mock.lastBulkReplaceFrontmatterArrayValue == testValues,
            "It should pass the correct values"
        )
        #expect(
            result.successful == ["meeting1.md", "meeting2.md"],
            "It should return the successful operations"
        )
        #expect(
            result.query == testQuery,
            "It should return the original query"
        )
    }

    @Test("It should handle bulk replace frontmatter array errors")
    func bulkReplaceFrontmatterArrayFromSearchError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.bulkReplaceFrontmatterArrayFromSearch(
                query: "test",
                key: "key",
                value: ["value1", "value2"]
            )
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.bulkReplaceFrontmatterArrayFromSearchCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    @Test("It should bulk append to frontmatter string from search")
    func bulkAppendToFrontmatterStringFromSearch() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testQuery = "project:alpha"
        let testKey = "notes"
        let testValue = " - Updated with new requirements"
        let expectedResult = BulkOperationResult(
            successful: ["alpha-doc1.md", "alpha-doc2.md"],
            failed: [],
            totalProcessed: 2,
            query: testQuery
        )
        mock.bulkOperationResultToReturn = expectedResult

        // When
        let result = try await server.bulkAppendToFrontmatterStringFromSearch(
            query: testQuery,
            key: testKey,
            value: testValue
        )

        // Then
        #expect(
            mock.bulkAppendToFrontmatterStringFromSearchCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastBulkAppendFrontmatterStringQuery == testQuery,
            "It should pass the correct query"
        )
        #expect(
            mock.lastBulkAppendFrontmatterStringKey == testKey,
            "It should pass the correct key"
        )
        #expect(
            mock.lastBulkAppendFrontmatterStringValue == testValue,
            "It should pass the correct value"
        )
        #expect(
            result.successful == ["alpha-doc1.md", "alpha-doc2.md"],
            "It should return the successful operations"
        )
        #expect(
            result.query == testQuery,
            "It should return the original query"
        )
    }

    @Test("It should handle bulk append to frontmatter string errors")
    func bulkAppendToFrontmatterStringFromSearchError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.bulkAppendToFrontmatterStringFromSearch(
                query: "test",
                key: "key",
                value: "value"
            )
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.bulkAppendToFrontmatterStringFromSearchCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    @Test("It should bulk append to frontmatter array from search")
    func bulkAppendToFrontmatterArrayFromSearch() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let testQuery = "category:research"
        let testKey = "keywords"
        let testValues = ["machine-learning", "data-analysis"]
        let expectedResult = BulkOperationResult(
            successful: ["research1.md", "research2.md", "research3.md"],
            failed: [],
            totalProcessed: 3,
            query: testQuery
        )
        mock.bulkOperationResultToReturn = expectedResult

        // When
        let result = try await server.bulkAppendToFrontmatterArrayFromSearch(
            query: testQuery,
            key: testKey,
            value: testValues
        )

        // Then
        #expect(
            mock.bulkAppendToFrontmatterArrayFromSearchCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastBulkAppendFrontmatterArrayQuery == testQuery,
            "It should pass the correct query"
        )
        #expect(
            mock.lastBulkAppendFrontmatterArrayKey == testKey,
            "It should pass the correct key"
        )
        #expect(
            mock.lastBulkAppendFrontmatterArrayValue == testValues,
            "It should pass the correct values"
        )
        #expect(
            result.successful == ["research1.md", "research2.md", "research3.md"],
            "It should return the successful operations"
        )
        #expect(
            result.totalProcessed == 3,
            "It should return the correct total processed count"
        )
        #expect(
            result.query == testQuery,
            "It should return the original query"
        )
    }

    @Test("It should handle bulk append to frontmatter array errors")
    func bulkAppendToFrontmatterArrayFromSearchError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.bulkAppendToFrontmatterArrayFromSearch(
                query: "test",
                key: "key",
                value: ["value1", "value2"]
            )
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.bulkAppendToFrontmatterArrayFromSearchCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    // MARK: - Integration Tests

    @Test("It should maintain repository isolation")
    func repositoryIsolation() async throws {
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

    // MARK: - MCP Resource Tests

    @Test("It should return enum types list from resource")
    func listEnumTypesResource() async throws {
        // Given
        let (server, _) = makeServerWithMock()

        // When
        let result = try await server.listEnumTypes()

        // Then
        #expect(
            result.contains("Language"),
            "It should include Language enum"
        )
        #expect(
            result.contains("resourceURI"),
            "It should include resource URIs"
        )
        #expect(
            result.contains("obsidian:\\/\\/enums\\/language"),
            "It should include language resource URI"
        )
    }

    @Test("It should return Language enum details from resource")
    func getLanguageEnumResource() async throws {
        // Given
        let (server, _) = makeServerWithMock()

        // When
        let result = try await server.getLanguageEnum()

        // Then
        #expect(
            result.contains("portuguese"),
            "It should include portuguese language"
        )
        #expect(
            result.contains("Language") && result.contains("enum"),
            "It should identify as Language enum"
        )
    }

    @Test("It should return WritingStyle enum details from resource")
    func getWritingStyleEnumResource() async throws {
        // Given
        let (server, _) = makeServerWithMock()

        // When
        let result = try await server.getWritingStyleEnum()

        // Then
        #expect(
            result.contains("formal"),
            "It should include formal style"
        )
        #expect(
            result.contains("WritingStyle") && result.contains("enum"),
            "It should identify as WritingStyle enum"
        )
    }

    @Test("It should return AnalysisFocus enum details from resource")
    func getAnalysisFocusEnumResource() async throws {
        // Given
        let (server, _) = makeServerWithMock()

        // When
        let result = try await server.getAnalysisFocusEnum()

        // Then
        #expect(
            result.contains("summary"),
            "It should include summary focus"
        )
        #expect(
            result.contains("AnalysisFocus") && result.contains("enum"),
            "It should identify as AnalysisFocus enum"
        )
    }

    @Test("It should return AbstractLength enum details from resource")
    func getAbstractLengthEnumResource() async throws {
        // Given
        let (server, _) = makeServerWithMock()

        // When
        let result = try await server.getAbstractLengthEnum()

        // Then
        #expect(
            result.contains("brief"),
            "It should include brief length"
        )
        #expect(
            result.contains("AbstractLength") && result.contains("enum"),
            "It should identify as AbstractLength enum"
        )
    }

    @Test("It should return OutlineStyle enum details from resource")
    func getOutlineStyleEnumResource() async throws {
        // Given
        let (server, _) = makeServerWithMock()

        // When
        let result = try await server.getOutlineStyleEnum()

        // Then
        #expect(
            result.contains("bullets"),
            "It should include bullets style"
        )
        #expect(
            result.contains("OutlineStyle") && result.contains("enum"),
            "It should identify as OutlineStyle enum"
        )
    }

    // MARK: - Periodic Notes Get Operations Tests

    @Test("It should get daily note")
    func getDailyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let expectedFile = File(
            filename: "2025-01-15.md",
            content: "# Daily Note\n\n## Tasks\n- Complete daily review"
        )
        mock.periodicNoteFileToReturn = expectedFile

        // When
        let result = try await server.getDailyNote()

        // Then
        #expect(
            mock.getPeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastPeriodicNotePeriod == "daily",
            "It should request daily period"
        )
        #expect(
            result.filename == expectedFile.filename,
            "It should return the expected filename"
        )
        #expect(
            result.content == expectedFile.content,
            "It should return the expected content"
        )
    }

    @Test("It should get weekly note")
    func getWeeklyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let expectedFile = File(
            filename: "2025-W03.md",
            content: "# Weekly Review\n\n## Goals\n- Complete sprint objectives"
        )
        mock.periodicNoteFileToReturn = expectedFile

        // When
        let result = try await server.getWeeklyNote()

        // Then
        #expect(
            mock.getPeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastPeriodicNotePeriod == "weekly",
            "It should request weekly period"
        )
        #expect(
            result.filename == expectedFile.filename,
            "It should return the expected filename"
        )
        #expect(
            result.content == expectedFile.content,
            "It should return the expected content"
        )
    }

    @Test("It should get monthly note")
    func getMonthlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let expectedFile = File(
            filename: "2025-01.md",
            content: "# Monthly Summary\n\n## Key Metrics\n- Revenue: $100k"
        )
        mock.periodicNoteFileToReturn = expectedFile

        // When
        let result = try await server.getMonthlyNote()

        // Then
        #expect(
            mock.getPeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastPeriodicNotePeriod == "monthly",
            "It should request monthly period"
        )
        #expect(
            result.filename == expectedFile.filename,
            "It should return the expected filename"
        )
        #expect(
            result.content == expectedFile.content,
            "It should return the expected content"
        )
    }

    @Test("It should get quarterly note")
    func getQuarterlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let expectedFile = File(
            filename: "2025-Q1.md",
            content: "# Q1 OKRs\n\n## Objectives\n1. Improve performance by 20%"
        )
        mock.periodicNoteFileToReturn = expectedFile

        // When
        let result = try await server.getQuarterlyNote()

        // Then
        #expect(
            mock.getPeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastPeriodicNotePeriod == "quarterly",
            "It should request quarterly period"
        )
        #expect(
            result.filename == expectedFile.filename,
            "It should return the expected filename"
        )
        #expect(
            result.content == expectedFile.content,
            "It should return the expected content"
        )
    }

    @Test("It should get yearly note")
    func getYearlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let expectedFile = File(
            filename: "2025.md",
            content: "# 2025 Annual Review\n\n## Achievements\n- Company IPO successful"
        )
        mock.periodicNoteFileToReturn = expectedFile

        // When
        let result = try await server.getYearlyNote()

        // Then
        #expect(
            mock.getPeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastPeriodicNotePeriod == "yearly",
            "It should request yearly period"
        )
        #expect(
            result.filename == expectedFile.filename,
            "It should return the expected filename"
        )
        #expect(
            result.content == expectedFile.content,
            "It should return the expected content"
        )
    }

    @Test("It should handle get periodic note errors")
    func getPeriodicNoteError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let expectedFile = File(filename: "test.md", content: "test content")
        mock.periodicNoteFileToReturn = expectedFile
        mock.errorToThrow = MockError.updateFailed

        // When/Then
        do {
            _ = try await server.getDailyNote()
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.getPeriodicNoteCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    // MARK: - Periodic Notes Create/Update Operations Tests

    @Test("It should create or update daily note")
    func createOrUpdateDailyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let content = "# Today's Tasks\n\n- Complete project review"

        // When
        let result = try await server.createOrUpdateDailyNote(content: content)

        // Then
        #expect(
            mock.createOrUpdatePeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastCreateOrUpdatePeriodicNotePeriod == "daily",
            "It should use daily period"
        )
        #expect(
            mock.lastCreateOrUpdatePeriodicNoteContent == content,
            "It should pass the correct content"
        )
        #expect(
            result.contains("Successfully updated daily periodic note"),
            "It should return success message"
        )
    }

    @Test("It should create or update weekly note")
    func createOrUpdateWeeklyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let content = "# Weekly Review\n\n## Accomplishments\n- Launched new feature"

        // When
        let result = try await server.createOrUpdateWeeklyNote(content: content)

        // Then
        #expect(
            mock.createOrUpdatePeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastCreateOrUpdatePeriodicNotePeriod == "weekly",
            "It should use weekly period"
        )
        #expect(
            mock.lastCreateOrUpdatePeriodicNoteContent == content,
            "It should pass the correct content"
        )
        #expect(
            result.contains("Successfully updated weekly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should create or update monthly note")
    func createOrUpdateMonthlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let content = "# Monthly Summary\n\n## Key Metrics\n- Revenue: $50k"

        // When
        let result = try await server.createOrUpdateMonthlyNote(content: content)

        // Then
        #expect(
            mock.createOrUpdatePeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastCreateOrUpdatePeriodicNotePeriod == "monthly",
            "It should use monthly period"
        )
        #expect(
            mock.lastCreateOrUpdatePeriodicNoteContent == content,
            "It should pass the correct content"
        )
        #expect(
            result.contains("Successfully updated monthly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should create or update quarterly note")
    func createOrUpdateQuarterlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let content = "# Q1 OKRs\n\n## Objectives\n1. Improve performance"

        // When
        let result = try await server.createOrUpdateQuarterlyNote(content: content)

        // Then
        #expect(
            mock.createOrUpdatePeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastCreateOrUpdatePeriodicNotePeriod == "quarterly",
            "It should use quarterly period"
        )
        #expect(
            mock.lastCreateOrUpdatePeriodicNoteContent == content,
            "It should pass the correct content"
        )
        #expect(
            result.contains("Successfully updated quarterly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should create or update yearly note")
    func createOrUpdateYearlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let content = "# 2024 Annual Review\n\n## Achievements\n- Company growth"

        // When
        let result = try await server.createOrUpdateYearlyNote(content: content)

        // Then
        #expect(
            mock.createOrUpdatePeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastCreateOrUpdatePeriodicNotePeriod == "yearly",
            "It should use yearly period"
        )
        #expect(
            mock.lastCreateOrUpdatePeriodicNoteContent == content,
            "It should pass the correct content"
        )
        #expect(
            result.contains("Successfully updated yearly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should handle create or update periodic note errors")
    func createOrUpdatePeriodicNoteError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.createOrUpdateFailed

        // When/Then
        do {
            _ = try await server.createOrUpdateDailyNote(content: "test")
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.createOrUpdatePeriodicNoteCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    // MARK: - Periodic Notes Append Operations Tests

    @Test("It should append to daily note")
    func appendToDailyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let content = "\n\n## Evening Reflection\n- Completed all tasks"

        // When
        let result = try await server.appendToDailyNote(content: content)

        // Then
        #expect(
            mock.appendToPeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastAppendToPeriodicNotePeriod == "daily",
            "It should use daily period"
        )
        #expect(
            mock.lastAppendToPeriodicNoteContent == content,
            "It should pass the correct content"
        )
        #expect(
            result.contains("Successfully appended content to daily periodic note"),
            "It should return success message"
        )
    }

    @Test("It should append to weekly note")
    func appendToWeeklyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let content = "\n\n## New Learning\n- Discovered better workflow"

        // When
        let result = try await server.appendToWeeklyNote(content: content)

        // Then
        #expect(
            mock.appendToPeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastAppendToPeriodicNotePeriod == "weekly",
            "It should use weekly period"
        )
        #expect(
            mock.lastAppendToPeriodicNoteContent == content,
            "It should pass the correct content"
        )
        #expect(
            result.contains("Successfully appended content to weekly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should append to monthly note")
    func appendToMonthlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let content = "\n\n## Additional Metric\n- Customer satisfaction: 95%"

        // When
        let result = try await server.appendToMonthlyNote(content: content)

        // Then
        #expect(
            mock.appendToPeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastAppendToPeriodicNotePeriod == "monthly",
            "It should use monthly period"
        )
        #expect(
            mock.lastAppendToPeriodicNoteContent == content,
            "It should pass the correct content"
        )
        #expect(
            result.contains("Successfully appended content to monthly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should append to quarterly note")
    func appendToQuarterlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let content = "\n\n## Risk Assessment\n- Market volatility concerns"

        // When
        let result = try await server.appendToQuarterlyNote(content: content)

        // Then
        #expect(
            mock.appendToPeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastAppendToPeriodicNotePeriod == "quarterly",
            "It should use quarterly period"
        )
        #expect(
            mock.lastAppendToPeriodicNoteContent == content,
            "It should pass the correct content"
        )
        #expect(
            result.contains("Successfully appended content to quarterly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should append to yearly note")
    func appendToYearlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let content = "\n\n## Late Addition\n- Unexpected partnership deal"

        // When
        let result = try await server.appendToYearlyNote(content: content)

        // Then
        #expect(
            mock.appendToPeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastAppendToPeriodicNotePeriod == "yearly",
            "It should use yearly period"
        )
        #expect(
            mock.lastAppendToPeriodicNoteContent == content,
            "It should pass the correct content"
        )
        #expect(
            result.contains("Successfully appended content to yearly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should handle append to periodic note errors")
    func appendToPeriodicNoteError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.appendFailed

        // When/Then
        do {
            _ = try await server.appendToDailyNote(content: "test")
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.appendToPeriodicNoteCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    // MARK: - Periodic Notes Delete Operations Tests

    @Test("It should delete daily note")
    func deleteDailyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()

        // When
        let result = try await server.deleteDailyNote()

        // Then
        #expect(
            mock.deletePeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastDeletePeriodicNotePeriod == "daily",
            "It should use daily period"
        )
        #expect(
            result.contains("Successfully deleted daily periodic note"),
            "It should return success message"
        )
    }

    @Test("It should delete weekly note")
    func deleteWeeklyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()

        // When
        let result = try await server.deleteWeeklyNote()

        // Then
        #expect(
            mock.deletePeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastDeletePeriodicNotePeriod == "weekly",
            "It should use weekly period"
        )
        #expect(
            result.contains("Successfully deleted weekly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should delete monthly note")
    func deleteMonthlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()

        // When
        let result = try await server.deleteMonthlyNote()

        // Then
        #expect(
            mock.deletePeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastDeletePeriodicNotePeriod == "monthly",
            "It should use monthly period"
        )
        #expect(
            result.contains("Successfully deleted monthly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should delete quarterly note")
    func deleteQuarterlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()

        // When
        let result = try await server.deleteQuarterlyNote()

        // Then
        #expect(
            mock.deletePeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastDeletePeriodicNotePeriod == "quarterly",
            "It should use quarterly period"
        )
        #expect(
            result.contains("Successfully deleted quarterly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should delete yearly note")
    func deleteYearlyNote() async throws {
        // Given
        let (server, mock) = makeServerWithMock()

        // When
        let result = try await server.deleteYearlyNote()

        // Then
        #expect(
            mock.deletePeriodicNoteCallCount == 1,
            "It should call the repository method once"
        )
        #expect(
            mock.lastDeletePeriodicNotePeriod == "yearly",
            "It should use yearly period"
        )
        #expect(
            result.contains("Successfully deleted yearly periodic note"),
            "It should return success message"
        )
    }

    @Test("It should handle delete periodic note errors")
    func deletePeriodicNoteError() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        mock.errorToThrow = MockError.deleteFailed

        // When/Then
        do {
            _ = try await server.deleteDailyNote()
            #expect(Bool(false), "It should throw an error")
        } catch {
            #expect(
                error is MockError,
                "It should throw the mock error"
            )
            #expect(
                mock.deletePeriodicNoteCallCount == 1,
                "It should call the repository method once"
            )
        }
    }

    // MARK: - Periodic Notes Integration Tests

    @Test("It should handle multiple periodic note operations independently")
    func multiplePeriodicNoteOperations() async throws {
        // Given
        let (server, mock) = makeServerWithMock()
        let mockFile = File(filename: "test.md", content: "test content")
        mock.periodicNoteFileToReturn = mockFile

        // When
        _ = try await server.getDailyNote()
        _ = try await server.getWeeklyNote()
        _ = try await server.createOrUpdateMonthlyNote(content: "test")
        _ = try await server.appendToQuarterlyNote(content: "test")
        _ = try await server.deleteYearlyNote()

        // Then
        #expect(
            mock.getPeriodicNoteCallCount == 2,
            "It should call get method twice"
        )
        #expect(
            mock.createOrUpdatePeriodicNoteCallCount == 1,
            "It should call create/update method once"
        )
        #expect(
            mock.appendToPeriodicNoteCallCount == 1,
            "It should call append method once"
        )
        #expect(
            mock.deletePeriodicNoteCallCount == 1,
            "It should call delete method once"
        )
    }
}
