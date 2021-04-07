//
//  CGColor+.swift
//  EFQRCode
//
//  Created by EyreFree on 2019/11/20.
//
//  Copyright (c) 2017-2021 EyreFree <eyrefree@eyrefree.org>
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

#if canImport(CoreImage)
import CoreImage
#endif

#if canImport(UIKit)
import UIKit
#endif

extension CGColor {
    
    #if canImport(CoreImage)
    func ciColor() -> CIColor {
        return CIColor(cgColor: self)
    }
    #endif
    
    #if canImport(UIKit)
    func uiColor() -> UIColor {
        return UIColor(cgColor: self)
    }
    #endif
    
    var rgba: (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)? {
        var color = self
        if color.colorSpace?.model != .rgb, #available(iOS 9.0, macOS 10.11, tvOS 9.0, watchOS 2.0, *) {
            color = color.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil) ?? color
        }
        if let components = color.components, 4 == color.numberOfComponents {
            return(
                red: UInt8(components[0] * 255.0),
                green: UInt8(components[1] * 255.0),
                blue: UInt8(components[2] * 255.0),
                alpha: UInt8(components[3] * 255.0)
            )
        } else {
            return nil
        }
    }
    
    static func initWith(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> CGColor? {
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [red, green, blue, alpha])
    }
}

public extension CGColor {
    /// Creates a white color in the RGB color space.
    /// - Parameters:
    ///   - white: how bright the color is, on a scale from 0 through 1.
    ///   - alpha: transparency, on a scale from 0 through 1.
    /// - Returns: the specified white color.
    static func white(_ white: CGFloat = 1.0, alpha: CGFloat = 1.0) -> CGColor? {
        return initWith(red: white, green: white, blue: white, alpha: alpha)
    }

    /// Creates a black color in the RGB color space.
    /// - Parameters:
    ///   - black: how dark the color is, on a scale from 0 through 1.
    ///   - alpha: transparency, on a scale from 0 through 1.
    /// - Returns: `white(1 - black, alpha: alpha)`.
    static func black(_ black: CGFloat = 1.0, alpha: CGFloat = 1.0) -> CGColor? {
        return white(1.0 - black, alpha: alpha)
    }
}
