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

/**
 * Extensions for CGColor to support QR code color processing and conversion.
 *
 * This extension provides utility methods for CGColor that are used throughout
 * the EFQRCode library for color manipulation, conversion, and formatting.
 *
 * ## Features
 *
 * - RGB color creation from integer values
 * - Hex string conversion for web compatibility
 * - Alpha channel extraction and manipulation
 * - Color space conversion to RGBA
 * - RGBA component extraction
 *
 * ## Usage
 *
 * ```swift
 * // Create color from RGB integer
 * let color = CGColor.createWith(rgb: 0xFF0000, alpha: 1.0)
 * 
 * // Convert to hex string
 * let hexString = try color?.hexString()
 * // Result: "#FF0000"
 * 
 * // Extract alpha value
 * let alpha = try color?.alpha()
 * // Result: 1.0
 * 
 * // Get RGBA components
 * let rgba = try color?.rgba()
 * // Result: (red: 255, green: 0, blue: 0, alpha: 1.0)
 * ```
 */
extension CGColor {
    
    /**
     * Creates a CGColor from an RGB integer value.
     *
     * This method converts a 32-bit RGB integer to a CGColor object.
     * The RGB values are extracted from the integer using bit shifting.
     *
     * - Parameters:
     *   - rgb: A 32-bit integer representing RGB values (0xRRGGBB).
     *   - alpha: The alpha value for the color (0.0 to 1.0). Defaults to 1.0.
     * - Returns: A CGColor object, or nil if color creation fails.
     *
     * ## Example
     *
     * ```swift
     * let redColor = CGColor.createWith(rgb: 0xFF0000)      // Red
     * let greenColor = CGColor.createWith(rgb: 0x00FF00)    // Green
     * let blueColor = CGColor.createWith(rgb: 0x0000FF)     // Blue
     * ```
     */
    static func createWith(rgb: UInt32, alpha: CGFloat = 1.0) -> CGColor? {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        let components = [red, green, blue, alpha]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        return CGColor(colorSpace: colorSpace, components: components)
    }
    
    /**
     * Converts the CGColor to a hex string representation.
     *
     * This method converts the color to a standard hex string format
     * commonly used in web development and design tools.
     *
     * - Returns: A hex string in the format "#RRGGBB".
     * - Throws: `EFQRCodeError.invalidCGColorComponents` if color components cannot be extracted.
     *
     * ## Example
     *
     * ```swift
     * let color = CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
     * let hexString = try color.hexString()
     * // Result: "#FF0000"
     * ```
     */
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
    
    /**
     * Extracts the alpha channel value from the CGColor.
     *
     * This method returns the transparency level of the color.
     * If the color doesn't have an alpha component, it returns 1.0 (fully opaque).
     *
     * - Returns: The alpha value (0.0 to 1.0).
     * - Throws: `EFQRCodeError.invalidCGColorComponents` if color components cannot be extracted.
     *
     * ## Example
     *
     * ```swift
     * let color = CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
     * let alpha = try color.alpha()
     * // Result: 0.5
     * ```
     */
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
    
    /**
     * Converts the CGColor to RGBA color space.
     *
     * This method ensures the color is in the device RGB color space,
     * which is required for consistent color component extraction.
     *
     * - Returns: A CGColor in RGBA color space.
     * - Throws: `EFQRCodeError.colorSpaceConversionFailure` if color space conversion fails.
     */
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
    
    /**
     * Extracts RGBA components from the CGColor.
     *
     * This method returns the individual red, green, blue, and alpha components
     * as 8-bit integers and a CGFloat alpha value.
     *
     * - Returns: A tuple containing (red, green, blue, alpha) components.
     * - Throws: `EFQRCodeError.invalidCGColorComponents` if color components cannot be extracted.
     *
     * ## Example
     *
     * ```swift
     * let color = CGColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.8)
     * let rgba = try color.rgba()
     * // Result: (red: 255, green: 128, blue: 0, alpha: 0.8)
     * ```
     */
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
