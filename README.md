# ObsidianMCPServer

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

### 🏷️ Metadata Management
- **Frontmatter Fields**: Set individual frontmatter properties
- **Frontmatter Arrays**: Append to frontmatter arrays (like tags)
- **Active & Vault Notes**: Manage frontmatter for any note

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

### Option 1: Build from Source

```bash
# Clone the repository
git clone https://github.com/yourusername/ObsidianMCPServer.git
cd ObsidianMCPServer

# Build the project
swift build -c release

# The executable will be at: .build/release/ObsidianMCPServer
```

### Option 2: Download Release

Download the latest release from the [Releases page](https://github.com/yourusername/ObsidianMCPServer/releases) and extract the binary.

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
- `getServerInfo()` - Get Obsidian server details and version

### Active Note Operations
- `getActiveNote()` - Retrieve the currently active note
- `updateActiveNote(content)` - Replace active note content entirely
- `deleteActiveNote()` - Delete the active note
- `setActiveNoteFrontmatter(key, value)` - Set a frontmatter field in the active note
- `appendToActiveNoteFrontmatter(key, value)` - Append a value to a frontmatter field array in the active note

### Vault Note Operations
- `getNote(filename)` - Get any note by filename/path
- `createOrUpdateNote(filename, content)` - Create new or update existing note
- `appendToNote(filename, content)` - Append content to existing note
- `deleteNote(filename)` - Delete a specific note
- `setNoteFrontmatter(filename, key, value)` - Set a frontmatter field in a specific vault note
- `appendToNoteFrontmatter(filename, key, value)` - Append a value to a frontmatter field array in a specific vault note

### Directory Operations
- `listDirectory(directory)` - List files and folders in vault directories

### Search Operations
- `search(query, ignoreCase, wholeWord, isRegex)` - Search entire vault

**Search Parameters**:
- `query` (required): The text or pattern to search for
- `ignoreCase` (optional): Whether to perform case-insensitive search (default: true)
- `wholeWord` (optional): Whether to match whole words only (default: false)
- `isRegex` (optional): Whether to treat the query as a regular expression (default: false)

## 💡 Usage Examples

### Basic Operations

```markdown
# Ask your AI assistant:

"Show me all my notes about machine learning"
→ Uses search() to find ML-related notes

"Create a new note called 'Daily Standup 2024-01-15' with today's agenda"
→ Uses createOrUpdateNote() to create the note

"Add a new section to my 'Project Ideas' note with today's brainstorming"
→ Uses appendToNote() to add content to the note

"What's in my currently active note?"
→ Uses getActiveNote() to read current content

"List all files in my 'Research' folder"
→ Uses listDirectory() to browse folder contents

"Set the 'status' frontmatter field to 'completed' in my active note"
→ Uses setActiveNoteFrontmatter() to update metadata

"Add 'project-alpha' to the tags array in my 'Project Ideas' note"
→ Uses appendToNoteFrontmatter() to add tags
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
```

## 🏗️ Development

### Project Structure

```
ObsidianMCPServer/
├── Sources/
│   ├── ObsidianMCPServer/           # MCP server implementation
│   │   ├── Models/                  # Data models (File, SearchResult, etc.)
│   │   ├── ObsidianMCPServer.swift  # Main MCP server with @MCPTool methods
│   └── ObsidianRepository.swift # Business logic layer
│   └── ObsidianNetworking/          # HTTP client and API models
│       ├── Factories/               # Request and client factories
│       └── Models/                  # Network response models
├── Tests/                           # Comprehensive test suite
└── Package.swift                    # Swift Package Manager configuration
```

### Key Dependencies

- **[SwiftMCP](https://github.com/Cocoanetics/SwiftMCP)** - Model Context Protocol implementation
- **[MicroClient](https://github.com/otaviocc/MicroClient)** - HTTP networking layer
- **ArgumentParser** - Command-line interface
- **SwiftLintPlugins** - Code quality and style enforcement

### Building for Development

```bash
# Clone and setup
git clone https://github.com/yourusername/ObsidianMCPServer.git
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
- Verify the API key has the required permissions
- Check Obsidian is running and vault is open

**Build Errors**:
- Ensure you have Swift 6.0+ and Xcode 15.0+
- Try `swift package clean` and rebuild

### Debug Mode

Run with verbose logging:

```bash
export OBSIDIAN_BASE_URL="http://127.0.0.1:27123"
export OBSIDIAN_API_KEY="your-key"
export DEBUG=1
./ObsidianMCPServer
```

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

- **Issues**: [GitHub Issues](https://github.com/yourusername/ObsidianMCPServer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/ObsidianMCPServer/discussions)
- **Documentation**: This README and inline code documentation

---

**Built with ❤️ for the Obsidian and AI community**
