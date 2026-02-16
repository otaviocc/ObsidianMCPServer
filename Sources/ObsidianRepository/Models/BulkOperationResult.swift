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
import SwiftMCP

/**
 Represents the result of a bulk operation performed on vault notes.

 This schema encapsulates the results of bulk operations like applying tags
 or updating frontmatter across multiple notes found via search. It provides
 detailed feedback about which operations succeeded and which failed.
 */
@Schema
public struct BulkOperationResult: Encodable {

    /// Filenames that were successfully processed
    public let successful: [String]

    /// Filenames that failed with their error details
    public let failed: [BulkOperationFailure]

    /// Total number of files processed
    public let totalProcessed: Int

    /// The original search query used to find the files
    public let query: String

    public init(
        successful: [String],
        failed: [BulkOperationFailure],
        totalProcessed: Int,
        query: String
    ) {
        self.successful = successful
        self.failed = failed
        self.totalProcessed = totalProcessed
        self.query = query
    }
}

/**
 Represents a failure that occurred during a bulk operation.

 This schema captures details about individual file operations that failed
 during bulk processing, including the filename and error message.
 */
@Schema
public struct BulkOperationFailure: Encodable {

    /// The filename that failed to be processed
    public let filename: String

    /// The error message describing what went wrong
    public let error: String

    public init(
        filename: String,
        error: String
    ) {
        self.filename = filename
        self.error = error
    }
}
