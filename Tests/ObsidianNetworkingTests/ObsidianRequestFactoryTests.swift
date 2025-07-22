import Testing
import Foundation
import MicroClient
@testable import ObsidianNetworking

@Suite("ObsidianRequestFactory Tests")
struct ObsidianRequestFactoryTests {

    let factory = ObsidianRequestFactory()

    // MARK: - Server Info Tests

    @Test("It should create server info request")
    func testMakeServerInfoRequest() {
        // When
        let request = factory.makeServerInfoRequest()

        // Then
        #expect(
            request.path == "/",
            "It should use root path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    // MARK: - Active File Tests

    @Test("It should create get active file request")
    func testMakeGetActiveFileRequest() {
        // When
        let request = factory.makeGetActiveFileRequest()

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct Accept header"
        )
    }

    @Test("It should create get active file JSON request")
    func testMakeGetActiveFileJsonRequest() {
        // When
        let request = factory.makeGetActiveFileJsonRequest()

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct Accept header"
        )
    }

    @Test("It should create update active file request")
    func testMakeUpdateActiveFileRequest() {
        // Given
        let content = "# Updated Note Content\nThis is the new content."

        // When
        let request = factory.makeUpdateActiveFileRequest(content: content)

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .put,
            "It should use PUT method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown; charset=utf-8",
            "It should set correct Content-Type header"
        )
    }

    @Test("It should create delete active file request")
    func testMakeDeleteActiveFileRequest() {
        // When
        let request = factory.makeDeleteActiveFileRequest()

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should create set active frontmatter request with replace operation")
    func testMakeSetActiveFrontmatterRequestReplace() {
        // Given
        let content = "important"
        let operation = "replace"
        let key = "tags"

        // When
        let request = factory.makeSetActiveFrontmatterRequest(
            content: content,
            operation: operation,
            key: key
        )

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .patch
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "application/json",
            "It should set correct Content-Type"
        )
        #expect(
            request.additionalHeaders?["Operation"] == operation,
            "It should set operation header"
        )
        #expect(
            request.additionalHeaders?["Target-Type"] == "frontmatter",
            "It should set target type header"
        )
    }

    @Test("It should create set active frontmatter request with append operation")
    func testMakeSetActiveFrontmatterRequestAppend() {
        // Given
        let content = "project"
        let operation = "append"
        let key = "categories"

        // When
        let request = factory.makeSetActiveFrontmatterRequest(
            content: content,
            operation: operation,
            key: key
        )

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .patch
        )
        #expect(
            request.additionalHeaders?["Operation"] == operation,
            "It should set operation header"
        )
    }

    @Test("It should create set active frontmatter request with special characters")
    func testMakeSetActiveFrontmatterRequestWithSpecialCharacters() {
        // Given
        let content = "test value"
        let operation = "replace"
        let key = "field with spaces & symbols!"

        // When
        let request = factory.makeSetActiveFrontmatterRequest(
            content: content,
            operation: operation,
            key: key
        )

        // Then
        #expect(
            request.method == .patch
        )
        #expect(
            request.additionalHeaders?["Target"] != nil,
            "It should URL encode the target key"
        )
    }

    // MARK: - Vault File Tests

    @Test("It should create get vault file request")
    func testMakeGetVaultFileRequest() {
        // Given
        let filename = "notes/project.md"

        // When
        let request = factory.makeGetVaultFileRequest(filename: filename)

        // Then
        #expect(
            request.path == "/vault/notes/project.md",
            "It should use correct vault path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct Accept header"
        )
    }

    @Test("It should create or update vault file request")
    func testMakeCreateOrUpdateVaultFileRequest() {
        // Given
        let filename = "new-note.md"
        let content = "# New Note\n\nThis is a new note."

        // When
        let request = factory.makeCreateOrUpdateVaultFileRequest(
            filename: filename,
            content: content
        )

        // Then
        #expect(
            request.path == "/vault/new-note.md",
            "It should use correct vault path"
        )
        #expect(
            request.method == .put,
            "It should use PUT method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set correct Content-Type header"
        )
    }

    @Test("It should create append to vault file request")
    func testMakeAppendToVaultFileRequest() {
        // Given
        let filename = "existing-note.md"
        let content = "\n\n## Additional Section\n\nAppended content."

        // When
        let request = factory.makeAppendToVaultFileRequest(
            filename: filename,
            content: content
        )

        // Then
        #expect(
            request.path == "/vault/existing-note.md",
            "It should use correct vault path"
        )
        #expect(
            request.method == .post,
            "It should use POST method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set correct Content-Type header"
        )
    }

    @Test("It should create delete vault file request")
    func testMakeDeleteVaultFileRequest() {
        // Given
        let filename = "old/deprecated.md"

        // When
        let request = factory.makeDeleteVaultFileRequest(filename: filename)

        // Then
        #expect(
            request.path == "/vault/old/deprecated.md",
            "It should use correct vault path"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should handle empty filename for vault operations")
    func testMakeGetVaultFileRequestEmptyFilename() {
        // Given
        let filename = ""

        // When
        let request = factory.makeGetVaultFileRequest(filename: filename)

        // Then
        #expect(
            request.path == "/vault",
            "It should handle empty filename correctly"
        )
    }

    @Test("It should handle special characters in vault filename")
    func testMakeGetVaultFileRequestSpecialCharacters() {
        // Given
        let filename = "folder with spaces/file & name.md"

        // When
        let request = factory.makeGetVaultFileRequest(filename: filename)

        // Then
        #expect(
            request.path?.contains("folder with spaces") == true,
            "It should preserve spaces in path"
        )
    }

    @Test("It should create set vault frontmatter request")
    func testMakeSetVaultFrontmatterRequest() {
        // Given
        let filename = "note.md"
        let content = "completed"
        let operation = "replace"
        let key = "status"

        // When
        let request = factory.makeSetVaultFrontmatterRequest(
            filename: filename,
            content: content,
            operation: operation,
            key: key
        )

        // Then
        #expect(
            request.path == "/vault/note.md",
            "It should use correct vault path"
        )
        #expect(
            request.method == .patch
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "application/json",
            "It should set correct Content-Type"
        )
        #expect(
            request.additionalHeaders?["Operation"] == operation,
            "It should set operation header"
        )
        #expect(
            request.additionalHeaders?["Target-Type"] == "frontmatter",
            "It should set target type header"
        )
    }

    @Test("It should create append vault frontmatter request")
    func testMakeAppendVaultFrontmatterRequest() {
        // Given
        let filename = "research.md"
        let content = "literature-review"
        let operation = "append"
        let key = "tags"

        // When
        let request = factory.makeSetVaultFrontmatterRequest(
            filename: filename,
            content: content,
            operation: operation,
            key: key
        )

        // Then
        #expect(
            request.additionalHeaders?["Operation"] == "append",
            "It should set append operation"
        )
    }

    // MARK: - Directory Listing Tests

    @Test("It should create list vault directory request for root")
    func testMakeListVaultDirectoryRequestRoot() {
        // Given
        let directory = ""

        // When
        let request = factory.makeListVaultDirectoryRequest(directory: directory)

        // Then
        #expect(
            request.path == "/vault/",
            "It should use vault root path for empty directory"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create list vault directory request for subdirectory")
    func testMakeListVaultDirectoryRequestSubdirectory() {
        // Given
        let directory = "projects/obsidian"

        // When
        let request = factory.makeListVaultDirectoryRequest(directory: directory)

        // Then
        #expect(
            request.path == "/vault/projects/obsidian/",
            "It should use correct subdirectory path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    // MARK: - Search Tests

    @Test("It should create search vault request")
    func testMakeSearchVaultRequest() {
        // Given
        let query = "test query"

        // When
        let request = factory.makeSearchVaultRequest(
            query: query
        )

        // Then
        #expect(
            request.path == "/search/simple/",
            "It should use search path"
        )
        #expect(
            request.method == .post,
            "It should use POST method"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/json",
            "It should set correct Accept header"
        )
        #expect(
            request.queryItems.contains { $0.name == "query" && $0.value == query },
            "It should include query parameter"
        )
        #expect(
            request.queryItems.contains { $0.name == "contextLength" && $0.value == "100" },
            "It should include context length parameter"
        )
    }

    @Test("It should create search vault request with special characters")
    func testMakeSearchVaultRequestSpecialCharacters() {
        // Given
        let query = "regex.*pattern & test"

        // When
        let request = factory.makeSearchVaultRequest(
            query: query
        )

        // Then
        #expect(
            request.queryItems.contains { $0.name == "query" && $0.value == query },
            "It should handle special characters in query"
        )
    }

    // MARK: - URL Encoding Tests

    @Test("It should URL encode frontmatter target key")
    func testURLEncodeFrontmatterTarget() {
        // Given
        let key = "field with spaces & symbols!"

        // When
        let request = factory.makeSetActiveFrontmatterRequest(
            content: "value",
            operation: "replace",
            key: key
        )

        // Then
        #expect(
            request.additionalHeaders?["Target"]?.contains("%20") == true ||
            request.additionalHeaders?["Target"]?.contains("+") == true,
            "It should URL encode spaces in target key"
        )
    }
}
