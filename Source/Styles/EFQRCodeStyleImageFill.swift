//
//  EFQRCodeStyleImageFill.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/4.
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
 * Parameters for image fill QR code styling.
 *
 * This class defines the styling parameters for image fill QR codes, which use
 * images as background with QR code modules as masks. This creates QR codes
 * where the image shows through the QR code pattern.
 *
 * ## Features
 *
 * - Image background with QR code mask
 * - Customizable background and mask colors
 * - Icon and backdrop support
 * - Image transparency control
 *
 * ## Usage
 *
 * ```swift
 * let imageParams = EFStyleImageFillParamsImage(
 *     image: myImage,
 *     mode: .scaleAspectFill,
 *     alpha: 1.0
 * )
 * 
 * let params = EFStyleImageFillParams(
 *     icon: icon,
 *     backdrop: backdrop,
 *     image: imageParams,
 *     backgroundColor: .white,
 *     maskColor: .black
 * )
 * 
 * let style = EFQRCodeStyle.imageFill(params)
 * ```
 *
 * ## Visual Characteristics
 *
 * - Image appears as background
 * - QR code modules create mask over image
 * - Maintains QR code structure and scannability
 * - Creates visually appealing QR codes with image content
 */
public class EFStyleImageFillParams: EFStyleParams {
    /// The default backdrop configuration for image fill QR codes.
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    /// The default background color (white).
    public static let defaultBackgroundColor: CGColor = CGColor.createWith(rgb: 0xffffff)!
    /// The default mask color (semi-transparent black).
    public static let defaultMaskColor: CGColor = CGColor.createWith(rgb: 0x000000, alpha: 0.1)!
    /// The image configuration for background filling.
    let image: EFStyleImageFillParamsImage?
    /// The background color for the QR code.
    let backgroundColor: CGColor
    /// The mask color applied over the image.
    let maskColor: CGColor
    /**
     * Creates image fill QR code styling parameters.
     *
     * - Parameters:
     *   - icon: The icon to display in the center of the QR code. Defaults to nil.
     *   - backdrop: The backdrop configuration. Defaults to default backdrop.
     *   - image: The image configuration for background filling. Defaults to nil.
     *   - backgroundColor: The background color. Defaults to white.
     *   - maskColor: The mask color applied over the image. Defaults to semi-transparent black.
     */
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleImageFillParams.defaultBackdrop,
        image: EFStyleImageFillParamsImage?,
        backgroundColor: CGColor = EFStyleImageFillParams.defaultBackgroundColor,
        maskColor: CGColor = EFStyleImageFillParams.defaultMaskColor
    ) {
        self.image = image
        self.backgroundColor = backgroundColor
        self.maskColor = maskColor
        super.init(icon: icon, backdrop: backdrop)
    }
    /**
     * Creates a copy of the parameters with optional modifications.
     *
     * - Parameters:
     *   - icon: The new icon. If nil, keeps the current icon.
     *   - backdrop: The new backdrop. If nil, keeps the current backdrop.
     *   - image: The new image configuration. If nil, keeps the current image.
     *   - backgroundColor: The new background color. If nil, keeps the current background color.
     *   - maskColor: The new mask color. If nil, keeps the current mask color.
     * - Returns: A new EFStyleImageFillParams with the specified modifications.
     */
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        image: EFStyleImageFillParamsImage? = nil,
        backgroundColor: CGColor? = nil,
        maskColor: CGColor? = nil
    ) -> EFStyleImageFillParams {
        return EFStyleImageFillParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            image: image ?? self.image,
            backgroundColor: backgroundColor ?? self.backgroundColor,
            maskColor: maskColor ?? self.maskColor
        )
    }
}

/// Image configuration for image fill QR codes.
public class EFStyleImageFillParamsImage {
    /// The image to be used as background.
    let image: EFStyleParamImage
    /// The image mode for scaling and positioning.
    let mode: EFImageMode
    /// The alpha transparency value for the image.
    let alpha: CGFloat
    /**
     * Creates an image configuration for image fill QR codes.
     *
     * - Parameters:
     *   - image: The image to be used as background.
     *   - mode: The image mode for scaling and positioning. Defaults to scaleAspectFill.
     *   - alpha: The alpha transparency value. Defaults to 1.0.
     */
    public init(
        image: EFStyleParamImage,
        mode: EFImageMode = .scaleAspectFill,
        alpha: CGFloat = 1
    ) {
        self.image = image
        self.mode = mode
        self.alpha = alpha
    }
    /**
     * Creates a copy of the image configuration with optional modifications.
     *
     * - Parameters:
     *   - image: The new image. If nil, keeps the current image.
     *   - mode: The new image mode. If nil, keeps the current mode.
     *   - alpha: The new alpha value. If nil, keeps the current alpha.
     * - Returns: A new EFStyleImageFillParamsImage with the specified modifications.
     */
    func copyWith(
        image: EFStyleParamImage? = nil,
        mode: EFImageMode? = nil,
        alpha: CGFloat? = nil
    ) -> EFStyleImageFillParamsImage {
        return EFStyleImageFillParamsImage(
            image: image ?? self.image,
            mode: mode ?? self.mode,
            alpha: alpha ?? self.alpha
        )
    }
}

