//
//  EFQRCodeStyleResampleImage.swift
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
 * Parameters for resample image QR code styling.
 *
 * This class defines the styling parameters for QR codes that use a resampled image
 * as the basis for module coloring. The QR code's modules are colored by sampling
 * from a source image, creating a visually blended effect between the QR code and the image.
 *
 * ## Features
 *
 * - Image-based module coloring via resampling
 * - Customizable alignment, timing, and position patterns
 * - Data module color fallback
 * - Icon and backdrop support
 * - Visually blended, artistic QR codes
 *
 * ## Usage
 *
 * ```swift
 * let imageParams = EFStyleResampleImageParamsImage(
 *     image: myImage,
 *     mode: .scaleAspectFill
 * )
 *
 * let params = EFStyleResampleImageParams(
 *     icon: icon,
 *     backdrop: backdrop,
 *     image: imageParams,
 *     align: align,
 *     timing: timing,
 *     position: position,
 *     dataColor: .black
 * )
 *
 * let style = EFQRCodeStyle.resampleImage(params)
 * ```
 */
public class EFStyleResampleImageParams: EFStyleParams {
    /// The default backdrop configuration for resample image QR codes.
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    /// The default alignment pattern configuration.
    public static let defaultAlign: EFStyleResampleImageParamsAlign = EFStyleResampleImageParamsAlign()
    /// The default timing pattern configuration.
    public static let defaultTiming: EFStyleResampleImageParamsTiming = EFStyleResampleImageParamsTiming()
    /// The default position detection pattern configuration.
    public static let defaultPosition: EFStyleResampleImageParamsPosition = EFStyleResampleImageParamsPosition()
    /// The default color for data modules (black).
    public static let defaultDataColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    /// The image configuration for resampling.
    let image: EFStyleResampleImageParamsImage?
    /// Alignment pattern styling parameters.
    let align: EFStyleResampleImageParamsAlign
    /// Timing pattern styling parameters.
    let timing: EFStyleResampleImageParamsTiming
    /// Position detection pattern styling parameters.
    let position: EFStyleResampleImageParamsPosition
    /// Fallback color for data modules if image is not available.
    let dataColor: CGColor
    /**
     * Creates resample image QR code styling parameters.
     *
     * - Parameters:
     *   - icon: The icon to display in the center of the QR code. Defaults to nil.
     *   - backdrop: The backdrop configuration. Defaults to default backdrop.
     *   - image: The image configuration for resampling. Defaults to nil.
     *   - align: The alignment pattern configuration. Defaults to default align.
     *   - timing: The timing pattern configuration. Defaults to default timing.
     *   - position: The position detection pattern configuration. Defaults to default position.
     *   - dataColor: The fallback color for data modules. Defaults to black.
     */
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleResampleImageParams.defaultBackdrop,
        image: EFStyleResampleImageParamsImage?,
        align: EFStyleResampleImageParamsAlign = EFStyleResampleImageParams.defaultAlign,
        timing: EFStyleResampleImageParamsTiming = EFStyleResampleImageParams.defaultTiming,
        position: EFStyleResampleImageParamsPosition = EFStyleResampleImageParams.defaultPosition,
        dataColor: CGColor = EFStyleResampleImageParams.defaultDataColor
    ) {
        self.image = image
        self.align = align
        self.timing = timing
        self.position = position
        self.dataColor = dataColor
        super.init(icon: icon, backdrop: backdrop)
    }
    /**
     * Creates a copy of the parameters with optional modifications.
     *
     * - Parameters:
     *   - icon: The new icon. If nil, keeps the current icon.
     *   - backdrop: The new backdrop. If nil, keeps the current backdrop.
     *   - image: The new image configuration. If nil, keeps the current image.
     *   - align: The new align configuration. If nil, keeps the current align.
     *   - timing: The new timing configuration. If nil, keeps the current timing.
     *   - position: The new position configuration. If nil, keeps the current position.
     *   - dataColor: The new data color. If nil, keeps the current data color.
     * - Returns: A new EFStyleResampleImageParams with the specified modifications.
     */
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        image: EFStyleResampleImageParamsImage? = nil,
        align: EFStyleResampleImageParamsAlign? = nil,
        timing: EFStyleResampleImageParamsTiming? = nil,
        position: EFStyleResampleImageParamsPosition? = nil,
        dataColor: CGColor? = nil
    ) -> EFStyleResampleImageParams {
        return EFStyleResampleImageParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            image: image ?? self.image,
            align: align ?? self.align,
            timing: timing ?? self.timing,
            position: position ?? self.position,
            dataColor: dataColor ?? self.dataColor
        )
    }
}

