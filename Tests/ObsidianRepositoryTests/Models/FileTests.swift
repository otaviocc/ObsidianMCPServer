import Testing

@testable import ObsidianRepository

@Suite("File Model Tests")
struct FileTests {

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
}
