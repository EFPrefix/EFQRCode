//
//  EFQRCodeStyleImage.swift
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
 * Parameters for image-based QR code styling.
 *
 * This class defines the styling parameters for image-based QR codes, which use
 * actual images to fill the QR code modules instead of solid colors. This creates
 * QR codes that incorporate visual content while maintaining scannability.
 *
 * ## Features
 *
 * - Image-based module filling
 * - Alignment pattern customization
 * - Timing pattern styling
 * - Position detection pattern styling
 * - Data module appearance control
 * - Icon and backdrop support
 *
 * ## Usage
 *
 * ```swift
 * let imageParams = EFStyleImageParamsImage(
 *     image: myImage,
 *     mode: .scaleAspectFill
 * )
 * 
 * let params = EFStyleImageParams(
 *     icon: icon,
 *     backdrop: backdrop,
 *     align: align,
 *     timing: timing,
 *     position: position,
 *     data: data,
 *     image: imageParams
 * )
 * 
 * let style = EFQRCodeStyle.image(params)
 * ```
 *
 * ## Visual Characteristics
 *
 * - QR code modules are filled with actual image content
 * - Maintains QR code structure and scannability
 * - Supports different image scaling modes
 * - Creates visually appealing, branded QR codes
 */
public class EFStyleImageParams: EFStyleParams {
    /// The default backdrop configuration for image QR codes.
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    /// The default alignment pattern configuration.
    public static let defaultAlign: EFStyleImageParamsAlign = EFStyleImageParamsAlign()
    /// The default timing pattern configuration.
    public static let defaultTiming: EFStyleImageParamsTiming = EFStyleImageParamsTiming()
    /// The default data module configuration.
    public static let defaultData: EFStyleImageParamsData = EFStyleImageParamsData()
    /// The default position detection pattern configuration.
    public static let defaultPosition: EFStyleImageParamsPosition = EFStyleImageParamsPosition()
    /// Alignment pattern styling parameters.
    let align: EFStyleImageParamsAlign
    /// Timing pattern styling parameters.
    let timing: EFStyleImageParamsTiming
    /// Position detection pattern styling parameters.
    let position: EFStyleImageParamsPosition
    /// Data module styling parameters.
    let data: EFStyleImageParamsData
    /// Image configuration for module filling.
    let image: EFStyleImageParamsImage?
    /**
     * Creates image-based QR code styling parameters.
     *
     * - Parameters:
     *   - icon: The icon to display in the center of the QR code. Defaults to nil.
     *   - backdrop: The backdrop configuration. Defaults to default backdrop.
     *   - align: The alignment pattern configuration. Defaults to default align.
     *   - timing: The timing pattern configuration. Defaults to default timing.
     *   - position: The position detection pattern configuration. Defaults to default position.
     *   - data: The data module configuration. Defaults to default data.
     *   - image: The image configuration for module filling. Defaults to nil.
     */
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleImageParams.defaultBackdrop,
        align: EFStyleImageParamsAlign = EFStyleImageParams.defaultAlign,
        timing: EFStyleImageParamsTiming = EFStyleImageParams.defaultTiming,
        position: EFStyleImageParamsPosition = EFStyleImageParams.defaultPosition,
        data: EFStyleImageParamsData = EFStyleImageParams.defaultData,
        image: EFStyleImageParamsImage?
    ) {
        self.align = align
        self.timing = timing
        self.position = position
        self.data = data
        self.image = image
        super.init(icon: icon, backdrop: backdrop)
    }
    /**
     * Creates a copy of the parameters with optional modifications.
     *
     * - Parameters:
     *   - icon: The new icon. If nil, keeps the current icon.
     *   - backdrop: The new backdrop. If nil, keeps the current backdrop.
     *   - align: The new align configuration. If nil, keeps the current align.
     *   - timing: The new timing configuration. If nil, keeps the current timing.
     *   - position: The new position configuration. If nil, keeps the current position.
     *   - data: The new data configuration. If nil, keeps the current data.
     *   - image: The new image configuration. If nil, keeps the current image.
     * - Returns: A new EFStyleImageParams with the specified modifications.
     */
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        align: EFStyleImageParamsAlign? = nil,
        timing: EFStyleImageParamsTiming? = nil,
        position: EFStyleImageParamsPosition? = nil,
        data: EFStyleImageParamsData? = nil,
        image: EFStyleImageParamsImage? = nil
    ) -> EFStyleImageParams {
        return EFStyleImageParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            align: align ?? self.align,
            timing: timing ?? self.timing,
            position: position ?? self.position,
            data: data ?? self.data,
            image: image ?? self.image
        )
    }
}

