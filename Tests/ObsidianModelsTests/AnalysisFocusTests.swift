import Foundation
import Testing

@testable import ObsidianModels

@Suite("AnalysisFocus Tests")
struct AnalysisFocusTests {

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
}
