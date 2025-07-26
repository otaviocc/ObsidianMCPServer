import Foundation
import ObsidianModels
import Testing

@testable import ObsidianResource

@Suite("ObsidianResource Tests")
struct ObsidianResourceTests {

    // MARK: - Helper Methods

    private func makeResource() -> ObsidianResource {
        ObsidianResource()
    }

    // MARK: - Tests

    @Test("It should list all enum types with resource URIs")
    func testListEnumTypes() async throws {
        // Given
        let resource = makeResource()

        // When
        let result = try await resource.listEnumTypes()

        // Then
        #expect(
            result.contains("Language"),
            "It should include Language enum"
        )
        #expect(
            result.contains("WritingStyle"),
            "It should include WritingStyle enum"
        )
        #expect(
            result.contains("AnalysisFocus"),
            "It should include AnalysisFocus enum"
        )
        #expect(
            result.contains("AbstractLength"),
            "It should include AbstractLength enum"
        )
        #expect(
            result.contains("OutlineStyle"),
            "It should include OutlineStyle enum"
        )
        #expect(
            result.contains("obsidian:\\/\\/enums\\/language"),
            "It should include language resource URI"
        )
        #expect(
            result.contains("obsidian:\\/\\/enums\\/writing-style"),
            "It should include writing-style resource URI"
        )
        #expect(
            result.contains("resourceURI"),
            "It should use resourceURI field instead of tool"
        )
    }

    @Test("It should return Language enum details")
    func testGetLanguageEnum() async throws {
        // Given
        let resource = makeResource()

        // When
        let result = try await resource.getLanguageEnum()

        // Then
        #expect(
            result.contains("portuguese"),
            "It should include portuguese language value"
        )
        #expect(
            result.contains("Spanish") || result.contains("es"),
            "It should include spanish language value"
        )
        #expect(
            result.contains("Language") && result.contains("enum"),
            "It should identify as Language enum"
        )
        #expect(
            result.contains("translateActiveNote"),
            "It should include usage example"
        )
    }

    @Test("It should return WritingStyle enum details")
    func testGetWritingStyleEnum() async throws {
        // Given
        let resource = makeResource()

        // When
        let result = try await resource.getWritingStyleEnum()

        // Then
        #expect(
            result.contains("formal"),
            "It should include formal style value"
        )
        #expect(
            result.contains("casual"),
            "It should include casual style value"
        )
        #expect(
            result.contains("WritingStyle") && result.contains("enum"),
            "It should identify as WritingStyle enum"
        )
        #expect(
            result.contains("rewriteActiveNote"),
            "It should include usage example"
        )
    }

    @Test("It should return AnalysisFocus enum details")
    func testGetAnalysisFocusEnum() async throws {
        // Given
        let resource = makeResource()

        // When
        let result = try await resource.getAnalysisFocusEnum()

        // Then
        #expect(
            result.contains("summary"),
            "It should include summary focus value"
        )
        #expect(
            result.contains("actionItems"),
            "It should include actionItems focus value"
        )
        #expect(
            result.contains("AnalysisFocus") && result.contains("enum"),
            "It should identify as AnalysisFocus enum"
        )
        #expect(
            result.contains("analyzeNote"),
            "It should include usage example"
        )
    }

    @Test("It should return AbstractLength enum details")
    func testGetAbstractLengthEnum() async throws {
        // Given
        let resource = makeResource()

        // When
        let result = try await resource.getAbstractLengthEnum()

        // Then
        #expect(
            result.contains("brief"),
            "It should include brief length value"
        )
        #expect(
            result.contains("standard"),
            "It should include standard length value"
        )
        #expect(
            result.contains("detailed"),
            "It should include detailed length value"
        )
        #expect(
            result.contains("AbstractLength") && result.contains("enum"),
            "It should identify as AbstractLength enum"
        )
        #expect(
            result.contains("generateActiveNoteAbstract"),
            "It should include usage example"
        )
    }

    @Test("It should return OutlineStyle enum details")
    func testGetOutlineStyleEnum() async throws {
        // Given
        let resource = makeResource()

        // When
        let result = try await resource.getOutlineStyleEnum()

        // Then
        #expect(
            result.contains("bullets"),
            "It should include bullets style value"
        )
        #expect(
            result.contains("numbered"),
            "It should include numbered style value"
        )
        #expect(
            result.contains("hierarchical"),
            "It should include hierarchical style value"
        )
        #expect(
            result.contains("OutlineStyle") && result.contains("enum"),
            "It should identify as OutlineStyle enum"
        )
        #expect(
            result.contains("generateActiveNoteOutline"),
            "It should include usage example"
        )
    }
}
