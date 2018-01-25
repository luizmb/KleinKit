import UIKit

extension UIView {
    public static var nibName: String {
        return String(NSStringFromClass(self).split(separator: ".").last!)
    }

    public class func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}

extension UIView {
    public enum ViewSide {
        case top
        case bottom
        case leading
        case trailing
        case left
        case right
    }

    public func anchorToParent(_ parent: UIView) {
        self.anchorToParent(parent, withSpacing: 0.0)
    }

    public func anchorToParent(_ parent: UIView, withSpacing spacing: Float) {
        self.anchorToParent(parent, withSpacing: spacing, sides: [.top, .leading, .trailing, .bottom])
    }

    public func anchorToParent(_ parent: UIView, sides: [ViewSide]) {
        self.anchorToParent(parent, withSpacing: 0.0, sides: sides)
    }

    public func anchorToParent(_ parent: UIView, withSpacing spacing: Float, sides: [ViewSide]) {
        sides.forEach { side in
            switch side {
            case .top:
                self.topAnchor.constraint(equalTo: parent.topAnchor, constant: CGFloat(spacing)).isActive = true
            case .bottom:
                parent.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: CGFloat(spacing)).isActive = true
            case .leading:
                self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: CGFloat(spacing)).isActive = true
            case .trailing:
                parent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: CGFloat(spacing)).isActive = true
            case .left:
                self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: CGFloat(spacing)).isActive = true
            case .right:
                parent.rightAnchor.constraint(equalTo: self.rightAnchor, constant: CGFloat(spacing)).isActive = true
            }
        }
    }
}
