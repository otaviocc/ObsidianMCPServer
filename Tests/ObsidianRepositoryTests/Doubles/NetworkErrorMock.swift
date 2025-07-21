import Foundation

enum NetworkErrorMock: Error, Equatable {
    case noMockResponse
    case networkFailure
    case serverError(Int)
    case timeout
    case unauthorized
    case notFound

    var localizedDescription: String {
        switch self {
        case .noMockResponse:
            return "Mock network client - no real network calls allowed"
        case .networkFailure:
            return "Simulated network failure"
        case .serverError(let code):
            return "Simulated server error with code \(code)"
        case .timeout:
            return "Simulated network timeout"
        case .unauthorized:
            return "Simulated unauthorized access"
        case .notFound:
            return "Simulated resource not found"
        }
    }
}