/// Alignment pattern styles for image-based QR codes.
public enum EFStyleImageParamAlignStyle: CaseIterable {
    /// No alignment pattern styling.
    case none
    
    /// Rectangular alignment pattern with sharp corners.
    case rectangle
    
    /// Circular alignment pattern with rounded corners.
    case round
    
    /// Rounded rectangle alignment pattern with soft corners.
    case roundedRectangle
}

/**
 * Alignment pattern styling parameters for image-based QR codes.
 *
 * This class defines the appearance of alignment patterns in image-based QR codes,
 * including their style, size, and colors for dark and light modules.
 *
 * ## Usage
 *
 * ```swift
 * let align = EFStyleImageParamsAlign(
 *     style: .rectangle,
 *     size: 1.0,
 *     colorDark: .black,
 *     colorLight: .white
 * )
 * ```
 */
public class EFStyleImageParamsAlign {
    
    /**
     * Default color for dark alignment pattern modules (black).
     */
    public static let defaultColorDark: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    /**
     * Default color for light alignment pattern modules (white).
     */
    public static let defaultColorLight: CGColor = CGColor.createWith(rgb: 0xffffff)!
    
    /**
     * The style of the alignment pattern.
     */
    let style: EFStyleImageParamAlignStyle
    
    /**
     * The size of the alignment pattern.
     */
    let size: CGFloat
    
    /**
     * The color of dark alignment pattern modules.
     */
    let colorDark: CGColor
    
    /**
     * The color of light alignment pattern modules.
     */
    let colorLight: CGColor
    
    /**
     * Creates alignment pattern styling parameters.
     *
     * - Parameters:
     *   - style: The style of the alignment pattern. Defaults to .rectangle.
     *   - size: The size of the alignment pattern. Defaults to 1.
     *   - colorDark: The color for dark alignment pattern modules. Defaults to default color dark.
     *   - colorLight: The color for light alignment pattern modules. Defaults to default color light.
     */
    public init(
        style: EFStyleImageParamAlignStyle = .rectangle,
        size: CGFloat = 1,
        colorDark: CGColor = EFStyleImageParamsAlign.defaultColorDark,
        colorLight: CGColor = EFStyleImageParamsAlign.defaultColorLight
    ) {
        self.style = style
        self.size = size
        self.colorDark = colorDark
        self.colorLight = colorLight
    }
}

/**
 * Timing pattern styles for image-based QR codes.
 *
 * These styles define how timing patterns appear in image-based QR codes.
 */
public enum EFStyleImageParamTimingStyle: CaseIterable {
    /**
     * No timing pattern styling.
     */
    case none
    
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
 * Timing pattern styling parameters for image-based QR codes.
 *
 * This class defines the appearance of timing patterns in image-based QR codes,
 * including their style, size, and colors for dark and light modules.
 *
 * ## Usage
 *
 * ```swift
 * let timing = EFStyleImageParamsTiming(
 *     style: .rectangle,
 *     size: 1.0,
 *     colorDark: .black,
 *     colorLight: .white
 * )
 * ```
 */
public class EFStyleImageParamsTiming {
    
    /**
     * Default color for dark timing pattern modules (black).
     */
    public static let defaultColorDark: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    /**
     * Default color for light timing pattern modules (white).
     */
    public static let defaultColorLight: CGColor = CGColor.createWith(rgb: 0xffffff)!
    
    /**
     * The style of the timing pattern.
     */
    let style: EFStyleImageParamTimingStyle
    
    /**
     * The size of the timing pattern.
     */
    let size: CGFloat
    
    /**
     * The color of dark timing pattern modules.
     */
    let colorDark: CGColor
    
    /**
     * The color of light timing pattern modules.
     */
    let colorLight: CGColor
    
