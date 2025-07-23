import Testing
import Foundation
@testable import ObsidianPrompt
@testable import ObsidianRepository

@Suite("ObsidianPrompt Tests")
struct ObsidianPromptTests {

    // MARK: - Test Helper

    private func makePromptWithMock() -> (ObsidianPrompt, ObsidianRepositoryMock) {
        let mockRepository = ObsidianRepositoryMock()
        let prompt = ObsidianPrompt(repository: mockRepository)
        return (prompt, mockRepository)
    }

    @Test("It should summarize note with general focus")
    func testSummarizeNoteWithGeneralFocus() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "test-note.md"
        let noteContent = File(
            filename: filename,
            content: "This is a test note with some content."
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.summarizeNote(filename: filename, focus: .general)

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

    @Test("It should summarize note with action items focus")
    func testSummarizeNoteWithActionItemsFocus() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "tasks.md"
        let noteContent = File(
            filename: filename,
            content: "- [ ] Task 1\n- [ ] Task 2"
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.summarizeNote(
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

    @Test("It should summarize note with tone focus")
    func testSummarizeNoteWithToneFocus() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "journal.md"
        let noteContent = File(
            filename: filename,
            content: "I'm feeling excited about this new project!"
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.summarizeNote(
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
    func testSummarizeNoteWithRepositoryError() async {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "non-existent.md"
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getVaultNoteThrowableError = expectedError

        // When/Then
        do {
            _ = try await prompt.summarizeNote(filename: filename, focus: .general)
            #expect(Bool(false), "It should throw an error when repository fails")
        } catch {
            #expect(
                error.localizedDescription == expectedError.localizedDescription,
                "It should propagate the repository error"
            )
        }
    }

    @Test("It should analyze active note with general focus")
    func testAnalyzeActiveNoteWithGeneralFocus() async throws {
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
            result.contains("currently active Obsidian note"),
            "It should mention it's the active note"
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
    func testAnalyzeActiveNoteWithActionItemsFocus() async throws {
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
    func testAnalyzeActiveNoteWithRepositoryError() async {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getActiveNoteThrowableError = expectedError

        // When/Then
        do {
            _ = try await prompt.analyzeActiveNote(focus: .general)
            #expect(Bool(false), "It should throw an error when repository fails")
        } catch {
            #expect(
                error.localizedDescription == expectedError.localizedDescription,
                "It should propagate the repository error"
            )
        }
    }

    @Test("It should generate follow-up questions with default count")
    func testGenerateFollowUpQuestionsWithDefaultCount() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "research-note.md"
        let noteContent = File(
            filename: filename,
            content: "Machine learning is transforming various industries through automation and intelligent decision-making."
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.generateFollowUpQuestions(
            filename: filename,
            questionCount: 5
        )

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
            result.contains("5 thought-provoking follow-up questions"),
            "It should mention the number of questions"
        )
        #expect(
            result.contains("research-note.md"),
            "It should include the filename"
        )
        #expect(
            result.contains(noteContent.content),
            "It should include the note content"
        )
        #expect(
            result.contains("Analysis"),
            "It should include question categories"
        )
        #expect(
            result.contains("Synthesis"),
            "It should include synthesis category"
        )
        #expect(
            result.contains("Application"),
            "It should include application category"
        )
    }

    @Test("It should generate follow-up questions with custom count")
    func testGenerateFollowUpQuestionsWithCustomCount() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "philosophy.md"
        let noteContent = File(
            filename: filename,
            content: "The nature of consciousness remains one of philosophy's greatest mysteries."
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.generateFollowUpQuestions(
            filename: filename,
            questionCount: 3
        )

        // Then
        #expect(
            result.contains("3 thought-provoking follow-up questions"),
            "It should mention the custom number of questions"
        )
        #expect(
            result.contains("philosophy.md"),
            "It should include the filename"
        )
    }

    @Test("It should propagate errors for follow-up questions")
    func testGenerateFollowUpQuestionsWithRepositoryError() async {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "missing.md"
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getVaultNoteThrowableError = expectedError

        // When/Then
        do {
            _ = try await prompt.generateFollowUpQuestions(filename: filename, questionCount: 3)
            #expect(Bool(false), "It should throw an error when repository fails")
        } catch {
            #expect(
                error.localizedDescription == expectedError.localizedDescription,
                "It should propagate the repository error"
            )
        }
    }
}
