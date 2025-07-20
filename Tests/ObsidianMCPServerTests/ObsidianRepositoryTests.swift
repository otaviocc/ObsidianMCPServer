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
        let activeRequest = spyFactory.makeGetActiveFileRequest()
        let vaultRequest = spyFactory.makeGetVaultFileRequest(filename: "test.md")
        let searchRequest = spyFactory.makeSearchVaultRequest(
            query: "test",
            ignoreCase: true,
            wholeWord: false,
            isRegex: false
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

        _ = spyFactory.makeGetActiveFileRequest()
        #expect(
            spyFactory.activeFileCallCount == 1,
            "It should track active file request calls"
        )
        // Headers removed - no longer tracked

        _ = spyFactory.makeUpdateActiveFileRequest(content: "new content")
        #expect(
            spyFactory.updateActiveFileCallCount == 1,
            "It should track update active file request calls"
        )
        #expect(
            spyFactory.lastContent == "new content",
            "It should track content correctly"
        )
        // Headers removed - no longer tracked

        _ = spyFactory.makeGetVaultFileRequest(filename: "test.md")
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
            isRegex: false
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

    // MARK: - Repository Method Tests

    @Test("It should call request factory for getServerInfo")
    func testGetServerInfo() async throws {
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
                "It should throw a network error"
            )
        }

        // Then
        #expect(
            spyFactory.serverInfoCallCount == 1,
            "It should call server info request factory"
        )
        #expect(
            mockClient.lastRequestPath == "/spy-server-info",
            "It should use correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == "GET",
            "It should use GET method"
        )
    }

    @Test("It should call request factory for getActiveNote")
    func testGetActiveNote() async throws {
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
                "It should throw a network error"
            )
        }

        // Then
        #expect(
            spyFactory.activeFileCallCount == 1,
            "It should call active file request factory"
        )
        #expect(
            mockClient.lastRequestPath == "/spy-active",
            "It should use correct request path"
        )
        #expect(
            mockClient.lastRequestMethod == "GET",
            "It should use GET method"
        )
    }

    @Test("It should call request factory for updateActiveNote")
    func testUpdateActiveNote() async throws {
        // Given
        let mockClient = makeMockNetworkClient()
        let spyFactory = RequestFactorySpy()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)
        let testContent = "# Updated Content"

        // When/Then
        do {
            try await repository.updateActiveNote(content: testContent)
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error"
            )
        }

        // Then
        #expect(
            spyFactory.updateActiveFileCallCount == 1,
            "It should call update active file request factory"
        )
        #expect(
            spyFactory.lastContent == testContent,
            "It should pass the correct content"
        )
        #expect(
            mockClient.lastRequestMethod == "PUT",
            "It should use PUT method"
        )
    }

    @Test("It should call request factory for deleteActiveNote")
    func testDeleteActiveNote() async throws {
        // Given
        let mockClient = makeMockNetworkClient()
        let spyFactory = RequestFactorySpy()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        // When/Then
        do {
            try await repository.deleteActiveNote()
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error"
            )
        }

        // Then
        #expect(
            spyFactory.deleteActiveFileCallCount == 1,
            "It should call delete active file request factory"
        )
        #expect(
            mockClient.lastRequestMethod == "DELETE",
            "It should use DELETE method"
        )
    }

    @Test("It should call request factory for setActiveNoteFrontmatterField")
    func testSetActiveNoteFrontmatterField() async throws {
        // Given
        let mockClient = makeMockNetworkClient()
        let spyFactory = RequestFactorySpy()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        // When/Then
        do {
            try await repository.setActiveNoteFrontmatterField(key: "tags", value: "important")
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error"
            )
        }

        // Then
        #expect(
            spyFactory.frontmatterCallCount == 1,
            "It should call frontmatter request factory"
        )
        #expect(
            mockClient.lastRequestMethod == "PATCH",
            "It should use PATCH method"
        )
    }

    @Test("It should call request factory for getVaultNote")
    func testGetVaultNote() async throws {
        // Given
        let mockClient = makeMockNetworkClient()
        let spyFactory = RequestFactorySpy()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)
        let testFilename = "test-note.md"

        // When/Then
        do {
            _ = try await repository.getVaultNote(filename: testFilename)
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error"
            )
        }

        // Then
        #expect(
            spyFactory.vaultFileCallCount == 1,
            "It should call vault file request factory"
        )
        #expect(
            spyFactory.lastFilename == testFilename,
            "It should pass the correct filename"
        )
        #expect(
            mockClient.lastRequestPath == "/spy-vault/\(testFilename)",
            "It should use correct vault path"
        )
        #expect(
            mockClient.lastRequestMethod == "GET",
            "It should use GET method"
        )
    }

    @Test("It should call request factory for createOrUpdateVaultNote")
    func testCreateOrUpdateVaultNote() async throws {
        // Given
        let mockClient = makeMockNetworkClient()
        let spyFactory = RequestFactorySpy()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)
        let testFile = File(filename: "new-note.md", content: "# New Note")

        // When/Then
        do {
            try await repository.createOrUpdateVaultNote(file: testFile)
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error"
            )
        }

        // Then
        #expect(
            spyFactory.vaultFileCallCount == 1,
            "It should call vault file request factory"
        )
        #expect(
            mockClient.lastRequestMethod == "PUT",
            "It should use PUT method"
        )
    }

    @Test("It should call request factory for searchVault")
    func testSearchVault() async throws {
        // Given
        let mockClient = makeMockNetworkClient()
        let spyFactory = RequestFactorySpy()
        let repository = ObsidianRepository(client: mockClient, requestFactory: spyFactory)

        // When/Then
        do {
            _ = try await repository.searchVault(
                query: "test search",
                ignoreCase: true,
                wholeWord: false,
                isRegex: false
            )
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(
                error is NetworkErrorMock,
                "It should throw a network error"
            )
        }

        // Then
        #expect(
            spyFactory.searchVaultCallCount == 1,
            "It should call search vault request factory"
        )
        #expect(
            spyFactory.lastQuery == "test search",
            "It should pass the correct query"
        )
        #expect(
            mockClient.lastRequestPath == "/spy-search/",
            "It should use correct search path"
        )
        #expect(
            mockClient.lastRequestMethod == "POST",
            "It should use POST method"
        )
    }

    // MARK: - Business Logic Tests

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
