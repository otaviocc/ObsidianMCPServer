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
        self._value = initialValue
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
