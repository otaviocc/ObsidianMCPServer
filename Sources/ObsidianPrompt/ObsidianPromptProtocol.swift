import Foundation

public protocol ObsidianPromptProtocol {

    /// Generate a prompt to analyze and summarize an Obsidian note with various focus types.
    ///
    /// This method provides a structured template for analyzing Obsidian note content,
    /// making it easy for LLMs to provide consistent and useful analysis based on specific needs.
    ///
    /// - Parameters:
    ///   - filename: The filename of the note to analyze
    ///   - focus: The type of analysis to perform (default: .general)
    /// - Returns: A formatted prompt for note analysis
    /// - Throws: An error if the note cannot be retrieved or the prompt cannot be generated
    func summarizeNote(
        filename: String,
        focus: AnalysisFocus
    ) async throws -> String

    /// Generate a prompt to analyze the currently active note in Obsidian with various focus types.
    ///
    /// This method provides analysis of the note currently open in Obsidian without requiring
    /// the user to specify a filename, making it convenient for quick analysis workflows.
    ///
    /// - Parameter focus: The type of analysis to perform (default: .general)
    /// - Returns: A formatted prompt for active note analysis
    /// - Throws: An error if no note is active or the note cannot be retrieved
    func analyzeActiveNote(focus: AnalysisFocus) async throws -> String

    /// Generate thought-provoking follow-up questions based on note content.
    ///
    /// This method creates engaging questions that encourage deeper thinking and exploration
    /// of the topics discussed in the note, perfect for research and learning workflows.
    ///
    /// - Parameters:
    ///   - filename: The filename of the note to analyze
    ///   - questionCount: The number of questions to generate (default: 5)
    /// - Returns: A formatted prompt with follow-up questions
    /// - Throws: An error if the note cannot be retrieved or the prompt cannot be generated
    func generateFollowUpQuestions(
        filename: String,
        questionCount: Int
    ) async throws -> String
}