    /**
     * Creates timing pattern styling parameters.
     *
     * - Parameters:
     *   - style: The style of the timing pattern. Defaults to .rectangle.
     *   - size: The size of the timing pattern. Defaults to 1.
     *   - colorDark: The color for dark timing pattern modules. Defaults to default color dark.
     *   - colorLight: The color for light timing pattern modules. Defaults to default color light.
     */
    public init(
        style: EFStyleImageParamTimingStyle = .rectangle,
        size: CGFloat = 1,
        colorDark: CGColor = EFStyleImageParamsTiming.defaultColorDark,
        colorLight: CGColor = EFStyleImageParamsTiming.defaultColorLight
    ) {
        self.style = style
        self.size = size
        self.colorDark = colorDark
        self.colorLight = colorLight
    }
}

/**
 * Image configuration for module filling in image-based QR codes.
 *
 * This class defines how an image is used to fill QR code modules.
 *
 * ## Usage
 *
 * ```swift
 * let imageParams = EFStyleImageParamsImage(
 *     image: myImage,
 *     mode: .scaleAspectFill
 * )
 * ```
 */
public class EFStyleImageParamsImage {
    
    /**
     * The image to use for module filling.
     */
    let image: EFStyleParamImage
    
    /**
     * The scaling mode for the image.
     */
    let mode: EFImageMode
    
    /**
     * The opacity of the image.
     */
    let alpha: CGFloat
    
    /**
     * Whether to allow transparent pixels in the image.
     */
    let allowTransparent: Bool
    
    /**
     * Creates image configuration for module filling.
     *
     * - Parameters:
     *   - image: The image to use.
     *   - mode: The scaling mode. Defaults to .scaleAspectFill.
     *   - alpha: The opacity of the image. Defaults to 1.
     *   - allowTransparent: Whether to allow transparent pixels. Defaults to false.
     */
    public init(
        image: EFStyleParamImage,
        mode: EFImageMode = .scaleAspectFill,
        alpha: CGFloat = 1,
        allowTransparent: Bool = false
    ) {
        self.image = image
        self.mode = mode
        self.alpha = alpha
        self.allowTransparent = allowTransparent
    }
    
    /**
     * Creates a copy of the image configuration with optional modifications.
     *
     * - Parameters:
     *   - image: The new image. If nil, keeps the current image.
     *   - mode: The new scaling mode. If nil, keeps the current mode.
     *   - alpha: The new opacity. If nil, keeps the current alpha.
     *   - allowTransparent: Whether to allow transparent pixels. If nil, keeps the current value.
     * - Returns: A new EFStyleImageParamsImage with the specified modifications.
     */
    func copyWith(
        image: EFStyleParamImage? = nil,
        mode: EFImageMode? = nil,
        alpha: CGFloat? = nil,
        allowTransparent: Bool? = nil
    ) -> EFStyleImageParamsImage {
        return EFStyleImageParamsImage(
            image: image ?? self.image,
            mode: mode ?? self.mode,
            alpha: alpha ?? self.alpha,
            allowTransparent: allowTransparent ?? self.allowTransparent
        )
    }
}

/**
 * Position detection pattern styling parameters for image-based QR codes.
 *
 * This class defines the appearance of position detection patterns in image-based QR codes,
 * including their style, size, and colors for dark and light modules.
 *
 * ## Usage
 *
 * ```swift
 * let position = EFStyleImageParamsPosition(
 *     style: .rectangle,
 *     size: 1.0,
 *     colorDark: .black,
 *     colorLight: .white
 * )
 * ```
 */
public class EFStyleImageParamsPosition {
    
    /**
     * Default color for dark position detection pattern modules (black).
     */
    public static let defaultColorDark: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    /**
     * Default color for light position detection pattern modules (white).
     */
    public static let defaultColorLight: CGColor = CGColor.createWith(rgb: 0xffffff)!
    
    /**
     * The style of the position detection pattern.
     */
    let style: EFStyleParamsPositionStyle
    
    /**
     * The size of the position detection pattern.
     */
    let size: CGFloat
    
    /**
     * The color of dark position detection pattern modules.
     */
    let colorDark: CGColor
    
    /**
     * The color of light position detection pattern modules.
     */
    let colorLight: CGColor
    
