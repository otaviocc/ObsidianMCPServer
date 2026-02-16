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

final class ThreadSafeBox<T>: @unchecked Sendable {

    // MARK: - Properties

    private let lock = NSLock()
    private var _value: T

    var value: T {
        lock.withLock { _value }
    }

    // MARK: - Life cycle

    init(_ initialValue: T) {
        _value = initialValue
    }

    // MARK: - Public

    func setValue(_ newValue: T) {
        lock.withLock { _value = newValue }
    }

    @discardableResult
    func modify<R>(_ transform: (inout T) -> R) -> R {
        lock.withLock { transform(&_value) }
    }

    func withValue<R>(_ accessor: (T) -> R) -> R {
        lock.withLock { accessor(_value) }
    }

    @discardableResult
    func swap(_ newValue: T) -> T {
        lock.withLock {
            let oldValue = _value
            _value = newValue
            return oldValue
        }
    }
}
