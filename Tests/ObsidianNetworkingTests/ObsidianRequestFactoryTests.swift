import Testing
import Foundation
import MicroClient
@testable import ObsidianNetworking

// swiftlint:disable type_body_length file_length

@Suite("ObsidianRequestFactory Tests")
struct ObsidianRequestFactoryTests {

    let factory = ObsidianRequestFactory()
    let testHeaders = ["Authorization": "Bearer test-token", "Custom-Header": "test-value"]

    // MARK: - Server Info Tests

    @Test("It should create a server info request with correct configuration")
    func testMakeServerInfoRequest() {
        let request = factory.makeServerInfoRequest()

        #expect(
            request.path == "/",
            "It should use root path for server info"
        )
        #expect(
            request.method == .get,
            "It should use GET method for server info"
        )
        #expect(
            request.additionalHeaders?.isEmpty == true,
            "It should have no additional headers by default"
        )
        #expect(
            request.body == nil,
            "It should have no body for server info request"
        )
        #expect(
            request.queryItems.isEmpty == true,
            "It should have no query items for server info"
        )
    }

    // MARK: - Active File Tests

    @Test("It should create a get active file request with correct headers")
    func testMakeGetActiveFileRequest() {
        let request = factory.makeGetActiveFileRequest(headers: testHeaders)

        #expect(
            request.path == "/active/",
            "It should use active file path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct Accept header"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == nil,
            "It should have no body for GET request"
        )
    }

    @Test("It should create a get active file JSON request with correct headers")
    func testMakeGetActiveFileJsonRequest() {
        let request = factory.makeGetActiveFileJsonRequest(headers: testHeaders)

        #expect(
            request.path == "/active/",
            "It should use active file path for JSON request"
        )
        #expect(
            request.method == .get,
            "It should use GET method for JSON request"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct JSON Accept header"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == nil,
            "It should have no body for JSON GET request"
        )
    }

    @Test("It should create an update active file request with content and headers")
    func testMakeUpdateActiveFileRequest() {
        let content = "# Test Note\nThis is test content."
        let request = factory.makeUpdateActiveFileRequest(content: content, headers: testHeaders)

        #expect(
            request.path == "/active/",
            "It should use active file path for update"
        )
        #expect(
            request.method == .put,
            "It should use PUT method for update"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown; charset=utf-8",
            "It should set correct markdown Content-Type"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == content.data(using: .utf8),
            "It should include content as UTF-8 encoded body"
        )
    }

    @Test("It should create a delete active file request")
    func testMakeDeleteActiveFileRequest() {
        let request = factory.makeDeleteActiveFileRequest(headers: testHeaders)

        #expect(
            request.path == "/active/",
            "It should use active file path for delete"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == nil,
            "It should have no body for DELETE request"
        )
    }

    @Test("It should create a patch active file request with content and headers")
    func testMakePatchActiveFileRequest() {
        let content = "Additional content to patch"
        let request = factory.makePatchActiveFileRequest(content: content, headers: testHeaders)

        #expect(
            request.path == "/active/",
            "It should use active file path for patch"
        )
        #expect(
            request.method == .patch,
            "It should use PATCH method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown; charset=utf-8",
            "It should set correct markdown Content-Type"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == content.data(using: .utf8),
            "It should include content as body"
        )
    }

    // MARK: - Vault File Tests

    @Test("It should create a get vault file request with correct path")
    func testMakeGetVaultFileRequest() {
        let filename = "folder/test-note.md"
        let request = factory.makeGetVaultFileRequest(filename: filename, headers: testHeaders)

        #expect(
            request.path == "/vault/folder/test-note.md",
            "It should construct correct vault file path"
        )
        #expect(
            request.method == .get,
            "It should use GET method for vault file"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct Accept header"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == nil,
            "It should have no body for GET request"
        )
    }

    @Test("It should create a get vault file request with simple filename")
    func testMakeGetVaultFileRequestSimpleFilename() {
        let filename = "simple-note.md"
        let request = factory.makeGetVaultFileRequest(filename: filename, headers: testHeaders)

        #expect(
            request.path == "/vault/simple-note.md",
            "It should construct simple vault file path"
        )
        #expect(
            request.method == .get,
            "It should use GET method for simple filename"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct Accept header"
        )
    }

    @Test("It should create a create or update vault file request")
    func testMakeCreateOrUpdateVaultFileRequest() {
        let filename = "new-note.md"
        let content = "# New Note\nThis is new content."
        let request = factory.makeCreateOrUpdateVaultFileRequest(
            filename: filename,
            content: content,
            headers: testHeaders
        )

        #expect(
            request.path == "/vault/new-note.md",
            "It should construct correct vault file path for create/update"
        )
        #expect(
            request.method == .put,
            "It should use PUT method for create/update"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set markdown Content-Type"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == content.data(using: .utf8),
            "It should include content as UTF-8 body"
        )
    }

    @Test("It should handle empty content in create or update vault file request")
    func testMakeCreateOrUpdateVaultFileRequestEmptyContent() {
        let filename = "empty-note.md"
        let content = ""
        let request = factory.makeCreateOrUpdateVaultFileRequest(
            filename: filename,
            content: content,
            headers: testHeaders
        )

        #expect(
            request.path == "/vault/empty-note.md",
            "It should construct path with empty content"
        )
        #expect(
            request.method == .put,
            "It should use PUT method for empty content"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set markdown Content-Type for empty content"
        )
        #expect(
            request.body == Data(),
            "It should have empty Data body for empty content"
        )
    }

    @Test("It should create an append to vault file request")
    func testMakeAppendToVaultFileRequest() {
        let filename = "existing-note.md"
        let content = "\nAppended content"
        let request = factory.makeAppendToVaultFileRequest(filename: filename, content: content, headers: testHeaders)

        #expect(
            request.path == "/vault/existing-note.md",
            "It should construct correct vault file path for append"
        )
        #expect(
            request.method == .post,
            "It should use POST method for append"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set markdown Content-Type for append"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == content.data(using: .utf8),
            "It should include append content as body"
        )
    }

    @Test("It should create a delete vault file request")
    func testMakeDeleteVaultFileRequest() {
        let filename = "to-delete.md"
        let request = factory.makeDeleteVaultFileRequest(filename: filename, headers: testHeaders)

        #expect(
            request.path == "/vault/to-delete.md",
            "It should construct correct vault file path for delete"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method for vault file"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == nil,
            "It should have no body for DELETE request"
        )
    }

    @Test("It should create a patch vault file request")
    func testMakePatchVaultFileRequest() {
        let filename = "to-patch.md"
        let content = "Patch content"
        let request = factory.makePatchVaultFileRequest(filename: filename, content: content, headers: testHeaders)

        #expect(
            request.path == "/vault/to-patch.md",
            "It should construct correct vault file path for patch"
        )
        #expect(
            request.method == .patch,
            "It should use PATCH method for vault file"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set markdown Content-Type for patch"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == content.data(using: .utf8),
            "It should include patch content as body"
        )
    }

    // MARK: - Directory Listing Tests

    @Test("It should create a list vault directory request for root")
    func testMakeListVaultDirectoryRequestRoot() {
        let directory = ""
        let request = factory.makeListVaultDirectoryRequest(directory: directory, headers: testHeaders)

        #expect(
            request.path == "/vault/",
            "It should construct root vault directory path"
        )
        #expect(
            request.method == .get,
            "It should use GET method for directory listing"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == nil,
            "It should have no body for directory listing"
        )
    }

    @Test("It should create a list vault directory request for subdirectory")
    func testMakeListVaultDirectoryRequestSubdirectory() {
        let directory = "projects/notes"
        let request = factory.makeListVaultDirectoryRequest(directory: directory, headers: testHeaders)

        #expect(
            request.path == "/vault/projects/notes/",
            "It should construct subdirectory path with trailing slash"
        )
        #expect(
            request.method == .get,
            "It should use GET method for subdirectory listing"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == nil,
            "It should have no body for subdirectory listing"
        )
    }

    @Test("It should create a list vault directory request for simple directory")
    func testMakeListVaultDirectoryRequestSimple() {
        let directory = "templates"
        let request = factory.makeListVaultDirectoryRequest(directory: directory, headers: testHeaders)

        #expect(
            request.path == "/vault/templates/",
            "It should construct simple directory path"
        )
        #expect(
            request.method == .get,
            "It should use GET method for simple directory"
        )
    }

    // MARK: - Search Tests

    @Test("It should create a search vault request with all parameters")
    func testMakeSearchVaultRequest() {
        let query = "test query"
        let ignoreCase = true
        let wholeWord = false
        let isRegex = true
        let request = factory.makeSearchVaultRequest(
            query: query,
            ignoreCase: ignoreCase,
            wholeWord: wholeWord,
            isRegex: isRegex,
            headers: testHeaders
        )

        #expect(
            request.path == "/search/simple/",
            "It should use correct search path"
        )
        #expect(
            request.method == .post,
            "It should use POST method for search"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/json",
            "It should set JSON Accept header"
        )
        #expect(
            request.additionalHeaders?["Authorization"] == "Bearer test-token",
            "It should pass through Authorization header"
        )
        #expect(
            request.additionalHeaders?["Custom-Header"] == "test-value",
            "It should pass through custom headers"
        )
        #expect(
            request.body == nil,
            "It should have no body for search request"
        )

        let queryItems = request.queryItems
        #expect(
            queryItems.count == 2,
            "It should have correct number of query items"
        )
        #expect(
            queryItems.contains { $0.name == "query" && $0.value == query },
            "It should include query parameter"
        )
        #expect(
            queryItems.contains { $0.name == "contextLength" && $0.value == "100" },
            "It should include contextLength parameter"
        )
    }

    @Test("It should create a search vault request with special characters in query")
    func testMakeSearchVaultRequestSpecialCharacters() {
        let query = "test & query with spaces"
        let request = factory.makeSearchVaultRequest(
            query: query,
            ignoreCase: false,
            wholeWord: true,
            isRegex: false,
            headers: testHeaders
        )

        #expect(
            request.path == "/search/simple/",
            "It should use correct search path for special characters"
        )
        #expect(
            request.method == .post,
            "It should use POST method for special character search"
        )

        let queryItems = request.queryItems
        #expect(
            queryItems.contains { $0.name == "query" && $0.value == query },
            "It should include query with special characters"
        )
    }

    // MARK: - Edge Cases and Error Conditions

    @Test("It should handle empty headers gracefully")
    func testEmptyHeaders() {
        let emptyHeaders: [String: String] = [:]
        let request = factory.makeGetActiveFileRequest(headers: emptyHeaders)

        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set default Accept header even with empty input headers"
        )
        #expect(
            request.additionalHeaders?.count == 1,
            "It should only have the default Accept header"
        )
    }

    @Test("It should handle filenames with special characters")
    func testFilenamesWithSpecialCharacters() {
        let filename = "file with spaces & symbols!.md"
        let request = factory.makeGetVaultFileRequest(filename: filename, headers: testHeaders)

        #expect(
            request.path == "/vault/file with spaces & symbols!.md",
            "It should construct path with special characters in filename"
        )
        #expect(
            request.method == .get,
            "It should use GET method for special character filename"
        )
    }

    @Test("It should handle nested directory paths correctly")
    func testNestedDirectoryPaths() {
        let filename = "deep/nested/folder/structure/note.md"
        let request = factory.makeGetVaultFileRequest(filename: filename, headers: testHeaders)

        #expect(
            request.path == "/vault/deep/nested/folder/structure/note.md",
            "It should construct deeply nested path correctly"
        )
        #expect(
            request.method == .get,
            "It should use GET method for nested path"
        )
    }

    @Test("It should handle Unicode content correctly")
    func testUnicodeContent() {
        let content = "# Test 🎉\nUnicode content: café, naïve, 中文"
        let request = factory.makeUpdateActiveFileRequest(content: content, headers: testHeaders)

        #expect(
            request.body == content.data(using: .utf8),
            "It should include Unicode content as body"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown; charset=utf-8",
            "It should set UTF-8 Content-Type for Unicode content"
        )
    }
}

// swiftlint:enable type_body_length file_length
