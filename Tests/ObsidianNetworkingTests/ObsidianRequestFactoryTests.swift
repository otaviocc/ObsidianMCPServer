import Testing
import Foundation
import MicroClient
@testable import ObsidianNetworking

@Suite("ObsidianRequestFactory Tests")
struct ObsidianRequestFactoryTests {

    let factory = ObsidianRequestFactory()
    let testHeaders = ["Authorization": "Bearer test-token", "Custom-Header": "test-value"]

    // MARK: - Server Info Tests

    @Test("It should create a server info request with correct configuration")
    func testMakeServerInfoRequest() {
        let request = factory.makeServerInfoRequest()

        #expect(request.path == "/")
        #expect(request.method == .get)
        #expect(request.additionalHeaders?.isEmpty == true)
        #expect(request.body == nil)
        #expect(request.queryItems.isEmpty == true)
    }

    // MARK: - Active File Tests

    @Test("It should create a get active file request with correct headers")
    func testMakeGetActiveFileRequest() {
        let request = factory.makeGetActiveFileRequest(headers: testHeaders)

        #expect(request.path == "/active/")
        #expect(request.method == .get)
        #expect(request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json")
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == nil)
    }

    @Test("It should create a get active file JSON request with correct headers")
    func testMakeGetActiveFileJsonRequest() {
        let request = factory.makeGetActiveFileJsonRequest(headers: testHeaders)

        #expect(request.path == "/active/")
        #expect(request.method == .get)
        #expect(request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json")
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == nil)
    }

    @Test("It should create an update active file request with content and headers")
    func testMakeUpdateActiveFileRequest() {
        let content = "# Test Note\nThis is test content."
        let request = factory.makeUpdateActiveFileRequest(content: content, headers: testHeaders)

        #expect(request.path == "/active/")
        #expect(request.method == .put)
        #expect(request.additionalHeaders?["Content-Type"] == "text/markdown; charset=utf-8")
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == content.data(using: .utf8))
    }

    @Test("It should create a delete active file request")
    func testMakeDeleteActiveFileRequest() {
        let request = factory.makeDeleteActiveFileRequest(headers: testHeaders)

        #expect(request.path == "/active/")
        #expect(request.method == .delete)
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == nil)
    }

    @Test("It should create a patch active file request with content and headers")
    func testMakePatchActiveFileRequest() {
        let content = "Additional content to patch"
        let request = factory.makePatchActiveFileRequest(content: content, headers: testHeaders)

        #expect(request.path == "/active/")
        #expect(request.method == .patch)
        #expect(request.additionalHeaders?["Content-Type"] == "text/markdown; charset=utf-8")
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == content.data(using: .utf8))
    }

    // MARK: - Vault File Tests

    @Test("It should create a get vault file request with correct path")
    func testMakeGetVaultFileRequest() {
        let filename = "folder/test-note.md"
        let request = factory.makeGetVaultFileRequest(filename: filename, headers: testHeaders)

        #expect(request.path == "/vault/folder/test-note.md")
        #expect(request.method == .get)
        #expect(request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json")
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == nil)
    }

    @Test("It should create a get vault file request with simple filename")
    func testMakeGetVaultFileRequestSimpleFilename() {
        let filename = "simple-note.md"
        let request = factory.makeGetVaultFileRequest(filename: filename, headers: testHeaders)

        #expect(request.path == "/vault/simple-note.md")
        #expect(request.method == .get)
        #expect(request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json")
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

        #expect(request.path == "/vault/new-note.md")
        #expect(request.method == .put)
        #expect(request.additionalHeaders?["Content-Type"] == "text/markdown")
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == content.data(using: .utf8))
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

        #expect(request.path == "/vault/empty-note.md")
        #expect(request.method == .put)
        #expect(request.additionalHeaders?["Content-Type"] == "text/markdown")
        #expect(request.body == Data())
    }

    @Test("It should create an append to vault file request")
    func testMakeAppendToVaultFileRequest() {
        let filename = "existing-note.md"
        let content = "\nAppended content"
        let request = factory.makeAppendToVaultFileRequest(filename: filename, content: content, headers: testHeaders)

        #expect(request.path == "/vault/existing-note.md")
        #expect(request.method == .post)
        #expect(request.additionalHeaders?["Content-Type"] == "text/markdown")
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == content.data(using: .utf8))
    }

    @Test("It should create a delete vault file request")
    func testMakeDeleteVaultFileRequest() {
        let filename = "to-delete.md"
        let request = factory.makeDeleteVaultFileRequest(filename: filename, headers: testHeaders)

        #expect(request.path == "/vault/to-delete.md")
        #expect(request.method == .delete)
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == nil)
    }

    @Test("It should create a patch vault file request")
    func testMakePatchVaultFileRequest() {
        let filename = "to-patch.md"
        let content = "Patch content"
        let request = factory.makePatchVaultFileRequest(filename: filename, content: content, headers: testHeaders)

        #expect(request.path == "/vault/to-patch.md")
        #expect(request.method == .patch)
        #expect(request.additionalHeaders?["Content-Type"] == "text/markdown")
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == content.data(using: .utf8))
    }

    // MARK: - Directory Listing Tests

    @Test("It should create a list vault directory request for root")
    func testMakeListVaultDirectoryRequestRoot() {
        let directory = ""
        let request = factory.makeListVaultDirectoryRequest(directory: directory, headers: testHeaders)

        #expect(request.path == "/vault/")
        #expect(request.method == .get)
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == nil)
    }

    @Test("It should create a list vault directory request for subdirectory")
    func testMakeListVaultDirectoryRequestSubdirectory() {
        let directory = "projects/notes"
        let request = factory.makeListVaultDirectoryRequest(directory: directory, headers: testHeaders)

        #expect(request.path == "/vault/projects/notes/")
        #expect(request.method == .get)
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == nil)
    }

    @Test("It should create a list vault directory request for simple directory")
    func testMakeListVaultDirectoryRequestSimple() {
        let directory = "templates"
        let request = factory.makeListVaultDirectoryRequest(directory: directory, headers: testHeaders)

        #expect(request.path == "/vault/templates/")
        #expect(request.method == .get)
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

        #expect(request.path == "/search/simple/")
        #expect(request.method == .post)
        #expect(request.additionalHeaders?["Accept"] == "application/json")
        #expect(request.additionalHeaders?["Authorization"] == "Bearer test-token")
        #expect(request.additionalHeaders?["Custom-Header"] == "test-value")
        #expect(request.body == nil)

        let queryItems = request.queryItems
        #expect(queryItems.count == 2)
        #expect(queryItems.contains { $0.name == "query" && $0.value == query })
        #expect(queryItems.contains { $0.name == "contextLength" && $0.value == "100" })
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

        #expect(request.path == "/search/simple/")
        #expect(request.method == .post)

        let queryItems = request.queryItems
        #expect(queryItems.contains { $0.name == "query" && $0.value == query })
    }

    // MARK: - Edge Cases and Error Conditions

    @Test("It should handle empty headers gracefully")
    func testEmptyHeaders() {
        let emptyHeaders: [String: String] = [:]
        let request = factory.makeGetActiveFileRequest(headers: emptyHeaders)

        #expect(request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json")
        #expect(request.additionalHeaders?.count == 1)
    }

    @Test("It should handle filenames with special characters")
    func testFilenamesWithSpecialCharacters() {
        let filename = "file with spaces & symbols!.md"
        let request = factory.makeGetVaultFileRequest(filename: filename, headers: testHeaders)

        #expect(request.path == "/vault/file with spaces & symbols!.md")
        #expect(request.method == .get)
    }

    @Test("It should handle nested directory paths correctly")
    func testNestedDirectoryPaths() {
        let filename = "deep/nested/folder/structure/note.md"
        let request = factory.makeGetVaultFileRequest(filename: filename, headers: testHeaders)

        #expect(request.path == "/vault/deep/nested/folder/structure/note.md")
        #expect(request.method == .get)
    }

    @Test("It should handle Unicode content correctly")
    func testUnicodeContent() {
        let content = "# Test 🎉\nUnicode content: café, naïve, 中文"
        let request = factory.makeUpdateActiveFileRequest(content: content, headers: testHeaders)

        #expect(request.body == content.data(using: .utf8))
        #expect(request.additionalHeaders?["Content-Type"] == "text/markdown; charset=utf-8")
    }
}
