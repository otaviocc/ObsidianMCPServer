import ObsidianModels
import ObsidianRepository
import Testing

@testable import ObsidianPrompt

@Suite("ObsidianPrompt Generation Operations Tests")
struct ObsidianPromptGenerationOperationsTests {

    // MARK: - Test Helper

    private func makePromptWithMock() -> (ObsidianPrompt, ObsidianRepositoryMock) {
        let mockRepository = ObsidianRepositoryMock()
        let prompt = ObsidianPrompt(repository: mockRepository)
        return (prompt, mockRepository)
    }

    @Test("It should generate follow-up questions with default count")
    func generateFollowUpQuestionsWithDefaultCount() async throws {
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
    func generateFollowUpQuestionsWithCustomCount() async throws {
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
    func generateFollowUpQuestionsWithRepositoryError() async {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "missing.md"
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getVaultNoteThrowableError = expectedError

        // When/Then
        await #expect(throws: ObsidianRepositoryMock.MockError.someMockError) {
            try await prompt.generateFollowUpQuestions(filename: filename, questionCount: 3)
        }
    }

    @Test("It should generate active note abstract with standard length")
    func generateActiveNoteAbstractStandard() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "research-paper.md",
            content: "# Research on Machine Learning\n\nThis paper presents findings on neural networks and their applications in natural language processing. Key discoveries include improved accuracy and performance metrics."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let length = AbstractLength.standard

        // When
        let result = try await prompt.generateActiveNoteAbstract(length: length)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("Generate Abstract"),
            "It should include the abstract generation title"
        )
        #expect(
            result.contains("Standard abstract (1 paragraph)"),
            "It should include the standard length description"
        )
        #expect(
            result.contains("research-paper.md"),
            "It should include the active note filename"
        )
        #expect(
            result.contains("neural networks"),
            "It should include the note content"
        )
        #expect(
            result.contains("3-5 sentences or 75-150 words"),
            "It should include standard length instructions"
        )
        #expect(
            result.contains("Generated Abstract"),
            "It should include instructions for output"
        )
    }

    @Test("It should generate active note abstract with brief length")
    func generateActiveNoteAbstractBrief() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "quick-notes.md",
            content: "Meeting summary with action items and next steps."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let length = AbstractLength.brief

        // When
        let result = try await prompt.generateActiveNoteAbstract(length: length)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
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
            "It should include brief-specific instructions"
        )
    }

    @Test("It should generate active note abstract with detailed length")
    func generateActiveNoteAbstractDetailed() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "comprehensive-analysis.md",
            content: "Detailed analysis of market trends, methodology, findings, and implications for future business strategy."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let length = AbstractLength.detailed

        // When
        let result = try await prompt.generateActiveNoteAbstract(length: length)

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
            "It should include detailed-specific instructions"
        )
    }

    @Test("It should generate active note outline with hierarchical style")
    func generateActiveNoteOutlineHierarchical() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "project-plan.md",
            content: "# Project Plan\n\n## Phase 1: Research\n- Literature review\n- Data collection\n\n## Phase 2: Implementation\n- Development\n- Testing"
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let style = OutlineStyle.hierarchical

        // When
        let result = try await prompt.generateActiveNoteOutline(style: style)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("Generate Outline"),
            "It should include the outline generation title"
        )
        #expect(
            result.contains("Hierarchical academic format"),
            "It should include the hierarchical style description"
        )
        #expect(
            result.contains("project-plan.md"),
            "It should include the active note filename"
        )
        #expect(
            result.contains("Phase 1: Research"),
            "It should include the note content"
        )
        #expect(
            result.contains("Roman numerals for major sections"),
            "It should include hierarchical style instructions"
        )
        #expect(
            result.contains("Generated Outline"),
            "It should include instructions for output"
        )
    }

    @Test("It should generate active note outline with bullets style")
    func generateActiveNoteOutlineBullets() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "meeting-agenda.md",
            content: "Meeting topics and discussion points for weekly review."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let style = OutlineStyle.bullets

        // When
        let result = try await prompt.generateActiveNoteOutline(style: style)

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
            "It should include bullets-specific formatting instructions"
        )
    }

    @Test("It should generate active note outline with numbered style")
    func generateActiveNoteOutlineNumbered() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "procedure-doc.md",
            content: "Step-by-step procedure with multiple sections and subsections."
        )
        mockRepository.getActiveNoteReturnValue = activeNote
        let style = OutlineStyle.numbered

        // When
        let result = try await prompt.generateActiveNoteOutline(style: style)

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
    func propagateErrorsForGenerateActiveNoteAbstract() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getActiveNoteThrowableError = expectedError
        let length = AbstractLength.standard

        // When & Then
        await #expect(throws: ObsidianRepositoryMock.MockError.someMockError) {
            try await prompt.generateActiveNoteAbstract(length: length)
        }
    }

    @Test("It should propagate errors for generate active note outline")
    func propagateErrorsForGenerateActiveNoteOutline() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getActiveNoteThrowableError = expectedError
        let style = OutlineStyle.hierarchical

        // When & Then
        await #expect(throws: ObsidianRepositoryMock.MockError.someMockError) {
            try await prompt.generateActiveNoteOutline(style: style)
        }
    }
}
