// MIT License
//
// Copyright (c) 2026 Otávio C.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
