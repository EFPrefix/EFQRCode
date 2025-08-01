//
//  EFQRCodeStyleBasic.swift
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
 * Parameters for basic QR code styling.
 *
 * This class defines the styling parameters for basic QR codes, including
 * alignment patterns, timing patterns, data modules, and position detection patterns.
 * It provides a comprehensive set of customization options for creating
 * traditional QR codes with custom colors and styles.
 *
 * ## Features
 *
 * - Alignment pattern customization
 * - Timing pattern styling
 * - Data module appearance
 * - Position detection pattern styling
 * - Icon and backdrop support
 *
 * ## Usage
 *
 * ```swift
 * let params = EFStyleBasicParams(
 *     icon: icon,
 *     backdrop: backdrop,
 *     position: position,
 *     data: data,
 *     align: align,
 *     timing: timing
 * )
 * 
 * let style = EFQRCodeStyle.basic(params)
 * ```
 */
public class EFStyleBasicParams: EFStyleParams {
    /// The default backdrop configuration for basic QR codes.
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    /// The default alignment pattern configuration.
    public static let defaultAlign: EFStyleBasicParamsAlign = EFStyleBasicParamsAlign()
    /// The default timing pattern configuration.
    public static let defaultTiming: EFStyleBasicParamsTiming = EFStyleBasicParamsTiming()
    /// The default data module configuration.
    public static let defaultData: EFStyleBasicParamsData = EFStyleBasicParamsData()
    /// The default position detection pattern configuration.
    public static let defaultPosition: EFStyleBasicParamsPosition = EFStyleBasicParamsPosition()
    /// Data module styling parameters.
    let data: EFStyleBasicParamsData
    /// Position detection pattern styling parameters.
    let position: EFStyleBasicParamsPosition
    /// Alignment pattern styling parameters.
    let align: EFStyleBasicParamsAlign
    /// Timing pattern styling parameters.
    let timing: EFStyleBasicParamsTiming
    /**
     * Creates basic QR code styling parameters.
     *
     * - Parameters:
     *   - icon: The icon to display in the center of the QR code. Defaults to nil.
     *   - backdrop: The backdrop configuration. Defaults to default backdrop.
     *   - position: The position detection pattern configuration. Defaults to default position.
     *   - data: The data module configuration. Defaults to default data.
     *   - align: The alignment pattern configuration. Defaults to default align.
     *   - timing: The timing pattern configuration. Defaults to default timing.
     */
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleBasicParams.defaultBackdrop,
        position: EFStyleBasicParamsPosition = EFStyleBasicParams.defaultPosition,
        data: EFStyleBasicParamsData = EFStyleBasicParams.defaultData,
        align: EFStyleBasicParamsAlign = EFStyleBasicParams.defaultAlign,
        timing: EFStyleBasicParamsTiming = EFStyleBasicParams.defaultTiming
    ) {
        self.data = data
        self.position = position
        self.align = align
        self.timing = timing
        super.init(icon: icon, backdrop: backdrop)
    }
    /**
     * Creates a copy of the parameters with optional modifications.
     *
     * - Parameters:
     *   - icon: The new icon. If nil, keeps the current icon.
     *   - backdrop: The new backdrop. If nil, keeps the current backdrop.
     *   - position: The new position configuration. If nil, keeps the current position.
     *   - data: The new data configuration. If nil, keeps the current data.
     *   - align: The new align configuration. If nil, keeps the current align.
     *   - timing: The new timing configuration. If nil, keeps the current timing.
     * - Returns: A new EFStyleBasicParams with the specified modifications.
     */
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        position: EFStyleBasicParamsPosition? = nil,
        data: EFStyleBasicParamsData? = nil,
        align: EFStyleBasicParamsAlign? = nil,
        timing: EFStyleBasicParamsTiming? = nil
    ) -> EFStyleBasicParams {
        return EFStyleBasicParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            position: position ?? self.position,
            data: data ?? self.data,
            align: align ?? self.align,
            timing: timing ?? self.timing
        )
    }
}

