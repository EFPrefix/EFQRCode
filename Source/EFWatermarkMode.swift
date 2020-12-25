//
//  EFDefine.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/4/11.
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

import Foundation

/// Options to specify how watermark position and size for QR code.
@objc public enum EFWatermarkMode: Int {
    /// The option to scale the watermark to fit the size of QR code by changing the aspect ratio of the watermark if necessary.
    case scaleToFill        = 0
    /// The option to scale the watermark to fit the size of the QR code by maintaining the aspect ratio. Any remaining area of the QR code uses the background color.
    case scaleAspectFit     = 1
    /// The option to scale the watermark to fill the size of the QR code. Some portion of the watermark may be clipped to fill the QR code.
    case scaleAspectFill    = 2
    /// The option to center the watermark in the QR code, keeping the proportions the same.
    case center             = 3
    /// The option to center the watermark aligned at the top in the QR code.
    case top                = 4
    /// The option to center the watermark aligned at the bottom in the QR code.
    case bottom             = 5
    /// The option to align the watermark on the left of the QR code.
    case left               = 6
    /// The option to align the watermark on the right of the QR code.
    case right              = 7
    /// The option to align the watermark in the top-left corner of the QR code.
    case topLeft            = 8
    /// The option to align the watermark in the top-right corner of the QR code.
    case topRight           = 9
    /// The option to align the watermark in the bottom-left corner of the QR code.
    case bottomLeft         = 10
    /// The option to align the watermark in the bottom-right corner of the QR code.
    case bottomRight        = 11
}
