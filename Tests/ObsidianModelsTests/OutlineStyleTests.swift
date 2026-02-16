// MIT License
//
// Copyright (c) 2026 Otávio C.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Testing
@testable import ObsidianModels

@Suite("OutlineStyle Tests")
struct OutlineStyleTests {

    @Test("It should have all OutlineStyle cases with descriptions")
    func outlineStyleCases() {
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
