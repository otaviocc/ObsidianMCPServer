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

public enum AbstractLength: String, CaseIterable, Sendable {

    case brief
    case standard
    case detailed

    public var description: String {
        switch self {
        case .brief: "Brief summary (1-2 sentences)"
        case .standard: "Standard abstract (1 paragraph)"
        case .detailed: "Detailed summary (2-3 paragraphs)"
        }
    }

    public var instructions: String {
        switch self {
        case .brief:
            """
            Create a concise summary in 1-2 sentences:
            - Capture only the most essential point or conclusion
            - Focus on the main takeaway or core message
            - Keep it under 50 words
            - Be direct and impactful
            - Suitable for quick reference or social sharing
            """
        case .standard:
            """
            Create a standard abstract in 1 paragraph:
            - Include main points, key arguments, and conclusion
            - Maintain logical flow between ideas
            - Target 3-5 sentences or 75-150 words
            - Balance comprehensiveness with brevity
            - Suitable for executive summaries or introductions
            """
        case .detailed:
            """
            Create a comprehensive summary in 2-3 paragraphs:
            - Cover all major topics and supporting points
            - Include methodology, findings, and implications if applicable
            - Maintain structure: introduction, body, conclusion
            - Target 150-300 words across multiple paragraphs
            - Include context and nuanced details
            - Suitable for academic abstracts or comprehensive overviews
            """
        }
    }
}