/// Alignment pattern style options for resample image QR codes.
public enum EFStyleResampleImageParamAlignStyle: CaseIterable {
    case none
    case rectangle
    case round
    case roundedRectangle
}

/// Alignment pattern styling parameters for resample image QR codes.
public class EFStyleResampleImageParamsAlign {
    /// The default color for alignment patterns.
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    /// The style of the alignment pattern.
    let style: EFStyleResampleImageParamAlignStyle
    /// Whether to only use white for alignment patterns.
    let onlyWhite: Bool
    /// The size of the alignment pattern.
    let size: CGFloat
    /// The color of the alignment pattern.
    let color: CGColor
    /**
     * Creates alignment pattern styling parameters.
     *
     * - Parameters:
     *   - style: The style of the alignment pattern. Defaults to rectangle.
     *   - onlyWhite: Whether to only use white. Defaults to false.
     *   - size: The size of the alignment pattern. Defaults to 1.
     *   - color: The color of the alignment pattern. Defaults to default color.
     */
    public init(
        style: EFStyleResampleImageParamAlignStyle = .rectangle,
        onlyWhite: Bool = false,
        size: CGFloat = 1,
        color: CGColor = EFStyleResampleImageParamsAlign.defaultColor
    ) {
        self.style = style
        self.onlyWhite = onlyWhite
        self.size = size
        self.color = color
    }
}

/// Timing pattern style options for resample image QR codes.
public enum EFStyleResampleImageParamTimingStyle: CaseIterable {
    case none
    case rectangle
    case round
    case roundedRectangle
}

/// Timing pattern styling parameters for resample image QR codes.
public class EFStyleResampleImageParamsTiming {
    /// The default color for timing patterns.
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    /// The style of the timing pattern.
    let style: EFStyleResampleImageParamTimingStyle
    /// Whether to only use white for timing patterns.
    let onlyWhite: Bool
    /// The size of the timing pattern.
    let size: CGFloat
    /// The color of the timing pattern.
    let color: CGColor
    /**
     * Creates timing pattern styling parameters.
     *
     * - Parameters:
     *   - style: The style of the timing pattern. Defaults to rectangle.
     *   - onlyWhite: Whether to only use white. Defaults to false.
     *   - size: The size of the timing pattern. Defaults to 1.
     *   - color: The color of the timing pattern. Defaults to default color.
     */
    public init(
        style: EFStyleResampleImageParamTimingStyle = .rectangle,
        onlyWhite: Bool = false,
        size: CGFloat = 1,
        color: CGColor = EFStyleResampleImageParamsTiming.defaultColor
    ) {
        self.style = style
        self.onlyWhite = onlyWhite
        self.size = size
        self.color = color
    }
}

/// Position detection pattern styling parameters for resample image QR codes.
public class EFStyleResampleImageParamsPosition {
    /// The default color for position detection patterns.
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    /// The style of the position detection pattern.
    let style: EFStyleParamsPositionStyle
    /// The size of the position detection pattern.
    let size: CGFloat
    /// The color of the position detection pattern.
    let color: CGColor
    /**
     * Creates position detection pattern styling parameters.
     *
     * - Parameters:
     *   - style: The style of the position detection pattern. Defaults to rectangle.
     *   - size: The size of the position detection pattern. Defaults to 1.
     *   - color: The color of the position detection pattern. Defaults to default color.
     */
    public init(
        style: EFStyleParamsPositionStyle = .rectangle,
        size: CGFloat = 1,
        color: CGColor = EFStyleResampleImageParamsPosition.defaultColor
    ) {
        self.style = style
        self.size = size
        self.color = color
    }
}

