//
//  EFSliderView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/28.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

public class EFSliderView: EFControl {

    let EFSliderViewHeight: CGFloat = 28.0
    let EFSliderViewMinWidth: CGFloat = 150.0
    let EFSliderViewTrackHeight: CGFloat = 3.0
    let EFThumbViewEdgeInset: CGFloat = -10.0

    private let thumbView: EFThumbView = EFThumbView()
    private let trackLayer: CAGradientLayer = CAGradientLayer()

    // The slider's current value. The default value is 0.0.
    private(set) var value: CGFloat = 0

    // The minimum value of the slider. The default value is 0.0.
    var minimumValue: CGFloat = 0

    // The maximum value of the slider. The default value is 1.0.
    var maximumValue: CGFloat = 1

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.accessibilityLabel = "color_slider"

        minimumValue = 0.0
        maximumValue = 1.0
        value = 0.0

        self.layer.delegate = self

        trackLayer.cornerRadius = EFSliderViewTrackHeight / 2.0
        trackLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        trackLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.addSublayer(trackLayer)

        thumbView.hitTestEdgeInsets = UIEdgeInsets(
            top: EFThumbViewEdgeInset, left: EFThumbViewEdgeInset,
            bottom: EFThumbViewEdgeInset, right: EFThumbViewEdgeInset
        )
        thumbView.gestureRecognizer.addTarget(self, action: #selector(ef_didPanThumbView(gestureRecognizer:)))
        self.addSubview(thumbView)

        let color = UIColor.blue.cgColor
        self.setColors(colors: [color, color])
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class var requiresConstraintBasedLayout: Bool {
        get {
            return true
        }
    }

    override public var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: EFSliderViewMinWidth, height: EFSliderViewHeight)
        }
    }

    func setValue(value: CGFloat) {
        if (value < minimumValue) {
            self.value = minimumValue
        } else if (value > maximumValue) {
            self.value = maximumValue
        } else {
            self.value = value
        }

        self.ef_updateThumbPositionWithValue(value: self.value)
    }

    // Sets the array of CGColorRef objects defining the color of each gradient stop on the track.
    // The location of each gradient stop is evaluated with formula: i * width_of_the_track / number_of_colors.
    // @param colors An array of CGColorRef objects.
    func setColors(colors: [CGColor]) {
        if colors.count <= 1 {
            fatalError("‘colors: [CGColor]’ at least need to have 2 elements")
        }
        trackLayer.colors = colors
        self.ef_updateLocations()
    }

    override public func layoutSubviews() {
        self.ef_updateThumbPositionWithValue(value: self.value)
        self.ef_updateTrackLayer()
    }

    // MARK:- UIControl touch tracking events
    @objc func ef_didPanThumbView(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.began
            && gestureRecognizer.state != UIGestureRecognizerState.changed {
            return
        }

        let translation = gestureRecognizer.translation(in: self)
        gestureRecognizer.setTranslation(CGPoint.zero, in: self)

        self.ef_setValueWithTranslation(translation: translation.x)
    }

    func ef_updateTrackLayer() {
        let height: CGFloat = EFSliderViewHeight
        let width: CGFloat = self.bounds.width

        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        trackLayer.bounds = CGRect(x: 0, y: 0, width: width, height: EFSliderViewTrackHeight)
        trackLayer.position = CGPoint(x: self.bounds.width / 2, y: height / 2)
        CATransaction.commit()
    }

    // MARK:- Private methods
    private func ef_setValueWithTranslation(translation: CGFloat) {
        let width: CGFloat = self.bounds.width - thumbView.bounds.width
        let valueRange: CGFloat = maximumValue - minimumValue
        let value: CGFloat = self.value + valueRange * translation / width

        self.setValue(value: value)
        self.sendActions(for: UIControlEvents.valueChanged)
    }

    private func ef_updateLocations() {
        let size: Int = trackLayer.colors?.count ?? 2
        if size == trackLayer.locations?.count {
            return
        }

        let step: CGFloat = 1.0 / (CGFloat(size) - 1)
        var locations: [NSNumber] = [0]

        var i: Int = 1
        while i < size - 1 {
            locations.append(NSNumber(value: Double(CGFloat(i) * step)))
            i += 1
        }

        locations.append(1.0)
        trackLayer.locations = locations
    }

    private func ef_updateThumbPositionWithValue(value: CGFloat) {
        let thumbWidth: CGFloat = thumbView.bounds.width
        let thumbHeight: CGFloat = thumbView.bounds.height
        let width: CGFloat = self.bounds.width - thumbWidth

        if width == 0 {
            return
        }

        let percentage: CGFloat = (value - minimumValue) / (maximumValue - minimumValue)
        let position: CGFloat = width * percentage
        thumbView.frame = CGRect(x: position, y: 0, width: thumbWidth, height: thumbHeight)
    }
}
