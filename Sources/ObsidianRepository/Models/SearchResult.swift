import Foundation
import SwiftMCP

/**
 Represents a search result item from vault search operations.

 This schema encapsulates a single search result, containing the file path
 and its relevance score. Used to return structured search results from
 vault search operations within the Obsidian MCP server.
 */
@Schema
public struct SearchResult: Encodable {

    /// The file path of the search result
    public let path: String

    /// The relevance score of the search result (higher values indicate better matches)
    public let score: Double

    public init(
        path: String,
        score: Double
    ) {
        self.path = path
        self.score = score
    }
}