/// Image configuration for resampling in resample image QR codes.
public class EFStyleResampleImageParamsImage {
    /// The image to be used for resampling.
    let image: EFStyleParamImage
    /// The image mode for resampling.
    let mode: EFImageMode
    /// The contrast adjustment for the image.
    let contrast: CGFloat
    /// The exposure adjustment for the image.
    let exposure: CGFloat
    /**
     * Creates an image configuration for resampling.
     *
     * - Parameters:
     *   - image: The image to be used for resampling.
     *   - mode: The image mode for resampling. Defaults to scaleAspectFill.
     *   - contrast: The contrast adjustment. Defaults to 0.
     *   - exposure: The exposure adjustment. Defaults to 0.
     */
    public init(
        image: EFStyleParamImage,
        mode: EFImageMode = .scaleAspectFill,
        contrast: CGFloat = 0,
        exposure: CGFloat = 0
    ) {
        self.image = image
        self.mode = mode
        self.contrast = contrast
        self.exposure = exposure
    }
    /**
     * Creates a copy of the image configuration with optional modifications.
     *
     * - Parameters:
     *   - image: The new image. If nil, keeps the current image.
     *   - mode: The new image mode. If nil, keeps the current mode.
     *   - contrast: The new contrast. If nil, keeps the current contrast.
     *   - exposure: The new exposure. If nil, keeps the current exposure.
     * - Returns: A new EFStyleResampleImageParamsImage with the specified modifications.
     */
    func copyWith(
        image: EFStyleParamImage? = nil,
        mode: EFImageMode? = nil,
        contrast: CGFloat? = nil,
        exposure: CGFloat? = nil
    ) -> EFStyleResampleImageParamsImage {
        return EFStyleResampleImageParamsImage(
            image: image ?? self.image,
            mode: mode ?? self.mode,
            contrast: contrast ?? self.contrast,
            exposure: exposure ?? self.exposure
        )
    }
}

/**
 * QR code style implementation for resample image effect.
 *
 * This class implements the rendering logic for QR codes that use a resampled image
 * to color the modules, supporting advanced artistic effects.
 */
