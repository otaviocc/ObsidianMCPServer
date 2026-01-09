import ObsidianModels
import ObsidianRepository
import Testing
@testable import ObsidianPrompt

@Suite("ObsidianPrompt Update Operations Tests")
struct ObsidianPromptUpdateOperationsTests {

    // MARK: - Test Helper

    private func makePromptWithMock() -> (ObsidianPrompt, ObsidianRepositoryMock) {
        let mockRepository = ObsidianRepositoryMock()
        let prompt = ObsidianPrompt(repository: mockRepository)
        return (prompt, mockRepository)
    }

    @Test("It should update daily note with agenda")
    func updateDailyNoteWithAgenda() async throws {
        // Given
        let (prompt, _) = makePromptWithMock()

        // When
        let result = try await prompt.updateDailyNoteWithAgenda()

        // Then
        #expect(
            result.contains("# Update Daily Note with Calendar Agenda"),
            "It should include the main heading"
        )

        #expect(
            result.contains(
                "You are an intelligent assistant that integrates calendar events into Obsidian daily notes"
            ),
            "It should include the objective description"
        )

        #expect(
            result.contains("Use Obsidian TODO syntax"),
            "It should include Obsidian TODO syntax instructions"
        )

        #expect(
            result.contains("createOrUpdateDailyNote"),
            "It should mention the createOrUpdateDailyNote MCP tool"
        )

        #expect(
            result.contains("## Meetings"),
            "It should include meetings section example"
        )
    }
}