/// Alignment pattern styling parameters for basic QR codes.
public class EFStyleBasicParamsAlign {
    /// Default color for alignment patterns (black).
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    /// The style of the alignment pattern.
    let style: EFStyleParamAlignStyle
    /// The size of the alignment pattern.
    let size: CGFloat
    /// The color of the alignment pattern.
    let color: CGColor
    /**
     * Creates alignment pattern styling parameters.
     *
     * - Parameters:
     *   - style: The style of the alignment pattern. Defaults to rectangle.
     *   - size: The size of the alignment pattern. Defaults to 1.0.
     *   - color: The color of the alignment pattern. Defaults to black.
     */
    public init(
        style: EFStyleParamAlignStyle = .rectangle,
        size: CGFloat = 1,
        color: CGColor = EFStyleBasicParamsAlign.defaultColor
    ) {
        self.style = style
        self.size = size
        self.color = color
    }
}

/**
 * Timing pattern styling parameters for basic QR codes.
 *
 * This class defines the appearance of timing patterns in QR codes,
 * which are the alternating dark and light modules that help decoders
 * locate the data modules.
 */
public class EFStyleBasicParamsTiming {
    /// Default color for timing patterns (black).
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    /// The style of the timing pattern.
    let style: EFStyleParamTimingStyle
    /// The size of the timing pattern modules.
    let size: CGFloat
    /// The color of the timing pattern.
    let color: CGColor
    /**
     * Creates timing pattern styling parameters.
     *
     * - Parameters:
     *   - style: The style of the timing pattern. Defaults to rectangle.
     *   - size: The size of the timing pattern modules. Defaults to 1.0.
     *   - color: The color of the timing pattern. Defaults to black.
     */
    public init(
        style: EFStyleParamTimingStyle = .rectangle,
        size: CGFloat = 1,
        color: CGColor = EFStyleBasicParamsTiming.defaultColor
    ) {
        self.style = style
        self.size = size
        self.color = color
    }
}

/**
 * Data module styling parameters for basic QR codes.
 *
 * This class defines the appearance of data modules in QR codes,
 * which encode the actual information content of the QR code.
 */
public class EFStyleBasicParamsData {
    /// Default color for data modules (black).
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    /// The style of the data modules.
    let style: EFStyleBasicParamsDataStyle
    /// The scale factor for data module size.
    let scale: CGFloat
    /// The color of the data modules.
    let color: CGColor
    /**
     * Creates data module styling parameters.
     *
     * - Parameters:
     *   - style: The style of the data modules. Defaults to rectangle.
     *   - scale: The scale factor for data module size. Defaults to 1.0.
     *   - color: The color of the data modules. Defaults to black.
     */
    public init(
        style: EFStyleBasicParamsDataStyle = .rectangle,
        scale: CGFloat = 1,
        color: CGColor = EFStyleBasicParamsData.defaultColor
    ) {
        self.color = color
        self.scale = scale
        self.style = style
    }
}

/**
 * Position detection pattern styling parameters for basic QR codes.
 *
 * This class defines the appearance of position detection patterns (finder patterns)
 * in QR codes, which are the large square patterns in three corners that help
 * decoders locate and orient the QR code.
 */
public class EFStyleBasicParamsPosition {
    /// Default color for position detection patterns (black).
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    /// The style of the position detection pattern.
    let style: EFStyleParamsPositionStyle
    /// The size factor for the position detection pattern.
    let size: CGFloat
    /// The color of the position detection pattern.
    let color: CGColor
    /**
     * Creates position detection pattern styling parameters.
     *
     * - Parameters:
     *   - style: The style of the position detection pattern. Defaults to rectangle.
     *   - size: The size factor for the position detection pattern. Defaults to 1.0.
     *   - color: The color of the position detection pattern. Defaults to black.
     */
    public init(
        style: EFStyleParamsPositionStyle = .rectangle,
        size: CGFloat = 1,
        color: CGColor = EFStyleBasicParamsPosition.defaultColor
    ) {
        self.color = color
        self.style = style
        self.size = size
    }
}

/**
 * Data module style options for basic QR codes.
 *
 * This enum defines the visual appearance options for data modules
 * in basic QR code styles.
 */
