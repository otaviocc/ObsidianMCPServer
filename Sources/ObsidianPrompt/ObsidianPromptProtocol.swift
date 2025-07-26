import Foundation

public protocol ObsidianPromptProtocol: ObsidianPromptAnalysisOperations,
                                        ObsidianPromptEnhancementOperations,
                                        ObsidianPromptGenerationOperations,
                                        ObsidianPromptTransformationOperations {}

// MARK: - Analysis Operations

public protocol ObsidianPromptAnalysisOperations {

    /// Generate a prompt to analyze an Obsidian note with various focus types.
    ///
    /// This method provides a structured template for analyzing Obsidian note content,
    /// making it easy for LLMs to provide consistent and useful analysis based on specific needs.
    ///
    /// - Parameters:
    ///   - filename: The filename of the note to analyze
    ///   - focus: The type of analysis to perform (default: .general)
    /// - Returns: A formatted prompt for note analysis
    /// - Throws: An error if the note cannot be retrieved or the prompt cannot be generated
    func analyzeNote(
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

    /// Extract key metadata from note content for frontmatter usage.
    ///
    /// This method analyzes the note content to identify important metadata such as dates,
    /// people, projects, locations, and other structured information that would be valuable
    /// in frontmatter fields for organization and querying.
    ///
    /// - Parameter filename: The filename of the note to analyze
    /// - Returns: A formatted prompt with extracted metadata suggestions
    /// - Throws: An error if the note cannot be retrieved or the prompt cannot be generated
    func extractMetadata(filename: String) async throws -> String
}

// MARK: - Enhancement Operations

public protocol ObsidianPromptEnhancementOperations {

    /// Analyze note content and suggest relevant tags for frontmatter.
    ///
    /// This method examines the note content to identify key topics, themes, and concepts,
    /// then suggests appropriate tags that would be useful for organization and discovery.
    ///
    /// - Parameters:
    ///   - filename: The filename of the note to analyze
    ///   - maxTags: The maximum number of tags to suggest
    /// - Returns: A formatted prompt with tag suggestions and MCP commands to apply them
    /// - Throws: An error if the note cannot be retrieved or the prompt cannot be generated
    func suggestTags(
        filename: String,
        maxTags: Int
    ) async throws -> String

    /// Suggest tags for the currently active note in Obsidian.
    ///
    /// This method provides tag suggestions for the note currently open in Obsidian without
    /// requiring the user to specify a filename, making it convenient for quick tagging workflows.
    ///
    /// - Parameter maxTags: The maximum number of tags to suggest (default: 8)
    /// - Returns: A formatted prompt with tag suggestions and MCP commands to apply them
    /// - Throws: An error if no note is active or the note cannot be retrieved
    func suggestActiveNoteTags(maxTags: Int) async throws -> String

    /// Generate a complete frontmatter structure based on note content.
    ///
    /// This method analyzes the note content to suggest a comprehensive frontmatter structure
    /// including tags, status, category, dates, and other relevant metadata fields.
    ///
    /// - Parameter filename: The filename of the note to analyze
    /// - Returns: A formatted prompt with complete frontmatter suggestions
    /// - Throws: An error if the note cannot be retrieved or the prompt cannot be generated
    func generateFrontmatter(filename: String) async throws -> String
}

// MARK: - Generation Operations

public protocol ObsidianPromptGenerationOperations {

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

// MARK: - Transformation Operations

public protocol ObsidianPromptTransformationOperations {

    /// Rewrite the currently active note in Obsidian with a specified writing style.
    ///
    /// This method allows the user to rewrite the note currently open in Obsidian
    /// with a specific writing style, such as formal, informal, or technical.
    ///
    /// - Parameter style: The desired writing style for the note.
    /// - Returns: A formatted prompt for rewriting the active note.
    /// - Throws: An error if no note is active or the note cannot be retrieved.
    func rewriteActiveNote(style: WritingStyle) async throws -> String

    /// Translate the currently active note in Obsidian to a specified language.
    ///
    /// This method translates the note currently open in Obsidian while preserving
    /// Obsidian-specific formatting, structure, and appropriate metadata.
    ///
    /// - Parameter language: The target language for translation
    /// - Returns: A formatted prompt for translating the active note
    /// - Throws: An error if no note is active or the note cannot be retrieved
    func translateActiveNote(language: Language) async throws -> String
}
