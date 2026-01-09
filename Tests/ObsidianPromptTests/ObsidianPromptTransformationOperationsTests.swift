import ObsidianModels
import ObsidianRepository
import Testing
@testable import ObsidianPrompt

@Suite("ObsidianPrompt Transformation Operations Tests")
struct ObsidianPromptTransformationOperationsTests {

    // MARK: - Test Helper

    private func makePromptWithMock() -> (ObsidianPrompt, ObsidianRepositoryMock) {
        let mockRepository = ObsidianRepositoryMock()
        let prompt = ObsidianPrompt(repository: mockRepository)
        return (prompt, mockRepository)
    }

    @Test("It should rewrite active note with formal style")
    func rewriteActiveNoteWithFormalStyle() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "active-note.md",
            content: "This is the currently active note content."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let style = WritingStyle.formal

        // When
        let result = try await prompt.rewriteActiveNote(style: style)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("Rewrite Note Content"),
            "It should include the rewrite prompt title"
        )

        #expect(
            result.contains("Formal and professional tone"),
            "It should include the formal style description"
        )

        #expect(
            result.contains("active-note.md"),
            "It should include the active note filename"
        )

        #expect(
            result.contains("This is the currently active note content."),
            "It should include the note content"
        )

        #expect(
            result.contains("Complete sentences and proper grammar"),
            "It should include formal style instructions"
        )
    }

    @Test("It should rewrite active note with emoji style")
    func rewriteActiveNoteWithEmojiStyle() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "active-note.md",
            content: "This is the currently active note content."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let style = WritingStyle.emoji

        // When
        let result = try await prompt.rewriteActiveNote(style: style)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("Rewrite Note Content"),
            "It should include the rewrite prompt title"
        )

        #expect(
            result.contains("Fun and expressive with emojis"),
            "It should include the emoji style description"
        )

        #expect(
            result.contains("Add relevant emojis throughout"),
            "It should include emoji style instructions"
        )
    }

    @Test("It should rewrite active note with ELI5 style")
    func rewriteActiveNoteWithELI5Style() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "active-note.md",
            content: "This is the currently active note content."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let style = WritingStyle.eli5

        // When
        let result = try await prompt.rewriteActiveNote(style: style)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("Rewrite Note Content"),
            "It should include the rewrite prompt title"
        )

        #expect(
            result.contains("Explain Like I'm 5"),
            "It should include the ELI5 style description"
        )

        #expect(
            result.contains("Use very simple words"),
            "It should include ELI5 style instructions"
        )

        #expect(
            result.contains("toys, animals, food"),
            "It should include ELI5 familiar examples"
        )
    }

    @Test("It should propagate errors for rewrite active note")
    func propagateErrorsForRewriteActiveNote() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getActiveNoteThrowableError = expectedError
        let style = WritingStyle.formal

        // When & Then
        await #expect(throws: ObsidianRepositoryMock.MockError.someMockError) {
            try await prompt.rewriteActiveNote(style: style)
        }
    }

    @Test("It should translate active note to Portuguese")
    func translateActiveNoteToPortuguese() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "project-notes.md",
            content: "This is a project note with some content to translate."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let language = Language.portuguese

        // When
        let result = try await prompt.translateActiveNote(language: language)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("Translate Note Content"),
            "It should include the translation prompt title"
        )
        #expect(
            result.contains("Portuguese (Português)"),
            "It should include the Portuguese language description"
        )
        #expect(
            result.contains("project-notes.md"),
            "It should include the active note filename"
        )
        #expect(
            result.contains("This is a project note with some content to translate."),
            "It should include the note content"
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
    }

    @Test("It should translate active note to Spanish")
    func translateActiveNoteToSpanish() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "meeting-notes.md",
            content: "# Meeting Notes\n\nDiscussed project timeline and deliverables."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let language = Language.spanish

        // When
        let result = try await prompt.translateActiveNote(language: language)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("Translate Note Content"),
            "It should include the translation prompt title"
        )
        #expect(
            result.contains("Spanish (Español)"),
            "It should include the Spanish language description"
        )
        #expect(
            result.contains("meeting-notes.md"),
            "It should include the active note filename"
        )
        #expect(
            result.contains("# Meeting Notes"),
            "It should include the note content"
        )
        #expect(
            result.contains("Use Latin American Spanish"),
            "It should include Latin American Spanish instructions"
        )
        #expect(
            result.contains("Preserve Obsidian Formatting"),
            "It should include Obsidian formatting preservation instructions"
        )
        #expect(
            result.contains("[[Page Name]]"),
            "It should include link preservation examples"
        )
    }

    @Test("It should translate active note to Japanese")
    func translateActiveNoteToJapanese() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "technical-doc.md",
            content: "Technical documentation with code blocks and references."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let language = Language.japanese

        // When
        let result = try await prompt.translateActiveNote(language: language)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
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
    }

    @Test("It should propagate errors for translate active note")
    func propagateErrorsForTranslateActiveNote() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getActiveNoteThrowableError = expectedError
        let language = Language.portuguese

        // When & Then
        await #expect(throws: ObsidianRepositoryMock.MockError.someMockError) {
            try await prompt.translateActiveNote(language: language)
        }
    }
}