    /**
     * Creates position detection pattern styling parameters.
     *
     * - Parameters:
     *   - style: The style of the position detection pattern. Defaults to .rectangle.
     *   - size: The size of the position detection pattern. Defaults to 1.
     *   - colorDark: The color for dark position detection pattern modules. Defaults to default color dark.
     *   - colorLight: The color for light position detection pattern modules. Defaults to default color light.
     */
    public init(
        style: EFStyleParamsPositionStyle = .rectangle,
        size: CGFloat = 1,
        colorDark: CGColor = EFStyleImageParamsPosition.defaultColorDark,
        colorLight: CGColor = EFStyleImageParamsPosition.defaultColorLight
    ) {
        self.style = style
        self.size = size
        self.colorDark = colorDark
        self.colorLight = colorLight
    }
}

/**
 * Data module styling parameters for image-based QR codes.
 *
 * This class defines the appearance of data modules in image-based QR codes,
 * including their style, scale, and colors for dark and light modules.
 *
 * ## Usage
 *
 * ```swift
 * let data = EFStyleImageParamsData(
 *     style: .rectangle,
 *     scale: 1.0,
 *     colorDark: .black,
 *     colorLight: .white
 * )
 * ```
 */
public class EFStyleImageParamsData {
    
    /**
     * Default color for dark data modules (black).
     */
    public static let defaultColorDark: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    /**
     * Default color for light data modules (white).
     */
    public static let defaultColorLight: CGColor = CGColor.createWith(rgb: 0xffffff)!
    
    /**
     * The style of the data module.
     */
    let style: EFStyleParamsDataStyle
    
    /**
     * The scale of the data module.
     */
    let scale: CGFloat // (0-1]
    
    /**
     * The color of dark data modules.
     */
    let colorDark: CGColor
    
    /**
     * The color of light data modules.
     */
    let colorLight: CGColor
    
    /**
     * Creates data module styling parameters.
     *
     * - Parameters:
     *   - style: The style of the data module. Defaults to .rectangle.
     *   - scale: The scale of the data module. Defaults to 1.
     *   - colorDark: The color for dark data modules. Defaults to default color dark.
     *   - colorLight: The color for light data modules. Defaults to default color light.
     */
    public init(
        style: EFStyleParamsDataStyle = .rectangle,
        scale: CGFloat = 1,
        colorDark: CGColor = EFStyleImageParamsData.defaultColorDark,
        colorLight: CGColor = EFStyleImageParamsData.defaultColorLight
    ) {
        self.style = style
        self.scale = scale
        self.colorDark = colorDark
        self.colorLight = colorLight
    }
}

/**
 * Base class for image-based QR code styling.
 *
 * This class provides the foundation for styling QR codes using images.
 * It handles common tasks like writing QR code, icon, and backdrop.
 */
public class EFQRCodeStyleImage: EFQRCodeStyleBase {
    
    /**
     * The styling parameters for the QR code.
     */
    let params: EFStyleImageParams
    
    /**
     * Creates an image-based QR code style with specified parameters.
     *
     * - Parameter params: The styling parameters.
     */
    public init(params: EFStyleImageParams) {
        self.params = params
        super.init()
    }
    
    /**
     * Writes the QR code to SVG format.
     *
     * - Parameter qrcode: The QR code model.
     * - Returns: An array of SVG strings.
     * - Throws: An error if writing fails.
     */
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        
        let type: EFStyleParamsDataStyle = params.data.style
        let size: CGFloat = max(0, params.data.scale)
        let opacityDark: CGFloat = max(0, try params.data.colorDark.alpha())
        let opacityLight: CGFloat = max(0, try params.data.colorLight.alpha())
        let otherColorDark: String = try params.data.colorDark.hexString()
        let otherColorLight: String = try params.data.colorLight.hexString()
        
        let posType: EFStyleParamsPositionStyle = params.position.style
        let posDarkColor: String = try params.position.colorDark.hexString()
        let posDarkAlpha: CGFloat = try params.position.colorDark.alpha()
        let posLightColor: String = try params.position.colorLight.hexString()
        let posLightAlpha: CGFloat = try params.position.colorLight.alpha()
        let posSize: CGFloat = params.position.size
        
