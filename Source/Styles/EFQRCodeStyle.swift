//
//  EFQRCodeStyle.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/1.
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
 * Parameters for QR code styling and customization.
 *
 * This class encapsulates the styling parameters used to customize the appearance
 * of QR codes, including icon placement and backdrop configuration.
 *
 * ## Usage
 *
 * ```swift
 * let icon = EFStyleParamIcon(
 *     image: .static(myIconImage),
 *     mode: .scaleAspectFill,
 *     alpha: 0.8,
 *     borderColor: .black,
 *     percentage: 0.2
 * )
 * 
 * let params = EFStyleParams(
 *     icon: icon,
 *     backdrop: .clear
 * )
 * ```
 */
public class EFStyleParams {
    
    /**
     * The icon to display in the center of the QR code.
     *
     * This can be a static image or an animated sequence of images.
     * When nil, no icon is displayed.
     */
    let icon: EFStyleParamIcon?
    
    /**
     * The backdrop configuration for the QR code.
     *
     * Defines the background appearance of the QR code, including
     * color, transparency, and other visual properties.
     */
    let backdrop: EFStyleParamBackdrop
    
    /**
     * Creates styling parameters for QR code customization.
     *
     * - Parameters:
     *   - icon: The icon to display in the center of the QR code. Defaults to nil.
     *   - backdrop: The backdrop configuration for the QR code.
     */
    init(
        icon: EFStyleParamIcon?,
        backdrop: EFStyleParamBackdrop
    ) {
        self.icon = icon
        self.backdrop = backdrop
    }
}

/**
 * Alignment styles for QR code elements.
 *
 * These styles define how different elements within the QR code are aligned
 * and positioned relative to each other.
 */
public enum EFStyleParamAlignStyle: CaseIterable {
    /**
     * Rectangular alignment with sharp corners.
     */
    case rectangle
    
    /**
     * Circular alignment with rounded corners.
     */
    case round
    
    /**
     * Rounded rectangle alignment with soft corners.
     */
    case roundedRectangle
}

/**
 * Timing pattern styles for QR codes.
 *
 * Timing patterns are the alternating black and white modules that help
 * QR code readers determine the size and position of the code.
 */
public enum EFStyleParamTimingStyle: CaseIterable {
    /**
     * Rectangular timing pattern with sharp corners.
     */
    case rectangle
    
    /**
     * Circular timing pattern with rounded corners.
     */
    case round
    
    /**
     * Rounded rectangle timing pattern with soft corners.
     */
    case roundedRectangle
}

/**
 * Data module styles for QR codes.
 *
 * Data modules are the individual black and white squares that contain
 * the encoded information in the QR code.
 */
public enum EFStyleParamsDataStyle: CaseIterable {
    /**
     * Rectangular data modules with sharp corners.
     */
    case rectangle
    
    /**
     * Circular data modules with rounded corners.
     */
    case round
    
    /**
     * Rounded rectangle data modules with soft corners.
     */
    case roundedRectangle
}

/**
 * Position detection pattern styles for QR codes.
 *
 * Position detection patterns are the three large squares in the corners
 * of QR codes that help readers locate and orient the code.
 */
public enum EFStyleParamsPositionStyle: CaseIterable {
    /**
     * Rectangular position patterns with sharp corners.
     */
    case rectangle
    
    /**
     * Circular position patterns with rounded corners.
     */
    case round
    
    /**
     * Rounded rectangle position patterns with soft corners.
     */
    case roundedRectangle
    
    /**
     * Planet-themed position patterns with celestial styling.
     */
    case planets
    
    /**
     * DSJ (Dancing Square J) position patterns with unique styling.
     */
    case dsj
}

/**
 * Icon configuration for QR code customization.
 *
 * This class defines how an icon is displayed in the center of a QR code,
 * including its appearance, size, and positioning.
 *
 * ## Usage
 *
 * ```swift
 * let icon = EFStyleParamIcon(
 *     image: .static(myLogoImage),
 *     mode: .scaleAspectFill,
 *     alpha: 0.9,
 *     borderColor: .white,
 *     percentage: 0.25
 * )
 * ```
 */
public class EFStyleParamIcon {
    /**
     * The image to display as the icon.
     *
     * Can be a static image or an animated sequence of images.
     */
    let image: EFStyleParamImage
    
