import Foundation

enum NetworkErrorMock: Error, Equatable {
    case noMockResponse
    case networkFailure
    case serverError(Int)
    case timeout
    case unauthorized
    case notFound
}
