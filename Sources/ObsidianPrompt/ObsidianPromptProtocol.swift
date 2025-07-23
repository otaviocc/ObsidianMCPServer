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
}
