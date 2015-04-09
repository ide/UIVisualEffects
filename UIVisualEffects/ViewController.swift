import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(scrollView)

        let yosemiteImage = UIImage(named: "Yosemite")!
        let backgroundImageView = UIImageView(image: yosemiteImage)
        scrollView.addSubview(backgroundImageView)

        scrollView.contentSize = yosemiteImage.size
        let minHorizScale = scrollView.bounds.width / yosemiteImage.size.width
        let minVertScale = scrollView.bounds.height / yosemiteImage.size.height
        scrollView.minimumZoomScale = min(minHorizScale, minVertScale)
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = max(minHorizScale, minVertScale)
        scrollView.contentOffset = CGPoint(
            x: (scrollView.contentSize.width - scrollView.bounds.width) / 2,
            y: (scrollView.contentSize.height - scrollView.bounds.height) / 2)
        setContentInsetToCenterScrollView(scrollView)

        let darkBlur = UIBlurEffect(style: .Dark)
        let darkBlurView = UIVisualEffectView(effect: darkBlur)
        self.view.addSubview(darkBlurView)

        let lightBlur = UIBlurEffect(style: .Light)
        let lightBlurView = UIVisualEffectView(effect: lightBlur)
        self.view.addSubview(lightBlurView)

        let extraLightBlur = UIBlurEffect(style: .ExtraLight)
        let extraLightBlurView = UIVisualEffectView(effect: extraLightBlur)
        self.view.addSubview(extraLightBlurView)

        let blurAreaAmount = self.view.bounds.height / 4
        var remainder: CGRect
        (darkBlurView.frame, remainder) = self.view.bounds.rectsByDividing(blurAreaAmount, fromEdge: CGRectEdge.MaxYEdge)
        (lightBlurView.frame, remainder) = remainder.rectsByDividing(blurAreaAmount, fromEdge: CGRectEdge.MaxYEdge)
        (extraLightBlurView.frame, remainder) = remainder.rectsByDividing(blurAreaAmount, fromEdge:CGRectEdge.MaxYEdge)

        darkBlurView.frame.integerize()
        lightBlurView.frame.integerize()
        extraLightBlur.frame.integerize()

        let extraLightVibrancyView = vibrancyEffectView(forBlurEffectView: extraLightBlurView)
        extraLightBlurView.contentView.addSubview(extraLightVibrancyView)

        let lightVibrancyView = vibrancyEffectView(forBlurEffectView: lightBlurView)
        lightBlurView.contentView.addSubview(lightVibrancyView)

        let darkVibrancyView = vibrancyEffectView(forBlurEffectView: darkBlurView)
        darkBlurView.contentView.addSubview(darkVibrancyView)


        let cameraButton = tintedIconButton(iconNamed: "Camera")
        cameraButton.center = extraLightVibrancyView.convertPoint(extraLightVibrancyView.center, fromView: extraLightVibrancyView.superview)
        extraLightVibrancyView.contentView.addSubview(cameraButton)

        let geniusButton = tintedIconButton(iconNamed: "Genius")
        geniusButton.center = lightVibrancyView.convertPoint(lightVibrancyView.center, fromView: lightVibrancyView.superview)
        lightVibrancyView.contentView.addSubview(geniusButton)

        let bitcoinButton = tintedIconButton(iconNamed: "Bitcoin")
        bitcoinButton.center = darkVibrancyView.convertPoint(darkVibrancyView.center, fromView: darkVibrancyView.superview)
        darkVibrancyView.contentView.addSubview(bitcoinButton)


        let extraLightTitleLabel = titleLabel(text: "Extra Light Blur")
        extraLightVibrancyView.contentView.addSubview(extraLightTitleLabel)

        let lightTitleLabel = titleLabel(text: "Light Blur")
        lightVibrancyView.contentView.addSubview(lightTitleLabel)

        let darkTitleLabel = titleLabel(text: "Dark Blur")
        darkVibrancyView.contentView.addSubview(darkTitleLabel)


        addVibrantStatusBarBackground(extraLightBlur)
    }

    private func vibrancyEffectView(forBlurEffectView blurEffectView:UIVisualEffectView) -> UIVisualEffectView {
        let vibrancy = UIVibrancyEffect(forBlurEffect: blurEffectView.effect as! UIBlurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.frame = blurEffectView.bounds
        vibrancyView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        return vibrancyView
    }

    private func tintedIconButton(iconNamed iconName: String) -> UIButton {
        let iconImage = UIImage(named: iconName)!.imageWithRenderingMode(.AlwaysTemplate)
        let borderImage = UIImage(named: "ButtonRoundRect")!.imageWithRenderingMode(.AlwaysTemplate)

        let button = UIButton(frame: CGRect(origin: CGPointZero, size: borderImage.size))
        button.setBackgroundImage(borderImage, forState: .Normal)
        button.setImage(iconImage, forState: .Normal)
        return button
    }

    private func titleLabel(#text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 12, y: 12)
        return label
    }

    private func addVibrantStatusBarBackground(effect: UIBlurEffect) {
        let statusBarBlurView = UIVisualEffectView(effect: effect)
        statusBarBlurView.frame = UIApplication.sharedApplication().statusBarFrame
        statusBarBlurView.autoresizingMask = .FlexibleWidth

        let statusBarVibrancyView = vibrancyEffectView(forBlurEffectView: statusBarBlurView)
        statusBarBlurView.contentView.addSubview(statusBarVibrancyView)

        let statusBar = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        statusBar.superview!.insertSubview(statusBarBlurView, belowSubview: statusBar)
        self.view.addSubview(statusBarBlurView)

        let statusBarBackgroundImage = UIImage(named: "MaskPixel")!.imageWithRenderingMode(.AlwaysTemplate)
        let statusBarBackgroundView = UIImageView(image: statusBarBackgroundImage)
        statusBarBackgroundView.frame = statusBarVibrancyView.bounds
        statusBarBackgroundView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        statusBarVibrancyView.contentView.addSubview(statusBarBackgroundView)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension ViewController: UIScrollViewDelegate {

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.isEmpty ? nil : (scrollView.subviews[0] as! UIView)
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {
        setContentInsetToCenterScrollView(scrollView)
    }

    func setContentInsetToCenterScrollView(scrollView: UIScrollView) {
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
