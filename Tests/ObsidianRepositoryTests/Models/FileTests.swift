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

import Testing
@testable import ObsidianRepository

@Suite("File Model Tests")
struct FileTests {

    @Test("It should create File model correctly")
    func fileModel() {
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
    func emptyFileName() {
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
    func emptyContent() {
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
    func specialCharactersInFilename() {
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
    func unicodeContent() {
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
    func longContent() {
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
    func whitespaceContent() {
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
    func filenameWithPaths() {
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