public class EFQRCodeStyleResampleImage: EFQRCodeStyleBase {
    /// The parameters for the resample image style.
    let params: EFStyleResampleImageParams
    /**
     * Creates a new resample image style with the given parameters.
     *
     * - Parameter params: The parameters for the resample image style.
     */
    public init(params: EFStyleResampleImageParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        
        let alignType: EFStyleResampleImageParamAlignStyle = params.align.style
        let alignOnlyWhite: Bool = params.align.onlyWhite
        
        let timingType: EFStyleResampleImageParamTimingStyle = params.timing.style
        let timingOnlyWhite: Bool = params.timing.onlyWhite
        
        let positionType: EFStyleParamsPositionStyle = params.position.style
        let positionColor: String = try params.position.color.hexString()
        let positionAlpha: CGFloat = try params.position.color.alpha()
        let positionSize: CGFloat = params.position.size
        
        var id: Int = 0
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                let posX: CGFloat = 3 * x.cgFloat
                let posY: CGFloat = 3 * y.cgFloat
                if typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther {
                    if isDark {
                        if alignType != .none && alignOnlyWhite == false {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Bab\" x=\"\(posX - 0.01)\" y=\"\(posY - 0.01)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Sab\" x=\"\(posX + 1 - 0.01)\" y=\"\(posY + 1 - 0.01)\"/>")
                            id += 1
                        }
                    } /*else {
                        if alignType == .none {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Sw\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Bw\" x=\"\(posX - 0.01)\" y=\"\(posY - 0.01)\"/>")
                            id += 1
                        }
                    }*/
                } else if typeTable[x][y] == QRPointType.timing {
                    if isDark {
                        if timingType != .none && timingOnlyWhite == false {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Btb\" x=\"\(posX - 0.01)\" y=\"\(posY - 0.01)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Stb\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        }
                    } /*else {
                        if timingType == .none {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Sw\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Bw\" x=\"\(posX - 0.01)\" y=\"\(posY - 0.01)\"/>")
                            id += 1
                        }
                    }*/
                } else if typeTable[x][y] == QRPointType.posCenter {
                    //white bg
                    /*let markArr: [CGFloat] = {
                        if x > y {
                            return [0, -3]
                        } else if x < y {
                            return [-3, 0]
                        }
                        return [-3, -3]
                    }()
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"24\" height=\"24\" fill=\"#FFFFFF\" x=\"\(posX - 12 - markArr[0])\" y=\"\(posY - 12 - markArr[1])\"/>");*/
                    id += 1
                    switch positionType {
                    case .rectangle:
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"9\" height=\"9\" fill=\"\(positionColor)\" x=\"\(posX - 3)\" y=\"\(posY - 3)\"/>")
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"none\" stroke-width=\"\(3 * positionSize)\" stroke=\"\(positionColor)\" x=\"\(posX - 7.5)\" y=\"\(posY - 7.5)\" width=\"18\" height=\"18\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"4.5\"/>")
                        id += 1
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"none\" stroke-width=\"\(3 * positionSize)\" stroke=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"9\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"4.5\"/>")
                        id += 1
                        pointList.append("<path key=\"\(id)\" opacity=\"\(positionAlpha)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(positionColor)\" stroke-width=\"\(100.cgFloat / 6 * positionSize)\" fill=\"none\" transform=\"translate(\(posX - 7.5),\(posY - 7.5)) scale(\(18.cgFloat / 100),\(18.cgFloat / 100))\"/>")
                        id += 1
                        break
                    case .planets:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"4.5\"/>")
                        id += 1
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"none\" stroke-width=\"0.45\" stroke-dasharray=\"1.5,1.5\" stroke=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"9\"/>")
                        id += 1
                        for w in 0..<EFQRCodeStyleBasic.planetsVw.count {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(posX + 3 * EFQRCodeStyleBasic.planetsVw[w] + 1.5)\" cy=\"\(posY + 1.5)\" r=\"\(1.5 * positionSize)\"/>")
                            id += 1
                        }
                        for h in 0..<EFQRCodeStyleBasic.planetsVh.count {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 3 * EFQRCodeStyleBasic.planetsVh[h] + 1.5)\" r=\"\(1.5 * positionSize)\"/>")
                            id += 1
                        }
                        break
                    case .dsj:
                        let widthValue: CGFloat = (3.0 - (1.0 - positionSize)) * 3
                        let xTempValue: CGFloat = (x.cgFloat + (1.0 - positionSize) / 2.0) * 3
                        let yTempValue: CGFloat = (y.cgFloat + (1.0 - positionSize) / 2.0) * 3
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 3)\" y=\"\(yTempValue - 3)\"/>")
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(3 * positionSize)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 9)\" y=\"\(yTempValue - 3)\"/>")
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(3 * positionSize)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue + 9)\" y=\"\(yTempValue - 3)\"/>")
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(3 * positionSize)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 3)\" y=\"\(yTempValue - 9)\"/>")
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(3 * positionSize)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 3)\" y=\"\(yTempValue + 9)\"/>")
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posOther {
                    continue
                } else {
                    if isDark {
                        pointList.append("<use key=\"\(id)\" xlink:href=\"#Sb\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                        id += 1
                    }
                }
            }
        }
        return pointList
    }
    
    override func writeIcon(qrcode: QRCode) throws -> [String] {
        struct Anchor {
            static var uniqueMark: Int = 0
        }
        
        guard let icon = params.icon else { return [] }
        
        var id: Int = 0
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        
        let scale: CGFloat = min(icon.percentage, 0.33)
        let opacity: CGFloat = max(0, icon.alpha)
        
        let iconSize: CGFloat = nCount.cgFloat * scale * 3
        let iconXY: CGFloat = (nCount.cgFloat * 3 - iconSize) / 2
        
        let bdColor: String = try icon.borderColor.hexString()
        let bdAlpha: CGFloat = max(0, try icon.borderColor.alpha())
        
        let randomIdDefs: String = "res\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        let randomIdClips: String = "res\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        
        pointList.append("<path opacity=\"\(bdAlpha)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(bdColor)\" stroke-width=\"\(100 / iconSize * 3)\" fill=\"\(bdColor)\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\"/>")
        pointList.append("<g key=\"g\(id)\">")
        id += 1
        
        let iconOffset: CGFloat = iconXY * 0.024
        let rectXY: CGFloat = iconXY - iconOffset
        let length: CGFloat = iconSize + 2.0 * iconOffset
        let iconRect: CGRect = CGRect(x: rectXY, y: rectXY, width: length, height: length)
        pointList.append(
            "<defs><path id=\"\(randomIdDefs)\" d=\"\(EFQRCodeStyleBasic.sq25)\"/>"
            + "<mask id=\"\(randomIdClips)\">"
            + "<use xlink:href=\"#\(randomIdDefs)\" overflow=\"visible\" fill=\"#ffffff\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\"/>"
            + "</mask>"
            + "</defs>"
            + "<g mask=\"url(#\(randomIdClips))\">"
            + (try icon.image.write(id: id, rect: iconRect, opacity: opacity, mode: icon.mode))
            + "</g>"
            + "</g>"
        )
        id += 1
        return pointList
    }
    
    /**
     * Generates SVG markup for image-resampled QR code modules.
     *
     * This method creates the resample image effect by sampling colors from the source image
     * and applying them to the QR code modules. It processes the image pixels and maps them
     * to QR code module positions with proper contrast adjustments.
     *
     * - Parameters:
     *   - params: The resample image styling parameters.
     *   - qrcode: The QR code model containing module structure.
     *   - image: The image parameters for resampling, or nil if no image is available.
     *   - newWidth: The target width for the resampled image in pixels.
     *   - newHeight: The target height for the resampled image in pixels.
     *   - color: The fallback hex color string for modules when image sampling fails.
     * - Returns: An SVG string containing the image-resampled QR code modules.
     * - Throws: `EFQRCodeError` if image processing or color conversion fails.
     */
    func writeResImage(params: EFStyleResampleImageParams, qrcode: QRCode, image: EFStyleResampleImageParamsImage?, newWidth: Int, newHeight: Int, color: String) throws -> String {
        guard let image = image else { return "" }
        
        let contrast: CGFloat = image.contrast
        let exposure: CGFloat = image.exposure
        let mode: EFImageMode = image.mode
        switch image.image {
        case .static(let image):
            let imageCliped: CGImage = try mode.imageForContent(ofImage: image, inCanvasOfRatio: CGSize(width: newWidth, height: newHeight))
            return try imageCliped.getGrayPointList(params: params, qrcode: qrcode, newWidth: newWidth, newHeight: newHeight, contrast: contrast, exposure: exposure, color: color).joined()
        case .animated(let images, let imageDelays):
            let resFrames: [String] = try images.map {
                let imageCliped: CGImage = try mode.imageForContent(ofImage: $0, inCanvasOfRatio: CGSize(width: newWidth, height: newHeight))
                return try imageCliped.getGrayPointList(params: params, qrcode: qrcode, newWidth: newWidth, newHeight: newHeight, contrast: contrast, exposure: exposure, color: color).joined()
            }
            if resFrames.isEmpty { return "" }
            let framePrefix: String = "resfm"
            let defs = resFrames.enumerated().map { (index, resFrame) -> String in
                "<g id=\"\(framePrefix)\(index)\">\(resFrame)</g>"
            }.joined()
            let totalDuration: CGFloat = imageDelays.reduce(0, +)
            let keyTimes: [CGFloat] = imageDelays.reduce(into: [0]) { result, delay in
                result.append((result.last ?? 0) + delay / totalDuration)
            }
            let use = """
            <use xlink:href="#\(framePrefix)0">
                <animate
                    attributeName="xlink:href"
                    values="\(resFrames.indices.map { "#\(framePrefix)\($0)" }.joined(separator: ";"))"
                    keyTimes="\(keyTimes.dropLast().map { String(format: "%.3f", $0) }.joined(separator: ";"))"
                    dur="\(totalDuration)s"
                    repeatCount="indefinite"
                    calcMode="discrete"
                />
            </use>
            """
            let svg = "<g><defs>\(defs)</defs>\(use)</g>"
            return svg
        }
    }
    
    override func viewBox(qrcode: QRCode) -> CGRect {
        let moduleCount: CGFloat = qrcode.model.moduleCount.cgFloat * 3.0
        if let quietzone = params.backdrop.quietzone {
            return CGRect(
                x: -moduleCount.cgFloat * quietzone.left,
                y: -moduleCount.cgFloat * quietzone.top,
                width: moduleCount.cgFloat * (quietzone.left + 1 + quietzone.right),
                height: moduleCount.cgFloat * (quietzone.top + 1 + quietzone.bottom)
            )
        }
        return CGRect(x: -3.0, y: -3.0, width: moduleCount + 6.0, height: moduleCount + 6.0)
    }
    
    override func generateSVG(qrcode: QRCode) throws -> String {
        let viewBoxRect: CGRect = viewBox(qrcode: qrcode)
        let (part1, part2) = try params.backdrop.generateSVG(qrcode: qrcode, viewBoxRect: viewBoxRect)
        return part1
        + (try customSVG(qrcode: qrcode))
        + part2
    }
    
    /**
     * Generates custom SVG markup for non-data modules in the resample image QR code.
     *
     * This method creates SVG elements for alignment patterns, timing patterns, and
     * position detection patterns that are not part of the main data resampling.
     * These elements use traditional QR code styling rather than image sampling.
     *
     * - Parameter qrcode: The QR code model containing module structure and type information.
     * - Returns: An SVG string containing the custom-styled QR code control patterns.
     * - Throws: `EFQRCodeError` if color conversion fails.
     */
    func customSVG(qrcode: QRCode) throws -> String {
        let alignType: EFStyleResampleImageParamAlignStyle = params.align.style
        let alignColor: String = try params.align.color.hexString()
        let alignAlpha: CGFloat = try params.align.color.alpha()
        let alignSize: CGFloat = params.align.size
        
        let timingType: EFStyleResampleImageParamTimingStyle = params.timing.style
        let timingColor: String = try params.timing.color.hexString()
        let timingAlpha: CGFloat = try params.timing.color.alpha()
        let timingSize: CGFloat = params.timing.size
        
        let otherOpacity: CGFloat = max(0, try params.dataColor.alpha())
        let otherColor: String = try params.dataColor.hexString()
        let size: Int = qrcode.model.moduleCount
        
        let alignElement: String = {
            // Bab is short for Big-align-black
            switch alignType {
            case .none:
                return "<rect id=\"Bab\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" width=\"\(1.02 * alignSize)\" height=\"\(1.02 * alignSize)\"/>"
            case .rectangle:
                return "<rect id=\"Bab\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" width=\"\(3.02 * alignSize)\" height=\"\(3.02 * alignSize)\"/>"
            case .round:
                let roundR: CGFloat = 3.02 * alignSize / 2
                return "<circle id=\"Bab\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" cx=\"\(roundR)\" cy=\"\(roundR)\" r=\"\(roundR)\"/>"
            case .roundedRectangle:
                let cd: CGFloat = 3.02 * alignSize / 4.0
                return "<rect id=\"Bab\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" width=\"\(3.02 * alignSize)\" height=\"\(3.02 * alignSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>"
            }
        }()
        let timingElement: String = {
            // Btb is short for Big-timing-black
            switch timingType {
            case .none:
                return "<rect id=\"Btb\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" width=\"\(1.02 * timingSize)\" height=\"\(1.02 * timingSize)\"/>"
            case .rectangle:
                return "<rect id=\"Btb\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" width=\"\(3.02 * timingSize)\" height=\"\(3.02 * timingSize)\"/>"
            case .round:
                let roundR: CGFloat = 3.02 * timingSize / 2.0
                return "<circle id=\"Btb\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" cx=\"\(roundR)\" cy=\"\(roundR)\" r=\"\(roundR)\"/>"
            case .roundedRectangle:
                let cd: CGFloat = 3.02 * timingSize / 4.0
                return "<rect id=\"Btb\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" width=\"\(3.02 * timingSize)\" height=\"\(3.02 * timingSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>"
            }
        }()
        
        // Sab is short for Small-align-black
        // Stb is short for Small-timing-black
        // Bb is short for Big-black
        // Sb is short for Small-black
        // Bw is short for Big-white
        // Sw is short for Small-white
        return "<defs>"
        + alignElement
        + "<rect id=\"Sab\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" width=\"\(1.02 * alignSize)\" height=\"\(1.02 * alignSize)\"/>"
        + timingElement
        + "<rect id=\"Stb\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" width=\"\(1.02 * timingSize)\" height=\"\(1.02 * timingSize)\"/>"
        + "<rect id=\"Bb\" opacity=\"\(otherOpacity)\" fill=\"\(otherColor)\" width=\"3.02\" height=\"3.02\"/>"
        + "<rect id=\"Sb\" opacity=\"\(otherOpacity)\" fill=\"\(otherColor)\" width=\"1.02\" height=\"1.02\"/>"
        + "<rect id=\"Bw\" fill=\"white\" width=\"3.02\" height=\"3.02\"/>"
        + "<rect id=\"Sw\" fill=\"white\" width=\"1.02\" height=\"1.02\"/>"
        + "</defs>"
        + (try writeResImage(params: params, qrcode: qrcode, image: params.image, newWidth: size * 3, newHeight: size * 3, color: "#Sb"))
        + (try writeQRCode(qrcode: qrcode)).joined()
        + (try writeIcon(qrcode: qrcode)).joined()
    }
    
    override func copyWith(
        iconImage: EFStyleParamImage? = nil,
        watermarkImage: EFStyleParamImage? = nil
    ) -> EFQRCodeStyleBase {
        let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
        let image: EFStyleResampleImageParamsImage? = params.image?.copyWith(image: watermarkImage)
        return EFQRCodeStyleResampleImage(params: params.copyWith(icon: icon, image: image))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, params.image?.image)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.resampleImage(params: self.params)
    }
}

