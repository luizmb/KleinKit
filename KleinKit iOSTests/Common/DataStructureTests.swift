import Foundation
@testable import KleinKit
import XCTest

// swiftlint:disable type_body_length
class DataStructureTests: UnitTest {
    func testAtomic() {
        let array = Atomic<[String]>([])
        XCTAssertTrue(array.atomicProperty.isEmpty)

        array.mutate { str in str.append("a") }
        XCTAssertEqual(array.atomicProperty.count, 1)
        XCTAssertEqual(array.atomicProperty, ["a"])

        array.mutate { str in str.append("b") }
        XCTAssertEqual(array.atomicProperty.count, 2)
        XCTAssertEqual(array.atomicProperty, ["a", "b"])
    }

    func testSyncableResult() {
        let notLoaded1: AsyncResult<String> = .notLoaded
        let notLoaded2: AsyncResult<String> = .notLoaded
        let loading1: AsyncResult<String> = .loading(task: Cancelable(), oldValue: nil)
        let loading2: AsyncResult<String> = .loading(task: Cancelable(), oldValue: nil)
        let loading3: AsyncResult<String> = .loading(task: Cancelable(), oldValue: .success("A"))
        let loading4: AsyncResult<String> = .loading(task: Cancelable(), oldValue: .failure(AnyError()))
        let loadedA1: AsyncResult<String> = .loaded(.success("a"))
        let loadedA2: AsyncResult<String> = .loaded(.success("a"))
        let loadedB1: AsyncResult<String> = .loaded(.success("b"))
        let loadedB2: AsyncResult<String> = .loaded(.success("b"))
        let loadedError1: AsyncResult<String> = .loaded(.failure(AnyError()))
        let loadedError2: AsyncResult<String> = .loaded(.failure(AnyError()))

        XCTAssertTrue(notLoaded1 == notLoaded2)
        XCTAssertTrue(loading1 == loading2)
        XCTAssertTrue(loadedA1 == loadedA2)
        XCTAssertTrue(loadedB1 == loadedB2)
        XCTAssertTrue(loadedError1 == loadedError2)

        XCTAssertFalse(notLoaded1 == loading1)
        XCTAssertFalse(notLoaded1 == loading3)
        XCTAssertFalse(notLoaded1 == loading4)
        XCTAssertFalse(notLoaded1 == loadedA1)
        XCTAssertFalse(notLoaded1 == loadedB1)
        XCTAssertFalse(notLoaded1 == loadedError1)
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
        let sutA1: Result<String> = .success("a")
        let sutA2: Result<String> = .success("a")
        let sutB: Result<String> = .success("b")
        let sutC: Result<String> = .failure(AnyError())

        XCTAssertTrue(sutA1 == sutA2)
        XCTAssertFalse(sutA1 == sutB)
        XCTAssertFalse(sutA1 == sutC)
        XCTAssertFalse(sutB == sutC)

        XCTAssertTrue(sutA2 == sutA1)
        XCTAssertFalse(sutB == sutA1)
        XCTAssertFalse(sutC == sutA1)
        XCTAssertFalse(sutC == sutB)

        // Inverse

        XCTAssertFalse(sutA1 != sutA2)
        XCTAssertTrue(sutA1 != sutB)
        XCTAssertTrue(sutA1 != sutC)
        XCTAssertTrue(sutB != sutC)

        XCTAssertFalse(sutA2 != sutA1)
        XCTAssertTrue(sutB != sutA1)
        XCTAssertTrue(sutC != sutA1)
        XCTAssertTrue(sutC != sutB)
    }

    func testResultEquatableForInt() {
        let sutA1: Result<Int> = .success(1)
        let sutA2: Result<Int> = .success(1)
        let sutB: Result<Int> = .success(2)
        let sutC: Result<Int> = .failure(AnyError())

        XCTAssertTrue(sutA1 == sutA2)
        XCTAssertFalse(sutA1 == sutB)
        XCTAssertFalse(sutA1 == sutC)
        XCTAssertFalse(sutB == sutC)

        XCTAssertTrue(sutA2 == sutA1)
        XCTAssertFalse(sutB == sutA1)
        XCTAssertFalse(sutC == sutA1)
        XCTAssertFalse(sutC == sutB)

        // Inverse

        XCTAssertFalse(sutA1 != sutA2)
        XCTAssertTrue(sutA1 != sutB)
        XCTAssertTrue(sutA1 != sutC)
        XCTAssertTrue(sutB != sutC)

        XCTAssertFalse(sutA2 != sutA1)
        XCTAssertTrue(sutB != sutA1)
        XCTAssertTrue(sutC != sutA1)
        XCTAssertTrue(sutC != sutB)
    }

