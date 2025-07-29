import Testing

@testable import ObsidianRepository

@Suite("SearchResult Model Tests")
struct SearchResultTests {

    @Test("It should create SearchResult model correctly")
    func searchResultModel() throws {
        // Given/When
        let searchResult = SearchResult(path: "notes/test.md", score: 0.85)

        // Then
        #expect(
            searchResult.path == "notes/test.md",
            "It should set the path correctly"
        )
        #expect(
            searchResult.score == 0.85,
            "It should set the score correctly"
        )
    }

    @Test("It should handle zero search score")
    func zeroSearchScore() throws {
        // Given/When
        let searchResult = SearchResult(path: "low-relevance.md", score: 0.0)

        // Then
        #expect(
            searchResult.path == "low-relevance.md",
            "It should handle path with zero score"
        )
        #expect(
            searchResult.score == 0.0,
            "It should handle zero score correctly"
        )
    }

    @Test("It should handle maximum search score")
    func maxSearchScore() throws {
        // Given/When
        let searchResult = SearchResult(path: "perfect-match.md", score: 1.0)

        // Then
        #expect(
            searchResult.path == "perfect-match.md",
            "It should handle path with maximum score"
        )
        #expect(
            searchResult.score == 1.0,
            "It should handle maximum score correctly"
        )
    }

    @Test("It should handle negative search score")
    func negativeSearchScore() throws {
        // Given/When
        let searchResult = SearchResult(path: "negative.md", score: -0.5)

        // Then
        #expect(
            searchResult.path == "negative.md",
            "It should handle path with negative score"
        )
        #expect(
            searchResult.score == -0.5,
            "It should handle negative score correctly"
        )
    }

    @Test("It should handle very high search score")
    func veryHighSearchScore() throws {
        // Given/When
        let searchResult = SearchResult(path: "high.md", score: 999.99)

        // Then
        #expect(
            searchResult.path == "high.md",
            "It should handle path with very high score"
        )
        #expect(
            searchResult.score == 999.99,
            "It should handle very high score correctly"
        )
    }

    @Test("It should handle search path with directories")
    func searchPathWithDirectories() throws {
        // Given/When
        let searchResult = SearchResult(path: "deep/nested/folders/note.md", score: 0.75)

        // Then
        #expect(
            searchResult.path == "deep/nested/folders/note.md",
            "It should handle deeply nested search result paths"
        )
        #expect(
            searchResult.score == 0.75,
            "It should handle score with nested path"
        )
    }
}
