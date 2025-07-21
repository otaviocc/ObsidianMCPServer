import Foundation
import SwiftMCP

/**
 Represents a file with its filename and content.

 This schema encapsulates a file's metadata and content, providing a unified
 representation for file operations within the Obsidian MCP server.
 */
@Schema
public struct File: Encodable {

    /// The name of the file including its path
    public let filename: String

    /// The textual content of the file
    public let content: String

    public init(
        filename: String,
        content: String
    ) {
        self.filename = filename
        self.content = content
    }
}
