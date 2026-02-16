// MIT License
//
// Copyright (c) 2026 Otávio C.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import ArgumentParser
import Foundation
import SwiftMCP

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
            logToStderr("Check environment variables OBSIDIAN_BASE_URL and OBSIDIAN_API_KEY")
            throw ExitCode.failure
        }

        let server = ObsidianMCPServer(baseURL: baseURL) {
            apiKey
        }

        logToStderr("MCP Server ObsidianMCPServer started with stdio transport")
        logToStderr("Base URL: \(baseURL.absoluteString)")

        let semaphore = DispatchSemaphore(value: 0)
        let errorBox = ThreadSafeBox<Error?>(nil)

        Task {
            do {
                let transport = StdioTransport(server: server)
                try await transport.run()
            } catch {
                errorBox.setValue(error)
                logToStderr("Error: \(error)")
            }
            semaphore.signal()
        }

        semaphore.wait()

        if let error = errorBox.value {
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
