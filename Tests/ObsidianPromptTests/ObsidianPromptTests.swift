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
}
