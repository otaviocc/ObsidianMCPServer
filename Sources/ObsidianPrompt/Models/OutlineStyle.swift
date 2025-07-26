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
            - Indent sub-points with additional spaces
            - Keep formatting clean and readable
            - Maximum 3-4 levels of nesting
            - Focus on clarity over formal structure
            - Example:
              • Main Topic
                - Subtopic
                  • Detail
            """
        case .numbered:
            """
            Create a numbered list outline:
            - Use numbers for main sections (1, 2, 3...)
            - Use letters for sub-sections (a, b, c...)
            - Use roman numerals for sub-sub-sections (i, ii, iii...)
            - Maintain consistent numbering throughout
            - Clear progression and logical sequence
            - Example:
              1. Main Section
                 a. Subsection
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
