# ObsidianMCPServer

[![codecov](https://codecov.io/github/otaviocc/ObsidianMCPServer/graph/badge.svg?token=684ATBMZH4)](https://codecov.io/github/otaviocc/ObsidianMCPServer)
[![Check Runs](https://img.shields.io/github/check-runs/otaviocc/ObsidianMCPServer/main)](https://github.com/otaviocc/ObsidianMCPServer/actions?query=branch%3Amain)
[![Mastodon Follow](https://img.shields.io/mastodon/follow/109580944375344260?domain=social.lol&style=flat)](https://social.lol/@otaviocc)

Connect your AI assistant to Obsidian! This Model Context Protocol (MCP) server enables Claude, Cursor, and other AI tools to read, write, search, and manage your Obsidian notes through the Local REST API.

## ✨ What You Can Do

🤖 **Ask your AI to:**
- *"Show me all my notes about machine learning"* → Search your vault with relevance scores
- *"Create a new meeting note with today's agenda"* → Generate structured notes
- *"Add this insight to my research project"* → Append content to existing notes
- *"Suggest tags for my current note"* → Auto-tag based on content analysis
- *"Translate my notes to Spanish"* → Multi-language content transformation
- *"Generate an outline of my research paper"* → Create structured summaries
- *"What action items are in my meeting notes?"* → Extract tasks and deadlines

🔍 **Smart Analysis & Generation**
- **12 Focus Types**: Analyze notes for themes, action items, insights, grammar, and more
- **Content Generation**: Create abstracts, outlines, and structured analysis
- **Multi-Language**: Translate to 12+ languages with proper localization
- **Style Transformation**: Rewrite in formal, casual, technical, ELI5, or creative styles

📝 **Full Note Management**
- Read and update any note in your vault
- Manage frontmatter fields and arrays (tags, metadata)
- Search across your entire knowledge base
- Navigate and organize your vault structure

## 🚀 Quick Setup

### 1. Install Obsidian Plugin

1. **Install "Local REST API"** from Community Plugins in Obsidian
2. **Set an API key** in plugin settings
3. **Start the server** using Command Palette: "Local REST API: Start"
4. **Note the URL**: `http://127.0.0.1:27123` (default)

### 2. Install ObsidianMCPServer

**Option A: Install from source code directly**

```bash
# Clone and build
git clone https://github.com/otaviocc/ObsidianMCPServer.git
cd ObsidianMCPServer
swift build -c release

# The executable will be at: .build/release/ObsidianMCPServer
```

**Option B: Install via [Mint](https://github.com/yonaskolb/Mint)**

```bash
mint install otaviocc/ObsidianMCPServer

# The executable will be at: `$HOME/.mint/bin/ObsidianMCPServer`
```

### 3. Configure Your AI Tool

**Claude Desktop** (`~/Library/Application Support/Claude/claude_desktop_config.json`):
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

**Cursor**: Add the same configuration in Settings → Tools & Integration

Replace `/path/to/ObsidianMCPServer` with your actual path:
- **Source build**: `.build/release/ObsidianMCPServer` (from your build directory)
- **Mint install**: `$HOME/.mint/bin/ObsidianMCPServer`

Also replace `your-api-key-here` with your plugin's API key.

## 🛠️ Available Features

### Core Operations
- **Search**: `search(query)` - Find notes across your vault
- **Active Note**: `getActiveNote()`, `updateActiveNote()`, `deleteActiveNote()`
- **Any Note**: `getNote(filename)`, `createOrUpdateNote()`, `appendToNote()`, `deleteNote()`
- **Browse**: `listDirectory()` - Navigate vault structure
- **Frontmatter**: Set and append to metadata fields and arrays

### Smart Analysis (12 Focus Types)
- **General**: Comprehensive overview with themes and insights
- **Summarize**: Clear, concise content summary
- **Action Items**: Extract tasks, deadlines, and next steps
- **Themes**: Identify main concepts and topics
- **Grammar**: Writing improvements and style suggestions
- **Keywords**: Extract terms for better organization
- **Insights**: Key learnings and "aha moments"
- **Connections**: Suggest links to other notes
- **Structure**: Organization and flow improvements
- **Questions**: Generate follow-up questions for deeper exploration
- **Tone**: Analyze mood and emotional context
- **Review**: Comprehensive strengths/weaknesses analysis

### Content Generation
- **Abstracts**: Brief, standard, or detailed summaries
- **Outlines**: Bullet points, numbered lists, or hierarchical format
- **Follow-up Questions**: Generate thought-provoking questions
- **Tag Suggestions**: Auto-suggest relevant tags
- **Frontmatter**: Generate complete metadata structure

### Content Transformation
- **Translation**: 12+ languages (Portuguese, Spanish, French, German, Italian, Japanese, Korean, Chinese, Russian, Arabic, Hindi, Dutch)
- **Writing Styles**: Formal, informal, technical, scientific, emoji, ELI5, creative, professional, academic, conversational

## 💡 Example Workflows

### Research Assistant
```
"Search for quantum computing notes" → "Create summary combining key points" → "Add references linking original notes"
```

### Meeting Management
```
"Get my active daily note" → "Add completed tasks to done section" → "Generate tomorrow's agenda"
```

### Content Organization
```
"Find untagged notes" → "Suggest appropriate tags" → "Update frontmatter automatically"
```

### Smart Analysis
```
"Analyze my research paper for key themes" → "Generate follow-up questions" → "Create detailed outline for presentation"
```

## 🔧 Requirements

- **macOS 12.0+** with **Swift 6.0+**
- **Obsidian** with **Local REST API plugin**
- **AI Tool** supporting MCP (Claude Desktop, Cursor, etc.)

## 🔒 Security

- API key stays local (never transmitted to external services)
- Server runs on localhost only
- Enable HTTPS in plugin for encrypted communication (port 27124)
- Only use with trusted AI applications

## 🐛 Troubleshooting

**Connection Issues:**
- Verify Obsidian Local REST API plugin is running
- Check base URL matches plugin settings (27123 for HTTP, 27124 for HTTPS)
- Confirm API key matches plugin configuration

**Build Issues:**
- Ensure Swift 6.0+ is installed
- Try `swift package clean` and rebuild

## 📋 Complete Tool Reference

<details>
<summary>Click to expand full tool list</summary>

### Server Information
- `getServerInfo()` - Get Obsidian server details

### Active Note Operations
- `getActiveNote()` - Get currently active note
- `updateActiveNote(content)` - Replace active note content
- `deleteActiveNote()` - Delete active note
- `setActiveNoteFrontmatterString(key, value)` - Set frontmatter field
- `appendToActiveNoteFrontmatterString(key, value)` - Append to frontmatter field
- `setActiveNoteFrontmatterArray(key, values)` - Set frontmatter array
- `appendToActiveNoteFrontmatterArray(key, values)` - Append to frontmatter array

### Vault Note Operations
- `getNote(filename)` - Get any note by filename
- `createOrUpdateNote(filename, content)` - Create or update note
- `appendToNote(filename, content)` - Append to existing note
- `deleteNote(filename)` - Delete specific note
- `setNoteFrontmatterString(filename, key, value)` - Set frontmatter field
- `appendToNoteFrontmatterString(filename, key, value)` - Append to frontmatter field
- `setNoteFrontmatterArray(filename, key, values)` - Set frontmatter array
- `appendToNoteFrontmatterArray(filename, key, values)` - Append to frontmatter array

### Directory & Search
- `listDirectory(directory)` - List vault contents
- `search(query)` - Search entire vault

### Analysis & Enhancement Prompts
- `summarizeNote(filename, focus)` - Analyze with 12 focus types
- `analyzeActiveNote(focus)` - Analyze current note
- `generateFollowUpQuestions(filename, questionCount)` - Create exploration questions
- `suggestTags(filename, maxTags)` - Auto-suggest tags
- `generateFrontmatter(filename)` - Generate metadata structure
- `suggestActiveNoteTags(maxTags)` - Tag suggestions for active note
- `extractMetadata(filename)` - Extract structured data

### Content Generation Prompts
- `generateActiveNoteAbstract(length)` - Create summaries (brief/standard/detailed)
- `generateActiveNoteOutline(style)` - Create outlines (bullets/numbered/hierarchical)

### Content Transformation Prompts
- `rewriteActiveNote(style)` - Transform writing style
- `translateActiveNote(language)` - Translate to other languages

### Enum Discovery (MCP Resources)
- `obsidian://enums` - List all available enum types
- `obsidian://enums/language` - Translation languages
- `obsidian://enums/writing-style` - Writing styles
- `obsidian://enums/analysis-focus` - Analysis focus types
- `obsidian://enums/abstract-length` - Summary lengths
- `obsidian://enums/outline-style` - Outline formats

</details>

---

## 🏗️ Development

<details>
<summary>Technical implementation details</summary>

### Project Structure
```
Sources/
├── ObsidianMCPServer/          # Main MCP server
├── ObsidianModels/             # Enum definitions
├── ObsidianPrompt/             # Prompt generation
├── ObsidianResource/           # Enum discovery
├── ObsidianRepository/         # Data access
└── ObsidianNetworking/         # HTTP client
```

### Key Dependencies
- **[SwiftMCP](https://github.com/Cocoanetics/SwiftMCP)** - MCP implementation
- **[MicroClient](https://github.com/otaviocc/MicroClient)** - HTTP networking
- **ArgumentParser** - CLI interface

### Building & Testing
```bash
# Development build
swift build

# Run tests (190+ test cases)
swift test

# Release build
swift build -c release
```

### Contributing
1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Add tests for new functionality
4. Ensure all tests pass: `swift test`
5. Submit Pull Request

</details>

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Obsidian](https://obsidian.md) for the knowledge management platform
- [Obsidian Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api) plugin
- [SwiftMCP](https://github.com/Cocoanetics/SwiftMCP) for MCP implementation
- The Model Context Protocol community

---

**Connect your AI to your knowledge base** 🧠✨
