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

@Suite("Language Tests")
struct LanguageTests {

    @Test("It should have all Language cases with descriptions")
    func languageCases() {
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
