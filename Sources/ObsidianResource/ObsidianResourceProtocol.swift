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

import Foundation
import ObsidianModels

public protocol ObsidianResourceProtocol {

    /// Lists all available enum types used as parameters in prompt methods.
    ///
    /// This method provides an overview of all enum types available for prompt parameters,
    /// enabling clients to discover what enums exist and how to access their detailed information
    /// through the MCP Resource system.
    ///
    /// - Returns: JSON string containing enum types with descriptions and resource URIs
    /// - Throws: An error if the enum information cannot be generated
    func listEnumTypes() async throws -> String

    /// Gets detailed information about Language enum values.
    ///
    /// Returns comprehensive details about all available language options for translation,
    /// including raw values, descriptions, and language-specific instructions.
    ///
    /// - Returns: JSON string containing Language enum values and usage details
    /// - Throws: An error if the Language enum information cannot be generated
    func getLanguageEnum() async throws -> String

    /// Gets detailed information about WritingStyle enum values.
    ///
    /// Returns comprehensive details about all available writing style options for rewriting,
    /// including raw values, descriptions, and style-specific instructions.
    ///
    /// - Returns: JSON string containing WritingStyle enum values and usage details
    /// - Throws: An error if the WritingStyle enum information cannot be generated
    func getWritingStyleEnum() async throws -> String

    /// Gets detailed information about AnalysisFocus enum values.
    ///
    /// Returns comprehensive details about all available analysis focus options,
    /// including raw values, descriptions, and focus-specific instructions.
    ///
    /// - Returns: JSON string containing AnalysisFocus enum values and usage details
    /// - Throws: An error if the AnalysisFocus enum information cannot be generated
    func getAnalysisFocusEnum() async throws -> String

    /// Gets detailed information about AbstractLength enum values.
    ///
    /// Returns comprehensive details about all available abstract length options,
    /// including raw values, descriptions, and length-specific instructions.
    ///
    /// - Returns: JSON string containing AbstractLength enum values and usage details
    /// - Throws: An error if the AbstractLength enum information cannot be generated
    func getAbstractLengthEnum() async throws -> String

    /// Gets detailed information about OutlineStyle enum values.
    ///
    /// Returns comprehensive details about all available outline style options,
    /// including raw values, descriptions, and style-specific instructions.
    ///
    /// - Returns: JSON string containing OutlineStyle enum values and usage details
    /// - Throws: An error if the OutlineStyle enum information cannot be generated
    func getOutlineStyleEnum() async throws -> String
}
