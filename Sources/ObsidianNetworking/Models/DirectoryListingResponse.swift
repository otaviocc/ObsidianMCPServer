import Foundation

public struct DirectoryListingResponse: Decodable, Sendable {

    // MARK: - Properties

    public let files: [String]
}
