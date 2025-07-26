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

    @Test("It should translate active note to Portuguese")
    func testTranslateActiveNoteToPortuguese() async throws {
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
            result.contains("Translate Active Note"),
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
    func testTranslateActiveNoteToSpanish() async throws {
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
            result.contains("Translate Active Note"),
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
    func testTranslateActiveNoteToJapanese() async throws {
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
    func testPropagateErrorsForTranslateActiveNote() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getActiveNoteThrowableError = expectedError
        let language = Language.portuguese

        // When & Then
        do {
            _ = try await prompt.translateActiveNote(language: language)
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

    @Test("It should generate active note abstract with standard length")
    func testGenerateActiveNoteAbstractStandard() async throws {
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
    func testGenerateActiveNoteAbstractBrief() async throws {
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
    func testGenerateActiveNoteAbstractDetailed() async throws {
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
    func testGenerateActiveNoteOutlineHierarchical() async throws {
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
    func testGenerateActiveNoteOutlineBullets() async throws {
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
    func testGenerateActiveNoteOutlineNumbered() async throws {
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
    func testPropagateErrorsForGenerateActiveNoteAbstract() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getActiveNoteThrowableError = expectedError
        let length = AbstractLength.standard

        // When & Then
        do {
            _ = try await prompt.generateActiveNoteAbstract(length: length)
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

    @Test("It should propagate errors for generate active note outline")
    func testPropagateErrorsForGenerateActiveNoteOutline() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getActiveNoteThrowableError = expectedError
        let style = OutlineStyle.hierarchical

        // When & Then
        do {
            _ = try await prompt.generateActiveNoteOutline(style: style)
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
