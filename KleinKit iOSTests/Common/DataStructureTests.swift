import XCTest
import Foundation
@testable import KleinKit

class DataStructureTests: UnitTest {
    func testAtomic() {
        let array = Atomic<[String]>([])
        XCTAssertTrue(array.atomicProperty.isEmpty)

        array.mutate { s in s.append("a") }
        XCTAssertEqual(array.atomicProperty.count, 1)
        XCTAssertEqual(array.atomicProperty, ["a"])

        array.mutate { s in s.append("b") }
        XCTAssertEqual(array.atomicProperty.count, 2)
        XCTAssertEqual(array.atomicProperty, ["a", "b"])
    }

    func testSyncableResult() {
        let neverLoaded1: SyncableResult<String> = .neverLoaded
        let neverLoaded2: SyncableResult<String> = .neverLoaded
        let loading1: SyncableResult<String> = .syncing(task: Cancelable(), oldValue: nil)
        let loading2: SyncableResult<String> = .syncing(task: Cancelable(), oldValue: nil)
        let loading3: SyncableResult<String> = .syncing(task: Cancelable(), oldValue: .success("A"))
        let loading4: SyncableResult<String> = .syncing(task: Cancelable(), oldValue: .failure(AnyError()))
        let loadedA1: SyncableResult<String> = .loaded(.success("a"))
        let loadedA2: SyncableResult<String> = .loaded(.success("a"))
        let loadedB1: SyncableResult<String> = .loaded(.success("b"))
        let loadedB2: SyncableResult<String> = .loaded(.success("b"))
        let loadedError1: SyncableResult<String> = .loaded(.failure(AnyError()))
        let loadedError2: SyncableResult<String> = .loaded(.failure(AnyError()))

        XCTAssertTrue(neverLoaded1 == neverLoaded2)
        XCTAssertTrue(loading1 == loading2)
        XCTAssertTrue(loadedA1 == loadedA2)
        XCTAssertTrue(loadedB1 == loadedB2)
        XCTAssertTrue(loadedError1 == loadedError2)

        XCTAssertFalse(neverLoaded1 == loading1)
        XCTAssertFalse(neverLoaded1 == loading3)
        XCTAssertFalse(neverLoaded1 == loading4)
        XCTAssertFalse(neverLoaded1 == loadedA1)
        XCTAssertFalse(neverLoaded1 == loadedB1)
        XCTAssertFalse(neverLoaded1 == loadedError1)
        XCTAssertFalse(loading1 == loading3)
        XCTAssertFalse(loading1 == loading4)
        XCTAssertFalse(loading1 == loadedA1)
        XCTAssertFalse(loading1 == loadedB1)
        XCTAssertFalse(loading1 == loadedError1)
        XCTAssertFalse(loading3 == loading4)
        XCTAssertFalse(loading3 == loadedA1)
        XCTAssertFalse(loading3 == loadedB1)
        XCTAssertFalse(loading3 == loadedError1)
        XCTAssertFalse(loading4 == loadedA1)
        XCTAssertFalse(loading4 == loadedB1)
        XCTAssertFalse(loading4 == loadedError1)
        XCTAssertFalse(loadedA1 == loadedB1)
        XCTAssertFalse(loadedA1 == loadedError1)
        XCTAssertFalse(loadedB1 == loadedError1)
    }

    func testDisposable() {
        let shouldDispose: XCTestExpectation = expectation(description: "Disposed")
        var count = 0
        func scoped() {
            XCTAssertEqual(count, 0)
            let disposables = Disposable {
                count += 1
                shouldDispose.fulfill()
            }
            let anotherPointer = disposables
            _ = anotherPointer
            XCTAssertEqual(count, 0)
        }
        XCTAssertEqual(count, 0)
        scoped()
        wait(for: [shouldDispose], timeout: 1)
        XCTAssertEqual(count, 1)
    }

    func testDisposableBagToNil() {
        let shouldDispose: XCTestExpectation = expectation(description: "Disposed")
        var count = 0

        var bag: [Any]? = []
        Disposable {
            count += 1
            shouldDispose.fulfill()
        }.addDisposableTo(&bag!)

        XCTAssertEqual(bag!.count, 1)
        XCTAssertEqual(count, 0)

        bag = nil
        wait(for: [shouldDispose], timeout: 1)
        XCTAssertEqual(count, 1)
    }

    func testDisposableBagToEmpty() {
        let shouldDispose: XCTestExpectation = expectation(description: "Disposed")
        var count = 0

        var bag: [Any] = []
        Disposable {
            count += 1
            shouldDispose.fulfill()
        }.addDisposableTo(&bag)

        XCTAssertEqual(bag.count, 1)
        XCTAssertEqual(count, 0)

        bag.removeAll()
        wait(for: [shouldDispose], timeout: 1)
        XCTAssertEqual(count, 1)
    }

