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

@Suite("ObsidianRepository Vault Operations Tests")
struct ObsidianRepositoryVaultOperationsTests {

    @Test("It should list vault directory and return file paths")
    func listVaultDirectory() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let expectedFiles = ["note1.md", "note2.md", "note3.md"]
        let stubbedResponse = try NetworkResponseMother.makeDirectoryListingResponse(
            files: expectedFiles
        )
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        let files = try await repository.listVaultDirectory()

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/vault/",
            "It should use the correct vault directory path"
        )
        #expect(
            mockClient.lastRequestMethod == .get,
            "It should use GET method"
        )
        #expect(
            files == expectedFiles,
            "It should return the correct file paths"
        )
    }
}