    func testResultEquatableForOptionalString() {
        let sutA1: Result<String?> = .success("a")
        let sutA2: Result<String?> = .success("a")
        let sutB: Result<String?> = .success("b")
        let sutC: Result<String?> = .failure(AnyError())
        let sutD: Result<String?> = .success(nil)

        XCTAssertTrue(sutA1 == sutA2)
        XCTAssertFalse(sutA1 == sutB)
        XCTAssertFalse(sutA1 == sutC)
        XCTAssertFalse(sutA1 == sutD)
        XCTAssertFalse(sutB == sutC)
        XCTAssertFalse(sutB == sutD)
        XCTAssertFalse(sutC == sutD)

        XCTAssertTrue(sutA2 == sutA1)
        XCTAssertFalse(sutB == sutA1)
        XCTAssertFalse(sutC == sutA1)
        XCTAssertFalse(sutD == sutA1)
        XCTAssertFalse(sutC == sutB)
        XCTAssertFalse(sutD == sutB)
        XCTAssertFalse(sutD == sutC)

        XCTAssertTrue(sutC == .failure(AnyError()))
        XCTAssertTrue(sutD == .success(nil))
        XCTAssertFalse(sutC != .failure(AnyError()))
        XCTAssertFalse(sutD != .success(nil))

        // Inverse

        XCTAssertFalse(sutA1 != sutA2)
        XCTAssertTrue(sutA1 != sutB)
        XCTAssertTrue(sutA1 != sutC)
        XCTAssertTrue(sutA1 != sutD)
        XCTAssertTrue(sutB != sutC)
        XCTAssertTrue(sutB != sutD)
        XCTAssertTrue(sutC != sutD)

        XCTAssertFalse(sutA2 != sutA1)
        XCTAssertTrue(sutB != sutA1)
        XCTAssertTrue(sutC != sutA1)
        XCTAssertTrue(sutD != sutA1)
        XCTAssertTrue(sutC != sutB)
        XCTAssertTrue(sutD != sutB)
        XCTAssertTrue(sutD != sutC)
    }

    func testResultEquatableForArrayOfStrings() {
        let sutA1: Result<[String]> = .success(["a", "a"])
        let sutA2: Result<[String]> = .success(["a", "a"])
        let sutB: Result<[String]> = .success(["a", "b"])
        let sutC: Result<[String]> = .success(["b", "a"])
        let sutD: Result<[String]> = .failure(AnyError())
        let sutE: Result<[String]> = .success([])

        XCTAssertTrue(sutA1 == sutA2)
        XCTAssertFalse(sutA1 == sutB)
        XCTAssertFalse(sutA1 == sutC)
        XCTAssertFalse(sutA1 == sutD)
        XCTAssertFalse(sutA1 == sutE)
        XCTAssertFalse(sutB == sutC)
        XCTAssertFalse(sutB == sutD)
        XCTAssertFalse(sutB == sutE)
        XCTAssertFalse(sutC == sutD)
        XCTAssertFalse(sutC == sutE)
        XCTAssertFalse(sutD == sutE)
        XCTAssertTrue(sutA2 == sutA1)
        XCTAssertFalse(sutB == sutA1)
        XCTAssertFalse(sutC == sutA1)
        XCTAssertFalse(sutD == sutA1)
        XCTAssertFalse(sutE == sutA1)
        XCTAssertFalse(sutC == sutB)
        XCTAssertFalse(sutD == sutB)
        XCTAssertFalse(sutE == sutB)
        XCTAssertFalse(sutD == sutC)
        XCTAssertFalse(sutE == sutC)
        XCTAssertFalse(sutE == sutD)

        XCTAssertTrue(sutD == .failure(AnyError()))
        XCTAssertFalse(sutD != .failure(AnyError()))
    }

    func testResultEquatableForArrayOfStringsInverse() {
        let sutA1: Result<[String]> = .success(["a", "a"])
        let sutA2: Result<[String]> = .success(["a", "a"])
        let sutB: Result<[String]> = .success(["a", "b"])
        let sutC: Result<[String]> = .success(["b", "a"])
        let sutD: Result<[String]> = .failure(AnyError())
        let sutE: Result<[String]> = .success([])

        XCTAssertFalse(sutA1 != sutA2)
        XCTAssertTrue(sutA1 != sutB)
        XCTAssertTrue(sutA1 != sutC)
        XCTAssertTrue(sutA1 != sutD)
        XCTAssertTrue(sutA1 != sutE)
        XCTAssertTrue(sutB != sutC)
        XCTAssertTrue(sutB != sutD)
        XCTAssertTrue(sutB != sutE)
        XCTAssertTrue(sutC != sutD)
        XCTAssertTrue(sutC != sutE)
        XCTAssertTrue(sutD != sutE)
        XCTAssertFalse(sutA2 != sutA1)
        XCTAssertTrue(sutB != sutA1)
        XCTAssertTrue(sutC != sutA1)
        XCTAssertTrue(sutD != sutA1)
        XCTAssertTrue(sutE != sutA1)
        XCTAssertTrue(sutC != sutB)
        XCTAssertTrue(sutD != sutB)
        XCTAssertTrue(sutE != sutB)
        XCTAssertTrue(sutD != sutC)
        XCTAssertTrue(sutE != sutC)
        XCTAssertTrue(sutE != sutD)
    }

