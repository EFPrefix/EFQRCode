//
//  CGColor+.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/4/9.
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

#if os(watchOS)
    import UIKit

    public extension CGColor {

        public static func EFWhite() -> CGColor! {
            return UIColor.white.cgColor
        }

        public static func EFBlack() -> CGColor! {
            return UIColor.black.cgColor
        }

        func toEFUIntPixel() -> EFUIntPixel? {
            guard let rgba = converted(to: CGColorSpaceCreateDeviceRGB(),
                                      intent: .defaultIntent, options: nil),
                let components = rgba.components,
                rgba.numberOfComponents == 4
                else { return nil }
            return EFUIntPixel(red: UInt8(components[0] * 255.0),
                               green: UInt8(components[1] * 255.0),
                               blue: UInt8(components[2] * 255.0),
                               alpha: UInt8(components[3] * 255.0))
        }
    }
#else
    import CoreImage

    public extension CGColor {

        public static func EFWhite() -> CGColor! {
            return CIColor.EFWhite().toCGColor()
        }

        public static func EFBlack() -> CGColor! {
            return CIColor.EFBlack().toCGColor()
        }

        public func toCIColor() -> CIColor {
            return CIColor(cgColor: self)
        }

        func toEFUIntPixel() -> EFUIntPixel? {
            let ciColor = toCIColor()
            return EFUIntPixel(red: UInt8(ciColor.red * 255.0),
                               green: UInt8(ciColor.green * 255.0),
                               blue: UInt8(ciColor.blue * 255.0),
                               alpha: UInt8(ciColor.alpha * 255.0))
        }
    }
#endif
