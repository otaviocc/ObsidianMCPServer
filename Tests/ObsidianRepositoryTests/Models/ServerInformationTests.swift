import Testing

@testable import ObsidianRepository

@Suite("ServerInformation Model Tests")
struct ServerInformationTests {

    @Test("It should create ServerInformation model correctly")
    func testServerInformationModel() throws {
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

    @Test("It should handle empty service name")
    func testEmptyServiceName() throws {
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

    @Test("It should handle empty version")
    func testEmptyVersion() throws {
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
