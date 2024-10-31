//
//  CGColor++.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/2.
//
//  Copyright (c) 2017-2024 EyreFree <eyrefree@eyrefree.org>
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
import CoreGraphics

extension CGColor {
    
    static func createWith(rgb: UInt32, alpha: CGFloat = 1.0) -> CGColor? {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        let components = [red, green, blue, alpha]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        return CGColor(colorSpace: colorSpace, components: components)
    }
    
    func hexString() throws -> String {
        let rgbaColor = try self.rgbaColor()
        guard let components = rgbaColor.components, components.count >= 3 else {
            throw EFQRCodeError.invalidCGColorComponents
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
        return hexString
    }
    
    func alpha() throws -> CGFloat {
        let rgbaColor = try self.rgbaColor()
        guard let components = rgbaColor.components, components.count >= 3 else {
            throw EFQRCodeError.invalidCGColorComponents
        }
        let alpha: CGFloat = {
            if components.count > 3 {
                return components[3]
            }
            return 1
        }()
        return alpha
    }
    
    func rgbaColor() throws -> CGColor {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        if let colorSpace = self.colorSpace, CFEqual(colorSpace, rgbColorSpace) {
            return self
        }
        guard let rgbColor = self.converted(to: rgbColorSpace, intent: .defaultIntent, options: nil) else {
            throw EFQRCodeError.colorSpaceConversionFailure
        }
        return rgbColor
    }
    
    func rgba() throws -> (red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat) {
        let rgbaColor: CGColor = try self.rgbaColor()
        if let components = rgbaColor.components, components.count >= 3 {
            return(
                red: UInt8(components[0] * 255.0),
                green: UInt8(components[1] * 255.0),
                blue: UInt8(components[2] * 255.0),
                alpha: components.count > 3 ? components[3] : 1
            )
        } else {
            throw EFQRCodeError.invalidCGColorComponents
        }
    }
}