public enum EFStyleBasicParamsDataStyle: CaseIterable {
    /// Rectangular data modules with sharp corners.
    case rectangle
    /// Circular data modules.
    case round
    /// Rounded rectangle data modules with soft corners.
    case roundedRectangle
    /// Randomly sized circular data modules for visual variety.
    case randomRound
}

/**
 * Basic QR code style implementation.
 *
 * This class implements the rendering logic for traditional QR codes with customizable
 * alignment, timing, data, and position patterns, as well as icon and backdrop support.
 */
public class EFQRCodeStyleBasic: EFQRCodeStyleBase {
    /// The parameters for the basic style.
    let params: EFStyleBasicParams
    
    /// SVG path data for rounded square shapes used in QR code styling.
    /// This path defines a rounded rectangle with corner radius optimized for QR code aesthetics.
    static let sq25: String = "M32.048565,-1.29480038e-15 L67.951435,1.29480038e-15 C79.0954192,-7.52316311e-16 83.1364972,1.16032014 87.2105713,3.3391588 C91.2846454,5.51799746 94.4820025,8.71535463 96.6608412,12.7894287 C98.8396799,16.8635028 100,20.9045808 100,32.048565 L100,67.951435 C100,79.0954192 98.8396799,83.1364972 96.6608412,87.2105713 C94.4820025,91.2846454 91.2846454,94.4820025 87.2105713,96.6608412 C83.1364972,98.8396799 79.0954192,100 67.951435,100 L32.048565,100 C20.9045808,100 16.8635028,98.8396799 12.7894287,96.6608412 C8.71535463,94.4820025 5.51799746,91.2846454 3.3391588,87.2105713 C1.16032014,83.1364972 5.01544207e-16,79.0954192 -8.63200256e-16,67.951435 L8.63200256e-16,32.048565 C-5.01544207e-16,20.9045808 1.16032014,16.8635028 3.3391588,12.7894287 C5.51799746,8.71535463 8.71535463,5.51799746 12.7894287,3.3391588 C16.8635028,1.16032014 20.9045808,7.52316311e-16 32.048565,-1.29480038e-15 Z"
    
    /// Horizontal offset values for planet-style position detection patterns.
    /// These values define the x-axis positions of satellite elements relative to the center.
    static let planetsVw: [CGFloat] = [3, -3]
    
    /// Vertical offset values for planet-style position detection patterns.
    /// These values define the y-axis positions of satellite elements relative to the center.
    static let planetsVh: [CGFloat] = [3, -3]
    
