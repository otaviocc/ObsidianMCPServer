# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Building and Testing
- **Build development**: `swift build`
- **Build release**: `swift build -c release`
- **Run tests**: `swift test` (280+ test cases across all modules)
- **Clean build**: `swift package clean`
- **Lint code**: SwiftLint is integrated via build plugins and runs automatically during builds

### Installation Options
- **From source**: `swift build -c release` (executable at `.build/release/ObsidianMCPServer`)
- **Via Homebrew**: `brew tap otaviocc/mcp && brew install obsidian-mcp-server` (executable at `/opt/homebrew/bin/obsidian-mcp-server`)
- **Via Mint**: `mint install otaviocc/ObsidianMCPServer` (executable at `$HOME/.mint/bin/ObsidianMCPServer`)

### Runtime Configuration
The server requires these environment variables:
- `OBSIDIAN_BASE_URL`: URL of the Obsidian Local REST API (typically `http://127.0.0.1:27123`)
- `OBSIDIAN_API_KEY`: API key from the Obsidian Local REST API plugin

## Architecture Overview

This is a **Swift-based Model Context Protocol (MCP) server** that bridges AI tools with Obsidian vaults through the Local REST API plugin. The architecture follows a clean, modular design with clear separation of concerns.

### Module Structure
- **ObsidianMCPServer/**: Main executable with MCP server implementation and CLI entry point
- **ObsidianModels/**: Core enum definitions (Language, WritingStyle, AnalysisFocus, etc.)
- **ObsidianNetworking/**: HTTP client layer with factories and response models
- **ObsidianRepository/**: Data access layer implementing vault operations
- **ObsidianPrompt/**: AI prompt generation for analysis and transformation tasks
- **ObsidianResource/**: MCP resource endpoints for enum discovery

### Key Dependencies
- **SwiftMCP**: Core MCP protocol implementation (from Cocoanetics)
- **MicroClient**: HTTP networking client
- **ArgumentParser**: CLI interface
- **AnyCodable**: JSON handling utilities
- **SwiftLintPlugins**: Code quality enforcement

### MCP Integration Pattern
The server uses the `@MCPServer`, `@MCPTool`, `@MCPPrompt`, and `@MCPResource` attributes to expose functionality:
- **Tools**: Direct vault operations (CRUD, search, frontmatter management)
- **Prompts**: Structured templates for AI analysis and content transformation
- **Resources**: Enum discovery endpoints for dynamic parameter options

### Networking Architecture
HTTP requests flow through:
1. `ObsidianRequestFactory` - Builds REST API requests
2. `ObsidianAPIFactory` - Creates configured HTTP clients
3. `ObsidianRepository` - Abstracts vault operations
4. Response models in `ObsidianNetworking/Models/`

### Error Handling
- `RepositoryError` enum for domain-specific errors
- Network validation through `NetworkResponse+Validation` extension
- Structured error propagation from HTTP layer to MCP tools

### Thread Safety
- `ThreadSafeBox<T>` for concurrent access patterns
- Async/await throughout the codebase
- Proper semaphore usage in main entry point

## Development Patterns

### Testing Structure
Each module has comprehensive test coverage with:
- **Unit tests**: Test individual components in isolation
- **Integration tests**: Test interactions between modules
- **Mock objects**: `*Mock.swift` files provide test doubles
- **Test fixtures**: `*Mother.swift` files provide test data builders

### Unit Testing Guidelines
This project uses **Apple's Swift Testing framework** (`import Testing`) with the following conventions:

#### Test Structure and Organization
- Tests are organized using `@Suite("Suite Name")` to group related test cases
- Use descriptive test names with `@Test("It should...")` following the pattern: "It should [expected behavior]"
- Test method names should be descriptive without the `test` prefix (not required in Swift Testing framework)
- Follow **Given/When/Then** structure within test methods for clarity

#### Assertion Format
- Use `#expect()` for all test assertions with **one argument per line**
- Each `#expect()` should include a descriptive message as the second parameter
- Message format: "It should [describe what is being verified]"

#### Example Test Structure
```swift
@Suite("Component Tests")
struct ComponentTests {
    
    @Test("It should perform expected behavior")
    func performExpectedBehavior() async throws {
        // Given
        let input = setupTestData()
        
        // When
        let result = performOperation(input)
        
        // Then
        #expect(
            result.property == expectedValue,
            "It should have the correct property value"
        )
        #expect(
            result.isValid == true,
            "It should be in a valid state"
        )
    }
}
```

#### Mock and Fixture Usage
- Use `*Mock.swift` files for test doubles with configurable behavior
- Use `*Mother.swift` factories for creating test data consistently
- Follow the Mother pattern: `static func makeObject() -> ObjectType`
- Example: `NetworkClientMother.makeMockNetworkClient()`

#### Mock Implementation Guidelines
Mocks in this project follow a consistent pattern for capturing method calls and enabling test expectations:

**Call Tracking Pattern:**
- Add `methodNameCalled: Bool` property for call verification
- Add `methodNameCallCount: Int` property for counting calls
- Add `lastMethodParameterName: Type?` properties to capture method parameters
- Increment call counters and set call flags at the start of each mock method

**Error Injection:**
- Check `errorToThrow: Error?` property and throw if set
- This allows tests to verify error handling behavior

**Return Value Stubbing:**
- Use dedicated properties like `resultToReturn: ResultType?` for configurable return values
- Force unwrap (`resultToReturn!`) to crash if not properly stubbed in tests
- This ensures tests explicitly configure expected return values rather than using fallbacks

**Example Mock Method Pattern:**
```swift
func methodName(parameter: String) async throws -> ResultType {
    methodNameCalled = true
    methodNameCallCount += 1
    lastMethodParameter = parameter
    
    if let error = errorToThrow {
        throw error
    }
    
    return resultToReturn!
}
```

This pattern enables tests to:
- Verify methods were called with correct parameters
- Configure specific return values for test scenarios
- Test error handling by injecting errors
- Ensure all return values are explicitly configured (no silent fallbacks)

#### Async Testing
- Use `async throws` for test methods that test async operations
- Properly handle errors with do/catch blocks when testing error conditions
- Use `#expect(Bool(false), "It should throw an error...")` for failure cases in catch blocks

### Code Organization
- Protocol-oriented design with `*Protocol.swift` interfaces
- Extension-based feature grouping (e.g., `ObsidianRepository` split across multiple extensions)
- Consistent factory pattern for dependency injection
- Clear separation between domain models and network DTOs

### SwiftLint Integration
All targets include SwiftLintBuildToolPlugin for consistent code style enforcement during builds.