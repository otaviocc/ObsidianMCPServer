import Foundation
import SwiftMCP
import ArgumentParser

struct ObsidianMCPCommand: ParsableCommand {

    // MARK: - Properties

    static let configuration = CommandConfiguration(
        commandName: "ObsidianMCPServer",
        abstract: "Obsidian MCP Server - access Obsidian via REST API"
    )

    // MARK: - Public

    func run() throws {
        guard let baseURLString = ProcessInfo.processInfo.environment["OBSIDIAN_BASE_URL"],
              let apiKey = ProcessInfo.processInfo.environment["OBSIDIAN_API_KEY"],
              let baseURL = URL(string: baseURLString)
        else {
            logToStderr("MCP Server ObsidianMCPServer failed to start")
            throw ExitCode.failure
        }

        let server = ObsidianMCPServer(baseURL: baseURL) {
            apiKey
        }

        logToStderr("MCP Server ObsidianMCPServer (1.0.0) started with stdio transport")
        logToStderr("Base URL: \(baseURL.absoluteString)")

        let semaphore = DispatchSemaphore(value: 0)
        var thrownError: Error?

        Task {
            do {
                let transport = StdioTransport(server: server)
                try await transport.run()
            } catch {
                thrownError = error
                logToStderr("Error: \(error)")
            }
            semaphore.signal()
        }

        semaphore.wait()

        if let error = thrownError {
            throw error
        }
    }

    // MARK: - Private

    private func logToStderr(_ message: String) {
        guard let data = (message + "\n").data(using: .utf8) else { return }
        try? FileHandle.standardError.write(contentsOf: data)
    }
}

ObsidianMCPCommand.main()
