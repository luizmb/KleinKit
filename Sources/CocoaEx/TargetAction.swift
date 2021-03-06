import UIKit

final class TargetAction: NSObject {
    let callback: () -> Void
    let selector: Selector = #selector(TargetAction.action(sender:))

    init(_ callback: @escaping () -> Void) {
        self.callback = callback
    }

    @objc func action(sender: Any) {
        callback()
    }
}

extension UIBarButtonItem {
    public convenience init(image: UIImage?, style: UIBarButtonItemStyle, disposableBag: inout [Any], onTap: @escaping () -> Void) {
        let targetAction = TargetAction(onTap)
        disposableBag.append(targetAction)
        self.init(image: image, style: style, target: targetAction, action: targetAction.selector)
    }

    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, disposableBag: inout [Any], onTap: @escaping () -> Void) {
        let targetAction = TargetAction(onTap)
        disposableBag.append(targetAction)
        self.init(barButtonSystemItem: systemItem, target: targetAction, action: targetAction.selector)
    }
}
