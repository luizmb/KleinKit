@testable import KleinKit
import UIKit

private func defaultDate() -> Date { return Date(timeIntervalSinceReferenceDate: 0) }

// Empty protocols
enum FooAction: Action { case foo }
struct AnyError: Error { }
class Cancelable: CancelableTask {
    let id = UUID()
    var cancelCount = 0
    func cancel() { cancelCount += 1 }
}

class MockWindow: NSObject, Window {
    static func create() -> Window {
        let window = MockWindow()
        window.frame = UIScreen.main.bounds
        return window
    }

    @discardableResult func setup(with viewController: UIViewController?) -> Window {
        self.rootViewController = viewController
        self.isKeyWindow = true
        return self
    }

    var frame: CGRect = .zero
    var isKeyWindow: Bool = false
    var rootViewController: UIViewController?
}

class MockApplication: NSObject, Application {
    var keepScreenOnChanged: ((Bool) -> Void)?
    var keepScreenOn: Bool = false {
        didSet {
            keepScreenOnChanged?(keepScreenOn)
        }
    }
}

class MockRepository: RepositoryProtocol {
    var calledSave: (Data, String)?
    var onCallSave: ((Data, String) -> Void)?
    func save(data: Data, filename: String) {
        onCallSave?(data, filename)
        calledSave = (data, filename)
    }

    var calledLoad: String?
    var onCallLoad: ((String) -> (Result<Data>))?
    func load(filename: String) -> Result<Data> {
        let result = onCallLoad?(filename) ?? .failure(AnyError())
        calledLoad = filename
        return result
    }
}
