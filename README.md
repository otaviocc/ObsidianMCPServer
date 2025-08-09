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

### Tools

| Name | Group | Description |
|---|---|---|
| `getServerInfo()` | Server | Get Obsidian server details |
| `getActiveNote()` | Active Note | Get currently active note |
| `updateActiveNote(content)` | Active Note | Replace active note content |
| `deleteActiveNote()` | Active Note | Delete active note |
| `setActiveNoteFrontmatterString(key, value)` | Active Note | Set frontmatter string field |
| `appendToActiveNoteFrontmatterString(key, value)` | Active Note | Append to frontmatter string field |
| `setActiveNoteFrontmatterArray(key, values)` | Active Note | Set frontmatter array field |
| `appendToActiveNoteFrontmatterArray(key, values)` | Active Note | Append to frontmatter array field |
| `getNote(filename)` | Vault Note | Get any note by filename |
| `createOrUpdateNote(filename, content)` | Vault Note | Create or update a note |
| `appendToNote(filename, content)` | Vault Note | Append content to a note |
| `deleteNote(filename)` | Vault Note | Delete specific note |
| `setNoteFrontmatterString(filename, key, value)` | Vault Note | Set frontmatter string field |
| `appendToNoteFrontmatterString(filename, key, value)` | Vault Note | Append to frontmatter string field |
| `setNoteFrontmatterArray(filename, key, values)` | Vault Note | Set frontmatter array field |
| `appendToNoteFrontmatterArray(filename, key, values)` | Vault Note | Append to frontmatter array field |
| `listDirectory(directory)` | Directory & Search | List vault contents |
| `search(query)` | Directory & Search | Search entire vault |
| `bulkApplyTagsFromSearch(query, tags)` | Bulk Operations | Apply tags to search matches |
| `bulkReplaceFrontmatterStringFromSearch(query, key, value)` | Bulk Operations | Replace frontmatter string for matches |
| `bulkReplaceFrontmatterArrayFromSearch(query, key, value)` | Bulk Operations | Replace frontmatter array for matches |
| `bulkAppendToFrontmatterStringFromSearch(query, key, value)` | Bulk Operations | Append to frontmatter string for matches |
| `bulkAppendToFrontmatterArrayFromSearch(query, key, value)` | Bulk Operations | Append to frontmatter array for matches |
| `getDailyNote()` | Periodic Notes (current) | Get the daily note |
| `getWeeklyNote()` | Periodic Notes (current) | Get the weekly note |
| `getMonthlyNote()` | Periodic Notes (current) | Get the monthly note |
| `getQuarterlyNote()` | Periodic Notes (current) | Get the quarterly note |
| `getYearlyNote()` | Periodic Notes (current) | Get the yearly note |
| `createOrUpdateDailyNote(content)` | Periodic Notes (current) | Create or replace daily note |
| `createOrUpdateWeeklyNote(content)` | Periodic Notes (current) | Create or replace weekly note |
| `createOrUpdateMonthlyNote(content)` | Periodic Notes (current) | Create or replace monthly note |
| `createOrUpdateQuarterlyNote(content)` | Periodic Notes (current) | Create or replace quarterly note |
| `createOrUpdateYearlyNote(content)` | Periodic Notes (current) | Create or replace yearly note |
| `appendToDailyNote(content)` | Periodic Notes (current) | Append to daily note |
| `appendToWeeklyNote(content)` | Periodic Notes (current) | Append to weekly note |
| `appendToMonthlyNote(content)` | Periodic Notes (current) | Append to monthly note |
| `appendToQuarterlyNote(content)` | Periodic Notes (current) | Append to quarterly note |
| `appendToYearlyNote(content)` | Periodic Notes (current) | Append to yearly note |
| `deleteDailyNote()` | Periodic Notes (current) | Delete daily note |
| `deleteWeeklyNote()` | Periodic Notes (current) | Delete weekly note |
| `deleteMonthlyNote()` | Periodic Notes (current) | Delete monthly note |
| `deleteQuarterlyNote()` | Periodic Notes (current) | Delete quarterly note |
| `deleteYearlyNote()` | Periodic Notes (current) | Delete yearly note |
| `getDailyNoteForDate(year, month, day)` | Periodic Notes (date) | Get daily note for date |
| `getWeeklyNoteForDate(year, month, day)` | Periodic Notes (date) | Get weekly note for date |
| `getMonthlyNoteForDate(year, month, day)` | Periodic Notes (date) | Get monthly note for date |
| `getQuarterlyNoteForDate(year, month, day)` | Periodic Notes (date) | Get quarterly note for date |
| `getYearlyNoteForDate(year, month, day)` | Periodic Notes (date) | Get yearly note for date |
| `deleteDailyNoteForDate(year, month, day)` | Periodic Notes (date) | Delete daily note for date |
| `deleteWeeklyNoteForDate(year, month, day)` | Periodic Notes (date) | Delete weekly note for date |
| `deleteMonthlyNoteForDate(year, month, day)` | Periodic Notes (date) | Delete monthly note for date |
| `deleteQuarterlyNoteForDate(year, month, day)` | Periodic Notes (date) | Delete quarterly note for date |
| `deleteYearlyNoteForDate(year, month, day)` | Periodic Notes (date) | Delete yearly note for date |
| `appendToDailyNoteForDate(year, month, day, content)` | Periodic Notes (date) | Append to daily note for date |
| `appendToWeeklyNoteForDate(year, month, day, content)` | Periodic Notes (date) | Append to weekly note for date |
| `appendToMonthlyNoteForDate(year, month, day, content)` | Periodic Notes (date) | Append to monthly note for date |
| `appendToQuarterlyNoteForDate(year, month, day, content)` | Periodic Notes (date) | Append to quarterly note for date |
| `appendToYearlyNoteForDate(year, month, day, content)` | Periodic Notes (date) | Append to yearly note for date |
| `createOrUpdateDailyNoteForDate(year, month, day, content)` | Periodic Notes (date) | Create/replace daily note for date |
| `createOrUpdateWeeklyNoteForDate(year, month, day, content)` | Periodic Notes (date) | Create/replace weekly note for date |
| `createOrUpdateMonthlyNoteForDate(year, month, day, content)` | Periodic Notes (date) | Create/replace monthly note for date |
| `createOrUpdateQuarterlyNoteForDate(year, month, day, content)` | Periodic Notes (date) | Create/replace quarterly note for date |
| `createOrUpdateYearlyNoteForDate(year, month, day, content)` | Periodic Notes (date) | Create/replace yearly note for date |

