import Testing
import Foundation
@testable import ObsidianMCPServer

@Suite("Obsidian Models Tests")
struct ObsidianModelsTests {

    // MARK: - File Model Tests

    @Test("It should create File model correctly")
    func testFileModel() throws {
        let file = File(filename: "test-note.md", content: "# Test\nContent")

        #expect(file.filename == "test-note.md")
        #expect(file.content == "# Test\nContent")
    }

    @Test("It should handle empty filename")
    func testEmptyFileName() throws {
        let file = File(filename: "", content: "Content")

        #expect(file.filename.isEmpty)
        #expect(file.content == "Content")
    }

    @Test("It should handle empty content")
    func testEmptyContent() throws {
        let file = File(filename: "empty.md", content: "")

        #expect(file.filename == "empty.md")
        #expect(file.content.isEmpty)
    }

    @Test("It should handle special characters in filename")
    func testSpecialCharactersInFilename() throws {
        let file = File(filename: "file with spaces & symbols!.md", content: "Content")

        #expect(file.filename == "file with spaces & symbols!.md")
        #expect(file.content == "Content")
    }

    @Test("It should handle Unicode content")
    func testUnicodeContent() throws {
        let file = File(
            filename: "unicode.md",
            content: "Unicode: 🎉 café naïve 中文"
        )

        #expect(file.filename == "unicode.md")
        #expect(file.content == "Unicode: 🎉 café naïve 中文")
    }

    @Test("It should handle very long content")
    func testLongContent() throws {
        let longContent = String(repeating: "A", count: 10000)
        let file = File(filename: "long.md", content: longContent)

        #expect(file.filename == "long.md")
        #expect(file.content.count == 10000)
    }

    // MARK: - ServerInformation Model Tests

    @Test("It should create ServerInformation model correctly")
    func testServerInformationModel() throws {
        let serverInfo = ServerInformation(service: "obsidian-api", version: "1.0.0")

        #expect(serverInfo.service == "obsidian-api")
        #expect(serverInfo.version == "1.0.0")
    }

    @Test("It should handle empty service name")
    func testEmptyServiceName() throws {
        let serverInfo = ServerInformation(service: "", version: "1.0.0")

        #expect(serverInfo.service.isEmpty)
        #expect(serverInfo.version == "1.0.0")
    }

    @Test("It should handle empty version")
    func testEmptyVersion() throws {
        let serverInfo = ServerInformation(service: "obsidian-api", version: "")

        #expect(serverInfo.service == "obsidian-api")
        #expect(serverInfo.version.isEmpty)
    }

    // MARK: - SearchResult Model Tests

    @Test("It should create SearchResult model correctly")
    func testSearchResultModel() throws {
        let searchResult = SearchResult(path: "notes/test.md", score: 0.85)

        #expect(searchResult.path == "notes/test.md")
        #expect(searchResult.score == 0.85)
    }

    @Test("It should handle zero search score")
    func testZeroSearchScore() throws {
        let searchResult = SearchResult(path: "low-relevance.md", score: 0.0)

        #expect(searchResult.path == "low-relevance.md")
        #expect(searchResult.score == 0.0)
    }

    @Test("It should handle maximum search score")
    func testMaxSearchScore() throws {
        let searchResult = SearchResult(path: "perfect-match.md", score: 1.0)

        #expect(searchResult.path == "perfect-match.md")
        #expect(searchResult.score == 1.0)
    }

    @Test("It should handle negative search score")
    func testNegativeSearchScore() throws {
        let searchResult = SearchResult(path: "negative.md", score: -0.5)

        #expect(searchResult.path == "negative.md")
        #expect(searchResult.score == -0.5)
    }

    @Test("It should handle very high search score")
    func testVeryHighSearchScore() throws {
        let searchResult = SearchResult(path: "high.md", score: 999.99)

        #expect(searchResult.path == "high.md")
        #expect(searchResult.score == 999.99)
    }

    // MARK: - PatchParameters Model Tests

    @Test("It should create PatchParameters with append operation")
    func testPatchParametersAppend() throws {
        let params = PatchParameters(
            operation: .append,
            targetType: .heading,
            target: "## New Section"
        )

        #expect(params.operation == .append)
        #expect(params.targetType == .heading)
        #expect(params.target == "## New Section")
    }

    @Test("It should create PatchParameters with replace operation")
    func testPatchParametersReplace() throws {
        let params = PatchParameters(
            operation: .replace,
            targetType: .block,
            target: "target-block-id"
        )

        #expect(params.operation == .replace)
        #expect(params.targetType == .block)
        #expect(params.target == "target-block-id")
    }

    @Test("It should create PatchParameters with prepend operation")
    func testPatchParametersPrepend() throws {
        let params = PatchParameters(
            operation: .prepend,
            targetType: .document,
            target: ""
        )

        #expect(params.operation == .prepend)
        #expect(params.targetType == .document)
        #expect(params.target.isEmpty)
    }

    @Test("It should handle all operation types")
    func testAllPatchOperations() throws {
        let appendParams = PatchParameters(operation: .append, targetType: .heading, target: "test")
        let prependParams = PatchParameters(operation: .prepend, targetType: .heading, target: "test")
        let replaceParams = PatchParameters(operation: .replace, targetType: .heading, target: "test")

        #expect(appendParams.operation == .append)
        #expect(prependParams.operation == .prepend)
        #expect(replaceParams.operation == .replace)
    }

    @Test("It should handle all target types")
    func testAllPatchTargetTypes() throws {
        let headingParams = PatchParameters(operation: .append, targetType: .heading, target: "test")
        let frontmatterParams = PatchParameters(operation: .append, targetType: .frontmatter, target: "test")
        let documentParams = PatchParameters(operation: .append, targetType: .document, target: "test")
        let blockParams = PatchParameters(operation: .append, targetType: .block, target: "test")
        let lineParams = PatchParameters(operation: .append, targetType: .line, target: "test")

        #expect(headingParams.targetType == .heading)
        #expect(frontmatterParams.targetType == .frontmatter)
        #expect(documentParams.targetType == .document)
        #expect(blockParams.targetType == .block)
        #expect(lineParams.targetType == .line)
    }

    @Test("It should handle empty target")
    func testEmptyTarget() throws {
        let params = PatchParameters(
            operation: .append,
            targetType: .document,
            target: ""
        )

        #expect(params.target.isEmpty)
    }

    @Test("It should handle complex target strings")
    func testComplexTarget() throws {
        let complexTarget = "## Complex Heading with Special Chars & Symbols! 🎉"
        let params = PatchParameters(
            operation: .replace,
            targetType: .heading,
            target: complexTarget
        )

        #expect(params.target == complexTarget)
    }

    // MARK: - Edge Cases

    @Test("It should handle file with only whitespace content")
    func testWhitespaceContent() throws {
        let file = File(filename: "whitespace.md", content: "   \n\t\r  ")

        #expect(file.filename == "whitespace.md")
        #expect(file.content == "   \n\t\r  ")
    }

    @Test("It should handle filename with path separators")
    func testFilenameWithPaths() throws {
        let file = File(filename: "folder/subfolder/note.md", content: "Content")

        #expect(file.filename == "folder/subfolder/note.md")
        #expect(file.content == "Content")
    }

    @Test("It should handle search path with directories")
    func testSearchPathWithDirectories() throws {
        let searchResult = SearchResult(path: "deep/nested/folders/note.md", score: 0.75)

        #expect(searchResult.path == "deep/nested/folders/note.md")
        #expect(searchResult.score == 0.75)
    }
}
