import Foundation

/**
 Represents errors that can occur within the repository layer.
 */
enum RepositoryError: Error, LocalizedError {

    /// Indicates that a repository operation failed, providing the HTTP status code and an associated message.
    case operationFailed(statusCode: Int, message: String)
    /// Indicates that the repository received an invalid or unexpected response.
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case let .operationFailed(statusCode, message): "Repository operation failed (\(statusCode)): \(message)"
        case .invalidResponse: "Invalid repository response"
        }
    }
}