    func testResultEquatableForString() {
        let a1: Result<String> = .success("a")
        let a2: Result<String> = .success("a")
        let b: Result<String> = .success("b")
        let c: Result<String> = .failure(AnyError())

        XCTAssertTrue(a1 == a2)
        XCTAssertFalse(a1 == b)
        XCTAssertFalse(a1 == c)
        XCTAssertFalse(b == c)

        XCTAssertTrue(a2 == a1)
        XCTAssertFalse(b == a1)
        XCTAssertFalse(c == a1)
        XCTAssertFalse(c == b)

        // Inverse

        XCTAssertFalse(a1 != a2)
        XCTAssertTrue(a1 != b)
        XCTAssertTrue(a1 != c)
        XCTAssertTrue(b != c)

        XCTAssertFalse(a2 != a1)
        XCTAssertTrue(b != a1)
        XCTAssertTrue(c != a1)
        XCTAssertTrue(c != b)
    }

    func testResultEquatableForInt() {
        let a1: Result<Int> = .success(1)
        let a2: Result<Int> = .success(1)
        let b: Result<Int> = .success(2)
        let c: Result<Int> = .failure(AnyError())

        XCTAssertTrue(a1 == a2)
        XCTAssertFalse(a1 == b)
        XCTAssertFalse(a1 == c)
        XCTAssertFalse(b == c)

        XCTAssertTrue(a2 == a1)
        XCTAssertFalse(b == a1)
        XCTAssertFalse(c == a1)
        XCTAssertFalse(c == b)

        // Inverse

        XCTAssertFalse(a1 != a2)
        XCTAssertTrue(a1 != b)
        XCTAssertTrue(a1 != c)
        XCTAssertTrue(b != c)

        XCTAssertFalse(a2 != a1)
        XCTAssertTrue(b != a1)
        XCTAssertTrue(c != a1)
        XCTAssertTrue(c != b)
    }

    func testResultEquatableForOptionalString() {
        let a1: Result<String?> = .success("a")
        let a2: Result<String?> = .success("a")
        let b: Result<String?> = .success("b")
        let c: Result<String?> = .failure(AnyError())
        let d: Result<String?> = .success(nil)

        XCTAssertTrue(a1 == a2)
        XCTAssertFalse(a1 == b)
        XCTAssertFalse(a1 == c)
        XCTAssertFalse(a1 == d)
        XCTAssertFalse(b == c)
        XCTAssertFalse(b == d)
        XCTAssertFalse(c == d)

        XCTAssertTrue(a2 == a1)
        XCTAssertFalse(b == a1)
        XCTAssertFalse(c == a1)
        XCTAssertFalse(d == a1)
        XCTAssertFalse(c == b)
        XCTAssertFalse(d == b)
        XCTAssertFalse(d == c)

        XCTAssertTrue(c == .failure(AnyError()))
        XCTAssertTrue(d == .success(nil))
        XCTAssertFalse(c != .failure(AnyError()))
        XCTAssertFalse(d != .success(nil))

        // Inverse

        XCTAssertFalse(a1 != a2)
        XCTAssertTrue(a1 != b)
        XCTAssertTrue(a1 != c)
        XCTAssertTrue(a1 != d)
        XCTAssertTrue(b != c)
        XCTAssertTrue(b != d)
        XCTAssertTrue(c != d)

        XCTAssertFalse(a2 != a1)
        XCTAssertTrue(b != a1)
        XCTAssertTrue(c != a1)
        XCTAssertTrue(d != a1)
        XCTAssertTrue(c != b)
        XCTAssertTrue(d != b)
        XCTAssertTrue(d != c)
    }

    func testResultEquatableForArrayOfStrings() {
        let a1: Result<[String]> = .success(["a", "a"])
        let a2: Result<[String]> = .success(["a", "a"])
        let b: Result<[String]> = .success(["a", "b"])
        let c: Result<[String]> = .success(["b", "a"])
        let d: Result<[String]> = .failure(AnyError())
        let e: Result<[String]> = .success([])

        XCTAssertTrue(a1 == a2)
        XCTAssertFalse(a1 == b)
        XCTAssertFalse(a1 == c)
        XCTAssertFalse(a1 == d)
        XCTAssertFalse(a1 == e)
        XCTAssertFalse(b == c)
        XCTAssertFalse(b == d)
        XCTAssertFalse(b == e)
        XCTAssertFalse(c == d)
        XCTAssertFalse(c == e)
        XCTAssertFalse(d == e)
        XCTAssertTrue(a2 == a1)
        XCTAssertFalse(b == a1)
        XCTAssertFalse(c == a1)
        XCTAssertFalse(d == a1)
        XCTAssertFalse(e == a1)
        XCTAssertFalse(c == b)
        XCTAssertFalse(d == b)
        XCTAssertFalse(e == b)
        XCTAssertFalse(d == c)
        XCTAssertFalse(e == c)
        XCTAssertFalse(e == d)

        XCTAssertTrue(d == .failure(AnyError()))
        XCTAssertFalse(d != .failure(AnyError()))

        // Inverse

        XCTAssertFalse(a1 != a2)
        XCTAssertTrue(a1 != b)
        XCTAssertTrue(a1 != c)
        XCTAssertTrue(a1 != d)
        XCTAssertTrue(a1 != e)
        XCTAssertTrue(b != c)
        XCTAssertTrue(b != d)
        XCTAssertTrue(b != e)
        XCTAssertTrue(c != d)
        XCTAssertTrue(c != e)
        XCTAssertTrue(d != e)
        XCTAssertFalse(a2 != a1)
        XCTAssertTrue(b != a1)
        XCTAssertTrue(c != a1)
        XCTAssertTrue(d != a1)
        XCTAssertTrue(e != a1)
        XCTAssertTrue(c != b)
        XCTAssertTrue(d != b)
        XCTAssertTrue(e != b)
        XCTAssertTrue(d != c)
        XCTAssertTrue(e != c)
        XCTAssertTrue(e != d)
    }

