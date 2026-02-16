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

import Testing
@testable import ObsidianRepository

@Suite("ServerInformation Model Tests")
struct ServerInformationTests {

    @Test("It should create ServerInformation model correctly")
    func serverInformationModel() {
        // Given/When
        let serverInfo = ServerInformation(service: "obsidian-api", version: "1.0.0")

        // Then
        #expect(
            serverInfo.service == "obsidian-api",
            "It should set the service name correctly"
        )
        #expect(
            serverInfo.version == "1.0.0",
            "It should set the version correctly"
        )
    }

    @Test("It should handle empty service name")
    func emptyServiceName() {
        // Given/When
        let serverInfo = ServerInformation(service: "", version: "1.0.0")

        // Then
        #expect(
            serverInfo.service.isEmpty,
            "It should handle empty service name"
        )
        #expect(
            serverInfo.version == "1.0.0",
            "It should preserve version with empty service"
        )
    }

    @Test("It should handle empty version")
    func emptyVersion() {
        // Given/When
        let serverInfo = ServerInformation(service: "obsidian-api", version: "")

        // Then
        #expect(
            serverInfo.service == "obsidian-api",
            "It should preserve service with empty version"
        )
        #expect(
            serverInfo.version.isEmpty,
            "It should handle empty version"
        )
    }
}
