//
//  CGColor++.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/2.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGColor {
    
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
        let alpha = components[3]
        return alpha / 255.0
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
}
