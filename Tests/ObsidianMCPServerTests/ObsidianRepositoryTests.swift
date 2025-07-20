import Testing
import Foundation
import Combine
import MicroClient
import ObsidianNetworking
@testable import ObsidianMCPServer

@Suite("ObsidianRepository Tests")
struct ObsidianRepositoryTests {

    // MARK: - Test Helper

    private func makeMockNetworkClient() -> MockNetworkClient {
        let configuration = NetworkConfiguration(
            session: URLSession.shared,
            defaultDecoder: JSONDecoder(),
            defaultEncoder: JSONEncoder(),
            baseURL: URL(string: "https://test.com")! // swiftlint:disable:this force_unwrapping
        )

        return MockNetworkClient(configuration: configuration)
    }

    // MARK: - Initialization Tests

    @Test("It should initialize with default request factory")
    func testInitializationWithDefaults() throws {
        let mockClient = makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)

        #expect(repository != nil)
        #expect(mockClient.verifyNoNetworkCalls())
    }

    @Test("It should initialize with custom request factory")
    func testInitializationWithCustomFactory() throws {
        let mockClient = makeMockNetworkClient()
        let spyFactory = SpyRequestFactory()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        #expect(repository != nil)
        #expect(mockClient.verifyNoNetworkCalls())
    }

    // MARK: - Protocol Conformance Tests

    @Test("It should conform to ObsidianRepositoryProtocol")
    func testProtocolConformance() throws {
        let mockClient = makeMockNetworkClient()
        let repository: ObsidianRepositoryProtocol = ObsidianRepository(client: mockClient)

        #expect(repository is ObsidianRepository)
    }

    @Test("It should have all required protocol methods available")
    func testProtocolMethods() throws {
        let mockClient = makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)

        // Verify that repository conforms to all sub-protocols
        let serverOps: ObsidianRepositoryServerOperations? = repository
        let activeNoteOps: ObsidianRepositoryActiveNoteOperations? = repository
        let vaultNoteOps: ObsidianRepositoryVaultNoteOperations? = repository
        let vaultOps: ObsidianRepositoryVaultOperations? = repository
        let searchOps: ObsidianRepositorySearchOperations? = repository

        #expect(serverOps != nil)
        #expect(activeNoteOps != nil)
        #expect(vaultNoteOps != nil)
        #expect(vaultOps != nil)
        #expect(searchOps != nil)
    }

    // MARK: - Network Isolation Tests

    @Test("It should never make real network calls - server operations")
    func testNetworkIsolationServerOperations() async throws {
        let mockClient = makeMockNetworkClient()
        let spyFactory = SpyRequestFactory()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        do {
            _ = try await repository.getServerInfo()
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(error is MockNetworkError)
        }

        #expect(mockClient.verifyNetworkCallMade())
        #expect(spyFactory.serverInfoCallCount > 0)
        #expect(mockClient.lastRequestPath == "/spy-server-info")
    }

    @Test("It should never make real network calls - active note operations")
    func testNetworkIsolationActiveNoteOperations() async throws {
        let mockClient = makeMockNetworkClient()
        let spyFactory = SpyRequestFactory()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        do {
            _ = try await repository.getActiveNote()
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(error is MockNetworkError)
        }

        do {
            try await repository.updateActiveNote(content: "test content")
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(error is MockNetworkError)
        }

        do {
            try await repository.deleteActiveNote()
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(error is MockNetworkError)
        }

        #expect(mockClient.runCallCount >= 3)
        #expect(spyFactory.activeFileCallCount > 0)
        #expect(spyFactory.updateActiveFileCallCount > 0)
        #expect(spyFactory.deleteActiveFileCallCount > 0)
    }

    @Test("It should never make real network calls - search operations")
    func testNetworkIsolationSearchOperations() async throws {
        let mockClient = makeMockNetworkClient()
        let spyFactory = SpyRequestFactory()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        do {
            _ = try await repository.searchVault(
                query: "test",
                ignoreCase: true,
                wholeWord: false,
                isRegex: false
            )
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(error is MockNetworkError)
        }

        #expect(mockClient.verifyNetworkCallMade())
        #expect(spyFactory.searchVaultCallCount > 0)
        #expect(spyFactory.lastQuery == "test")
    }

    // MARK: - Request Factory Integration Tests

    @Test("It should create proper request paths")
    func testRequestPaths() throws {
        let spyFactory = SpyRequestFactory()

        let serverRequest = spyFactory.makeServerInfoRequest()
        #expect(serverRequest.path == "/spy-server-info")

        let activeRequest = spyFactory.makeGetActiveFileRequest(headers: [:])
        #expect(activeRequest.path == "/spy-active")

        let vaultRequest = spyFactory.makeGetVaultFileRequest(filename: "test.md", headers: [:])
        #expect(vaultRequest.path == "/spy-vault/test.md")

        let searchRequest = spyFactory.makeSearchVaultRequest(
            query: "test",
            ignoreCase: true,
            wholeWord: false,
            isRegex: false,
            headers: [:]
        )
        #expect(searchRequest.path == "/spy-search/")
    }

    @Test("It should track method calls correctly")
    func testMethodCallTracking() throws {
        let spyFactory = SpyRequestFactory()

        _ = spyFactory.makeServerInfoRequest()
        #expect(spyFactory.serverInfoCallCount == 1)

        _ = spyFactory.makeGetActiveFileRequest(headers: ["test": "value"])
        #expect(spyFactory.activeFileCallCount == 1)
        #expect(spyFactory.lastHeaders["test"] == "value")

        _ = spyFactory.makeUpdateActiveFileRequest(content: "new content", headers: ["auth": "token"])
        #expect(spyFactory.updateActiveFileCallCount == 1)
        #expect(spyFactory.lastContent == "new content")
        #expect(spyFactory.lastHeaders["auth"] == "token")

        _ = spyFactory.makeGetVaultFileRequest(filename: "test.md", headers: [:])
        #expect(spyFactory.vaultFileCallCount == 1)
        #expect(spyFactory.lastFilename == "test.md")

        _ = spyFactory.makeSearchVaultRequest(
            query: "search term",
            ignoreCase: true,
            wholeWord: false,
            isRegex: false,
            headers: [:]
        )
        #expect(spyFactory.searchVaultCallCount == 1)
        #expect(spyFactory.lastQuery == "search term")
    }

    // MARK: - Business Logic Tests

    @Test("It should handle PatchParameters correctly")
    func testPatchParametersHandling() throws {
        let appendParams = PatchParameters(
            operation: .append,
            targetType: .heading,
            target: "## New Section"
        )

        let prependParams = PatchParameters(
            operation: .prepend,
            targetType: .frontmatter,
            target: "tags: [test]"
        )

        let replaceParams = PatchParameters(
            operation: .replace,
            targetType: .document,
            target: "New content"
        )

        #expect(appendParams.operation == .append)
        #expect(appendParams.targetType == .heading)
        #expect(prependParams.operation == .prepend)
        #expect(prependParams.targetType == .frontmatter)
        #expect(replaceParams.operation == .replace)
        #expect(replaceParams.targetType == .document)
    }

    @Test("It should handle File objects correctly")
    func testFileHandling() throws {
        let file1 = File(filename: "note.md", content: "# Test")
        let file2 = File(filename: "folder/note.md", content: "# Nested")
        let file3 = File(filename: "unicode-🎉.md", content: "Unicode content: café")

        #expect(file1.filename == "note.md")
        #expect(file1.content == "# Test")
        #expect(file2.filename == "folder/note.md")
        #expect(file3.content.contains("café"))
    }

    @Test("It should handle ServerInformation correctly")
    func testServerInformationHandling() throws {
        let serverInfo1 = ServerInformation(service: "obsidian-local-rest-api", version: "1.1.0")
        let serverInfo2 = ServerInformation(service: "test-service", version: "2.0.0")

        #expect(serverInfo1.service == "obsidian-local-rest-api")
        #expect(serverInfo1.version == "1.1.0")
        #expect(serverInfo2.service == "test-service")
        #expect(serverInfo2.version == "2.0.0")
    }

    @Test("It should handle SearchResult correctly")
    func testSearchResultHandling() throws {
        let result1 = SearchResult(path: "notes/important.md", score: 0.95)
        let result2 = SearchResult(path: "drafts/idea.md", score: 0.3)
        let result3 = SearchResult(path: "archive/old.md", score: 0.0)

        #expect(result1.score > result2.score)
        #expect(result2.score > result3.score)
        #expect(result1.path.contains("important"))
        #expect(result3.score == 0.0)
    }
}
