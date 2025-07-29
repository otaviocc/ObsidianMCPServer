import Testing

@testable import ObsidianRepository

@Suite("RepositoryError Tests")
struct RepositoryErrorTests {

    @Test("It should provide correct error description for operation failed")
    func repositoryErrorOperationFailed() throws {
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
    func repositoryErrorOperationFailedDifferentStatusCode() throws {
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
    func repositoryErrorInvalidResponse() throws {
        // Given/When
        let error = RepositoryError.invalidResponse

        // Then
        #expect(
            error.errorDescription == "Invalid repository response",
            "It should provide error description for invalid response"
        )
    }
}
