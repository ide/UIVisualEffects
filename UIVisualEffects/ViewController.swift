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

        let darkBlur = UIBlurEffect(style: .dark)
        let darkBlurView = UIVisualEffectView(effect: darkBlur)
        self.view.addSubview(darkBlurView)

        let lightBlur = UIBlurEffect(style: .light)
        let lightBlurView = UIVisualEffectView(effect: lightBlur)
        self.view.addSubview(lightBlurView)

        let extraLightBlur = UIBlurEffect(style: .extraLight)
        let extraLightBlurView = UIVisualEffectView(effect: extraLightBlur)
        self.view.addSubview(extraLightBlurView)

        let blurAreaAmount = self.view.bounds.height / 4
        var remainder: CGRect
        (darkBlurView.frame, remainder) = self.view.bounds.divided(atDistance: blurAreaAmount, from: CGRectEdge.maxYEdge)
        (lightBlurView.frame, remainder) = remainder.divided(atDistance: blurAreaAmount, from: CGRectEdge.maxYEdge)
        (extraLightBlurView.frame, remainder) = remainder.divided(atDistance: blurAreaAmount, from:CGRectEdge.maxYEdge)

        darkBlurView.frame = darkBlurView.frame.integral
        lightBlurView.frame = lightBlurView.frame.integral
        extraLightBlurView.frame = extraLightBlurView.frame.integral

        let extraLightVibrancyView = vibrancyEffectView(forBlurEffectView: extraLightBlurView)
        extraLightBlurView.contentView.addSubview(extraLightVibrancyView)

        let lightVibrancyView = vibrancyEffectView(forBlurEffectView: lightBlurView)
        lightBlurView.contentView.addSubview(lightVibrancyView)

        let darkVibrancyView = vibrancyEffectView(forBlurEffectView: darkBlurView)
        darkBlurView.contentView.addSubview(darkVibrancyView)


        let cameraButton = tintedIconButton(iconNamed: "Camera")
        cameraButton.center = extraLightVibrancyView.convert(extraLightVibrancyView.center, from: extraLightVibrancyView.superview)
        extraLightVibrancyView.contentView.addSubview(cameraButton)

        let geniusButton = tintedIconButton(iconNamed: "Genius")
        geniusButton.center = lightVibrancyView.convert(lightVibrancyView.center, from: lightVibrancyView.superview)
        lightVibrancyView.contentView.addSubview(geniusButton)

        let bitcoinButton = tintedIconButton(iconNamed: "Bitcoin")
        bitcoinButton.center = darkVibrancyView.convert(darkVibrancyView.center, from: darkVibrancyView.superview)
        darkVibrancyView.contentView.addSubview(bitcoinButton)


        let extraLightTitleLabel = titleLabel(text: "Extra Light Blur")
        extraLightVibrancyView.contentView.addSubview(extraLightTitleLabel)

        let lightTitleLabel = titleLabel(text: "Light Blur")
        lightVibrancyView.contentView.addSubview(lightTitleLabel)

        let darkTitleLabel = titleLabel(text: "Dark Blur")
        darkVibrancyView.contentView.addSubview(darkTitleLabel)


        addVibrantStatusBarBackground(extraLightBlur)
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
        button.setBackgroundImage(borderImage, for: UIControlState())
        button.setImage(iconImage, for: UIControlState())
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

        let statusBar = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.superview!.insertSubview(statusBarBlurView, belowSubview: statusBar)
        self.view.addSubview(statusBarBlurView)

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