    /**
     * The scaling mode for the icon image.
     *
     * Determines how the icon image is scaled to fit the available space.
     */
    let mode: EFImageMode
    
    /**
     * The transparency level of the icon (0.0 to 1.0).
     *
     * 0.0 is completely transparent, 1.0 is completely opaque.
     */
    let alpha: CGFloat
    
    /**
     * The border color of the icon.
     *
     * The color of the border around the icon, if any.
     */
    let borderColor: CGColor
    
    /**
     * The size of the icon as a percentage of the QR code size.
     *
     * Values range from 0.0 to 1.0, where 1.0 would make the icon
     * the same size as the QR code.
     */
    let percentage: CGFloat
    
    /**
     * Creates an icon configuration for QR code customization.
     *
     * - Parameters:
     *   - image: The image to display as the icon.
     *   - mode: The scaling mode for the icon image. Defaults to `.scaleAspectFill`.
     *   - alpha: The transparency level of the icon (0.0 to 1.0). Defaults to 1.0.
     *   - borderColor: The border color of the icon.
     *   - percentage: The size of the icon as a percentage of the QR code size. Defaults to 0.2.
     */
    public init(
        image: EFStyleParamImage,
        mode: EFImageMode = .scaleAspectFill,
        alpha: CGFloat = 1,
        borderColor: CGColor,
        percentage: CGFloat = 0.2
    ) {
        self.image = image
        self.mode = mode
        self.alpha = alpha
        self.borderColor = borderColor
        self.percentage = percentage
    }
    
    /**
     * Creates a copy of the icon configuration with optional modifications.
     *
     * - Parameters:
     *   - image: The new image to use. If nil, keeps the current image.
     *   - mode: The new scaling mode. If nil, keeps the current mode.
     *   - alpha: The new transparency level. If nil, keeps the current alpha.
     *   - borderColor: The new border color. If nil, keeps the current border color.
     *   - percentage: The new size percentage. If nil, keeps the current percentage.
     * - Returns: A new EFStyleParamIcon with the specified modifications.
     */
    func copyWith(
        image: EFStyleParamImage? = nil,
        mode: EFImageMode? = nil,
        alpha: CGFloat? = nil,
        borderColor: CGColor? = nil,
        percentage: CGFloat? = nil
    ) -> EFStyleParamIcon {
        return EFStyleParamIcon(
            image: image ?? self.image,
            mode: mode ?? self.mode,
            alpha: alpha ?? self.alpha,
            borderColor: borderColor ?? self.borderColor,
            percentage: percentage ?? self.percentage
        )
    }
    
    func write(qrcode: QRCode) throws -> [String] {
        struct Anchor {
            static var uniqueMark: Int = 0
        }
        
        var id: Int = 0
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        
        let scale: CGFloat = min(self.percentage, 0.33)
        let imageAlpha: CGFloat = max(0, alpha)
        
        let iconSize: CGFloat = nCount.cgFloat * scale
        let iconXY: CGFloat = (nCount.cgFloat - iconSize) / 2.0
        
        let bdColor: String = try borderColor.hexString()
        let bdAlpha: CGFloat = max(0, try borderColor.alpha())
        
        let randomIdDefs: String = "icon\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        let randomIdClips: String = "icon\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        
        pointList.append("<path opacity=\"\(bdAlpha)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(bdColor)\" stroke-width=\"\(100.0 / iconSize)\" fill=\"\(bdColor)\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100.0),\(iconSize / 100.0))\"/>")
        pointList.append("<g key=\"g\(id)\">")
        id += 1
        
        let iconOffset: CGFloat = iconXY * 0.024
        let rectXY: CGFloat = iconXY - iconOffset
        let length: CGFloat = iconSize + 2.0 * iconOffset
        let iconRect: CGRect = CGRect(x: rectXY, y: rectXY, width: length, height: length)
        pointList.append(
            "<defs><path id=\"\(randomIdDefs)\" d=\"\(EFQRCodeStyleBasic.sq25)\"/>"
            + "<mask id=\"\(randomIdClips)\">"
            + "<use xlink:href=\"#\(randomIdDefs)\" overflow=\"visible\" fill=\"#ffffff\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100.0),\(iconSize / 100.0))\"/>"
            + "</mask>"
            + "</defs>"
            + "<g mask=\"url(#\(randomIdClips))\">"
            + (try image.write(id: id, rect: iconRect, opacity: imageAlpha, mode: mode))
            + "</g>"
            + "</g>"
        )
        id += 1
        return pointList
    }
}

