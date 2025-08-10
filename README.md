# ObsidianMCPServer

[![codecov](https://codecov.io/github/otaviocc/ObsidianMCPServer/graph/badge.svg?token=684ATBMZH4)](https://codecov.io/github/otaviocc/ObsidianMCPServer)
[![Check Runs](https://img.shields.io/github/check-runs/otaviocc/ObsidianMCPServer/main)](https://github.com/otaviocc/ObsidianMCPServer/actions?query=branch%3Amain)
[![Mastodon Follow](https://img.shields.io/mastodon/follow/109580944375344260?domain=social.lol&style=flat)](https://social.lol/@otaviocc)

Connect your AI assistant to Obsidian! This Model Context Protocol (MCP) server enables Claude, Cursor, and other AI tools to read, write, search, and manage your Obsidian notes through the Local REST API.

## 🚀 Quick Setup

### 1. Install Obsidian Plugin

1. **Install "Local REST API"** from Community Plugins in Obsidian
2. **Set an API key** in plugin settings
3. **Start the server** using Command Palette: "Local REST API: Start"
4. **Note the URL**: `http://127.0.0.1:27123` (default)

### 2. Install ObsidianMCPServer

**Option A: Install from source code directly**

```bash
git clone https://github.com/otaviocc/ObsidianMCPServer.git
cd ObsidianMCPServer
swift build -c release

# The executable will be at: .build/release/ObsidianMCPServer
```

**Option B: Install via [Brew](https://brew.sh) 🤩**

```bash
brew tap otaviocc/mcp
brew install obsidian-mcp-server

# The executable will be at: `/opt/homebrew/bin/obsidian-mcp-server`
```

**Option C: Install via [Mint](https://github.com/yonaskolb/Mint)**

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
- **Brew install**: `/opt/homebrew/bin/obsidian-mcp-server`
- **Mint install**: `$HOME/.mint/bin/ObsidianMCPServer`

Also replace `your-api-key-here` with your plugin's API key.

## 🛠️ Available Features

### Tools

**Server:** Basic server identification and connection information for the Obsidian MCP interface.

- `getServerInfo()`: Get Obsidian server details

**Active Note:** Operations for working with the currently open note in Obsidian's interface, providing direct access to read, modify, and manage the active document and its metadata.

- `getActiveNote()`: Get currently active note
- `updateActiveNote(content)`: Replace active note content
- `deleteActiveNote()`: Delete active note
- `setActiveNoteFrontmatterString(key, value)`: Set frontmatter string field
- `appendToActiveNoteFrontmatterString(key, value)`: Append to frontmatter string field
- `setActiveNoteFrontmatterArray(key, values)`: Set frontmatter array field
- `appendToActiveNoteFrontmatterArray(key, values)`: Append to frontmatter array field

**Vault Note:** File operations for any note in the vault by filename, enabling programmatic access to create, read, update, delete notes and manage their frontmatter throughout the entire vault structure.

- `getNote(filename)`: Get any note by filename
- `createOrUpdateNote(filename, content)`: Create or update a note
- `appendToNote(filename, content)`: Append content to a note
- `deleteNote(filename)`: Delete specific note
- `setNoteFrontmatterString(filename, key, value)`: Set frontmatter string field
- `appendToNoteFrontmatterString(filename, key, value)`: Append to frontmatter string field
- `setNoteFrontmatterArray(filename, key, values)`: Set frontmatter array field
- `appendToNoteFrontmatterArray(filename, key, values)`: Append to frontmatter array field

**Directory & Search:** Vault exploration and content discovery tools for browsing directory structures and performing text-based searches across all notes.

- `listDirectory(directory)`: List vault contents
- `search(query)`: Search entire vault

**Bulk Operations:** Batch processing tools that apply changes to multiple notes simultaneously based on search criteria, enabling efficient vault-wide metadata and tag management.

- `bulkApplyTagsFromSearch(query, tags)`: Apply tags to search matches
- `bulkReplaceFrontmatterStringFromSearch(query, key, value)`: Replace frontmatter string for matches
- `bulkReplaceFrontmatterArrayFromSearch(query, key, value)`: Replace frontmatter array for matches
- `bulkAppendToFrontmatterStringFromSearch(query, key, value)`: Append to frontmatter string for matches
- `bulkAppendToFrontmatterArrayFromSearch(query, key, value)`: Append to frontmatter array for matches

**Periodic Notes (Current):** Integration with the Periodic Notes plugin for managing time-based notes (daily, weekly, monthly, quarterly, yearly) for the current time period, supporting journaling and time-based workflows.

- `getDailyNote()`: Get the daily note
- `getWeeklyNote()`: Get the weekly note
- `getMonthlyNote()`: Get the monthly note
- `getQuarterlyNote()`: Get the quarterly note
- `getYearlyNote()`: Get the yearly note
- `createOrUpdateDailyNote(content)`: Create or replace daily note
- `createOrUpdateWeeklyNote(content)`: Create or replace weekly note
- `createOrUpdateMonthlyNote(content)`: Create or replace monthly note
- `createOrUpdateQuarterlyNote(content)`: Create or replace quarterly note
- `createOrUpdateYearlyNote(content)`: Create or replace yearly note
- `appendToDailyNote(content)`: Append to daily note
- `appendToWeeklyNote(content)`: Append to weekly note
- `appendToMonthlyNote(content)`: Append to monthly note
- `appendToQuarterlyNote(content)`: Append to quarterly note
- `appendToYearlyNote(content)`: Append to yearly note
- `deleteDailyNote()`: Delete daily note
- `deleteWeeklyNote()`: Delete weekly note
- `deleteMonthlyNote()`: Delete monthly note
- `deleteQuarterlyNote()`: Delete quarterly note
- `deleteYearlyNote()`: Delete yearly note

**Periodic Notes (Date-Specific):** Advanced periodic note operations that target specific historical or future dates, enabling precise temporal note management and retrospective journaling workflows.

- `getDailyNoteForDate(year, month, day)`: Get daily note for date
- `getWeeklyNoteForDate(year, month, day)`: Get weekly note for date
- `getMonthlyNoteForDate(year, month, day)`: Get monthly note for date
- `getQuarterlyNoteForDate(year, month, day)`: Get quarterly note for date
- `getYearlyNoteForDate(year, month, day)`: Get yearly note for date
- `deleteDailyNoteForDate(year, month, day)`: Delete daily note for date
- `deleteWeeklyNoteForDate(year, month, day)`: Delete weekly note for date
- `deleteMonthlyNoteForDate(year, month, day)`: Delete monthly note for date
- `deleteQuarterlyNoteForDate(year, month, day)`: Delete quarterly note for date
- `deleteYearlyNoteForDate(year, month, day)`: Delete yearly note for date
- `appendToDailyNoteForDate(year, month, day, content)`: Append to daily note for date
- `appendToWeeklyNoteForDate(year, month, day, content)`: Append to weekly note for date
- `appendToMonthlyNoteForDate(year, month, day, content)`: Append to monthly note for date
- `appendToQuarterlyNoteForDate(year, month, day, content)`: Append to quarterly note for date
- `appendToYearlyNoteForDate(year, month, day, content)`: Append to yearly note for date
- `createOrUpdateDailyNoteForDate(year, month, day, content)`: Create/replace daily note for date
- `createOrUpdateWeeklyNoteForDate(year, month, day, content)`: Create/replace weekly note for date
- `createOrUpdateMonthlyNoteForDate(year, month, day, content)`: Create/replace monthly note for date
- `createOrUpdateQuarterlyNoteForDate(year, month, day, content)`: Create/replace quarterly note for date
- `createOrUpdateYearlyNoteForDate(year, month, day, content)`: Create/replace yearly note for date

### Prompts

**Analysis:** Structured prompts for examining and understanding note content with customizable focus areas, enabling comprehensive content analysis and insights.

- `analyzeNote(filename, focus)`: Analyze an Obsidian note with focus types
- `analyzeActiveNote(focus)`: Analyze the currently active note

**Questions:** Interactive prompt generation that creates thought-provoking follow-up questions to deepen engagement with note content.

- `generateFollowUpQuestions(filename, questionCount)`: Generate follow‑up questions

**Metadata:** Intelligent metadata extraction and suggestion tools that analyze content to recommend tags, frontmatter structures, and organizational elements.

- `suggestTags(filename, maxTags)`: Suggest relevant tags for a note
- `generateFrontmatter(filename)`: Generate complete frontmatter structure
- `suggestActiveNoteTags(maxTags)`: Tag suggestions for active note
- `extractMetadata(filename)`: Extract structured metadata from content

**Transformation:** Content modification prompts that reshape existing notes by changing writing style or translating to different languages while preserving structure and meaning.

- `rewriteActiveNote(style)`: Rewrite active note in a style
- `translateActiveNote(language)`: Translate active note to a language

**Generation:** Content creation prompts that produce structured derivatives of existing notes, including abstracts, summaries, and hierarchical outlines.

- `generateActiveNoteAbstract(length)`: Generate abstract/summary
- `generateActiveNoteOutline(style)`: Generate structured outline

**Proofreading:** Grammar and text enhancement tools that correct errors, improve readability, and polish writing while preserving technical content and Obsidian formatting.

- `proofreadActiveNote()`: Proofread and correct grammar

### Resources

**Enum Discovery:** Type system exploration tools that expose available parameter options for prompts, enabling better integration and user interface development.

- `obsidian://enums`: List all available enum types
- `obsidian://enums/language`: Translation languages
- `obsidian://enums/writing-style`: Writing styles
- `obsidian://enums/analysis-focus`: Analysis focus types
- `obsidian://enums/abstract-length`: Summary lengths
- `obsidian://enums/outline-style`: Outline formats

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

## 🏗️ Development

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

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Obsidian](https://obsidian.md) for the knowledge management platform
- [Obsidian Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api) plugin
- [SwiftMCP](https://github.com/Cocoanetics/SwiftMCP) for MCP implementation
- The Model Context Protocol community