/**
 * Extensions for CGImage to support resample image QR code generation.
 *
 * This extension provides utility methods for processing images used in
 * resample image QR code styles, including color analysis and pixel sampling.
 */
extension CGImage {
    
    /**
     * Calculates the grayscale value for RGBA color components with gamma correction.
     *
     * This method converts RGB color values to grayscale using standard luminance
     * coefficients and applies alpha blending for proper color representation.
     *
     * - Parameters:
     *   - red: The red component value (0-255).
     *   - green: The green component value (0-255).
     *   - blue: The blue component value (0-255).
     *   - alpha: The alpha component value (0-1).
     * - Returns: The calculated grayscale value (0-255).
     */
    func gamma(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> CGFloat {
        let gray: CGFloat = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        let weightedGray: CGFloat = gray * alpha + (1 - alpha) * 255.0
        return weightedGray
    }
    
    /**
     * Generates QR code modules by sampling grayscale values from the image.
     *
     * This method processes the image to create QR code modules based on pixel brightness,
     * applying contrast and exposure adjustments. It handles different QR code module types
     * (data, alignment, timing) and creates appropriate SVG elements for each.
     *
     * - Parameters:
     *   - params: The resample image styling parameters.
     *   - qrcode: The QR code model containing module structure and type information.
     *   - newWidth: The target width for image resampling.
     *   - newHeight: The target height for image resampling.
     *   - contrast: The contrast adjustment value. Defaults to 0.
     *   - exposure: The exposure adjustment value. Defaults to 0.
     *   - color: The fallback color string for modules when image sampling fails.
     * - Returns: An array of SVG strings representing the QR code modules.
     * - Throws: `EFQRCodeError` if color conversion or image processing fails.
     */
    func getGrayPointList(params: EFStyleResampleImageParams, qrcode: QRCode, newWidth: Int, newHeight: Int, contrast: CGFloat = 0, exposure: CGFloat = 0, color: String) throws -> [String] {
        // filter trans area
        let nCount: Int = qrcode.model.moduleCount
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var posOrigins: [(Int, Int)] = []
        var swOrigins: [(Int, Int)] = []
        var bwOrigins: [(Int, Int)] = []
        let alignType: EFStyleResampleImageParamAlignStyle = params.align.style
        let timingType: EFStyleResampleImageParamTimingStyle = params.timing.style
        for x in 0..<nCount {
            for y in 0..<nCount {
                let posX: Int = 3 * x
                let posY: Int = 3 * y
                if typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther {
                    let isDark: Bool = qrcode.model.isDark(x, y)
                    if !isDark {
                        if alignType == .none {
                            let oriX: Int = posX + 1
                            let oriY: Int = posY + 1
                            swOrigins.append((oriX, oriY))
                        } else {
                            let oriX: Int = posX
                            let oriY: Int = posY
                            bwOrigins.append((oriX, oriY))
                        }
                    }
                } else if typeTable[x][y] == QRPointType.timing {
                    let isDark: Bool = qrcode.model.isDark(x, y)
                    if !isDark {
                        if timingType == .none {
                            let oriX: Int = posX + 1
                            let oriY: Int = posY + 1
                            swOrigins.append((oriX, oriY))
                        } else {
                            let oriX: Int = posX
                            let oriY: Int = posY
                            bwOrigins.append((oriX, oriY))
                        }
                    }
                } else if typeTable[x][y] == QRPointType.posCenter {
                    let markArr: [Int] = {
                        if x > y {
                            return [0, -3]
                        } else if x < y {
                            return [-3, 0]
                        }
                        return [-3, -3]
                    }()
                    let oriX: Int = posX - 12 - markArr[0]
                    let oriY: Int = posY - 12 - markArr[1]
                    posOrigins.append((oriX, oriY))
                }
            }
        }
        
        let dataSize = newWidth * newHeight * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: &pixelData,
            width: newWidth,
            height: newHeight,
            bitsPerComponent: 8,
            bytesPerRow: 4 * newWidth,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw EFQRCodeError.cannotCreateCGContext
        }
        
        context.draw(self, in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        var gpl: [String] = []
        for x in 0 ..< newWidth {
            for y in 0 ..< newHeight {
                // filter trans area
                let isTransArea: Bool = {
                    for posOrigin in posOrigins {
                        if x >= posOrigin.0 && x < posOrigin.0 + 24 && y >= posOrigin.1 && y < posOrigin.1 + 24 {
                            return true
                        }
                    }
                    for bwOrigin in bwOrigins {
                        if x >= bwOrigin.0 && x < bwOrigin.0 + 3 && y >= bwOrigin.1 && y < bwOrigin.1 + 3 {
                            return true
                        }
                    }
                    for swOrigin in swOrigins {
                        if x >= swOrigin.0 && x < swOrigin.0 + 1 && y >= swOrigin.1 && y < swOrigin.1 + 1 {
                            return true
                        }
                    }
                    return false
                }()
                if isTransArea { continue }
                
                let offset: Int = 4 * (x + y * newWidth)
                // RGBA
                let alpha: CGFloat = CGFloat(pixelData[offset + 3]) / 255.0
                let red: CGFloat = pixelData[offset + 0].cgFloat
                let green: CGFloat = pixelData[offset + 1].cgFloat
                let blue: CGFloat = pixelData[offset + 2].cgFloat
                
                let gray: CGFloat = gamma(red, green, blue, alpha)
                if Double.random(in: 0..<1) > ((gray / 255.0) + exposure - 0.5) * (contrast + 1) + 0.5 && (x % 3 != 1 || y % 3 != 1) {
                    gpl.append("<use key=\"g_\(x)_\(y)\" x=\"\(x)\" y=\"\(y)\" xlink:href=\"\(color)\"/>")
                }
            }
        }
        return gpl
    }
}
