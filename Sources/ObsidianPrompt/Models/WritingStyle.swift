import Foundation

public enum WritingStyle: String, CaseIterable, Sendable {
    case formal = "formal"
    case informal = "informal"
    case technical = "technical"
    case scientific = "scientific"
    case emoji = "emoji"
    case eli5 = "eli5"
    case creative = "creative"
    case professional = "professional"
    case academic = "academic"
    case conversational = "conversational"

    public var description: String {
        switch self {
        case .formal: "Formal and professional tone"
        case .informal: "Casual and relaxed tone"
        case .technical: "Technical and precise language"
        case .scientific: "Scientific and research-oriented"
        case .emoji: "Fun and expressive with emojis"
        case .eli5: "Explain Like I'm 5 - simple and easy to understand"
        case .creative: "Creative and imaginative writing"
        case .professional: "Business and workplace appropriate"
        case .academic: "Scholarly and educational tone"
        case .conversational: "Natural conversation style"
        }
    }

    public var instructions: String {
        switch self {
        case .formal:
            """
            Rewrite using formal language with:
            - Complete sentences and proper grammar
            - Professional vocabulary
            - Third-person perspective where appropriate
            - No contractions or colloquialisms
            - Structured and organized presentation
            """
        case .informal:
            """
            Rewrite using informal, casual language with:
            - Contractions and everyday language
            - First or second person perspective
            - Relaxed tone and conversational style
            - Simple sentence structures
            - Friendly and approachable voice
            """
        case .technical:
            """
            Rewrite using technical language with:
            - Precise technical terminology
            - Detailed explanations of processes
            - Step-by-step breakdowns
            - Industry-specific vocabulary
            - Clear logical structure
            """
        case .scientific:
            """
            Rewrite using scientific language with:
            - Objective and evidence-based tone
            - Hypothesis and conclusion format
            - Data-driven explanations
            - Research methodology references
            - Precise and measurable language
            """
        case .emoji:
            """
            Rewrite with emojis and fun language:
            - Add relevant emojis throughout
            - Use expressive and energetic tone
            - Make it visually engaging
            - Keep it light and entertaining
            - Use emojis to enhance meaning, not replace words
            """
        case .eli5:
            """
            Rewrite as if explaining to a 5-year-old:
            - Use very simple words and concepts
            - Short, easy sentences
            - Relate to familiar things (toys, animals, food)
            - Use analogies and examples
            - Ask questions to engage the reader
            - Be patient and encouraging
            """
        case .creative:
            """
            Rewrite using creative and imaginative language:
            - Use metaphors and vivid imagery
            - Engaging storytelling techniques
            - Descriptive and colorful language
            - Unique perspective or approach
            - Artistic and expressive tone
            """
        case .professional:
            """
            Rewrite for professional business context:
            - Clear and concise communication
            - Action-oriented language
            - Results and impact focused
            - Appropriate for workplace sharing
            - Confident and competent tone
            """
        case .academic:
            """
            Rewrite in academic style:
            - Scholarly vocabulary and tone
            - Well-structured arguments
            - Evidence-based statements
            - Citations and references format
            - Analytical and critical thinking
            """
        case .conversational:
            """
            Rewrite as natural conversation:
            - Direct address to the reader
            - Questions and interactive elements
            - Natural speech patterns
            - Personal anecdotes or examples
            - Engaging and relatable tone
            """
        }
    }
}
