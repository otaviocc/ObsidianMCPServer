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

public enum OutlineStyle: String, CaseIterable, Sendable {

    case bullets
    case numbered
    case hierarchical

    public var description: String {
        switch self {
        case .bullets: "Bullet point format"
        case .numbered: "Numbered list format"
        case .hierarchical: "Hierarchical academic format"
        }
    }

    public var instructions: String {
        switch self {
        case .bullets:
            """
            Create a bullet point outline:
            - Use simple bullet points (•, -, *) for all levels
            - CRITICAL: Use exactly 4 spaces (NOT tabs) for each indentation level
            - Level 1: No indentation
            - Level 2: 4 spaces from left margin
            - Level 3: 8 spaces from left margin
            - Level 4: 12 spaces from left margin
            - Keep formatting clean and readable
            - Maximum 3-4 levels of nesting
            - Focus on clarity over formal structure
            - Example:
            • Main Topic
                - Subtopic
                    • Detail
                        * Sub-detail
            """
        case .numbered:
            """
            Create a numbered list outline:
            - Use numbers for main sections (1, 2, 3...)
            - Use letters for sub-sections (a, b, c...)
            - Use roman numerals for sub-sub-sections (i, ii, iii...)
            - CRITICAL: Use exactly 4 spaces (NOT tabs) for each indentation level
            - Level 1: No indentation
            - Level 2: 4 spaces from left margin
            - Level 3: 8 spaces from left margin
            - Level 4: 12 spaces from left margin
            - Maintain consistent numbering throughout
            - Clear progression and logical sequence
            - Example:
            1. Main Section
                a. Subsection
                    i. Sub-subsection
                b. Subsection
            2. Main Section
            """
        case .hierarchical:
            """
            Create a formal hierarchical outline:
            - Use traditional academic outline format
            - Roman numerals for major sections (I, II, III...)
            - Capital letters for main subsections (A, B, C...)
            - Arabic numbers for sub-subsections (1, 2, 3...)
            - Lowercase letters for details (a, b, c...)
            - CRITICAL: Use exactly 4 spaces (NOT tabs) for each indentation level
            - Level 1 (I, II, III): No indentation
            - Level 2 (A, B, C): 4 spaces from left margin
            - Level 3 (1, 2, 3): 8 spaces from left margin
            - Level 4 (a, b, c): 12 spaces from left margin
            - Maintain proper indentation and alignment
            - Example:
            I. Major Section
                A. Main Subsection
                    1. Detail
                    2. Detail
                        a. Sub-detail
                        b. Sub-detail
                B. Main Subsection
            II. Major Section
            """
        }
    }
}
