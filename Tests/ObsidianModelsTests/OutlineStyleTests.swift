import Foundation
import Testing

@testable import ObsidianModels

@Suite("OutlineStyle Tests")
struct OutlineStyleTests {

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
}
