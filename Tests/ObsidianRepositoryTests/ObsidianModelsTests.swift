import Testing
import Foundation

@testable import ObsidianRepository

@Suite("Obsidian Models Tests")
struct ObsidianModelsTests {

    // MARK: - File Model Tests

    @Test("It should create File model correctly")
    func testFileModel() throws {
        // Given/When
        let file = File(filename: "test-note.md", content: "# Test\nContent")

        // Then
        #expect(
            file.filename == "test-note.md",
            "It should set the filename correctly"
        )
        #expect(
            file.content == "# Test\nContent",
            "It should set the content correctly"
        )
    }

    @Test("It should handle empty filename")
    func testEmptyFileName() throws {
        // Given/When
        let file = File(filename: "", content: "Content")

        // Then
        #expect(
            file.filename.isEmpty,
            "It should handle empty filename"
        )
        #expect(
            file.content == "Content",
            "It should preserve content with empty filename"
        )
    }

    @Test("It should handle empty content")
    func testEmptyContent() throws {
        // Given/When
        let file = File(filename: "empty.md", content: "")

        // Then
        #expect(
            file.filename == "empty.md",
            "It should preserve filename with empty content"
        )
        #expect(
            file.content.isEmpty,
            "It should handle empty content"
        )
    }

    @Test("It should handle special characters in filename")
    func testSpecialCharactersInFilename() throws {
        // Given/When
        let file = File(filename: "file with spaces & symbols!.md", content: "Content")

        // Then
        #expect(
            file.filename == "file with spaces & symbols!.md",
            "It should handle special characters in filename"
        )
        #expect(
            file.content == "Content",
            "It should preserve content with special filename"
        )
    }

    @Test("It should handle Unicode content")
    func testUnicodeContent() throws {
        // Given/When
        let file = File(
            filename: "unicode.md",
            content: "Unicode: 🎉 café naïve 中文"
        )

        // Then
        #expect(
            file.filename == "unicode.md",
            "It should handle Unicode filename correctly"
        )
        #expect(
            file.content == "Unicode: 🎉 café naïve 中文",
            "It should handle Unicode content correctly"
        )
    }

    @Test("It should handle very long content")
    func testLongContent() throws {
        // Given
        let longContent = String(repeating: "A", count: 10000)

        // When
        let file = File(filename: "long.md", content: longContent)

        // Then
        #expect(
            file.filename == "long.md",
            "It should handle filename with long content"
        )
        #expect(
            file.content.count == 10000,
            "It should handle very long content correctly"
        )
    }

    // MARK: - ServerInformation Model Tests

    @Test("It should create ServerInformation model correctly")
    func testServerInformationModel() throws {
        // Given/When
        let serverInfo = ServerInformation(service: "obsidian-api", version: "1.0.0")

        // Then
        #expect(
            serverInfo.service == "obsidian-api",
            "It should set the service name correctly"
        )
        #expect(
            serverInfo.version == "1.0.0",
            "It should set the version correctly"
        )
    }

    @Test("It should handle empty service name")
    func testEmptyServiceName() throws {
        // Given/When
        let serverInfo = ServerInformation(service: "", version: "1.0.0")

        // Then
        #expect(
            serverInfo.service.isEmpty,
            "It should handle empty service name"
        )
        #expect(
            serverInfo.version == "1.0.0",
            "It should preserve version with empty service"
        )
    }

    @Test("It should handle empty version")
    func testEmptyVersion() throws {
        // Given/When
        let serverInfo = ServerInformation(service: "obsidian-api", version: "")

        // Then
        #expect(
            serverInfo.service == "obsidian-api",
            "It should preserve service with empty version"
        )
        #expect(
            serverInfo.version.isEmpty,
            "It should handle empty version"
        )
    }

    // MARK: - SearchResult Model Tests

    @Test("It should create SearchResult model correctly")
    func testSearchResultModel() throws {
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
    func testZeroSearchScore() throws {
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
    func testMaxSearchScore() throws {
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
    func testNegativeSearchScore() throws {
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
    func testVeryHighSearchScore() throws {
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

    // MARK: - Edge Cases

    @Test("It should handle file with only whitespace content")
    func testWhitespaceContent() throws {
        // Given/When
        let file = File(filename: "whitespace.md", content: "   \n\t\r  ")

        // Then
        #expect(
            file.filename == "whitespace.md",
            "It should handle filename with whitespace content"
        )
        #expect(
            file.content == "   \n\t\r  ",
            "It should preserve whitespace content exactly"
        )
    }

    @Test("It should handle filename with path separators")
    func testFilenameWithPaths() throws {
        // Given/When
        let file = File(filename: "folder/subfolder/note.md", content: "Content")

        // Then
        #expect(
            file.filename == "folder/subfolder/note.md",
            "It should handle nested path filenames"
        )
        #expect(
            file.content == "Content",
            "It should preserve content with nested path filename"
        )
    }

    @Test("It should handle search path with directories")
    func testSearchPathWithDirectories() throws {
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

    // MARK: - RepositoryError Tests

    @Test("It should provide correct error description for operation failed")
    func testRepositoryErrorOperationFailed() throws {
        // Given
        let statusCode = 404
        let message = "Not Found"

        // When
        let error = RepositoryError.operationFailed(statusCode: statusCode, message: message)

        // Then
        #expect(
            error.errorDescription == "Repository operation failed (404): Not Found",
            "It should provide formatted error description with status code and message"
        )
    }

    @Test("It should provide correct error description for operation failed with different status code")
    func testRepositoryErrorOperationFailedDifferentStatusCode() throws {
        // Given
        let statusCode = 500
        let message = "Internal Server Error"

        // When
        let error = RepositoryError.operationFailed(statusCode: statusCode, message: message)

        // Then
        #expect(
            error.errorDescription == "Repository operation failed (500): Internal Server Error",
            "It should provide formatted error description with different status code"
        )
    }

    @Test("It should provide correct error description for invalid response")
    func testRepositoryErrorInvalidResponse() throws {
        // Given/When
        let error = RepositoryError.invalidResponse

        // Then
        #expect(
            error.errorDescription == "Invalid repository response",
            "It should provide error description for invalid response"
        )
    }
}
