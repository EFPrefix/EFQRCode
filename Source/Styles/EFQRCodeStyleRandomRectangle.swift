//
//  EFQRCodeStyleRandomRectangle.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/3.
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

import QRCodeSwift

/**
 * Parameters for random rectangle QR code styling.
 *
 * This class defines the styling parameters for random rectangle QR codes, which
 * create QR codes with randomly sized and colored rectangles for each dark module.
 * This creates QR codes with a unique, artistic appearance that maintains scannability.
 *
 * ## Features
 *
 * - Random rectangle generation for each dark module
 * - Variable rectangle sizes and colors
 * - Artistic, non-uniform appearance
 * - Icon and backdrop support
 * - Unique visual style
 *
 * ## Usage
 *
 * ```swift
 * let params = EFStyleRandomRectangleParams(
 *     icon: icon,
 *     backdrop: backdrop,
 *     color: .green
 * )
 * 
 * let style = EFQRCodeStyle.randomRectangle(params)
 * ```
 *
 * ## Visual Characteristics
 *
 * - Each dark module is represented by randomly sized rectangles
 * - Colors vary around the base color with random offsets
 * - Creates an artistic, non-uniform appearance
 * - Maintains QR code structure and scannability
 */
public class EFStyleRandomRectangleParams: EFStyleParams {
    /// The default backdrop configuration for random rectangle QR codes.
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    /// The default color for random rectangles (green).
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x14AA3C)!
    /// The base color for random rectangles.
    let color: CGColor
    /**
     * Creates random rectangle QR code styling parameters.
     *
     * - Parameters:
     *   - icon: The icon to display in the center of the QR code. Defaults to nil.
     *   - backdrop: The backdrop configuration. Defaults to default backdrop.
     *   - color: The base color for random rectangles. Defaults to green.
     */
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleRandomRectangleParams.defaultBackdrop,
        color: CGColor = EFStyleRandomRectangleParams.defaultColor
    ) {
        self.color = color
        super.init(icon: icon, backdrop: backdrop)
    }
    /**
     * Creates a copy of the parameters with optional modifications.
     *
     * - Parameters:
     *   - icon: The new icon. If nil, keeps the current icon.
     *   - backdrop: The new backdrop. If nil, keeps the current backdrop.
     *   - color: The new color. If nil, keeps the current color.
     * - Returns: A new EFStyleRandomRectangleParams with the specified modifications.
     */
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        color: CGColor? = nil
    ) -> EFStyleRandomRectangleParams {
        return EFStyleRandomRectangleParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            color: color ?? self.color
        )
    }
}

/**
 * Random rectangle QR code implementation.
 *
 * This class implements the random rectangle QR code rendering, creating QR codes
 * with randomly sized and colored rectangles for each dark module. This creates
 * QR codes with a unique, artistic appearance.
 *
 * ## Features
 *
 * - Random rectangle generation for dark modules
 * - Variable sizes and colors based on base color
 * - Artistic, non-uniform appearance
 * - Icon and backdrop support
 * - Unique visual style
 *
 * ## Usage
 *
 * ```swift
 * let params = EFStyleRandomRectangleParams(
 *     color: .green
 * )
 * 
 * let style = EFQRCodeStyleRandomRectangle(params: params)
 * ```
 */
public class EFQRCodeStyleRandomRectangle: EFQRCodeStyleBase {
    /// The random rectangle styling parameters.
    let params: EFStyleRandomRectangleParams
    /**
     * Creates a random rectangle QR code with the specified parameters.
     *
     * - Parameter params: The random rectangle styling parameters.
     */
    public init(params: EFStyleRandomRectangleParams) {
        self.params = params
        super.init()
    }
    /**
     * Writes the QR code to SVG format with random rectangles.
     *
     * This method generates random rectangles for each dark module in the QR code,
     * creating a unique, artistic appearance.
     *
     * - Parameter qrcode: The QR code model.
     * - Returns: An array of SVG strings representing the random rectangles.
     * - Throws: An error if writing fails.
     */
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        var id: Int = 0
        
        let rgba = try params.color.rgba()
        let redValue: Double = rgba.red.double// ?? 20
        let greenValue: Double = rgba.green.double// ?? 170
        let blueValue: Double = rgba.blue.double// ?? 60
        let alphaValue: Double = rgba.alpha
        
        var randArr: [(Int, Int)] = []
        for row in 0..<nCount {
            for col in 0..<nCount {
                randArr.append((row, col))
            }
        }
        randArr.shuffle()
        
