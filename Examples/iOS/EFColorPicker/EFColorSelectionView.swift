//
//  EFColorSelectionView.swift
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

// The enum to define the EFColorView's types.
public enum EFSelectedColorView: Int {
    // The RGB color view type.
    case RGB = 0

    // The HSB color view type.
    case HSB = 1
}

// The EFColorSelectionView aggregates views that should be used to edit color components.
public class EFColorSelectionView: UIView, EFColorView, EFColorViewDelegate {

    // The selected color view
    private(set) var selectedIndex: EFSelectedColorView = EFSelectedColorView.RGB

    let rgbColorView: EFRGBView = EFRGBView()
    let hsbColorView: EFHSBView = EFHSBView()

    weak public var delegate: EFColorViewDelegate?

    public var color: UIColor = UIColor.white {
        didSet {
            self.selectedView()?.color = color
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.ef_init()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.ef_init()
    }

    // Makes a color component view (rgb or hsb) visible according to the index.
    // @param index    This index define a view to show.
    // @param animated If YES, the view is being appeared using an animation.
    func setSelectedIndex(index: EFSelectedColorView, animated: Bool) {
        self.selectedIndex = index
        self.selectedView()?.color = self.color
        UIView.animate(withDuration: animated ? 0.5 : 0.0) {
            [weak self] in
            if let strongSelf = self {
                strongSelf.rgbColorView.alpha = EFSelectedColorView.RGB == index ? 1.0 : 0.0
                strongSelf.hsbColorView.alpha = EFSelectedColorView.HSB == index ? 1.0 : 0.0
            }
        }
    }

    func selectedView() -> EFColorView? {
        return (EFSelectedColorView.RGB == self.selectedIndex ? self.rgbColorView : self.hsbColorView) as? EFColorView
    }

    func addColorView(view: EFColorView) {
        view.delegate = self
        if let view = view as? UIView {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            let views = [
                "view" : view
            ]
            let visualFormats = [
                "H:|[view]|",
                "V:|[view]|"
            ]
            for visualFormat in visualFormats {
                self.addConstraints(
                    NSLayoutConstraint.constraints(
                        withVisualFormat: visualFormat,
                        options: NSLayoutFormatOptions(rawValue: 0),
                        metrics: nil,
                        views: views
                    )
                )
            }
        }
    }

    override public func updateConstraints() {
        self.rgbColorView.setNeedsUpdateConstraints()
        self.hsbColorView.setNeedsUpdateConstraints()
        super.updateConstraints()
    }

    // MARK:- FBColorViewDelegate methods
    public func colorView(colorView: EFColorView, didChangeColor color: UIColor) {
        self.color = color
        self.delegate?.colorView(colorView: self, didChangeColor: self.color)
    }

    // MARK:- Private
    private func ef_init() {
        self.accessibilityLabel = "color_selection_view"

        self.backgroundColor = UIColor.white
        self.addColorView(view: rgbColorView)
        self.addColorView(view: hsbColorView)
        self.setSelectedIndex(index: EFSelectedColorView.RGB, animated: false)
    }
}
