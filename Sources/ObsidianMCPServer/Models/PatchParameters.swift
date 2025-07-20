import Foundation
import SwiftMCP

/**
 Represents configuration for patch operations on Obsidian notes.

 This schema encapsulates the necessary parameters to perform patch operations
 on Obsidian vault files, including the type of operation, target type, and
 specific target to modify. Used to structure patch requests within the
 Obsidian MCP server.
 */
@Schema
struct PatchParameters: Sendable, Codable {

    /**
     Defines the type of patch operation to perform on Obsidian notes.

     This enum specifies how content should be modified when applying patch
     operations to vault files within the Obsidian MCP server.
     */
    enum PatchOperation: String, Sendable, Codable {
        /// Add content to the end of the target
        case append

        /// Add content to the beginning of the target
        case prepend

        /// Replace the entire target with new content
        case replace
    }

    /**
     Defines the type of target element for patch operations.

     This enum specifies what part of an Obsidian note should be targeted
     when performing patch operations within the Obsidian MCP server.
     */
    enum TargetType: String, Sendable, Codable {
        /// Target a specific heading in the note
        case heading

        /// Target the frontmatter section of the note
        case frontmatter

        /// Target the entire document
        case document

        /// Target a specific block of content
        case block

        /// Target a specific line in the note
        case line
    }

    /// The type of patch operation to perform (append, prepend, or replace)
    let operation: PatchOperation

    /// The type of target to modify (heading, frontmatter, document, block, or line)
    let targetType: TargetType

    /// The specific target identifier for the operation
    let target: String
}
