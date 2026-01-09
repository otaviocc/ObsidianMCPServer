import Foundation
import Testing
@testable import ObsidianMCPServer

@Suite("ThreadSafeBox Tests")
struct ThreadSafeBoxTests {

    // MARK: - Initialization Tests

    @Test("It should initialize with value")
    func initialization() {
        // Given/When
        let box = ThreadSafeBox(42)
        // Then
        #expect(box.value == 42)

        // Given/When
        let stringBox = ThreadSafeBox("Hello")
        // Then
        #expect(stringBox.value == "Hello")

        // Given/When
        let arrayBox = ThreadSafeBox([1, 2, 3])
        // Then
        #expect(arrayBox.value == [1, 2, 3])
    }

    // MARK: - Value Access Tests

    @Test("It should get value")
    func valueGetter() {
        // Given
        let box = ThreadSafeBox(100)

        // When
        let retrievedValue = box.value

        // Then
        #expect(retrievedValue == 100)
    }

    @Test("It should set value")
    func setValue() {
        // Given
        let box = ThreadSafeBox(0)

        // When
        box.setValue(42)

        // Then
        #expect(box.value == 42)

        // When
        box.setValue(-10)

        // Then
        #expect(box.value == -10)
    }

    // MARK: - Modify Tests

    @Test("It should modify with return value")
    func modifyWithReturn() {
        // Given
        let box = ThreadSafeBox(10)

        // When
        let result = box.modify { value in
            value += 5
            return value * 2
        }

        // Then
        #expect(result == 30)
        #expect(box.value == 15)
    }

    @Test("It should modify without return value")
    func modifyWithoutReturn() {
        // Given
        let box = ThreadSafeBox([1, 2, 3])

        // When
        box.modify { array in
            array.append(4)
            array.append(5)
        }

        // Then
        #expect(box.value == [1, 2, 3, 4, 5])
    }

    @Test("It should modify with complex transformation")
    func complexModify() {
        struct Counter {

            var count: Int
            var name: String
        }

        // Given
        let box = ThreadSafeBox(
            Counter(count: 0, name: "test")
        )

        // When
        let finalCount = box.modify { counter in
            counter.count += 10
            counter.name = "modified"
            return counter.count
        }

        // Then
        #expect(finalCount == 10)
        #expect(box.value.count == 10)
        #expect(box.value.name == "modified")
    }

    // MARK: - WithValue Tests

    @Test("It should access value with withValue")
    func withValue() {
        // Given
        let box = ThreadSafeBox("Hello World")

        // When
        let length = box.withValue(\.count)

        // Then
        #expect(length == 11)

        // When
        let uppercased = box.withValue(\.localizedUppercase)

        // Then
        #expect(uppercased == "HELLO WORLD")
        #expect(box.value == "Hello World")
    }

    @Test("It should perform withValue with complex operations")
    func withValueComplexOperations() {
        // Given
        let box = ThreadSafeBox([1, 2, 3, 4, 5])

        // When
        let sum = box.withValue { array in
            array.reduce(0, +)
        }

        // Then
        #expect(sum == 15)

        // When
        let filtered = box.withValue { array in
            array.filter { $0 % 2 == 0 }
        }

        // Then
        #expect(filtered == [2, 4])
        #expect(box.value == [1, 2, 3, 4, 5])
    }

    // MARK: - Swap Tests

    @Test("It should swap values")
    func swap() {
        // Given
        let box = ThreadSafeBox(100)

        // When
        let oldValue = box.swap(200)

        // Then
        #expect(oldValue == 100)
        #expect(box.value == 200)
    }

    @Test("It should swap with different types")
    func swapWithDifferentTypes() {
        // Given
        let stringBox = ThreadSafeBox("original")

        // When
        let oldString = stringBox.swap("new")

        // Then
        #expect(oldString == "original")
        #expect(stringBox.value == "new")

        // Given
        let arrayBox = ThreadSafeBox([1, 2])

        // When
        let oldArray = arrayBox.swap([3, 4, 5])

        // Then
        #expect(oldArray == [1, 2])
        #expect(arrayBox.value == [3, 4, 5])
    }
}