    func testResultMap() {
        let successfulInt1: Result<Int> = .success(1)
        let successfulInt2: Result<Int> = .success(2)
        let e = AnyError()
        let errorInt: Result<Int> = .failure(e)

        XCTAssertTrue(successfulInt1.map(String.init) == .success("1"))
        XCTAssertTrue(successfulInt2.map(String.init) == .success("2"))
        XCTAssertTrue(errorInt.map(String.init) == .failure(e))
    }

    func testResultFlatMap() {
        let successfulInt1: Result<Int> = .success(1)
        let successfulInt2: Result<Int> = .success(2)
        let e = AnyError()
        let errorInt: Result<Int> = .failure(e)

        func successfulFunc(_ input: Int) -> Result<String> {
            return .success(String(input))
        }

        func errorFunc(_ input: Int) -> Result<String> {
            return .failure(e)
        }

        XCTAssertTrue(successfulInt1.flatMap(successfulFunc) == .success("1"))
        XCTAssertTrue(successfulInt2.flatMap(successfulFunc) == .success("2"))
        XCTAssertTrue(errorInt.flatMap(successfulFunc) == .failure(e))

        XCTAssertTrue(successfulInt1.flatMap(errorFunc) == .failure(e))
        XCTAssertTrue(successfulInt2.flatMap(errorFunc) == .failure(e))
        XCTAssertTrue(errorInt.flatMap(errorFunc) == .failure(e))
    }

    func testResultCoalesceToResultT() {
        let a: Result<String> = .success("a")
        let b: Result<String> = .success("b")
        let c: Result<String> = .failure(AnyError())
        let d: Result<String> = .failure(AnyError())

        XCTAssertTrue(a ??? b == a)
        XCTAssertTrue(a ??? c == a)
        XCTAssertTrue(a ??? d == a)

        XCTAssertTrue(b ??? a == b)
        XCTAssertTrue(b ??? c == b)
        XCTAssertTrue(b ??? d == b)

        XCTAssertTrue(c ??? a == a)
        XCTAssertTrue(c ??? b == b)
        XCTAssertTrue(c ??? d == .failure(AnyError()))

        XCTAssertTrue(d ??? a == a)
        XCTAssertTrue(d ??? b == b)
        XCTAssertTrue(d ??? c == .failure(AnyError()))

        // Repeat but with nil prefix

        XCTAssertTrue(c ??? a ??? b == a)
        XCTAssertTrue(c ??? a ??? c == a)
        XCTAssertTrue(c ??? a ??? d == a)

        XCTAssertTrue(c ??? b ??? a == b)
        XCTAssertTrue(c ??? b ??? c == b)
        XCTAssertTrue(c ??? b ??? d == b)

        XCTAssertTrue(d ??? c ??? a == a)
        XCTAssertTrue(d ??? c ??? b == b)
        XCTAssertTrue(d ??? c ??? d == .failure(AnyError()))

        XCTAssertTrue(c ??? d ??? a == a)
        XCTAssertTrue(c ??? d ??? b == b)
        XCTAssertTrue(c ??? d ??? c == .failure(AnyError()))
    }

    func testResultCoalesceToT() {
        let a: Result<String> = .success("a")
        let b: Result<String> = .failure(AnyError())
        let c = "c"

        XCTAssertTrue(a ??? c == "a")
        XCTAssertTrue(b ??? c == "c")

        // Repeat but with nil prefix

        XCTAssertTrue(b ??? a ??? c == "a")
    }

    func testResultCoalesceToOptionalT() {
        let a: Result<String> = .success("a")
        let b: Result<String> = .failure(AnyError())
        let c: String? = "c"
        let d: String? = nil

        XCTAssertTrue(a ??? c == "a")
        XCTAssertTrue(a ??? d == "a")

        XCTAssertTrue(b ??? c == "c")
        XCTAssertTrue(b ??? d == nil)

        // Repeat but with nil prefix

        XCTAssertTrue(b ??? a ??? c == "a")
        XCTAssertTrue(b ??? a ??? d == "a")

        XCTAssertTrue(b ??? b ??? c == "c")
        XCTAssertTrue(b ??? b ??? d == nil)
    }
}
