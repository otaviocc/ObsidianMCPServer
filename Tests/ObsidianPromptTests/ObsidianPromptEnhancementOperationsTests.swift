import ObsidianModels
import ObsidianRepository
import Testing
@testable import ObsidianPrompt

@Suite("ObsidianPrompt Enhancement Operations Tests")
struct ObsidianPromptEnhancementOperationsTests {

    // MARK: - Test Helper

    private func makePromptWithMock() -> (ObsidianPrompt, ObsidianRepositoryMock) {
        let mockRepository = ObsidianRepositoryMock()
        let prompt = ObsidianPrompt(repository: mockRepository)
        return (prompt, mockRepository)
    }

    @Test("It should suggest tags with default count")
    func suggestTagsWithDefaultCount() async throws {
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
    func suggestTagsWithCustomCount() async throws {
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
    func generateFrontmatter() async throws {
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
    func suggestActiveNoteTagsWithDefaultCount() async throws {
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
            result.contains("Content from the currently active note"),
            "It should mention it's the active note content"
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
    func suggestActiveNoteTagsWithCustomCount() async throws {
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

    @Test("It should add sections to active note")
    func addSectionsToActiveNote() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let activeNote = File(
            filename: "project-update.md",
            content: "# Project Alpha Update\nWe made significant progress this week on the user authentication system."
        )
        mockRepository.getActiveNoteReturnValue = activeNote

        // When
        let result = try await prompt.addSectionsToActiveNote()

        // Then
        #expect(
            mockRepository.getActiveNoteCallsCount == 1,
            "It should call getActiveNote once"
        )
        #expect(
            result.contains("project-update.md"),
            "It should include the active note filename"
        )
        #expect(
            result.contains("Content from the currently active note"),
            "It should mention it's the active note content"
        )
        #expect(
            result.contains("Project Alpha Update"),
            "It should include the note content"
        )
        #expect(
            result.contains("suggest sections to add"),
            "It should mention section suggestions"
        )
        #expect(
            result.contains("Preserve ALL existing content"),
            "It should emphasize content preservation"
        )
        #expect(
            result.contains("Next Steps/Actions"),
            "It should include section type suggestions"
        )
        #expect(
            result.contains("Related Notes"),
            "It should include related notes section"
        )
        #expect(
            result.contains("updateActiveNote(content:"),
            "It should include MCP command for updating"
        )
        #expect(
            result.contains("## Overview") && result.contains("## Next Steps"),
            "It should include example section formatting"
        )
    }

    @Test("It should propagate errors for add sections to active note")
    func propagateErrorsForAddSectionsToActiveNote() async throws {
        // Given
        let (prompt, mockRepository) = makePromptWithMock()
        let expectedError = ObsidianRepositoryMock.MockError.someMockError
        mockRepository.getActiveNoteThrowableError = expectedError

        // When & Then
        await #expect(throws: ObsidianRepositoryMock.MockError.someMockError) {
            try await prompt.addSectionsToActiveNote()
        }
    }
}
