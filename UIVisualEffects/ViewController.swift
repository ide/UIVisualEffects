import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.black
        self.view.addSubview(scrollView)

        let elCapitanImage = UIImage(named: "ElCapitan")!
        let backgroundImageView = UIImageView(image: elCapitanImage)
        scrollView.addSubview(backgroundImageView)

        scrollView.contentSize = elCapitanImage.size
        let minHorizScale = scrollView.bounds.width / elCapitanImage.size.width
        let minVertScale = scrollView.bounds.height / elCapitanImage.size.height
        scrollView.minimumZoomScale = min(minHorizScale, minVertScale)
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = max(minHorizScale, minVertScale)
        scrollView.contentOffset = CGPoint(
            x: (scrollView.contentSize.width - scrollView.bounds.width) / 2,
            y: (scrollView.contentSize.height - scrollView.bounds.height) / 2)
        setContentInsetToCenterScrollView(scrollView)

        let lightBlur = UIBlurEffect(style: .light)
        let lightBlurView = UIVisualEffectView(effect: lightBlur)
        lightBlurView.frame = self.view.bounds
        self.view.addSubview(lightBlurView)
    }

    fileprivate func vibrancyEffectView(forBlurEffectView blurEffectView:UIVisualEffectView) -> UIVisualEffectView {
        let vibrancy = UIVibrancyEffect(blurEffect: blurEffectView.effect as! UIBlurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.frame = blurEffectView.bounds
        vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return vibrancyView
    }

    fileprivate func tintedIconButton(iconNamed iconName: String) -> UIButton {
        let iconImage = UIImage(named: iconName)!.withRenderingMode(.alwaysTemplate)
        let borderImage = UIImage(named: "ButtonRoundRect")!.withRenderingMode(.alwaysTemplate)

        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: borderImage.size))
        button.setBackgroundImage(borderImage, for: UIControl.State())
        button.setImage(iconImage, for: UIControl.State())
        return button
    }

    fileprivate func titleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 12, y: 12)
        return label
    }

    fileprivate func addVibrantStatusBarBackground(_ effect: UIBlurEffect) {
        let statusBarBlurView = UIVisualEffectView(effect: effect)
        statusBarBlurView.frame = UIApplication.shared.statusBarFrame
        statusBarBlurView.autoresizingMask = .flexibleWidth

        let statusBarVibrancyView = vibrancyEffectView(forBlurEffectView: statusBarBlurView)
        statusBarBlurView.contentView.addSubview(statusBarVibrancyView)

        let statusBarBackgroundImage = UIImage(named: "MaskPixel")!.withRenderingMode(.alwaysTemplate)
        let statusBarBackgroundView = UIImageView(image: statusBarBackgroundImage)
        statusBarBackgroundView.frame = statusBarVibrancyView.bounds
        statusBarBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        statusBarVibrancyView.contentView.addSubview(statusBarBackgroundView)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.isEmpty ? nil : (scrollView.subviews[0] as UIView)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setContentInsetToCenterScrollView(scrollView)
    }

    func setContentInsetToCenterScrollView(_ scrollView: UIScrollView) {
        var leftInset: CGFloat = 0.0
        if (scrollView.contentSize.width < scrollView.bounds.width) {
            leftInset = (scrollView.bounds.width - scrollView.contentSize.width) / 2
        }

        var topInset: CGFloat = 0.0
        if (scrollView.contentSize.height < scrollView.bounds.height) {
            topInset = (scrollView.bounds.height - scrollView.contentSize.height) / 2
        }
        
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: 0, right: 0)
    }
}
