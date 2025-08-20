import Testing

@testable import ObsidianRepository

@Suite
struct `ServerInformation Model Tests` {

    @Test
    func `It should create ServerInformation model correctly`() throws {
        // Given/When
        let serverInfo = ServerInformation(service: "obsidian-api", version: "1.0.0")

        // Then
        #expect(
            serverInfo.service == "obsidian-api",
            "It should set the service name correctly"
        )
        #expect(
            serverInfo.version == "1.0.0",
            "It should set the version correctly"
        )
    }

    @Test
    func `It should handle empty service name`() throws {
        // Given/When
        let serverInfo = ServerInformation(service: "", version: "1.0.0")

        // Then
        #expect(
            serverInfo.service.isEmpty,
            "It should handle empty service name"
        )
        #expect(
            serverInfo.version == "1.0.0",
            "It should preserve version with empty service"
        )
    }

    @Test
    func `It should handle empty version`() throws {
        // Given/When
        let serverInfo = ServerInformation(service: "obsidian-api", version: "")

        // Then
        #expect(
            serverInfo.service == "obsidian-api",
            "It should preserve service with empty version"
        )
        #expect(
            serverInfo.version.isEmpty,
            "It should handle empty version"
        )
    }
}
