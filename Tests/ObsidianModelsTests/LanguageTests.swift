import Foundation
import Testing

@testable import ObsidianModels

@Suite("Language Tests")
struct LanguageTests {

    @Test("It should have all Language cases with descriptions")
    func testLanguageCases() {
        #expect(
            Language.portuguese.description == "Portuguese (Português)",
            "It should have correct description for Portuguese language"
        )
        #expect(
            Language.spanish.description == "Spanish (Español)",
            "It should have correct description for Spanish language"
        )
        #expect(
            Language.french.description == "French (Français)",
            "It should have correct description for French language"
        )
        #expect(
            Language.japanese.description == "Japanese (日本語)",
            "It should have correct description for Japanese language"
        )
        #expect(
            !Language.portuguese.instructions.isEmpty,
            "It should have non-empty instructions for Portuguese language"
        )
    }
}
