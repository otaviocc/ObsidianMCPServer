import Foundation
import SwiftMCP

/**
 Represents server information from the Obsidian API.

 This schema encapsulates essential server details including the service name
 and version. Used to provide server identification and version information
 within the Obsidian MCP server.
 */
@Schema
struct ServerInformation: Encodable {

    /// The name of the service (e.g., "obsidian-local-rest-api")
    let service: String

    /// The version of the service
    let version: String
}