/**
 * Image fill QR code implementation.
 *
 * This class implements the image fill QR code rendering, creating QR codes
 * where images are used as background with QR code modules as masks.
 *
 * ## Features
 *
 * - Image background with QR code mask overlay
 * - Customizable background and mask colors
 * - Image transparency control
 * - Icon and backdrop support
 *
 * ## Usage
 *
 * ```swift
 * let params = EFStyleImageFillParams(
 *     image: imageParams,
 *     backgroundColor: .white,
 *     maskColor: .black
 * )
 * 
 * let style = EFQRCodeStyleImageFill(params: params)
 * ```
 */
public class EFQRCodeStyleImageFill: EFQRCodeStyleBase {
    /// The image fill styling parameters.
    let params: EFStyleImageFillParams
    /**
     * Creates an image fill QR code with the specified parameters.
     *
     * - Parameter params: The image fill styling parameters.
     */
    public init(params: EFStyleImageFillParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        
        let backgroundColor: String = try params.backgroundColor.hexString()
        let backgroundAlpha: CGFloat = try params.backgroundColor.alpha()
        
        let maskColor: String = try params.maskColor.hexString()
        let maskAlpha: CGFloat = try params.maskColor.alpha()
        
        var id: Int = 0
        
        pointList.append("<defs><mask id=\"hole\"><rect x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" fill=\"black\"/>")
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if isDark {
                    pointList.append("<rect x=\"\(x.cgFloat - 0.01)\" y=\"\(y.cgFloat - 0.01)\" width=\"1.02\" height=\"1.02\" fill=\"white\"/>")
                }
            }
        }
        pointList.append("</mask></defs>")
        
        pointList.append("<g x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" mask=\"url(#hole)\">")
        pointList.append("<rect key=\"\(id)\" opacity=\"\(backgroundAlpha)\" x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" fill=\"\(backgroundColor)\"/>")
        id += 1
        
        if let paramsImage = params.image {
            let imageAlpha: CGFloat = max(0, paramsImage.alpha)
            let imageLine: String = try paramsImage.image.write(id: id, rect: CGRect(x: 0, y: 0, width: nCount, height: nCount), opacity: imageAlpha, mode: paramsImage.mode)
            pointList.append(imageLine)
            id += 1
        }
        
        pointList.append("<rect key=\"\(id)\" opacity=\"\(maskAlpha)\" x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" fill=\"\(maskColor)\"/>")
        id += 1
        
        pointList.append("</g>")
        
        return pointList
    }
    
    override func writeIcon(qrcode: QRCode) throws -> [String] {
        return try params.icon?.write(qrcode: qrcode) ?? []
    }
    
    override func viewBox(qrcode: QRCode) -> CGRect {
        return params.backdrop.viewBox(moduleCount: qrcode.model.moduleCount)
    }
    
    override func generateSVG(qrcode: QRCode) throws -> String {
        let viewBoxRect: CGRect = viewBox(qrcode: qrcode)
        let (part1, part2) = try params.backdrop.generateSVG(qrcode: qrcode, viewBoxRect: viewBoxRect)
        return part1
        + (try writeQRCode(qrcode: qrcode)).joined()
        + (try writeIcon(qrcode: qrcode)).joined()
        + part2
    }
    
    override func copyWith(
        iconImage: EFStyleParamImage? = nil,
        watermarkImage: EFStyleParamImage? = nil
    ) -> EFQRCodeStyleBase {
        let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
        let image: EFStyleImageFillParamsImage? = params.image?.copyWith(image: watermarkImage)
        return EFQRCodeStyleImageFill(params: params.copyWith(icon: icon, image: image))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, params.image?.image)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.imageFill(params: self.params)
    }
}
