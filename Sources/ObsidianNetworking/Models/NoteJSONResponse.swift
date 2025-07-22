import AnyCodable
import Foundation

public struct NoteJSONResponse: Decodable {

    // MARK: - Nested types

    public struct FileStat: Decodable {
        public let ctime: Double
        public let mtime: Double
        public let size: Int
    }

    // MARK: - Properties

    public let content: String
    public let frontmatter: [String: AnyCodable]
    public let path: String
    public let stat: FileStat
    public let tags: [String]
}
