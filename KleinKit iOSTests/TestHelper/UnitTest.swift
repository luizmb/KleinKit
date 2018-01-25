import Foundation
import XCTest
@testable import KleinKit

class UnitTest: XCTestCase {
    var injector: MockInjector!

    override func setUp() {
        injector = MockInjector()
        MockInjector.getInjector = { [unowned self] in self.injector }
    }

    override func tearDown() {
        MockInjector.getInjector = { nil }
    }
}
