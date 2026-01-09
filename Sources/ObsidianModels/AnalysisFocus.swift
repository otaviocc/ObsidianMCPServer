import Foundation

public enum AnalysisFocus: String, CaseIterable, Sendable {

    case general
    case summarize
    case themes
    case actionItems = "action-items"
    case connections
    case tone
    case grammar
    case structure
    case questions
    case keywords
    case insights
    case review

    public var description: String {
        switch self {
        case .general: "Comprehensive analysis including summary, themes, and actionable insights"
        case .summarize: "Clear, concise summary of main content without detailed analysis"
        case .themes: "Identify main themes, concepts, and topics discussed"
        case .actionItems: "Extract tasks, deadlines, and next steps"
        case .connections: "Suggest links to other notes and concepts"
        case .tone: "Analyze mood, attitude, and emotional context"
        case .grammar: "Review grammar, spelling, and style improvements"
        case .structure: "Analyze organization and suggest layout improvements"
        case .questions: "Identify key questions and suggest follow-ups"
        case .keywords: "Extract important terms for tagging"
        case .insights: "Focus on key learnings and 'aha moments'"
        case .review: "Comprehensive review with strengths and improvements"
        }
    }

    // swiftlint:disable line_length
    public var instructions: String {
        switch self {
        case .general: "Provide a comprehensive analysis including summary, themes, and actionable insights."
        case .summarize: "Provide a clear, concise summary of the main content without going into detailed analysis."
        case .themes: "Focus on identifying and highlighting the main themes, concepts, and topics discussed."
        case .actionItems: "Extract all action items, tasks, deadlines, and next steps mentioned in the note."
        case .connections: "Suggest potential connections to other notes, topics, or concepts that could be linked."
        case .tone: "Analyze the tone, mood, and emotional context of the writing. Identify the author's attitude and perspective."
        case .grammar: "Review the text for grammar, spelling, style, and clarity improvements. Provide specific suggestions."
        case .structure: "Analyze the organization and structure of the content. Suggest improvements to flow and layout."
        case .questions: "Identify key questions raised in the note and suggest follow-up questions for deeper exploration."
        case .keywords: "Extract the most important keywords, terms, and concepts for tagging and searchability."
        case .insights: "Focus on extracting key insights, learnings, and 'aha moments' from the content."
        case .review: "Provide a comprehensive review including strengths, weaknesses, and suggestions for improvement."
        }
    }
    // swiftlint:enable line_length
}
