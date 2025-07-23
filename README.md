# ObsidianMCPServer

[![codecov](https://codecov.io/github/otaviocc/ObsidianMCPServer/graph/badge.svg?token=684ATBMZH4)](https://codecov.io/github/otaviocc/ObsidianMCPServer)
[![Check Runs](https://img.shields.io/github/check-runs/otaviocc/ObsidianMCPServer/main)](https://github.com/otaviocc/ObsidianMCPServer/actions?query=branch%3Amain)
[![Mastodon Follow](https://img.shields.io/mastodon/follow/109580944375344260?domain=social.lol&style=flat)](https://social.lol/@otaviocc)

A Model Context Protocol (MCP) server that enables AI assistants to interact with your Obsidian vault through the Obsidian Local REST API. This bridge allows LLMs like Claude and other AI tools to read, write, search, and manage your Obsidian notes programmatically.

## 🎯 Purpose

This MCP server provides AI assistants with powerful capabilities to:

- 📖 **Read and analyze** your existing notes
- ✍️ **Create and update** notes with new content
- 🔍 **Search across** your entire vault
- 📁 **Navigate** your vault structure
- 🔧 **Manage frontmatter** fields and arrays
- 🗑️ **Manage files** (create, update, delete)

Perfect for AI-assisted note-taking, knowledge management, research workflows, and content generation directly within your Obsidian vault.

## ✨ Features

### 📝 Note Management
- **Active Note Operations**: Get, update, delete the currently active note
- **Vault Note Operations**: Full CRUD operations on any note in your vault
- **Flexible Content Updates**: Complete replacement or appending content
- **Frontmatter Support**: Set and append to frontmatter fields and arrays

### 🔍 Search & Discovery
- **Full-Text Search**: Search across all notes with customizable options
- **Advanced Options**: Case sensitivity, whole word matching, regex support
- **Directory Browsing**: List files and folders to understand vault structure
- **Structured Results**: Search returns relevance scores and file paths

### 🏷️ Metadata Management
- **Frontmatter Fields**: Set individual frontmatter properties
- **Frontmatter Arrays**: Append to frontmatter arrays (like tags)
- **Active & Vault Notes**: Manage frontmatter for any note

### 🎯 Intelligent Analysis
- **MCP Prompts**: Generate structured analysis prompts with 12 different focus types

## 🔧 Prerequisites

### 1. Obsidian Local REST API Plugin

Install and configure the [Obsidian Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api) plugin:

1. **Install the plugin**:
   - Open Obsidian Settings → Community Plugins
   - Browse and search for "Local REST API"
   - Install and enable the plugin

2. **Configure the plugin**:
   - Go to plugin settings
   - Set a secure API key
   - Note the server URLs:
     - **HTTP**: `http://127.0.0.1:27123` (default)
     - **HTTPS**: `https://127.0.0.1:27124` (if enabled)

3. **Start the server**:
   - Use the command palette: "Local REST API: Start"
   - The server will run while Obsidian is open

### 2. Swift Development Environment

- **macOS 12.0+** (required)
- **Swift 6.0+** and Xcode 15.0+
- **Command Line Tools**: `xcode-select --install`

## 🚀 Installation

### Build from Source

```bash
# Clone the repository
git clone https://github.com/otaviocc/ObsidianMCPServer.git
cd ObsidianMCPServer

# Build the project
swift build -c release

# The executable will be at: .build/release/ObsidianMCPServer
```

## ⚙️ Configuration

### Environment Variables

The server requires two environment variables:

```bash
# For HTTP (default)
export OBSIDIAN_BASE_URL="http://127.0.0.1:27123"
export OBSIDIAN_API_KEY="your-api-key-here"

# For HTTPS (if enabled in plugin)
export OBSIDIAN_BASE_URL="https://127.0.0.1:27124"
export OBSIDIAN_API_KEY="your-api-key-here"
```

Replace `your-api-key-here` with the API key from your Obsidian Local REST API plugin settings.

### Verify Setup

Test your configuration:

```bash
# Set environment variables
export OBSIDIAN_BASE_URL="http://127.0.0.1:27123"
export OBSIDIAN_API_KEY="your-api-key"

# Test the server
./ObsidianMCPServer
```

You should see output like:
```
MCP Server ObsidianMCPServer (1.0.0) started with stdio transport
Base URL: http://127.0.0.1:27123
```

## 🤖 AI Tool Integration

### Claude Desktop

Add this configuration to your Claude Desktop config file:

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "/path/to/ObsidianMCPServer",
      "env": {
        "OBSIDIAN_BASE_URL": "http://127.0.0.1:27123",
        "OBSIDIAN_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

### Cursor

Add this to your Cursor MCP settings:

1. Open Cursor Settings
2. Navigate to "Tools & Integration"
3. Add a new server:

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "/path/to/ObsidianMCPServer",
      "env": {
        "OBSIDIAN_BASE_URL": "http://127.0.0.1:27123",
        "OBSIDIAN_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

### Other MCP-Compatible Tools

For any MCP-compatible tool, use the same configuration pattern:
- **Command**: Path to the `ObsidianMCPServer` executable
- **Environment**: Set `OBSIDIAN_BASE_URL` and `OBSIDIAN_API_KEY`
- **Transport**: stdio (default)

## 🛠️ Available MCP Tools

### Server Information
- `getServerInfo()` - Get Obsidian server details and version, returns ServerInformation object with service name and version

### Active Note Operations
- `getActiveNote()` - Retrieve the currently active note, returns File object with filename and content
- `updateActiveNote(content)` - Replace active note content entirely
- `deleteActiveNote()` - Delete the active note
- `setActiveNoteFrontmatter(key, value)` - Set a frontmatter field in the active note
- `appendToActiveNoteFrontmatter(key, value)` - Append a value to a frontmatter field array in the active note

### Vault Note Operations
- `getNote(filename)` - Get any note by filename/path, returns File object with filename and content
- `createOrUpdateNote(filename, content)` - Create new or update existing note
- `appendToNote(filename, content)` - Append content to existing note
- `deleteNote(filename)` - Delete a specific note
- `setNoteFrontmatter(filename, key, value)` - Set a frontmatter field in a specific vault note
- `appendToNoteFrontmatter(filename, key, value)` - Append a value to a frontmatter field array in a specific vault note

### Directory Operations
- `listDirectory(directory)` - List files and folders in vault directories, returns newline-separated list of paths

### Search Operations
- `search(query, ignoreCase, wholeWord, isRegex)` - Search entire vault, returns array of SearchResult objects with path and relevance score

**Search Parameters**:
- `query` (required): The text or pattern to search for
- `ignoreCase` (optional): Whether to perform case-insensitive search (default: true)
- `wholeWord` (optional): Whether to match whole words only (default: false)
- `isRegex` (optional): Whether to treat the query as a regular expression (default: false)

**Return Types**:
- `File`: Object with `filename` (string) and `content` (string) properties
- `SearchResult`: Object with `path` (string) and `score` (double) properties
- `ServerInformation`: Object with `service` (string) and `version` (string) properties

### MCP Prompts
- `summarizeNote(filename, focus)` - Generate structured prompts for analyzing Obsidian notes with comprehensive focus options
- `analyzeActiveNote(focus)` - Generate structured prompts for analyzing the currently active note in Obsidian
- `generateFollowUpQuestions(filename, questionCount)` - Generate thought-provoking follow-up questions based on note content

**Note Analysis Prompt Parameters**:
- `filename` (required): The filename or path of the note to analyze
- `focus` (optional): The type of analysis to perform (default: `.general`)

**Active Note Analysis Prompt Parameters**:
- `focus` (optional): The type of analysis to perform (default: `.general`)

**Follow-Up Questions Prompt Parameters**:
- `filename` (required): The filename or path of the note to analyze
- `questionCount` (optional): The number of questions to generate (default: 5)

**Available Focus Types** (AnalysisFocus `enum`):
- `.general`: Comprehensive analysis including summary, themes, and actionable insights
- `.summarize`: Clear, concise summary of main content without detailed analysis
- `.themes`: Focus on identifying main themes, concepts, and topics discussed
- `.actionItems`: Extract all action items, tasks, deadlines, and next steps
- `.connections`: Suggest potential connections to other notes, topics, or concepts for linking
- `.tone`: Analyze mood, attitude, and emotional context of the writing
- `.grammar`: Review grammar, spelling, style, and clarity improvements with specific suggestions
- `.structure`: Analyze organization and suggest improvements to flow and layout
- `.questions`: Identify key questions raised and suggest follow-up questions for deeper exploration
- `.keywords`: Extract important keywords, terms, and concepts for tagging and searchability
- `.insights`: Focus on extracting key insights, learnings, and "aha moments"
- `.review`: Comprehensive review including strengths, weaknesses, and improvement suggestions

## 💡 Usage Examples

### Basic Operations

```markdown
# Ask your AI assistant:

"Show me all my notes about machine learning"
→ Uses search() to find ML-related notes with relevance scores

"Create a new note called 'Daily Standup 2024-01-15' with today's agenda"
→ Uses createOrUpdateNote() to create the note

"Add a new section to my 'Project Ideas' note with today's brainstorming"
→ Uses appendToNote() to add content to the note

"What's in my currently active note?"
→ Uses getActiveNote() to read current content and filename

"List all files in my 'Research' folder"
→ Uses listDirectory() to browse folder contents

"Set the 'status' frontmatter field to 'completed' in my active note"
→ Uses setActiveNoteFrontmatter() to update metadata

"Add 'project-alpha' to the tags array in my 'Project Ideas' note"
→ Uses appendToNoteFrontmatter() to add tags

"Generate a summary prompt for my 'Meeting Notes 2024-01-15' file"
→ Uses summarizeNote() prompt to create structured analysis

"Analyze my currently active note for action items"
→ Uses analyzeActiveNote() with focus=.actionItems for the note currently open in Obsidian

"Create follow-up questions for my research paper"
→ Uses generateFollowUpQuestions() to create 5 thought-provoking questions

"Generate 10 questions based on my philosophy notes"
→ Uses generateFollowUpQuestions() with questionCount=10 for deeper exploration

"Analyze the tone and mood of my currently open journal entry"
→ Uses analyzeActiveNote() with focus=.tone to understand emotional context

"Check grammar and style in my research draft"
→ Uses summarizeNote() with focus=.grammar for writing improvements

"Extract keywords from my brainstorming session notes"
→ Uses summarizeNote() with focus=.keywords for better tagging

"Get key insights from my conference attendance notes"
→ Uses summarizeNote() with focus=.insights to extract learnings
```

### Advanced Workflows

```markdown
# Research Assistant Workflow:
1. "Search for notes about 'quantum computing'"
2. "Create a summary note combining the key points"
3. "Add references section linking to original notes"

# Daily Note Management:
1. "Get my active daily note"
2. "Add today's completed tasks to the done section"
3. "Create tomorrow's note with carried-over tasks"

# Content Organization:
1. "Find all untagged notes in my vault"
2. "Suggest appropriate tags based on content"
3. "Update frontmatter with recommended tags using setNoteFrontmatter"

# Project Management:
1. "List all notes in my 'Projects' directory"
2. "Update project status in frontmatter fields"
3. "Add new project phases to existing project notes"

# Smart Analysis with Prompts:
1. "Use .summarize focus on my research paper for a quick overview"
2. "Apply .themes analysis to identify main concepts in my reading notes"
3. "Generate .actionItems analysis for my meeting notes"
4. "Use .tone analysis on my journal entries to understand emotional patterns"
5. "Apply .grammar focus to polish my writing drafts"
6. "Extract .keywords from my brainstorming sessions for better organization"
7. "Use .insights focus to capture key learnings from conference notes"
8. "Apply .structure analysis to improve note organization and flow"

# Active Note Workflows:
1. "Analyze my current note for action items without specifying filename"
2. "Get insights from whatever note I'm currently viewing"
3. "Generate follow-up questions for my active research note"
4. "Apply tone analysis to my currently open journal entry"

# Knowledge Exploration:
1. "Generate 10 follow-up questions for my philosophy paper"
2. "Create thought-provoking questions based on my research findings"
3. "Generate questions that encourage deeper thinking about my project"
4. "Create follow-up questions focusing on practical applications"
```

## 🏗️ Development

### Project Structure

```
ObsidianMCPServer/
├── Sources/
│   ├── ObsidianMCPServer/                    # Main MCP server executable
│   │   ├── Models/                           # ThreadSafeBox utility
│   │   ├── ObsidianMCPServer.swift           # MCP server implementation with @MCPTool and @MCPPrompt methods
│   │   └── main.swift                        # Command-line entry point
│   ├── ObsidianPrompt/                       # Prompt business logic layer
│   │   ├── Models/                           # AnalysisFocus enum and prompt models
│   │   ├── ObsidianPrompt.swift              # Prompt generation implementation
│   │   └── ObsidianPromptProtocol.swift      # Prompt protocols
│   ├── ObsidianRepository/                   # Data access layer
│   │   ├── Models/                           # Domain models (File, SearchResult, ServerInformation)
│   │   ├── ObsidianRepository.swift          # Repository implementation
│   │   └── ObsidianRepositoryProtocol.swift  # Repository protocols
│   └── ObsidianNetworking/                   # HTTP client and API models
│       ├── Factories/                        # Request and client factories
│       └── Models/                           # Network response models
├── Tests/                                    # Comprehensive test suite
│   ├── ObsidianMCPServerTests/               # MCP server tests
│   ├── ObsidianPromptTests/                  # Prompt generation tests
│   ├── ObsidianRepositoryTests/              # Repository layer tests
│   └── ObsidianNetworkingTests/              # Network layer tests
└── Package.swift                             # Swift Package Manager configuration
```

### Key Dependencies

- **[SwiftMCP](https://github.com/Cocoanetics/SwiftMCP)** - Model Context Protocol implementation
- **[MicroClient](https://github.com/otaviocc/MicroClient)** - HTTP networking layer
- **ArgumentParser** - Command-line interface
- **SwiftLintPlugins** - Code quality and style enforcement

### Building for Development

```bash
# Clone and setup
git clone https://github.com/otaviocc/ObsidianMCPServer.git
cd ObsidianMCPServer

# Run tests
swift test

# Build debug version
swift build

# Build release version
swift build -c release

# Run with environment variables
OBSIDIAN_BASE_URL="http://127.0.0.1:27123" \
OBSIDIAN_API_KEY="your-key" \
swift run ObsidianMCPServer
```

### Testing

The project includes comprehensive tests:

```bash
# Run all tests
swift test

# Run specific test targets
swift test --filter ObsidianMCPServerTests
swift test --filter ObsidianPromptTests
swift test --filter ObsidianRepositoryTests
swift test --filter ObsidianNetworkingTests

# Generate test coverage
swift test --enable-code-coverage
```

## 🔒 Security Considerations

- **API Key**: Keep your Obsidian API key secure and never commit it to version control
- **Network**: The Local REST API runs on localhost by default (secure)
- **HTTPS**: Enable HTTPS in the Obsidian plugin for encrypted communication (port 27124)
- **Access**: The server can read/write your entire vault - use with trusted AI tools only

## 🐛 Troubleshooting

### Common Issues

**Connection Failed**:
- Verify Obsidian Local REST API plugin is installed and running
- Check the base URL matches your plugin settings (HTTP: 27123, HTTPS: 27124)
- Ensure API key is correct

**Permission Denied**:
- Check Obsidian is running and vault is open

**Build Errors**:
- Ensure you have Swift 6.0+ and Xcode 15.0+
- Try `swift package clean` and rebuild

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes with tests
4. Ensure all tests pass: `swift test`
5. Commit with clear messages: `git commit -m 'Add amazing feature'`
6. Push to your fork: `git push origin feature/amazing-feature`
7. Open a Pull Request

### Development Guidelines

- Follow Swift API Design Guidelines
- Add comprehensive tests for new features
- Include documentation for public APIs
- Run SwiftLint for code style consistency

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Obsidian](https://obsidian.md) for the incredible note-taking platform
- [Obsidian Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api) plugin developers
- [SwiftMCP](https://github.com/Cocoanetics/SwiftMCP) for the MCP implementation
- The Model Context Protocol community

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/otaviocc/ObsidianMCPServer/issues)
- **Documentation**: This README and inline code documentation

---

**Built with ❤️ for the Obsidian and AI community**
