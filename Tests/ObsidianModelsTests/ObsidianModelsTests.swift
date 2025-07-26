import Foundation
import Testing

@testable import ObsidianModels

@Suite("ObsidianModels Tests")
struct ObsidianModelsTests {

    @Test("It should have all AnalysisFocus cases with descriptions")
    func testAnalysisFocusCases() {
        #expect(
            AnalysisFocus.general.description == "Comprehensive analysis including summary, themes, and actionable insights",
            "It should have correct description for general analysis focus"
        )
        #expect(
            AnalysisFocus.actionItems.description == "Extract tasks, deadlines, and next steps",
            "It should have correct description for action items analysis focus"
        )
        #expect(
            AnalysisFocus.tone.description == "Analyze mood, attitude, and emotional context",
            "It should have correct description for tone analysis focus"
        )
        #expect(
            !AnalysisFocus.general.instructions.isEmpty,
            "It should have non-empty instructions for general analysis focus"
        )
    }

    @Test("It should have all AbstractLength cases with descriptions")
    func testAbstractLengthCases() {
        #expect(
            AbstractLength.brief.description == "Brief summary (1-2 sentences)",
            "It should have correct description for brief abstract length"
        )
        #expect(
            AbstractLength.standard.description == "Standard abstract (1 paragraph)",
            "It should have correct description for standard abstract length"
        )
        #expect(
            AbstractLength.detailed.description == "Detailed summary (2-3 paragraphs)",
            "It should have correct description for detailed abstract length"
        )
        #expect(
            !AbstractLength.brief.instructions.isEmpty,
            "It should have non-empty instructions for brief abstract length"
        )
    }

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

    @Test("It should have all OutlineStyle cases with descriptions")
    func testOutlineStyleCases() {
        #expect(
            OutlineStyle.bullets.description == "Bullet point format",
            "It should have correct description for bullets outline style"
        )
        #expect(
            OutlineStyle.numbered.description == "Numbered list format",
            "It should have correct description for numbered outline style"
        )
        #expect(
            OutlineStyle.hierarchical.description == "Hierarchical academic format",
            "It should have correct description for hierarchical outline style"
        )
        #expect(
            !OutlineStyle.bullets.instructions.isEmpty,
            "It should have non-empty instructions for bullets outline style"
        )
    }

    @Test("It should have all WritingStyle cases with descriptions")
    func testWritingStyleCases() {
        #expect(
            WritingStyle.formal.description == "Formal and professional tone",
            "It should have correct description for formal writing style"
        )
        #expect(
            WritingStyle.emoji.description == "Fun and expressive with emojis",
            "It should have correct description for emoji writing style"
        )
        #expect(
            WritingStyle.eli5.description == "Explain Like I'm 5 - simple and easy to understand",
            "It should have correct description for ELI5 writing style"
        )
        #expect(
            !WritingStyle.formal.instructions.isEmpty,
            "It should have non-empty instructions for formal writing style"
        )
    }
}
