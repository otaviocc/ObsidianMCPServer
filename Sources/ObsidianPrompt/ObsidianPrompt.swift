import Foundation
import ObsidianRepository

// swiftlint:disable type_body_length file_length

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

    // swiftlint:disable line_length
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
    // swiftlint:enable line_length

    public func suggestTags(
        filename: String,
        maxTags: Int = 8
    ) async throws -> String {
        let noteContent = try await repository.getVaultNote(filename: filename)

        let prompt = """
        Analyze the following Obsidian note content and suggest \(maxTags) relevant tags for frontmatter organization.

        **Note:** \(noteContent.filename)

        **Note Content:**
        \(noteContent.content)

        **Instructions:**
        1. Suggest up to \(maxTags) relevant tags based on the content
        2. Focus on topics, themes, concepts, categories, and key subjects
        3. Use lowercase, hyphen-separated format (e.g., "machine-learning", "project-management")
        4. Prioritize specific and actionable tags over generic ones
        5. Consider both explicit topics mentioned and implicit themes
        6. Think about how these tags would help with future searches and organization

        **Tag Categories to Consider:**
        - **Topics**: Main subjects discussed (e.g., "artificial-intelligence", "web-development")
        - **Type**: Note type or format (e.g., "meeting-notes", "research", "tutorial")
        - **Status**: Current state (e.g., "in-progress", "completed", "draft")
        - **Project**: Related projects or initiatives
        - **Context**: Relevant contexts (e.g., "work", "personal", "learning")

        **Output Format:**
        For each suggested tag, provide:
        1. The tag name
        2. Brief reasoning for the suggestion
        3. MCP command to apply it

        **Example:**
        Suggested tags for \(noteContent.filename):
        • #tag-name - Brief reasoning for this tag
        • #another-tag - Why this tag is relevant

        **MCP Commands to Apply Tags:**
        ```
        appendToNoteFrontmatterField(filename: "\(noteContent.filename)", key: "tags", value: "tag-name")
        ```
        """

        return prompt
    }

    // swiftlint:disable line_length function_body_length
    public func generateFrontmatter(filename: String) async throws -> String {
        let noteContent = try await repository.getVaultNote(filename: filename)

        let prompt = """
        Analyze the following Obsidian note content and generate a complete frontmatter structure with appropriate metadata fields.

        **Note:** \(noteContent.filename)

        **Note Content:**
        \(noteContent.content)

        **Instructions:**
        1. Create a comprehensive frontmatter structure based on the content
        2. Include relevant fields such as tags, status, category, dates, author, etc.
        3. Suggest appropriate values for each field based on content analysis
        4. Use YAML format for the frontmatter structure
        5. Include both common fields and content-specific fields

        **Common Frontmatter Fields to Consider:**
        - **tags**: Relevant topic and category tags
        - **status**: Current state (draft, in-progress, completed, published)
        - **category**: High-level classification
        - **type**: Note type (meeting, research, tutorial, journal, etc.)
        - **created**: Creation date (if inferable from content)
        - **modified**: Last modification date
        - **author**: Author or creator (if mentioned)
        - **project**: Related project or initiative
        - **priority**: Importance level (if applicable)
        - **due_date**: Deadline or due date (if mentioned)
        - **related**: Related notes or topics

        **Content-Specific Fields:**
        Based on the note content, suggest additional relevant fields such as:
        - **attendees**: For meeting notes (use [[Name]] format for linking to people's notes)
        - **location**: For event or meeting notes
        - **source**: For research or reference notes
        - **summary**: Brief description
        - **keywords**: Key terms for searching
        - **author**: Author or creator (use [[Name]] format for linking)

        **Output Format:**
        1. Complete YAML frontmatter structure
        2. Reasoning for each field inclusion
        3. MCP commands to set each field
        4. **Important**: Use [[Name]] format for people's names to create clickable links to their notes

        **Example Output:**
        ```yaml
        ---
        tags: [tag1, tag2, tag3]
        status: draft
        category: research
        type: meeting-notes
        created: 2024-01-15
        project: project-name
        attendees: ["[[John Smith]]", "[[Sarah Wilson]]"]
        author: "[[John Smith]]"
        ---
        ```

        **MCP Commands:**
        ```
        setNoteFrontmatterField(filename: "\(noteContent.filename)", key: "tags", value: "tag1,tag2,tag3")
        setNoteFrontmatterField(filename: "\(noteContent.filename)", key: "attendees", value: "[[John Smith]],[[Sarah Wilson]]")
        setNoteFrontmatterField(filename: "\(noteContent.filename)", key: "author", value: "[[John Smith]]")
        ```
        """

        return prompt
    }
    // swiftlint:enable line_length function_body_length

    public func suggestActiveNoteTags(maxTags: Int = 8) async throws -> String {
        let activeNote = try await repository.getActiveNote()

        let prompt = """
        Analyze the currently active Obsidian note and suggest \(maxTags) relevant tags for frontmatter organization.

        **Active Note:** \(activeNote.filename)

        **Note Content:**
        \(activeNote.content)

        **Instructions:**
        1. Suggest up to \(maxTags) relevant tags based on the content
        2. Focus on topics, themes, concepts, categories, and key subjects
        3. Use lowercase, hyphen-separated format (e.g., "machine-learning", "daily-journal")
        4. Prioritize specific and actionable tags over generic ones
        5. Consider both explicit topics mentioned and implicit themes
        6. Think about how these tags would help with future searches and organization

        **Tag Categories to Consider:**
        - **Topics**: Main subjects discussed
        - **Type**: Note type or format (meeting, research, journal, etc.)
        - **Status**: Current state (draft, in-progress, completed)
        - **Project**: Related projects or initiatives
        - **Context**: Relevant contexts (work, personal, learning)

        **Output Format:**
        For each suggested tag, provide:
        1. The tag name
        2. Brief reasoning for the suggestion
        3. MCP command to apply it to the active note

        **Example:**
        Suggested tags for active note (\(activeNote.filename)):
        • #tag-name - Brief reasoning for this tag
        • #another-tag - Why this tag is relevant

        **MCP Commands to Apply Tags to Active Note:**
        ```
        appendToActiveNoteFrontmatterField(key: "tags", value: "tag-name")
        ```

        **Note:** These commands will directly update the currently active note in Obsidian.
        """

        return prompt
    }

    // swiftlint:disable line_length function_body_length
    public func extractMetadata(filename: String) async throws -> String {
        let noteContent = try await repository.getVaultNote(filename: filename)

        let prompt = """
        Analyze the following Obsidian note content and extract key metadata that would be valuable for frontmatter organization and querying.

        **Note:** \(noteContent.filename)

        **Note Content:**
        \(noteContent.content)

        **Instructions:**
        1. Identify and extract structured information that could be useful as frontmatter fields
        2. Look for dates, people, places, projects, companies, events, deadlines, etc.
        3. Suggest appropriate frontmatter field names for each piece of metadata
        4. Provide the extracted values in a structured format
        5. Include reasoning for why each piece of metadata is valuable

        **Metadata Categories to Extract:**

        **Temporal Information:**
        - Dates mentioned (meetings, deadlines, events)
        - Time periods or durations
        - Schedules or recurring events

        **People & Organizations:**
        - Names of people mentioned (use [[Name]] format for Obsidian linking)
        - Companies or organizations
        - Teams or departments
        - Roles or positions

        **Location Information:**
        - Physical locations (cities, buildings, rooms)
        - Virtual locations (URLs, platforms)
        - Geographic references

        **Project & Work Context:**
        - Project names or codes
        - Task or initiative references
        - Goals or objectives mentioned
        - Milestones or deliverables

        **Categories & Classification:**
        - Subject areas or domains
        - Document types or formats
        - Priority levels mentioned
        - Status indicators

        **Relationships & References:**
        - Related documents or notes mentioned
        - External sources or citations
        - Dependencies or prerequisites
        - Follow-up items or next steps

        **Output Format:**
        For each extracted metadata item:
        1. **Field Name**: Suggested frontmatter field name
        2. **Value**: Extracted value(s) with proper Obsidian formatting
        3. **Reasoning**: Why this metadata is valuable
        4. **MCP Command**: How to set this field
        5. **Important**: Use [[Name]] format for people's names to create clickable links

        **Example:**
        **Extracted Metadata for \(noteContent.filename):**

        1. **Field**: attendees
           **Value**: ["[[John Smith]]", "[[Sarah Wilson]]", "[[Mike Chen]]"]
           **Reasoning**: People mentioned as meeting participants, formatted as Obsidian links
           **Command**: `setNoteFrontmatterField(filename: "\(noteContent.filename)", key: "attendees", value: "[[John Smith]],[[Sarah Wilson]],[[Mike Chen]]")`

        2. **Field**: author
           **Value**: "[[John Smith]]"
           **Reasoning**: Person identified as the author or note creator, formatted as Obsidian link
           **Command**: `setNoteFrontmatterField(filename: "\(noteContent.filename)", key: "author", value: "[[John Smith]]")`

        3. **Field**: due_date
           **Value**: "2024-02-15"
           **Reasoning**: Deadline mentioned for project completion
           **Command**: `setNoteFrontmatterField(filename: "\(noteContent.filename)", key: "due_date", value: "2024-02-15")`
        """

        return prompt
    }
    // swiftlint:enable line_length function_body_length

    // swiftlint:disable line_length
    public func rewriteActiveNote(style: WritingStyle) async throws -> String {
        let activeNote = try await repository.getActiveNote()

        let prompt = """
        # Rewrite Active Note: \(style.description)

        You are an expert writer and editor. Please rewrite the following note content using the specified writing style.

        **Writing Style**: \(style.description)

        **Style Guidelines**:
        \(style.instructions)

        **Original Note**: \(activeNote.filename)
        **Content**:
        ```
        \(activeNote.content)
        ```

        **Rewriting Instructions**:
        1. **Preserve Core Information**: Keep all important facts, data, and key points
        2. **Maintain Structure**: Preserve headings, lists, and logical organization where appropriate
        3. **Apply Style Consistently**: Transform the language and tone throughout
        4. **Preserve Formatting**: Keep Obsidian-specific formatting like [[links]], #tags, and markdown
        5. **Enhance Clarity**: Make the content clearer and more engaging in the target style

        **Output Requirements**:
        - Provide the complete rewritten content
        - Maintain the same information density
        - Preserve any Obsidian links ([[Page Name]]) and hashtags (#tag)
        - Keep code blocks, tables, and special formatting intact
        - Ensure the rewritten version is ready to replace the original

        **Rewritten Content**:
        """

        return prompt
    }
    // swiftlint:enable line_length
}

// swiftlint:enable type_body_length file_length
