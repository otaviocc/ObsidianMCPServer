import Foundation
import SwiftMCP

/**
 Represents a file with its filename and content.

 This schema encapsulates a file's metadata and content, providing a unified
 representation for file operations within the Obsidian MCP server.
 */
@Schema
struct File: Encodable {

    /// The name of the file including its path
    let filename: String

    /// The textual content of the file
    let content: String
}