    func testResultMap() {
        let successfulInt1: Result<Int> = .success(1)
        let successfulInt2: Result<Int> = .success(2)
        let error = AnyError()
        let errorInt: Result<Int> = .failure(error)

        XCTAssertTrue(successfulInt1.map(String.init) == .success("1"))
        XCTAssertTrue(successfulInt2.map(String.init) == .success("2"))
        XCTAssertTrue(errorInt.map(String.init) == .failure(error))
    }

    func testResultFlatMap() {
        let successfulInt1: Result<Int> = .success(1)
        let successfulInt2: Result<Int> = .success(2)
        let error = AnyError()
        let errorInt: Result<Int> = .failure(error)

        func successfulFunc(_ input: Int) -> Result<String> {
            return .success(String(input))
        }

        func errorFunc(_ input: Int) -> Result<String> {
            return .failure(error)
        }

        XCTAssertTrue(successfulInt1.flatMap(successfulFunc) == .success("1"))
        XCTAssertTrue(successfulInt2.flatMap(successfulFunc) == .success("2"))
        XCTAssertTrue(errorInt.flatMap(successfulFunc) == .failure(error))

        XCTAssertTrue(successfulInt1.flatMap(errorFunc) == .failure(error))
        XCTAssertTrue(successfulInt2.flatMap(errorFunc) == .failure(error))
        XCTAssertTrue(errorInt.flatMap(errorFunc) == .failure(error))
    }

    func testResultCoalesceToResultT() {
        let sutA: Result<String> = .success("a")
        let sutB: Result<String> = .success("b")
        let sutC: Result<String> = .failure(AnyError())
        let sutD: Result<String> = .failure(AnyError())

        XCTAssertTrue(sutA ??? sutB == sutA)
        XCTAssertTrue(sutA ??? sutC == sutA)
        XCTAssertTrue(sutA ??? sutD == sutA)

        XCTAssertTrue(sutB ??? sutA == sutB)
        XCTAssertTrue(sutB ??? sutC == sutB)
        XCTAssertTrue(sutB ??? sutD == sutB)

        XCTAssertTrue(sutC ??? sutA == sutA)
        XCTAssertTrue(sutC ??? sutB == sutB)
        XCTAssertTrue(sutC ??? sutD == .failure(AnyError()))

        XCTAssertTrue(sutD ??? sutA == sutA)
        XCTAssertTrue(sutD ??? sutB == sutB)
        XCTAssertTrue(sutD ??? sutC == .failure(AnyError()))

        // Repeat but with nil prefix

        XCTAssertTrue(sutC ??? sutA ??? sutB == sutA)
        XCTAssertTrue(sutC ??? sutA ??? sutC == sutA)
        XCTAssertTrue(sutC ??? sutA ??? sutD == sutA)

        XCTAssertTrue(sutC ??? sutB ??? sutA == sutB)
        XCTAssertTrue(sutC ??? sutB ??? sutC == sutB)
        XCTAssertTrue(sutC ??? sutB ??? sutD == sutB)

        XCTAssertTrue(sutD ??? sutC ??? sutA == sutA)
        XCTAssertTrue(sutD ??? sutC ??? sutB == sutB)
        XCTAssertTrue(sutD ??? sutC ??? sutD == .failure(AnyError()))

        XCTAssertTrue(sutC ??? sutD ??? sutA == sutA)
        XCTAssertTrue(sutC ??? sutD ??? sutB == sutB)
        XCTAssertTrue(sutC ??? sutD ??? sutC == .failure(AnyError()))
    }

    func testResultCoalesceToT() {
        let sutA: Result<String> = .success("a")
        let sutB: Result<String> = .failure(AnyError())
        let sutC = "c"

        XCTAssertTrue(sutA ??? sutC == "a")
        XCTAssertTrue(sutB ??? sutC == "c")

        // Repeat but with nil prefix

        XCTAssertTrue(sutB ??? sutA ??? sutC == "a")
    }

    func testResultCoalesceToOptionalT() {
        let sutA: Result<String> = .success("a")
        let sutB: Result<String> = .failure(AnyError())
        let sutC: String? = "c"
        let sutD: String? = nil

        XCTAssertTrue(sutA ??? sutC == "a")
        XCTAssertTrue(sutA ??? sutD == "a")

        XCTAssertTrue(sutB ??? sutC == "c")
        XCTAssertTrue(sutB ??? sutD == nil)

        // Repeat but with nil prefix

        XCTAssertTrue(sutB ??? sutA ??? sutC == "a")
        XCTAssertTrue(sutB ??? sutA ??? sutD == "a")

        XCTAssertTrue(sutB ??? sutB ??? sutC == "c")
        XCTAssertTrue(sutB ??? sutB ??? sutD == nil)
    }
}
// swiftlint:enable type_body_length
