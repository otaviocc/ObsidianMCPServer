import Foundation

public struct SimpleSearchResponse: Decodable, Sendable {

    // MARK: - Properties

    public let filename: String
    public let score: Double
}