### Prompts

| Name | Group | Description |
|---|---|---|
| `analyzeNote(filename, focus)` | Analysis | Analyze an Obsidian note with focus types |
| `analyzeActiveNote(focus)` | Analysis | Analyze the currently active note |
| `generateFollowUpQuestions(filename, questionCount)` | Questions | Generate follow‑up questions |
| `suggestTags(filename, maxTags)` | Metadata | Suggest relevant tags for a note |
| `generateFrontmatter(filename)` | Metadata | Generate complete frontmatter structure |
| `suggestActiveNoteTags(maxTags)` | Metadata | Tag suggestions for active note |
| `extractMetadata(filename)` | Metadata | Extract structured metadata from content |
| `rewriteActiveNote(style)` | Transformation | Rewrite active note in a style |
| `translateActiveNote(language)` | Transformation | Translate active note to a language |
| `generateActiveNoteAbstract(length)` | Generation | Generate abstract/summary |
| `generateActiveNoteOutline(style)` | Generation | Generate structured outline |
| `proofreadActiveNote()` | Proofreading | Proofread and correct grammar |

### Resources

| Name | Group | Description |
|---|---|---|
| `obsidian://enums` | Enum Discovery | List all available enum types |
| `obsidian://enums/language` | Enum Discovery | Translation languages |
| `obsidian://enums/writing-style` | Enum Discovery | Writing styles |
| `obsidian://enums/analysis-focus` | Enum Discovery | Analysis focus types |
| `obsidian://enums/abstract-length` | Enum Discovery | Summary lengths |
| `obsidian://enums/outline-style` | Enum Discovery | Outline formats |

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
