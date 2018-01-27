import UIKit

public protocol ConfigurableCell {

    associatedtype DataObject

    func update(_ viewModel: DataObject?)
}
