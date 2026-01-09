import Foundation
import Testing
@testable import ObsidianModels

@Suite("AbstractLength Tests")
struct AbstractLengthTests {

    @Test("It should have all AbstractLength cases with descriptions")
    func abstractLengthCases() {
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
}
