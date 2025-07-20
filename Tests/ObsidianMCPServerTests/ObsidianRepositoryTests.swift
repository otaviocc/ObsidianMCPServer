import Testing
import Foundation
import Combine
import MicroClient
import ObsidianNetworking
@testable import ObsidianMCPServer

// swiftlint:disable type_body_length file_length

@Suite("ObsidianRepository Tests")
struct ObsidianRepositoryTests {

    // MARK: - Test Helper

    private func makeMockNetworkClient() -> NetworkClientMock {
        let configuration = NetworkConfiguration(
            session: URLSession.shared,
            defaultDecoder: JSONDecoder(),
            defaultEncoder: JSONEncoder(),
            baseURL: URL(string: "https://test.com")! // swiftlint:disable:this force_unwrapping
        )

        return NetworkClientMock(configuration: configuration)
    }

    // MARK: - Initialization Tests

    @Test("It should initialize with default request factory")
    func testInitializationWithDefaults() throws {
        // Given
        let mockClient = makeMockNetworkClient()

        // When
        let repository = ObsidianRepository(client: mockClient)

        // Then
        #expect(
            repository != nil,
            "It should create a repository instance"
        )
        #expect(
            mockClient.verifyNoNetworkCalls(),
            "It should not make any network calls during initialization"
        )
    }

    @Test("It should initialize with custom request factory")
    func testInitializationWithCustomFactory() throws {
        // Given
        let mockClient = makeMockNetworkClient()
        let spyFactory = RequestFactorySpy()

        // When
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        // Then
        #expect(
            repository != nil,
            "It should create a repository instance with custom factory"
        )
        #expect(
            mockClient.verifyNoNetworkCalls(),
            "It should not make any network calls during initialization"
        )
    }

    // MARK: - Protocol Conformance Tests

    @Test("It should conform to ObsidianRepositoryProtocol")
    func testProtocolConformance() throws {
        // Given
        let mockClient = makeMockNetworkClient()

        // When
        let repository: ObsidianRepositoryProtocol = ObsidianRepository(client: mockClient)

        // Then
        #expect(
            repository is ObsidianRepository,
            "It should conform to the protocol"
        )
    }

    @Test("It should have all required protocol methods available")
    func testProtocolMethods() throws {
        // Given
        let mockClient = makeMockNetworkClient()

        // When
        let repository = ObsidianRepository(client: mockClient)

        // Verify that repository conforms to all sub-protocols
        let serverOps: ObsidianRepositoryServerOperations? = repository
        let activeNoteOps: ObsidianRepositoryActiveNoteOperations? = repository
        let vaultNoteOps: ObsidianRepositoryVaultNoteOperations? = repository
        let vaultOps: ObsidianRepositoryVaultOperations? = repository
        let searchOps: ObsidianRepositorySearchOperations? = repository

        // Then
        #expect(
            serverOps != nil,
            "It should conform to server operations protocol"
        )
        #expect(
            activeNoteOps != nil,
            "It should conform to active note operations protocol"
        )
        #expect(
            vaultNoteOps != nil,
            "It should conform to vault note operations protocol"
        )
        #expect(
            vaultOps != nil,
            "It should conform to vault operations protocol"
        )
        #expect(
            searchOps != nil,
            "It should conform to search operations protocol"
        )
    }

    // MARK: - Network Isolation Tests

    @Test("It should never make real network calls - server operations")
    func testNetworkIsolationServerOperations() async throws {
        // Given
        let mockClient = makeMockNetworkClient()
        let spyFactory = RequestFactorySpy()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        // When/Then
        do {
            _ = try await repository.getServerInfo()
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error mock"
            )
        }

        // Then
        #expect(
            mockClient.verifyNetworkCallMade(),
            "It should make a network call"
        )
        #expect(
            spyFactory.serverInfoCallCount > 0,
            "It should call the request factory for server info"
        )
        #expect(
            mockClient.lastRequestPath == "/spy-server-info",
            "It should use the correct request path"
        )
    }

    @Test("It should never make real network calls - active note operations")
    func testNetworkIsolationActiveNoteOperations() async throws {
        // Given
        let mockClient = makeMockNetworkClient()
        let spyFactory = RequestFactorySpy()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        // When/Then
        do {
            _ = try await repository.getActiveNote()
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error mock for get active note"
            )
        }

        do {
            try await repository.updateActiveNote(content: "test content")
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error mock for update active note"
            )
        }

        do {
            try await repository.deleteActiveNote()
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error mock for delete active note"
            )
        }

        // Then
        #expect(
            mockClient.runCallCount >= 3,
            "It should make at least three network calls"
        )
        #expect(
            spyFactory.activeFileCallCount > 0,
            "It should call active file request factory method"
        )
        #expect(
            spyFactory.updateActiveFileCallCount > 0,
            "It should call update active file request factory method"
        )
        #expect(
            spyFactory.deleteActiveFileCallCount > 0,
            "It should call delete active file request factory method"
        )
    }

    @Test("It should never make real network calls - search operations")
    func testNetworkIsolationSearchOperations() async throws {
        // Given
        let mockClient = makeMockNetworkClient()
        let spyFactory = RequestFactorySpy()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        // When/Then
        do {
            _ = try await repository.searchVault(
                query: "test",
                ignoreCase: true,
                wholeWord: false,
                isRegex: false
            )
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error mock for search vault"
            )
        }

        // Then
        #expect(
            mockClient.verifyNetworkCallMade(),
            "It should make a network call"
        )
        #expect(
            spyFactory.searchVaultCallCount > 0,
            "It should call the search vault request factory method"
        )
        #expect(
            spyFactory.lastQuery == "test",
            "It should pass the correct query to the factory"
        )
    }

    // MARK: - Request Factory Integration Tests

    @Test("It should create proper request paths")
    func testRequestPaths() throws {
        // Given
        let spyFactory = RequestFactorySpy()

        // When
        let serverRequest = spyFactory.makeServerInfoRequest()
        let activeRequest = spyFactory.makeGetActiveFileRequest(headers: [:])
        let vaultRequest = spyFactory.makeGetVaultFileRequest(filename: "test.md", headers: [:])
        let searchRequest = spyFactory.makeSearchVaultRequest(
            query: "test",
            ignoreCase: true,
            wholeWord: false,
            isRegex: false,
            headers: [:]
        )

        // Then
        #expect(
            serverRequest.path == "/spy-server-info",
            "It should create correct server info request path"
        )
        #expect(
            activeRequest.path == "/spy-active",
            "It should create correct active file request path"
        )
        #expect(
            vaultRequest.path == "/spy-vault/test.md",
            "It should create correct vault file request path"
        )
        #expect(
            searchRequest.path == "/spy-search/",
            "It should create correct search vault request path"
        )
    }

    // swiftlint:disable function_body_length

    @Test("It should track method calls correctly")
    func testMethodCallTracking() throws {
        // Given
        let spyFactory = RequestFactorySpy()

        // When/Then - Test each method call individually since spy tracks last values
        _ = spyFactory.makeServerInfoRequest()
        #expect(
            spyFactory.serverInfoCallCount == 1,
            "It should track server info request calls"
        )

        _ = spyFactory.makeGetActiveFileRequest(headers: ["test": "value"])
        #expect(
            spyFactory.activeFileCallCount == 1,
            "It should track active file request calls"
        )
        #expect(
            spyFactory.lastHeaders["test"] == "value",
            "It should track headers correctly"
        )

        _ = spyFactory.makeUpdateActiveFileRequest(content: "new content", headers: ["auth": "token"])
        #expect(
            spyFactory.updateActiveFileCallCount == 1,
            "It should track update active file request calls"
        )
        #expect(
            spyFactory.lastContent == "new content",
            "It should track content correctly"
        )
        #expect(
            spyFactory.lastHeaders["auth"] == "token",
            "It should track auth headers correctly"
        )

        _ = spyFactory.makeGetVaultFileRequest(filename: "test.md", headers: [:])
        #expect(
            spyFactory.vaultFileCallCount == 1,
            "It should track vault file request calls"
        )
        #expect(
            spyFactory.lastFilename == "test.md",
            "It should track filename correctly"
        )

        _ = spyFactory.makeSearchVaultRequest(
            query: "search term",
            ignoreCase: true,
            wholeWord: false,
            isRegex: false,
            headers: [:]
        )
        #expect(
            spyFactory.searchVaultCallCount == 1,
            "It should track search vault request calls"
        )
        #expect(
            spyFactory.lastQuery == "search term",
            "It should track search query correctly"
        )
    }

    // swiftlint:enable function_body_length

    // MARK: - Business Logic Tests

    @Test("It should handle PatchParameters correctly")
    func testPatchParametersHandling() throws {
        // Given/When
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

        // Then
        #expect(
            appendParams.operation == .append,
            "It should set append operation correctly"
        )
        #expect(
            appendParams.targetType == .heading,
            "It should set heading target type correctly"
        )
        #expect(
            prependParams.operation == .prepend,
            "It should set prepend operation correctly"
        )
        #expect(
            prependParams.targetType == .frontmatter,
            "It should set frontmatter target type correctly"
        )
        #expect(
            replaceParams.operation == .replace,
            "It should set replace operation correctly"
        )
        #expect(
            replaceParams.targetType == .document,
            "It should set document target type correctly"
        )
    }

    @Test("It should handle File objects correctly")
    func testFileHandling() throws {
        // Given/When
        let file1 = File(filename: "note.md", content: "# Test")
        let file2 = File(filename: "folder/note.md", content: "# Nested")
        let file3 = File(filename: "unicode-🎉.md", content: "Unicode content: café")

        // Then
        #expect(
            file1.filename == "note.md",
            "It should handle simple filename correctly"
        )
        #expect(
            file1.content == "# Test",
            "It should handle simple content correctly"
        )
        #expect(
            file2.filename == "folder/note.md",
            "It should handle nested path filename correctly"
        )
        #expect(
            file3.content.contains("café"),
            "It should handle Unicode content correctly"
        )
    }

    @Test("It should handle ServerInformation correctly")
    func testServerInformationHandling() throws {
        // Given/When
        let serverInfo1 = ServerInformation(service: "obsidian-local-rest-api", version: "1.1.0")
        let serverInfo2 = ServerInformation(service: "test-service", version: "2.0.0")

        // Then
        #expect(
            serverInfo1.service == "obsidian-local-rest-api",
            "It should handle obsidian service name correctly"
        )
        #expect(
            serverInfo1.version == "1.1.0",
            "It should handle version string correctly"
        )
        #expect(
            serverInfo2.service == "test-service",
            "It should handle test service name correctly"
        )
        #expect(
            serverInfo2.version == "2.0.0",
            "It should handle different version string correctly"
        )
    }

    @Test("It should handle SearchResult correctly")
    func testSearchResultHandling() throws {
        // Given/When
        let result1 = SearchResult(path: "notes/important.md", score: 0.95)
        let result2 = SearchResult(path: "drafts/idea.md", score: 0.3)
        let result3 = SearchResult(path: "archive/old.md", score: 0.0)

        // Then
        #expect(
            result1.score > result2.score,
            "It should handle score comparison correctly"
        )
        #expect(
            result2.score > result3.score,
            "It should handle different score values correctly"
        )
        #expect(
            result1.path.contains("important"),
            "It should handle path content correctly"
        )
        #expect(
            result3.score == 0.0,
            "It should handle zero score correctly"
        )
    }
}

// swiftlint:enable type_body_length file_length
