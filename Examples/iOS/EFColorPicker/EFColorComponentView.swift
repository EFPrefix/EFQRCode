//
//  EFColorComponentView.swift
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

// The view to edit a color component.
public class EFColorComponentView: UIControl, UITextFieldDelegate {

    // Temporary disabled the color component editing via text field
    public var colorTextFieldEnabled: Bool = false {
        didSet {
            if textField.isHidden != !colorTextFieldEnabled {
                ef_remakeConstraints()
                textField.isHidden = !colorTextFieldEnabled
            }
        }
    }

    let EFColorComponentViewSpacing: CGFloat = 5.0
    let EFColorComponentLabelWidth: CGFloat = 60.0
    let EFColorComponentTextFieldWidth: CGFloat = 50.0

    // The title.
    var title: String {
        get {
            return label.text ?? ""
        }
        set {
            label.text = newValue
        }
    }

    // The current value. The default value is 0.0.
    var value: CGFloat {
        get {
            return slider.value
        }
        set {
            slider.setValue(value: newValue)
            textField.text = String(format: format, value)
        }
    }

    // The minimum value. The default value is 0.0.
    var minimumValue: CGFloat {
        get {
            return slider.minimumValue
        }
        set {
            slider.minimumValue = newValue
        }
    }

    // The maximum value. The default value is 255.0.
    var maximumValue: CGFloat {
        get {
            return slider.maximumValue
        }
        set {
            slider.maximumValue = newValue
        }
    }

    // The format string to use apply for textfield value. \c %.f by default.
    var format: String = "%.f"

    private let label: UILabel = UILabel()
    private let slider: EFSliderView = EFSliderView() // The color slider to edit color component.
    private let textField: UITextField = UITextField()

    override open class var requiresConstraintBasedLayout: Bool {
        get {
            return true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        ef_baseInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ef_baseInit()
    }

    // MARK:- UITextFieldDelegate methods
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.value = CGFloat(Double(textField.text ?? "") ?? 0)
        self.sendActions(for: UIControlEvents.valueChanged)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        //first, check if the new string is numeric only. If not, return NO;
        let characterSet = NSCharacterSet(charactersIn: "0123456789,.").inverted
        if !(newString.rangeOfCharacter(from: characterSet)?.isEmpty != false) {
            return false
        }
        return CGFloat(Double(newString) ?? 0) <= slider.maximumValue
    }

    // Sets the array of CGColorRef objects defining the color of each gradient stop on a slider's track.
    // The location of each gradient stop is evaluated with formula: i * width_of_the_track / number_of_colors.
    // @param colors An array of CGColorRef objects.
    func setColors(colors: [CGColor]) {
        if colors.count <= 1 {
            fatalError("‘colors: [CGColor]’ at least need to have 2 elements")
        }

        slider.setColors(colors: colors)
    }

    // MARK:- Private methods
    private func ef_baseInit() {
        self.accessibilityLabel = "color_component_view"

        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)

        slider.maximumValue = EFRGBColorComponentMaxValue
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(slider)

        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.isHidden = !colorTextFieldEnabled
        self.addSubview(textField)

        self.value = 0.0

        slider.addTarget(self, action: #selector(ef_didChangeSliderValue(sender:)), for: UIControlEvents.valueChanged)
        textField.delegate = self

        self.ef_installConstraints()
    }

    @objc private func ef_didChangeSliderValue(sender: EFSliderView) {
        self.value = sender.value
        self.sendActions(for: UIControlEvents.valueChanged)
    }

    private func ef_installConstraints() {
        if colorTextFieldEnabled {
            let views: [String : Any] = [
                "label" : label,
                "slider" : slider,
                "textField" : textField
            ]
            let metrics: [String : Any] = [
                "spacing" : EFColorComponentViewSpacing,
                "label_width" : EFColorComponentLabelWidth,
                "textfield_width" : EFColorComponentTextFieldWidth
            ]

            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[label(label_width)]-spacing-[slider]-spacing-[textField(textfield_width)]|",
                    options: NSLayoutFormatOptions.alignAllCenterY,
                    metrics: metrics,
                    views: views
                )
            )
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[label]|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: views
                )
            )
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[textField]|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: views
                )
            )
        } else {
            let views: [String : Any] = [
                "label" : label,
                "slider" : slider
            ]
            let metrics: [String : Any] = [
                "spacing" : EFColorComponentViewSpacing,
                "label_width" : EFColorComponentLabelWidth
            ]
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[label(label_width)]-spacing-[slider]-spacing-|",
                    options: NSLayoutFormatOptions.alignAllCenterY,
                    metrics: metrics,
                    views: views
                )
            )
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[label]|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: views
                )
            )
        }
    }

    private func ef_remakeConstraints() {
        // Remove all old constraints
        if !colorTextFieldEnabled {
            let views: [String : Any] = [
                "label" : label,
                "slider" : slider,
                "textField" : textField
            ]
            let metrics: [String : Any] = [
                "spacing" : EFColorComponentViewSpacing,
                "label_width" : EFColorComponentLabelWidth,
                "textfield_width" : EFColorComponentTextFieldWidth
            ]
            self.removeConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[label(label_width)]-spacing-[slider]-spacing-[textField(textfield_width)]|",
                    options: NSLayoutFormatOptions.alignAllCenterY,
                    metrics: metrics,
                    views: views
                )
            )
            self.removeConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[label]|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: views
                )
            )
            self.removeConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[textField]|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: views
                )
            )
        } else {
            let views: [String : Any] = [
                "label" : label,
                "slider" : slider
            ]
            let metrics: [String : Any] = [
                "spacing" : EFColorComponentViewSpacing,
                "label_width" : EFColorComponentLabelWidth
            ]
            self.removeConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[label(label_width)]-spacing-[slider]-spacing-|",
                    options: NSLayoutFormatOptions.alignAllCenterY,
                    metrics: metrics,
                    views: views
                )
            )
            self.removeConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[label]|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: views
                )
            )
        }

        // Readd control
        for control in [label, slider, textField] {
            control.removeFromSuperview()
            self.addSubview(control)
        }

        // Add new constraints
        ef_installConstraints()
    }
}