    /**
     * Creates a new basic QR code style with the given parameters.
     *
     * - Parameter params: The parameters for the basic style.
     */
    public init(params: EFStyleBasicParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        
        let type: EFStyleBasicParamsDataStyle = params.data.style
        let size: CGFloat = max(0, params.data.scale)
        let opacity: CGFloat = max(0, try params.data.color.alpha())
        let otherColor: String = try params.data.color.hexString()
        
        let posType: EFStyleParamsPositionStyle = params.position.style
        let posSize: CGFloat = max(0, params.position.size)
        let positionColor: String = try params.position.color.hexString()
        let positionAlpha: CGFloat = try params.position.color.alpha()
        
        let alignType: EFStyleParamAlignStyle = params.align.style
        let alignColor: String = try params.align.color.hexString()
        let alignAlpha: CGFloat = try params.align.color.alpha()
        let alignSize: CGFloat = params.align.size
        
        let timingType: EFStyleParamTimingStyle = params.timing.style
        let timingColor: String = try params.timing.color.hexString()
        let timingAlpha: CGFloat = try params.timing.color.alpha()
        let timingSize: CGFloat = params.timing.size
        
        var id: Int = 0
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if !isDark {
                    continue
                } else if typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther {
                    switch alignType {
                    case .rectangle:
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(alignAlpha)\" width=\"\(alignSize)\" height=\"\(alignSize)\" fill=\"\(alignColor)\" x=\"\(x.cgFloat + (1.0 - alignSize) / 2.0)\" y=\"\(y.cgFloat + (1.0 - alignSize) / 2.0)\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(alignAlpha)\" r=\"\(alignSize / 2)\" fill=\"\(alignColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        let cd: CGFloat = alignSize / 4.0
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" x=\"\(x.cgFloat + (1.0 - alignSize) / 2.0)\" y=\"\(y.cgFloat + (1.0 - alignSize) / 2.0)\" width=\"\(alignSize)\" height=\"\(alignSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>")
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.timing {
                    switch timingType {
                    case .rectangle:
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(timingAlpha)\" width=\"\(timingSize)\" height=\"\(timingSize)\" fill=\"\(timingColor)\" x=\"\(x.cgFloat + (1.0 - timingSize) / 2.0)\" y=\"\(y.cgFloat + (1.0 - timingSize) / 2.0)\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(timingAlpha)\" r=\"\(timingSize / 2.0)\" fill=\"\(timingColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        let cd: CGFloat = timingSize / 4.0
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" x=\"\(x.cgFloat + (1.0 - timingSize) / 2.0)\" y=\"\(y.cgFloat + (1.0 - timingSize) / 2.0)\" width=\"\(timingSize)\" height=\"\(timingSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>")
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posCenter {
                    switch posType {
                    case .rectangle:
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"3\" height=\"3\" fill=\"\(positionColor)\" x=\"\(x.cgFloat - 1)\" y=\"\(y.cgFloat - 1)\"/>")
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"none\" stroke-width=\"\(1 * posSize)\" stroke=\"\(positionColor)\" x=\"\(x.cgFloat - 2.5)\" y=\"\(y.cgFloat - 2.5)\" width=\"6\" height=\"6\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"none\" stroke-width=\"\(1 * posSize)\" stroke=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<path key=\"\(id)\" opacity=\"\(positionAlpha)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(positionColor)\" stroke-width=\"\(100.cgFloat / 6 * posSize)\" fill=\"none\" transform=\"translate(\(x.cgFloat - 2.5),\(y.cgFloat - 2.5)) scale(\(6.cgFloat / 100),\(6.cgFloat / 100))\"/>")
                        id += 1
                        break
                    case .planets:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"none\" stroke-width=\"0.15\" stroke-dasharray=\"0.5,0.5\" stroke=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\"/>")
                        id += 1
                        for w in 0..<EFQRCodeStyleBasic.planetsVw.count {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(x.cgFloat + EFQRCodeStyleBasic.planetsVw[w] + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(0.5 * posSize)\"/>")
                            id += 1
                        }
                        for h in 0..<EFQRCodeStyleBasic.planetsVh.count {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + EFQRCodeStyleBasic.planetsVh[h] + 0.5)\" r=\"\(0.5 * posSize)\"/>")
                            id += 1
                        }
                        break
                    case .dsj:
                        let widthValue: CGFloat = 3.0 - (1.0 - posSize)
                        let xTempValue: CGFloat = x.cgFloat + (1.0 - posSize) / 2.0
                        let yTempValue: CGFloat = y.cgFloat + (1.0 - posSize) / 2.0
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue - 1)\"/>")
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(posSize)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 3)\" y=\"\(yTempValue - 1)\"/>")
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(posSize)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue + 3)\" y=\"\(yTempValue - 1)\"/>")
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(posSize)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue - 3)\"/>")
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(posSize)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue + 3)\"/>")
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posOther {
                    continue
                } else {
                    switch type {
                    case .rectangle:
                        pointList.append("<rect opacity=\"\(opacity)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(otherColor)\" x=\"\(x.cgFloat + (1.0 - size) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(opacity)\" r=\"\(size / 2)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                        id += 1
                        break
                    case .randomRound:
                        pointList.append("<circle opacity=\"\(opacity)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(0.5 * Double.random(in: 0.33..<1.0))\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        let cd: CGFloat = size / 4.0
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(opacity)\" fill=\"\(otherColor)\" x=\"\(x.cgFloat + (1.0 - size) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\" width=\"\(size)\" height=\"\(size)\" rx=\"\(cd)\" ry=\"\(cd)\"/>")
                        id += 1
                        break
                    }
                }
            }
        }
        
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
        return EFQRCodeStyleBasic(params: params.copyWith(icon: icon))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, nil)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.basic(params: self.params)
    }
}
