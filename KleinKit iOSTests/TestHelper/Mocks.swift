//
//  EmptyProtocols.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit
@testable import KleinKit

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
        let w = MockWindow()
        w.frame = UIScreen.main.bounds
        return w
    }

    @discardableResult func setup(with viewController: UIViewController?) -> Window {
        self.rootViewController = viewController
        self.isKeyWindow = true
        return self
    }

    var frame: CGRect = .zero
    var isKeyWindow: Bool = false
    var rootViewController: UIViewController? = nil
}

class MockApplication: NSObject, Application {
    var keepScreenOnChanged: ((Bool) -> ())?
    var keepScreenOn: Bool = false {
        didSet {
            keepScreenOnChanged?(keepScreenOn)
        }
    }
}

class MockRepository: RepositoryProtocol {
    var calledSave: (Data, String)?
    var onCallSave: ((Data, String) -> ())?
    func save(data: Data, filename: String) {
        onCallSave?(data, filename)
        calledSave = (data, filename)
    }

    var calledLoad: String?
    var onCallLoad: ((String) -> (Result<Data>))?
    func load(filename: String) -> Result<Data> {
        let result = onCallLoad?(filename) ?? .error(AnyError())
        calledLoad = filename
        return result
    }
}