public enum EFStyleParamImage {
    case `static`(image: CGImage)
    case animated(images: [CGImage], imageDelays: [CGFloat])
    
    func write(id: Int, rect: CGRect, opacity: CGFloat, mode: EFImageMode) throws -> String {
        struct Anchor {
            static var uniqueMark: Int = 0
        }
        switch self {
        case .static(let image):
            let imageCliped: CGImage = try mode.imageForContent(ofImage: image, inCanvasOfRatio: rect.size)
            let pngBase64EncodedString: String = try imageCliped.pngBase64EncodedString()
            return "<image key=\"i\(id)\" opacity=\"\(opacity)\" xlink:href=\"\(pngBase64EncodedString)\" width=\"\(rect.width)\" height=\"\(rect.height)\" x=\"\(rect.origin.x)\" y=\"\(rect.origin.y)\"/>"
        case .animated(let images, let imageDelays):
            let pngBase64EncodedStrings: [String] = try images.map {
                let imageCliped: CGImage = try mode.imageForContent(ofImage: $0, inCanvasOfRatio: rect.size)
                return try imageCliped.pngBase64EncodedString()
            }
            if pngBase64EncodedStrings.isEmpty { return "" }
            Anchor.uniqueMark += 1
            let framePrefix: String = "\(Anchor.uniqueMark)fm"
            let defs: String = pngBase64EncodedStrings.enumerated().map { (index, base64Image) -> String in
                "<image id=\"\(framePrefix)\(index)\" xlink:href=\"\(base64Image)\" width=\"\(rect.width)\" height=\"\(rect.height)\" x=\"\(rect.origin.x)\" y=\"\(rect.origin.y)\" opacity=\"\(opacity)\"/>"
            }.joined()
            let totalDuration: CGFloat = imageDelays.reduce(0, +)
            let keyTimes: [CGFloat] = imageDelays.reduce(into: [0]) { result, delay in
                result.append((result.last ?? 0) + delay / totalDuration)
            }
            let use: String = """
            <use xlink:href="#\(framePrefix)0">
                <animate
                    attributeName="xlink:href"
                    values="\(pngBase64EncodedStrings.indices.map { "#\(framePrefix)\($0)" }.joined(separator: ";"))"
                    keyTimes="\(keyTimes.dropLast().map { String(format: "%.3f", $0) }.joined(separator: ";"))"
                    dur="\(totalDuration)s"
                    repeatCount="indefinite"
                    calcMode="discrete"
                />
            </use>
            """
            let svg: String = "<g key=\"g\(id)\"><defs>\(defs)</defs>\(use)</g>"
            return svg
        }
    }
}

public class EFStyleParamBackdrop {
    
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0xffffff)!
    
    let cornerRadius: CGFloat
    let color: CGColor
    let image: EFStyleParamBackdropImage?
    let quietzone: EFEdgeInsets?
    
    public init(
        cornerRadius: CGFloat = 0,
        color: CGColor = EFStyleParamBackdrop.defaultColor,
        image: EFStyleParamBackdropImage? = nil,
        quietzone: EFEdgeInsets? = nil
    ) {
        self.cornerRadius = cornerRadius
        self.color = color
        self.image = image
        self.quietzone = quietzone
    }
    
    func viewBox(moduleCount: Int) -> CGRect {
        if let quietzone = quietzone {
            return CGRect(
                x: -moduleCount.cgFloat * quietzone.left,
                y: -moduleCount.cgFloat * quietzone.top,
                width: moduleCount.cgFloat * (quietzone.left + 1 + quietzone.right),
                height: moduleCount.cgFloat * (quietzone.top + 1 + quietzone.bottom)
            )
        }
        return CGRect(x: -1, y: -1, width: moduleCount.cgFloat + 2, height: moduleCount.cgFloat + 2)
    }
    
    func generateSVG(qrcode: QRCode, viewBoxRect: CGRect) throws -> (String, String) {
        let bgColor: String = try color.hexString()
        let bgAlpha: CGFloat = max(0, try color.alpha())
        return (
            """
            <svg className="Qr-item-svg" width="\(viewBoxRect.width)" height="\(viewBoxRect.height)" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                <defs>
                    <clipPath id="rounded-corners">
                        <rect width="\(viewBoxRect.width)" height="\(viewBoxRect.height)" rx="\(cornerRadius)" ry="\(cornerRadius)"/>
                    </clipPath>
                </defs>
                <g clip-path="url(#rounded-corners)">
                    <rect width="\(viewBoxRect.width)" height="\(viewBoxRect.height)" opacity=\"\(bgAlpha)\" fill="\(bgColor)"/>
                    \(try image?.write(size: viewBoxRect.size) ?? "")
                    <g width="\(viewBoxRect.width)" height="\(viewBoxRect.height)" transform="translate(\(-viewBoxRect.minX), \(-viewBoxRect.minY))">
            """,
            """
                    </g>
                </g>
            </svg>
            """
        )
    }
}

