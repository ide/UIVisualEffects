import UIKit

/// This extension prevents UIVisualEffectView from consuming touches since as its name implies it is intended for
/// visual effect and not interactivity. This is done by letting the superview handle touches that are not in a subview
/// of the UIVisualEffectView's content view.
///
/// This behavior should usually be implemented in a subclass rather than an extension, which affects all
/// UIVisualEffectView instances.
extension UIVisualEffectView {

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self.contentView ? nil : view
    }
}