        let alignType: EFStyleImageParamAlignStyle = params.align.style
        let alignDarkColor: String = try params.align.colorDark.hexString()
        let alignDarkAlpha: CGFloat = try params.align.colorDark.alpha()
        let alignLightColor: String = try params.align.colorLight.hexString()
        let alignLightAlpha: CGFloat = try params.align.colorLight.alpha()
        let alignSize: CGFloat = params.align.size
        
        let timingType: EFStyleImageParamTimingStyle = params.timing.style
        let timingDarkColor: String = try params.timing.colorDark.hexString()
        let timingDarkAlpha: CGFloat = try params.timing.colorDark.alpha()
        let timingLightColor: String = try params.timing.colorLight.hexString()
        let timingLightAlpha: CGFloat = try params.timing.colorLight.alpha()
        let timingSize: CGFloat = params.timing.size
        
        var id: Int = 0
        
        var imageLineIndex: Int? = nil
        if let image = params.image {
            if image.allowTransparent == true {
                for x in 0..<nCount {
                    for y in 0..<nCount {
                        let isDark: Bool = qrcode.model.isDark(x, y)
                        if alignType != .none && (typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther) {
                            
                        } else if timingType != .none && typeTable[x][y] == QRPointType.timing {
                            
                        } else if typeTable[x][y] == QRPointType.posCenter {
                            
                        } else if typeTable[x][y] == QRPointType.posOther {
                            continue
                        } else {
                            if isDark {
                                switch type {
                                case .rectangle:
                                    pointList.append("<rect opacity=\"\(opacityDark)\" width=\"1\" height=\"1\" key=\"\(id)\" fill=\"\(otherColorDark)\" x=\"\(x.cgFloat)\" y=\"\(y.cgFloat)\"/>")
                                    id += 1
                                    break
                                case .round:
                                    pointList.append("<circle opacity=\"\(opacityDark)\" r=\"0.5\" key=\"\(id)\" fill=\"\(otherColorDark)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                                    id += 1
                                    break
                                case .roundedRectangle:
                                    pointList.append("<rect key=\"\(id)\" opacity=\"\(opacityDark)\" fill=\"\(otherColorDark)\" x=\"\(x.cgFloat)\" y=\"\(y.cgFloat)\" width=\"1\" height=\"1\" rx=\"0.25\" ry=\"0.25\"/>")
                                    id += 1
                                    break
                                }
                            } else {
                                switch type {
                                case .rectangle:
                                    pointList.append("<rect opacity=\"\(opacityLight)\" width=\"1\" height=\"1\" key=\"\(id)\" fill=\"\(otherColorLight)\" x=\"\(x.cgFloat)\" y=\"\(y.cgFloat)\"/>")
                                    id += 1
                                    break
                                case .round:
                                    pointList.append("<circle opacity=\"\(opacityLight)\" r=\"0.5\" key=\"\(id)\" fill=\"\(otherColorLight)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                                    id += 1
                                    break
                                case .roundedRectangle:
                                    pointList.append("<rect key=\"\(id)\" opacity=\"\(opacityLight)\" fill=\"\(otherColorLight)\" x=\"\(x.cgFloat)\" y=\"\(y.cgFloat)\" width=\"1\" height=\"1\" rx=\"0.25\" ry=\"0.25\"/>")
                                    id += 1
                                    break
                                }
                            }
                        }
                    }
                }
            }
            
            let line = try image.image.write(id: id, rect: CGRect(x: 0, y: 0, width: nCount, height: nCount), opacity: image.alpha, mode: image.mode)
            imageLineIndex = pointList.count
            pointList.append(line)
            id += 1
        }
        
        var imageMask: String = "<defs><mask id=\"hole\"><rect x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" fill=\"white\"/>"
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if alignType != .none && (typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther) {
                    let thisAlignColor: String = isDark ? alignDarkColor : alignLightColor
                    let thisAlignAlpha: CGFloat = isDark ? alignDarkAlpha : alignLightAlpha
                    let kof: String = "key=\"\(id)\" opacity=\"\(thisAlignAlpha)\" fill=\"\(thisAlignColor)\" "
                    let alignLine: String = {
                        var newLine: String = ""
                        switch alignType {
                        case .none:
                            break
                        case .rectangle:
                            newLine = "<rect \(kof)width=\"\(alignSize)\" height=\"\(alignSize)\" x=\"\(x.cgFloat + (1.0 - alignSize) / 2.0)\" y=\"\(y.cgFloat + (1.0 - alignSize) / 2.0)\"/>"
                            id += 1
                            break
                        case .round:
                            newLine = "<circle \(kof)r=\"\(alignSize / 2)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>"
                            id += 1
                            break
                        case .roundedRectangle:
                            let cd: CGFloat = alignSize / 4.0
                            newLine = "<rect \(kof)x=\"\(x.cgFloat + (1.0 - alignSize) / 2.0)\" y=\"\(y.cgFloat + (1.0 - alignSize) / 2.0)\" width=\"\(alignSize)\" height=\"\(alignSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>"
                            id += 1
                            break
                        }
                        return newLine
                    }()
                    pointList.append(alignLine)
                    /*if let _ = imageLineIndex, !alignLine.isEmpty && !isDark {
                        imageMask += alignLine.replace(kof, with: "fill=\"black\" ")
                    }*/
                } else if timingType != .none && typeTable[x][y] == QRPointType.timing {
                    let thisTimingColor: String = isDark ? timingDarkColor : timingLightColor
                    let thisTimingAlpha: CGFloat = isDark ? timingDarkAlpha : timingLightAlpha
                    let kof: String = "key=\"\(id)\" opacity=\"\(thisTimingAlpha)\" fill=\"\(thisTimingColor)\" "
                    let timingLine: String = {
                        var newLine: String = ""
                        switch timingType {
                        case .none:
                            break
                        case .rectangle:
                            newLine += "<rect \(kof)width=\"\(timingSize)\" height=\"\(timingSize)\" x=\"\(x.cgFloat + (1.0 - timingSize) / 2.0)\" y=\"\(y.cgFloat + (1.0 - timingSize) / 2.0)\"/>"
                            id += 1
                            break
                        case .round:
                            newLine += "<circle \(kof)r=\"\(timingSize / 2.0)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>"
                            id += 1
                            break
                        case .roundedRectangle:
                            let cd: CGFloat = timingSize / 4.0
                            newLine += "<rect \(kof)x=\"\(x.cgFloat + (1.0 - timingSize) / 2.0)\" y=\"\(y.cgFloat + (1.0 - timingSize) / 2.0)\" width=\"\(timingSize)\" height=\"\(timingSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>"
                            id += 1
                            break
                        }
                        return newLine
                    }()
                    pointList.append(timingLine)
                    /*if let _ = imageLineIndex, !timingLine.isEmpty && !isDark {
                        imageMask += timingLine.replace(kof, with: "fill=\"black\" ")
                    }*/
                } else if typeTable[x][y] == QRPointType.posCenter {
                    let markArr: [CGFloat] = {
                        if x > y {
                            return [0, -1]
                        } else if x < y {
                            return [-1, 0]
                        }
                        return [-1, -1]
                    }()
                    let kof: String = "key=\"\(id)\" opacity=\"\(posLightAlpha)\" fill=\"\(posLightColor)\" "
                    let posBGLine: String = "<rect \(kof)width=\"8\" height=\"8\" x=\"\(x.cgFloat - 4 - markArr[0])\" y=\"\(y.cgFloat - 4 - markArr[1])\"/>"
                    pointList.append(posBGLine)
                    if let _ = imageLineIndex {
                        imageMask += posBGLine.replace(kof, with: "fill=\"black\" ")
                    }
                    id += 1
                    switch posType {
                    case .rectangle:
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"3\" height=\"3\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(x.cgFloat - 1)\" y=\"\(y.cgFloat - 1)\"/>")
                        id += 1
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"\(1 * posSize)\" stroke=\"\(posDarkColor)\" x=\"\(x.cgFloat - 2.5)\" y=\"\(y.cgFloat - 2.5)\" width=\"6\" height=\"6\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"\(1 * posSize)\" stroke=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<path opacity=\"\(posDarkAlpha)\" key=\"\(id)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(posDarkColor)\" stroke-width=\"\(100.cgFloat / 6 * posSize)\" fill=\"none\" transform=\"translate(\(x.cgFloat - 2.5),\(y.cgFloat - 2.5)) scale(\(6.cgFloat / 100),\(6.cgFloat / 100))\"/>")
                        id += 1
                        break
                    case .planets:
                        pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"0.15\" stroke-dasharray=\"0.5,0.5\" stroke=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\"/>")
                        id += 1
                        for w in 0..<EFQRCodeStyleBasic.planetsVw.count {
                            pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"\(posDarkColor)\" cx=\"\(x.cgFloat + EFQRCodeStyleBasic.planetsVw[w] + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(0.5 * posSize)\"/>")
                            id += 1
                        }
                        for h in 0..<EFQRCodeStyleBasic.planetsVh.count {
                            pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + EFQRCodeStyleBasic.planetsVh[h] + 0.5)\" r=\"\(0.5 * posSize)\"/>")
                            id += 1
                        }
                        break
                    case .dsj:
                        let widthValue: CGFloat = 3.0 - (1.0 - posSize)
                        let xTempValue: CGFloat = x.cgFloat + (1.0 - posSize) / 2.0
                        let yTempValue: CGFloat = y.cgFloat + (1.0 - posSize) / 2.0
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"\(widthValue)\" height=\"\(widthValue)\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue - 1)\"/>")
                        id += 1
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"\(posSize)\" height=\"\(widthValue)\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(xTempValue - 3)\" y=\"\(yTempValue - 1)\"/>")
                        id += 1
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"\(posSize)\" height=\"\(widthValue)\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(xTempValue + 3)\" y=\"\(yTempValue - 1)\"/>")
                        id += 1
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"\(widthValue)\" height=\"\(posSize)\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue - 3)\"/>")
                        id += 1
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"\(widthValue)\" height=\"\(posSize)\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue + 3)\"/>")
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posOther {
                    continue
                } else {
                    if isDark {
                        switch type {
                        case .rectangle:
                            pointList.append("<rect opacity=\"\(opacityDark)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(otherColorDark)\" x=\"\(x.cgFloat + (1.0 - size) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\"/>")
                            id += 1
                            break
                        case .round:
                            pointList.append("<circle opacity=\"\(opacityDark)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColorDark)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                            break
                        case .roundedRectangle:
                            let cd: CGFloat = size / 4.0
                            pointList.append("<rect key=\"\(id)\" opacity=\"\(opacityDark)\" fill=\"\(otherColorDark)\" x=\"\(x.cgFloat + (1.0 - size) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\" width=\"\(size)\" height=\"\(size)\" rx=\"\(cd)\" ry=\"\(cd)\"/>")
                            id += 1
                            break
                        }
                    } else {
                        switch type {
                        case .rectangle:
                            pointList.append("<rect opacity=\"\(opacityLight)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(otherColorLight)\" x=\"\(x.cgFloat + (1.0 - size) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\"/>")
                            id += 1
                            break
                        case .round:
                            pointList.append("<circle opacity=\"\(opacityLight)\" r=\"\(size / 2.0)\" key=\"\(id)\" fill=\"\(otherColorLight)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                            break
                        case .roundedRectangle:
                            let cd: CGFloat = size / 4.0
                            pointList.append("<rect key=\"\(id)\" opacity=\"\(opacityLight)\" fill=\"\(otherColorLight)\" x=\"\(x.cgFloat + (1.0 - size) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\" width=\"\(size)\" height=\"\(size)\" rx=\"\(cd)\" ry=\"\(cd)\"/>")
                            id += 1
                            break
                        }
                    }
                    
                }
            }
        }
        if let imageLineIndex = imageLineIndex {
            imageMask += "</mask></defs>"
            let oldImageLine: String = pointList[imageLineIndex]
            pointList[imageLineIndex] = "\(imageMask)<g x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" mask=\"url(#hole)\">\(oldImageLine)</g>"
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
        let image: EFStyleImageParamsImage? = params.image?.copyWith(image: watermarkImage)
        return EFQRCodeStyleImage(params: params.copyWith(icon: icon, image: image))
    }
    
    /**
     * Retrieves the current icon and watermark images.
     *
     * - Returns: A tuple containing the icon image and watermark image.
     */
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, params.image?.image)
    }
    
    /**
     * Converts the style to an EFQRCodeStyle.
     *
     * - Returns: The EFQRCodeStyle representation.
     */
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.image(params: self.params)
    }
}