public class EFStyleParamBackdropImage {
    let image: CGImage
    let alpha: CGFloat
    let mode: EFImageMode
    
    public init(
        image: CGImage,
        alpha: CGFloat = 1,
        mode: EFImageMode = .scaleAspectFill
    ) {
        self.image = image
        self.alpha = alpha
        self.mode = mode
    }
    
    func write(size: CGSize) throws -> String {
        let imageCliped: CGImage = try self.mode.imageForContent(ofImage: image, inCanvasOfRatio: size)
        let pngBase64EncodedString: String = try imageCliped.pngBase64EncodedString()
        return "<image key=\"bi\" opacity=\"\(alpha)\" xlink:href=\"\(pngBase64EncodedString)\" width=\"\(size.width)\" height=\"\(size.height)\" x=\"0\" y=\"0\"/>"
    }
}

public class EFQRCodeStyleBase {
    
    func writeQRCode(qrcode: QRCode) throws -> [String] {
        Utils.ShowNotImplementedError()
        return []
    }
    
    func writeIcon(qrcode: QRCode) throws -> [String] {
        Utils.ShowNotImplementedError()
        return []
    }
    
    func viewBox(qrcode: QRCode) -> CGRect {
        Utils.ShowNotImplementedError()
        return CGRect.zero
    }
    
    func generateSVG(qrcode: QRCode) throws -> String {
        Utils.ShowNotImplementedError()
        return ""
    }
    
    func copyWith(
        iconImage: EFStyleParamImage? = nil,
        watermarkImage: EFStyleParamImage? = nil
    ) -> EFQRCodeStyleBase {
        Utils.ShowNotImplementedError()
        return self
    }
    
    func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        Utils.ShowNotImplementedError()
        return (nil, nil)
    }
    
    func toQRCodeStyle() -> EFQRCodeStyle {
        Utils.ShowNotImplementedError()
        return .basic(params: .init())
    }
}

public enum EFQRCodeStyle {
    case basic(params: EFStyleBasicParams)
    case bubble(params: EFStyleBubbleParams)
    case d25(params: EFStyle25DParams)
    case dsj(params: EFStyleDSJParams)
    case function(params: EFStyleFunctionParams)
    case image(params: EFStyleImageParams)
    case imageFill(params: EFStyleImageFillParams)
    case line(params: EFStyleLineParams)
    case randomRectangle(params: EFStyleRandomRectangleParams)
    case resampleImage(params: EFStyleResampleImageParams)
    
    var implementation: EFQRCodeStyleBase {
        switch self {
        case .basic(let params):
            return EFQRCodeStyleBasic(params: params)
        case .bubble(let params):
            return EFQRCodeStyleBubble(params: params)
        case .d25(let params):
            return EFQRCodeStyle25D(params: params)
        case .dsj(let params):
            return EFQRCodeStyleDSJ(params: params)
        case .function(let params):
            return EFQRCodeStyleFunction(params: params)
        case .image(let params):
            return EFQRCodeStyleImage(params: params)
        case .imageFill(let params):
            return EFQRCodeStyleImageFill(params: params)
        case .line(let params):
            return EFQRCodeStyleLine(params: params)
        case .randomRectangle(let params):
            return EFQRCodeStyleRandomRectangle(params: params)
        case .resampleImage(let params):
            return EFQRCodeStyleResampleImage(params: params)
        }
    }
}
