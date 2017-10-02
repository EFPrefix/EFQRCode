//
//  EFColorView.swift
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

//  The delegate of a EFColorView object must adopt the EFColorViewDelegate protocol.
//  Methods of the protocol allow the delegate to handle color value changes.
public protocol EFColorViewDelegate: class {

    // Tells the data source to return the color components.
    // @param colorView The color view.
    // @param color The new color value.
    func colorView(colorView: EFColorView, didChangeColor color: UIColor)
}

/// The \c EFColorView protocol declares a view's interface for displaying and editing color value.
public protocol EFColorView: class {

    // The object that acts as the delegate of the receiving color selection view.
    weak var delegate: EFColorViewDelegate? { get set }

    // The current color.
    var color: UIColor { get set }
}
