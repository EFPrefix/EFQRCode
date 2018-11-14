//
//  EFUIntPixel.swift
//  EFQRCode
//
//  Created by EyreFree on 2018/11/14.
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

import CoreGraphics

#if os(iOS) || os(tvOS) || os(macOS)
import CoreImage
#endif

public struct EFUIntPixel {
    public var red: UInt8 = 0
    public var green: UInt8 = 0
    public var blue: UInt8 = 0
    public var alpha: UInt8 = 0

    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init?(color: CGColor) {
        var color = color
        if color.colorSpace?.model != .rgb, #available(iOS 9.0, *) {
            color = color.converted(
                to: CGColorSpaceCreateDeviceRGB(),
                intent: .defaultIntent,
                options: nil
                ) ?? color
        }
        if let components = color.components, 4 == color.numberOfComponents {
            self.init(
                red: UInt8(components[0] * 255.0),
                green: UInt8(components[1] * 255.0),
                blue: UInt8(components[2] * 255.0),
                alpha: UInt8(components[3] * 255.0)
            )
        } else {
            return nil
        }
    }
}
