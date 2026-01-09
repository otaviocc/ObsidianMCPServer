import ObsidianModels
import ObsidianRepository
import Testing
@testable import ObsidianPrompt

@Suite("ObsidianPrompt Analysis Operations Tests")
struct ObsidianPromptAnalysisOperationsTests {

    // MARK: - Test Helper

    private func makePromptWithMock() -> (ObsidianPrompt, ObsidianRepositoryMock) {
        let mockRepository = ObsidianRepositoryMock()
        let prompt = ObsidianPrompt(repository: mockRepository)
        return (prompt, mockRepository)
    }

    @Test("It should analyze note with general focus")
    func analyzeNoteWithGeneralFocus() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "test-note.md"
        let noteContent = File(
            filename: filename,
            content: "This is a test note with some content."
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.analyzeNote(filename: filename, focus: .general)

        // Then
        #expect(
            mockRepository.getVaultNoteCallsCount == 1,
            "It should call getVaultNote once"
        )
        #expect(
            mockRepository.getVaultNoteReceivedArguments == filename,
            "It should pass the correct filename"
        )
        #expect(
            result.contains(filename),
            "It should include the filename in the prompt"
        )
        #expect(
            result.contains("Comprehensive analysis"),
            "It should include the general analysis description"
        )
        #expect(
            result.contains(noteContent.content),
            "It should include the note content"
        )
    }

    @Test("It should analyze note with action items focus")
    func analyzeNoteWithActionItemsFocus() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "tasks.md"
        let noteContent = File(
            filename: filename,
            content: "- [ ] Task 1\n- [ ] Task 2"
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.analyzeNote(
            filename: filename,
            focus: .actionItems
        )

        // Then
        #expect(
            result.contains("Extract tasks, deadlines, and next steps"),
            "It should include action items description"
        )
        #expect(
            result.contains("Extract all action items"),
            "It should include action items instructions"
        )
    }

    @Test("It should analyze note with tone focus")
    func analyzeNoteWithToneFocus() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "journal.md"
        let noteContent = File(
            filename: filename,
            content: "I'm feeling excited about this new project!"
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.analyzeNote(
            filename: filename,
            focus: .tone
        )

        // Then
        #expect(
            result.contains("Analyze mood, attitude, and emotional context"),
            "It should include tone analysis description"
        )
        #expect(
            result.contains("tone, mood, and emotional context"),
            "It should include tone analysis instructions"
        )
    }

    @Test("It should propagate repository errors")
    func analyzeNoteWithRepositoryError() async {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "non-existent.md"
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getVaultNoteThrowableError = expectedError

        // When/Then
        await #expect(throws: ObsidianRepositoryMock.MockError.someMockError) {
            try await prompt.analyzeNote(filename: filename, focus: .general)
        }
    }

    @Test("It should analyze active note with general focus")
    func analyzeActiveNoteWithGeneralFocus() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "active-note.md",
            content: "This is the currently active note content."
        )
        mockRepository.getActiveNoteReturnValue = activeNote

        // When
        let result = try await prompt.analyzeActiveNote(focus: .general)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("active-note.md"),
            "It should include the active note filename"
        )
        #expect(
            result.contains("Content from the currently active note"),
            "It should mention it's the active note content"
        )
        #expect(
            result.contains("Comprehensive analysis"),
            "It should include the general analysis description"
        )
        #expect(
            result.contains(activeNote.content),
            "It should include the note content"
        )
    }

    @Test("It should analyze active note with action items focus")
    func analyzeActiveNoteWithActionItemsFocus() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "daily-tasks.md",
            content: "Today's tasks:\n- [ ] Review code\n- [x] Write tests"
        )
        mockRepository.getActiveNoteReturnValue = activeNote

        // When
        let result = try await prompt.analyzeActiveNote(focus: .actionItems)

        // Then
        #expect(
            result.contains("Extract tasks, deadlines, and next steps"),
            "It should include action items description"
        )
        #expect(
            result.contains("Extract all action items"),
            "It should include action items instructions"
        )
        #expect(
            result.contains("daily-tasks.md"),
            "It should include the active note filename"
        )
    }

    @Test("It should propagate active note repository errors")
    func analyzeActiveNoteWithRepositoryError() async {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getActiveNoteThrowableError = expectedError

        // When/Then
        await #expect(throws: ObsidianRepositoryMock.MockError.someMockError) {
            try await prompt.analyzeActiveNote(focus: .general)
        }
    }

    @Test("It should extract metadata from note content")
    func extractMetadata() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "meeting-minutes.md"
        let noteContent = File(
            filename: filename,
            content: "Meeting with John Smith and Sarah Wilson on January 15, 2024. Project Alpha deadline: March 1st. Location: Conference Room A."
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.extractMetadata(filename: filename)

        // Then
        #expect(
            mockRepository.getVaultNoteCallsCount == 1,
            "It should call getVaultNote once"
        )
        #expect(
            result.contains("meeting-minutes.md"),
            "It should include the filename"
        )
        #expect(
            result.contains("extract key metadata"),
            "It should mention metadata extraction"
        )
        #expect(
            result.contains("Temporal Information"),
            "It should include metadata categories"
        )
        #expect(
            result.contains("People & Organizations"),
            "It should include people category"
        )
        #expect(
            result.contains("Location Information"),
            "It should include location category"
        )
        #expect(
            result.contains("setNoteFrontmatterArray") && result.contains("setNoteFrontmatterString"),
            "It should include MCP commands for both string and array fields"
        )
        #expect(
            result.contains("John Smith"),
            "It should include the note content"
        )
    }

    @Test("It should propagate errors for extract metadata")
    func extractMetadataWithRepositoryError() async {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "missing-file.md"
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getVaultNoteThrowableError = expectedError

        // When/Then
        await #expect(throws: ObsidianRepositoryMock.MockError.someMockError) {
            try await prompt.extractMetadata(filename: filename)
        }
    }
}
