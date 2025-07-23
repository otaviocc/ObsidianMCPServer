import Foundation
import ObsidianRepository

public final class ObsidianPrompt: ObsidianPromptProtocol {

    // MARK: - Properties

    private let repository: ObsidianRepositoryProtocol

    // MARK: - Life Cycle

    public init(repository: ObsidianRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public

    public func summarizeNote(
        filename: String,
        focus: AnalysisFocus = .general
    ) async throws -> String {
        let noteContent = try await repository.getVaultNote(filename: filename)
        let instructions = focus.instructions

        let prompt = """
        Analyze the following Obsidian note and provide insights based on the requested focus.

        **Note:** \(noteContent.filename)
        **Analysis Type:** \(focus.description)

        **Instructions:**
        \(instructions)

        **Note Content:**
        \(noteContent.content)

        **Please provide:**
        1. A clear summary of the main content
        2. Key insights based on the analysis type
        3. Any suggestions for improvement or follow-up actions
        """

        return prompt
    }

    public func analyzeActiveNote(focus: AnalysisFocus = .general) async throws -> String {
        let activeNote = try await repository.getActiveNote()
        let instructions = focus.instructions

        let prompt = """
        Analyze the currently active Obsidian note and provide insights based on the requested focus.

        **Active Note:** \(activeNote.filename)
        **Analysis Type:** \(focus.description)

        **Instructions:**
        \(instructions)

        **Note Content:**
        \(activeNote.content)

        **Please provide:**
        1. A clear summary of the main content
        2. Key insights based on the analysis type
        3. Any suggestions for improvement or follow-up actions
        """

        return prompt
    }

    public func generateFollowUpQuestions(
        filename: String,
        questionCount: Int = 5
    ) async throws -> String {
        let noteContent = try await repository.getVaultNote(filename: filename)

        let prompt = """
        Based on the following Obsidian note content, generate \(questionCount) thought-provoking follow-up questions that encourage deeper thinking and exploration of the topics discussed.

        **Note:** \(noteContent.filename)

        **Note Content:**
        \(noteContent.content)

        **Please provide:**
        1. \(questionCount) engaging questions that build upon the content
        2. Questions should encourage critical thinking and further research
        3. Focus on different aspects: analysis, synthesis, evaluation, and application
        4. Make questions specific enough to be actionable but broad enough to stimulate deep thinking
        5. Consider connections to related topics and potential areas for expansion

        **Question Categories to Consider:**
        - **Analysis**: What patterns, trends, or relationships can be identified?
        - **Synthesis**: How does this connect to other concepts or ideas?
        - **Evaluation**: What are the strengths, weaknesses, or implications?
        - **Application**: How can this knowledge be applied or tested?
        - **Extension**: What new areas does this open up for exploration?
        """

        return prompt
    }
}
