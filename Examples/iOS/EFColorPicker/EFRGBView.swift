//
//  EFRGBView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/29.
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

public class EFRGBView: UIView, EFColorView {

    let EFColorSampleViewHeight: CGFloat = 30.0
    let EFViewMargin: CGFloat = 20.0
    let EFSliderViewMargin: CGFloat = 30.0
    let EFRGBColorComponentsSize: Int = 3

    private let colorSample: UIView = UIView()
    var colorComponentViews: [EFColorComponentView] = []
    private var colorComponents: RGB = RGB(1, 1, 1, 1)

    weak public var delegate: EFColorViewDelegate?

    public var color: UIColor {
        get {
            return UIColor(
                red: colorComponents.red,
                green: colorComponents.green,
                blue: colorComponents.blue,
                alpha: colorComponents.alpha
            )
        }
        set {
            colorComponents = EFRGBColorComponents(color: newValue)
            self.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.ef_baseInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.ef_baseInit()
    }

    func reloadData() {
        colorSample.backgroundColor = self.color
        colorSample.accessibilityValue = EFHexStringFromColor(color: self.color)
        self.ef_reloadColorComponentViews(colorComponents: colorComponents)
    }

    // MARK:- Private methods
    private func ef_baseInit() {
        self.accessibilityLabel = "rgb_view"

        colorSample.accessibilityLabel = "color_sample"
        colorSample.layer.borderColor = UIColor.black.cgColor
        colorSample.layer.borderWidth = 0.5
        colorSample.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(colorSample)

        var tmp: [EFColorComponentView] = []
        let titles = [
            NSLocalizedString("Red", comment: ""),
            NSLocalizedString("Green", comment: ""),
            NSLocalizedString("Blue", comment: "")
        ]
        let maxValues: [CGFloat] = [
            EFRGBColorComponentMaxValue, EFRGBColorComponentMaxValue, EFRGBColorComponentMaxValue
        ]
        for i in 0 ..< EFRGBColorComponentsSize {
            let colorComponentView = self.ef_colorComponentViewWithTitle(
                title: titles[i], tag: i, maxValue: maxValues[i]
            )
            self.addSubview(colorComponentView)
            colorComponentView.addTarget(
                self, action: #selector(ef_colorComponentDidChangeValue(_:)), for: UIControlEvents.valueChanged
            )
            tmp.append(colorComponentView)
        }

        colorComponentViews = tmp
        self.ef_installConstraints()
    }

    @objc @IBAction private func ef_colorComponentDidChangeValue(_ sender: EFColorComponentView) {
        self.ef_setColorComponentValue(value: sender.value / sender.maximumValue, atIndex: UInt(sender.tag))
        self.delegate?.colorView(colorView: self, didChangeColor: self.color)
        self.reloadData()
    }

    private func ef_setColorComponentValue(value: CGFloat, atIndex index: UInt) {
        switch index {
        case 0:
            colorComponents.red = value
            break
        case 1:
            colorComponents.green = value
            break
        case 2:
            colorComponents.blue = value
            break
        default:
            colorComponents.alpha = value
            break
        }
    }

    private func ef_colorComponentViewWithTitle(title: String, tag: Int, maxValue: CGFloat) -> EFColorComponentView {
        let colorComponentView: EFColorComponentView = EFColorComponentView()
        colorComponentView.title = title
        colorComponentView.translatesAutoresizingMaskIntoConstraints = false
        colorComponentView.tag = tag
        colorComponentView.maximumValue = maxValue
        return colorComponentView
    }

    private func ef_installConstraints() {
        let metrics = [
            "margin" : EFViewMargin,
            "height" : EFColorSampleViewHeight,
            "slider_margin" : EFSliderViewMargin
        ]
        var views = [
            "colorSample" : colorSample
        ]

        let visualFormats = [
            "H:|-margin-[colorSample]-margin-|",
            "V:|-margin-[colorSample(height)]"
        ]
        for visualFormat in visualFormats {
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: visualFormat,
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: metrics,
                    views: views
                )
            )
        }

        var previousView: UIView = colorSample
        for colorComponentView in colorComponentViews {
            views = [
                "previousView" : previousView,
                "colorComponentView" : colorComponentView
            ]

            let visualFormats = [
                "H:|-margin-[colorComponentView]-margin-|",
                "V:[previousView]-slider_margin-[colorComponentView]"
            ]
            for visualFormat in visualFormats {
                self.addConstraints(
                    NSLayoutConstraint.constraints(
                        withVisualFormat: visualFormat,
                        options: NSLayoutFormatOptions(rawValue: 0),
                        metrics: metrics,
                        views: views
                    )
                )
            }

            previousView = colorComponentView
        }

        views = [
            "previousView" : previousView
        ]
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[previousView]-(>=margin)-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views
            )
        )
    }

    private func ef_colorComponentsWithRGB(rgb: RGB) -> [CGFloat] {
        return [rgb.red, rgb.green, rgb.blue, rgb.alpha]
    }

    private func ef_reloadColorComponentViews(colorComponents: RGB) {
        let components = self.ef_colorComponentsWithRGB(rgb: colorComponents)

        for (idx, colorComponentView) in colorComponentViews.enumerated() {
            colorComponentView.setColors(
                colors: self.ef_colorsWithColorComponents(
                    colorComponents: components, currentColorIndex: colorComponentView.tag
                )
            )
            colorComponentView.value = components[idx] * colorComponentView.maximumValue
        }
    }

    private func ef_colorsWithColorComponents(colorComponents: [CGFloat], currentColorIndex colorIndex: Int) -> [CGColor] {
        let currentColorValue: CGFloat = colorComponents[colorIndex]
        var colors: [CGFloat] = [CGFloat](repeating: 0, count: 12)
        for i in 0 ..< EFRGBColorComponentsSize {
            colors[i] = colorComponents[i]
            colors[i + 4] = colorComponents[i]
            colors[i + 8] = colorComponents[i]
        }
        colors[colorIndex] = 0
        colors[colorIndex + 4] = currentColorValue
        colors[colorIndex + 8] = 1.0

        let start: UIColor = UIColor(red: colors[0], green: colors[1], blue: colors[2], alpha: 1)
        let middle: UIColor = UIColor(red: colors[4], green: colors[5], blue: colors[6], alpha: 1)
        let end: UIColor = UIColor(red: colors[8], green: colors[9], blue: colors[10], alpha: 1)

        return [start.cgColor, middle.cgColor, end.cgColor]
    }
}
