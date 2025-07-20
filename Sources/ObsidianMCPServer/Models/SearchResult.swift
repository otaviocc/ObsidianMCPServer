import Foundation
import SwiftMCP

/**
 Represents a search result item from vault search operations.

 This schema encapsulates a single search result, containing the file path
 and its relevance score. Used to return structured search results from
 vault search operations within the Obsidian MCP server.
 */
@Schema
struct SearchResult: Encodable {

    /// The file path of the search result
    let path: String

    /// The relevance score of the search result (higher values indicate better matches)
    let score: Double
}