        for randItem in randArr {
            let row: Int = randItem.0
            let col: Int = randItem.1
            
            let isDark: Bool = qrcode.model.isDark(row, col)
            if isDark {
                let tempRand = Double.random(in: 0.8...1.3)
                let randNum = Double.random(in: 50...230)
                
                let rValue = clampRGBValue(Int(redValue + randNum))
                let gValue = clampRGBValue(Int(greenValue - randNum / 2))
                let bValue = clampRGBValue(Int(blueValue + randNum * 2))
                
                let r2Value = clampRGBValue(rValue - 40)
                let g2Value = clampRGBValue(gValue - 40)
                let b2Value = clampRGBValue(bValue - 40)
                
                let tempRGB = [
                    "rgb(\(rValue),\(gValue),\(bValue))",
                    "rgb(\(r2Value),\(g2Value),\(b2Value))"
                ]
                let width: CGFloat = 0.15
                pointList.append("<rect key=\"\(id)\" opacity=\"\(0.9 * alphaValue)\" fill=\"\(tempRGB[1])\" width=\"\(1 * tempRand.cgFloat + width.cgFloat)\" height=\"\(1 * tempRand.cgFloat + width.cgFloat)\" x=\"\(row.cgFloat - (tempRand.cgFloat - 1) / 2.0)\" y=\"\(col.cgFloat - (tempRand.cgFloat - 1) / 2.0)\"/>")
                id += 1
                pointList.append("<rect key=\"\(id)\" opacity=\"\(alphaValue)\" fill=\"\(tempRGB[0])\" width=\"\(1 * tempRand.cgFloat)\" height=\"\(1 * tempRand.cgFloat)\" x=\"\(row.cgFloat - (tempRand.cgFloat - 1) / 2.0)\" y=\"\(col.cgFloat - (tempRand.cgFloat - 1) / 2.0)\"/>")
                id += 1
            }
        }
        return pointList
    }
    /**
     * Writes the icon to SVG format.
     *
     * - Parameter qrcode: The QR code model.
     * - Returns: An array of SVG strings.
     * - Throws: An error if writing fails.
     */
    override func writeIcon(qrcode: QRCode) throws -> [String] {
        return try params.icon?.write(qrcode: qrcode) ?? []
    }
    /**
     * Calculates the viewBox for the QR code.
     *
     * - Parameter qrcode: The QR code model.
     * - Returns: The viewBox rectangle.
     */
    override func viewBox(qrcode: QRCode) -> CGRect {
        return params.backdrop.viewBox(moduleCount: qrcode.model.moduleCount)
    }
    /**
     * Generates the SVG string for the QR code.
     *
     * - Parameter qrcode: The QR code model.
     * - Returns: The SVG string.
     * - Throws: An error if generation fails.
     */
    override func generateSVG(qrcode: QRCode) throws -> String {
        let viewBoxRect: CGRect = viewBox(qrcode: qrcode)
        let (part1, part2) = try params.backdrop.generateSVG(qrcode: qrcode, viewBoxRect: viewBoxRect)
        return part1
        + (try writeQRCode(qrcode: qrcode)).joined()
        + (try writeIcon(qrcode: qrcode)).joined()
        + part2
    }
    /**
     * Clamps RGB values to the valid range [0, 255].
     *
     * - Parameter value: The RGB value to clamp.
     * - Returns: The clamped RGB value.
     */
    private func clampRGBValue(_ value: Int) -> Int {
        return max(0, min(255, value))
    }
    /**
     * Creates a copy of the style with optional modified icon and watermark images.
     *
     * - Parameters:
     *   - iconImage: The new icon image. If nil, keeps the current icon image.
     *   - watermarkImage: The new watermark image. If nil, keeps the current watermark image.
     * - Returns: A new EFQRCodeStyleBase with the specified modifications.
     */
    override func copyWith(
        iconImage: EFStyleParamImage? = nil,
        watermarkImage: EFStyleParamImage? = nil
    ) -> EFQRCodeStyleBase {
        let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
        return EFQRCodeStyleRandomRectangle(params: params.copyWith(icon: icon))
    }
    /**
     * Retrieves the current icon and watermark images.
     *
     * - Returns: A tuple containing the icon image and watermark image.
     */
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, nil)
    }
    /**
     * Converts the style to an EFQRCodeStyle.
     *
     * - Returns: The EFQRCodeStyle representation.
     */
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.randomRectangle(params: self.params)
    }
}
