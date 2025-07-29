import Foundation
import Testing

@testable import ObsidianModels

@Suite("WritingStyle Tests")
struct WritingStyleTests {

    @Test("It should have all WritingStyle cases with descriptions")
    func writingStyleCases() {
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
