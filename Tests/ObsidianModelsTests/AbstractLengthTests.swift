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
