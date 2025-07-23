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
}
