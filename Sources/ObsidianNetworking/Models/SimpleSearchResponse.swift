import Foundation

public struct SimpleSearchResponse: Decodable {

    // MARK: - Properties

    public let filename: String
    public let score: Double
}
