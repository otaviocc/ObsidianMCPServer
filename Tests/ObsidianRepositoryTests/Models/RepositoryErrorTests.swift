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

@Suite("RepositoryError Tests")
struct RepositoryErrorTests {

    @Test("It should provide correct error description for operation failed")
    func repositoryErrorOperationFailed() {
        // Given
        let statusCode = 404
        let message = "Not Found"

        // When
        let error = RepositoryError.operationFailed(statusCode: statusCode, message: message)

        // Then
        #expect(
            error.errorDescription == "Repository operation failed (404): Not Found",
            "It should provide formatted error description with status code and message"
        )
    }

    @Test("It should provide correct error description for operation failed with different status code")
    func repositoryErrorOperationFailedDifferentStatusCode() {
        // Given
        let statusCode = 500
        let message = "Internal Server Error"

        // When
        let error = RepositoryError.operationFailed(statusCode: statusCode, message: message)

        // Then
        #expect(
            error.errorDescription == "Repository operation failed (500): Internal Server Error",
            "It should provide formatted error description with different status code"
        )
    }

    @Test("It should provide correct error description for invalid response")
    func repositoryErrorInvalidResponse() {
        // Given/When
        let error = RepositoryError.invalidResponse

        // Then
        #expect(
            error.errorDescription == "Invalid repository response",
            "It should provide error description for invalid response"
        )
    }
}
