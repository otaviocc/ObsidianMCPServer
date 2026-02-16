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
import ObsidianModels

public final class ObsidianResource: ObsidianResourceProtocol {

    // MARK: - Life Cycle

    public init() {}

    // MARK: - Public Methods

    public func listEnumTypes() async throws -> String {
        let enumTypes = [
            [
                "name": "Language",
                "description": "Available languages for translateActiveNote prompt",
                "usage": "translateActiveNote(language: .portuguese)",
                "resourceURI": "obsidian://enums/language"
            ],
            [
                "name": "WritingStyle",
                "description": "Available writing styles for rewriteActiveNote prompt",
                "usage": "rewriteActiveNote(style: .formal)",
                "resourceURI": "obsidian://enums/writing-style"
            ],
            [
                "name": "AnalysisFocus",
                "description": "Available focus types for analyzeNote and analyzeActiveNote prompts",
                "usage": "analyzeNote(filename: \"note.md\", focus: .actionItems)",
                "resourceURI": "obsidian://enums/analysis-focus"
            ],
            [
                "name": "AbstractLength",
                "description": "Available length options for generateActiveNoteAbstract prompt",
                "usage": "generateActiveNoteAbstract(length: .detailed)",
                "resourceURI": "obsidian://enums/abstract-length"
            ],
            [
                "name": "OutlineStyle",
                "description": "Available style options for generateActiveNoteOutline prompt",
                "usage": "generateActiveNoteOutline(style: .numbered)",
                "resourceURI": "obsidian://enums/outline-style"
            ]
        ]

        let result: [String: Any] = [
            "enumTypes": enumTypes,
            "description": "Available enum types for Obsidian MCP prompt parameters",
            "note": "Use the 'resourceURI' field to access detailed values through MCP Resources"
        ]

        return try toJSONString(result)
    }

    public func getLanguageEnum() async throws -> String {
        let languages = Language.allCases
            .map { language in
                [
                    "value": language.rawValue,
                    "description": language.description
                ]
            }

        let result: [String: Any] = [
            "enum": "Language",
            "description": "Available languages for translating notes",
            "usage": "translateActiveNote(language: .portuguese)",
            "values": languages
        ]

        return try toJSONString(result)
    }

    public func getWritingStyleEnum() async throws -> String {
        let styles = WritingStyle.allCases
            .map { style in
                [
                    "value": style.rawValue,
                    "description": style.description
                ]
            }

        let result: [String: Any] = [
            "enum": "WritingStyle",
            "description": "Available writing styles for rewriting notes",
            "usage": "rewriteActiveNote(style: .formal)",
            "values": styles
        ]

        return try toJSONString(result)
    }

    public func getAnalysisFocusEnum() async throws -> String {
        let focuses = AnalysisFocus.allCases
            .map { focus in
                [
                    "value": focus.rawValue,
                    "description": focus.description
                ]
            }

        let result: [String: Any] = [
            "enum": "AnalysisFocus",
            "description": "Available focus types for analyzing notes",
            "usage": "analyzeNote(filename: \"note.md\", focus: .actionItems)",
            "values": focuses
        ]

        return try toJSONString(result)
    }

    public func getAbstractLengthEnum() async throws -> String {
        let lengths = AbstractLength.allCases
            .map { length in
                [
                    "value": length.rawValue,
                    "description": length.description
                ]
            }

        let result: [String: Any] = [
            "enum": "AbstractLength",
            "description": "Available length options for generating abstracts",
            "usage": "generateActiveNoteAbstract(length: .detailed)",
            "values": lengths
        ]

        return try toJSONString(result)
    }

    public func getOutlineStyleEnum() async throws -> String {
        let styles = OutlineStyle.allCases
            .map { style in
                [
                    "value": style.rawValue,
                    "description": style.description
                ]
            }

        let result: [String: Any] = [
            "enum": "OutlineStyle",
            "description": "Available style options for generating outlines",
            "usage": "generateActiveNoteOutline(style: .numbered)",
            "values": styles
        ]

        return try toJSONString(result)
    }

    // MARK: - Private Methods

    private func toJSONString(_ object: [String: Any]) throws -> String {
        let jsonData = try JSONSerialization.data(
            withJSONObject: object,
            options: .prettyPrinted
        )

        return String(data: jsonData, encoding: .utf8) ?? "{}"
    }
}
