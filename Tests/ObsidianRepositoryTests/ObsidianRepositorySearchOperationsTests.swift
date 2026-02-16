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

@Suite("ObsidianRepository Search Operations Tests")
struct ObsidianRepositorySearchOperationsTests {

    @Test("It should search vault and return mapped SearchResults")
    func searchVault() async throws {
        // Given
        let mockClient = NetworkClientMother.makeMockNetworkClient()
        let repository = ObsidianRepository(client: mockClient)
        let expectedResults = [
            ("note1.md", 0.95 as Float),
            ("note2.md", 0.87 as Float),
            ("folder/note3.md", 0.73 as Float)
        ]
        let stubbedResponse = try NetworkResponseMother.makeSearchResponse(
            results: expectedResults
        )
        mockClient.stubNetworkResponse(toReturn: stubbedResponse)

        // When
        let searchResults = try await repository.searchVault(
            query: "test search"
        )

        // Then
        #expect(
            mockClient.runCallCount == 1,
            "It should make the network call"
        )
        #expect(
            mockClient.lastRequestPath == "/search/simple/",
            "It should use the correct search path"
        )
        #expect(
            mockClient.lastRequestMethod == .post,
            "It should use POST method"
        )
        #expect(
            searchResults.count == 3,
            "It should return the correct number of results"
        )
        #expect(
            searchResults[0].path == "note1.md",
            "It should return the correct first result path"
        )
        #expect(
            searchResults[0].score == 0.95,
            "It should return the correct first result score"
        )
        #expect(
            searchResults[1].path == "note2.md",
            "It should return the correct second result path"
        )
        #expect(
            searchResults[1].score == 0.87,
            "It should return the correct second result score"
        )
        #expect(
            searchResults[2].path == "folder/note3.md",
            "It should return the correct third result path"
        )
        #expect(
            searchResults[2].score == 0.73,
            "It should return the correct third result score"
        )
    }
}
