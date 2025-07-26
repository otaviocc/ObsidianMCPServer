import ObsidianRepository
import Testing

@testable import ObsidianPrompt

@Suite("ObsidianPrompt Tests")
struct ObsidianPromptTests {

    // MARK: - Test Helper

    private func makePromptWithMock() -> (ObsidianPrompt, ObsidianRepositoryMock) {
        let mockRepository = ObsidianRepositoryMock()
        let prompt = ObsidianPrompt(repository: mockRepository)
        return (prompt, mockRepository)
    }

    @Test("It should analyze note with general focus")
    func testAnalyzeNoteWithGeneralFocus() async throws {
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
    func testAnalyzeNoteWithActionItemsFocus() async throws {
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
    func testAnalyzeNoteWithToneFocus() async throws {
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
    func testAnalyzeNoteWithRepositoryError() async {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "non-existent.md"
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getVaultNoteThrowableError = expectedError

        // When/Then
        do {
            _ = try await prompt.analyzeNote(filename: filename, focus: .general)
            #expect(
                Bool(false),
                "It should throw an error when repository fails"
            )
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
            #expect(
                Bool(false),
                "It should throw an error when repository fails"
            )
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
            #expect(
                Bool(false),
                "It should throw an error when repository fails"
            )
        } catch {
            #expect(
                error.localizedDescription == expectedError.localizedDescription,
                "It should propagate the repository error"
            )
        }
    }

    // MARK: - Frontmatter Prompt Tests

    @Test("It should suggest tags with default count")
    func testSuggestTagsWithDefaultCount() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "tech-article.md"
        let noteContent = File(
            filename: filename,
            content: "This article discusses machine learning applications in web development, focusing on TensorFlow.js implementation and React integration."
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.suggestTags(filename: filename, maxTags: 8)

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
            result.contains("8 relevant tags"),
            "It should mention the number of tags to suggest"
        )
        #expect(
            result.contains("tech-article.md"),
            "It should include the filename"
        )
        #expect(
            result.contains("machine learning"),
            "It should include the note content"
        )
        #expect(
            result.contains("appendToNoteFrontmatterArray"),
            "It should include MCP commands"
        )
        #expect(
            result.contains("Topics"),
            "It should include tag categories"
        )
    }

    @Test("It should suggest tags with custom count")
    func testSuggestTagsWithCustomCount() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "meeting-notes.md"
        let noteContent = File(
            filename: filename,
            content: "Weekly team standup discussion about project roadmap and sprint planning."
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.suggestTags(filename: filename, maxTags: 5)

        // Then
        #expect(
            result.contains("5 relevant tags"),
            "It should mention the custom number of tags"
        )
        #expect(
            result.contains("meeting-notes.md"),
            "It should include the filename"
        )
    }

    @Test("It should generate complete frontmatter structure")
    func testGenerateFrontmatter() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "project-proposal.md"
        let noteContent = File(
            filename: filename,
            content: "Project Alpha proposal for Q2 2024. Team: John Smith, Sarah Wilson. Deadline: March 15th. Status: Draft."
        )
        mockRepository.getVaultNoteReturnValue = noteContent

        // When
        let result = try await prompt.generateFrontmatter(filename: filename)

        // Then
        #expect(
            mockRepository.getVaultNoteCallsCount == 1,
            "It should call getVaultNote once"
        )
        #expect(
            result.contains("project-proposal.md"),
            "It should include the filename"
        )
        #expect(
            result.contains("complete frontmatter structure"),
            "It should mention frontmatter generation"
        )
        #expect(
            result.contains("YAML format"),
            "It should mention YAML format"
        )
        #expect(
            result.contains("setNoteFrontmatterArray") && result.contains("setNoteFrontmatterString"),
            "It should include MCP commands for both string and array fields"
        )
        #expect(
            result.contains("tags"),
            "It should include common frontmatter fields"
        )
        #expect(
            result.contains("status"),
            "It should include status field"
        )
        #expect(
            result.contains("category"),
            "It should include category field"
        )
    }

    @Test("It should suggest active note tags with default count")
    func testSuggestActiveNoteTagsWithDefaultCount() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "daily-journal.md",
            content: "Today I worked on improving my Swift programming skills and learned about async/await patterns."
        )
        mockRepository.getActiveNoteReturnValue = activeNote

        // When
        let result = try await prompt.suggestActiveNoteTags(maxTags: 8)

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("daily-journal.md"),
            "It should include the active note filename"
        )
        #expect(
            result.contains("currently active Obsidian note"),
            "It should mention it's the active note"
        )
        #expect(
            result.contains("8 relevant tags"),
            "It should mention the number of tags"
        )
        #expect(
            result.contains("appendToActiveNoteFrontmatterArray"),
            "It should include active note MCP commands"
        )
        #expect(
            result.contains("Swift programming"),
            "It should include the note content"
        )
    }

    @Test("It should suggest active note tags with custom count")
    func testSuggestActiveNoteTagsWithCustomCount() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "research-notes.md",
            content: "Research on artificial intelligence and machine learning algorithms."
        )
        mockRepository.getActiveNoteReturnValue = activeNote

        // When
        let result = try await prompt.suggestActiveNoteTags(maxTags: 3)

        // Then
        #expect(
            result.contains("3 relevant tags"),
            "It should mention the custom number of tags"
        )
        #expect(
            result.contains("research-notes.md"),
            "It should include the active note filename"
        )
    }

    @Test("It should extract metadata from note content")
    func testExtractMetadata() async throws {
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
            result.contains("Rewrite Active Note"),
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
            result.contains("Rewrite Active Note"),
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
            result.contains("Rewrite Active Note"),
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
        do {
            _ = try await prompt.rewriteActiveNote(style: style)
            #expect(
                Bool(false),
                "It should throw an error when repository fails"
            )
        } catch {
            #expect(
                error.localizedDescription == expectedError.localizedDescription,
                "It should propagate the repository error"
            )
        }
    }

    @Test("It should propagate errors for extract metadata")
    func testExtractMetadataWithRepositoryError() async {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let filename = "missing-file.md"
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getVaultNoteThrowableError = expectedError

        // When/Then
        do {
            _ = try await prompt.extractMetadata(filename: filename)
            #expect(
                Bool(false),
                "It should throw an error when repository fails"
            )
        } catch {
            #expect(
                error.localizedDescription == expectedError.localizedDescription,
                "It should propagate the repository error"
            )
        }
    }
}
