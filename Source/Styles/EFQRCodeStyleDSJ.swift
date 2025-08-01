//
//  EFQRCodeStyleDSJ.swift
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
 * Parameters for DSJ-style QR code styling.
 *
 * This class defines the styling parameters for DSJ-style QR codes, which use
 * distinctive position and data module patterns inspired by the "DSJ" visual style.
 *
 * ## Features
 *
 * - Custom DSJ-style position detection patterns
 * - Customizable data module appearance
 * - Icon and backdrop support
 * - Unique, visually striking QR codes
 *
 * ## Usage
 *
 * ```swift
 * let dataParams = EFStyleDSJParamsData(
 *     lineSize: 0.7,
 *     xSize: 0.7,
 *     horizontalLineColor: .yellow,
 *     verticalLineColor: .red,
 *     xColor: .blue
 * )
 *
 * let params = EFStyleDSJParams(
 *     icon: icon,
 *     backdrop: backdrop,
 *     position: position,
 *     data: dataParams
 * )
 *
 * let style = EFQRCodeStyle.dsj(params)
 * ```
 */
public class EFStyleDSJParams: EFStyleParams {
    /// The default backdrop configuration for DSJ QR codes.
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    /// The default position detection pattern configuration.
    public static let defaultPosition: EFStyleDSJParamsPosition = EFStyleDSJParamsPosition()
    /// The default data module configuration.
    public static let defaultData: EFStyleDSJParamsData = EFStyleDSJParamsData()
    /// Position detection pattern styling parameters.
    let position: EFStyleDSJParamsPosition
    /// Data module styling parameters.
    let data: EFStyleDSJParamsData
    /**
     * Creates DSJ-style QR code styling parameters.
     *
     * - Parameters:
     *   - icon: The icon to display in the center of the QR code. Defaults to nil.
     *   - backdrop: The backdrop configuration. Defaults to default backdrop.
     *   - position: The position detection pattern configuration. Defaults to default position.
     *   - data: The data module configuration. Defaults to default data.
     */
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleDSJParams.defaultBackdrop,
        position: EFStyleDSJParamsPosition = EFStyleDSJParams.defaultPosition,
        data: EFStyleDSJParamsData = EFStyleDSJParams.defaultData
    ) {
        self.position = position
        self.data = data
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
     * - Returns: A new EFStyleDSJParams with the specified modifications.
     */
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        position: EFStyleDSJParamsPosition? = nil,
        data: EFStyleDSJParamsData? = nil
    ) -> EFStyleDSJParams {
        return EFStyleDSJParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            position: position ?? self.position,
            data: data ?? self.data
        )
    }
}

/// Position detection pattern styling parameters for DSJ QR codes.
public class EFStyleDSJParamsPosition {
    /// Default color for position detection patterns (blue).
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x0B2D97)!
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
     *   - style: The style of the position detection pattern. Defaults to .dsj.
     *   - size: The size of the position detection pattern. Defaults to 0.925.
     *   - color: The color of the position detection pattern. Defaults to blue.
     */
    public init(
        style: EFStyleParamsPositionStyle = .dsj,
        size: CGFloat = 0.925,
        color: CGColor = EFStyleDSJParamsPosition.defaultColor
    ) {
        self.style = style
        self.size = size
        self.color = color
    }
}

/// Data module styling parameters for DSJ QR codes.
public class EFStyleDSJParamsData {
    /// Default color for horizontal lines (yellow).
    public static let defaultHorizontalLineColor: CGColor = CGColor.createWith(rgb: 0xF6B506)!
    /// Default color for vertical lines (red).
    public static let defaultVerticalLineColor: CGColor = CGColor.createWith(rgb: 0xE02020)!
    /// Default color for X shapes (blue).
    public static let defaultXColor: CGColor = CGColor.createWith(rgb: 0x0B2D97)!
    /// The size of the lines in data modules.
    let lineSize: CGFloat
    /// The size of the X shapes in data modules.
    let xSize: CGFloat
    /// The color of horizontal lines.
    let horizontalLineColor: CGColor
    /// The color of vertical lines.
    let verticalLineColor: CGColor
    /// The color of X shapes.
    let xColor: CGColor
    /**
     * Creates data module styling parameters.
     *
     * - Parameters:
     *   - lineSize: The size of the lines. Defaults to 0.7.
     *   - xSize: The size of the X shapes. Defaults to 0.7.
     *   - horizontalLineColor: The color of horizontal lines. Defaults to yellow.
     *   - verticalLineColor: The color of vertical lines. Defaults to red.
     *   - xColor: The color of X shapes. Defaults to blue.
     */
    public init(
        lineSize: CGFloat = 0.7,
        xSize: CGFloat = 0.7,
        horizontalLineColor: CGColor = EFStyleDSJParamsData.defaultHorizontalLineColor,
        verticalLineColor: CGColor = EFStyleDSJParamsData.defaultVerticalLineColor,
        xColor: CGColor = EFStyleDSJParamsData.defaultXColor
    ) {
        self.lineSize = lineSize
        self.xSize = xSize
        self.horizontalLineColor = horizontalLineColor
        self.verticalLineColor = verticalLineColor
        self.xColor = xColor
    }
}

/**
 * DSJ-style QR code implementation.
 *
 * This class implements the DSJ-style QR code rendering, creating QR codes
 * with distinctive position and data module patterns inspired by the "DSJ" visual style.
 *
 * ## Features
 *
 * - Custom DSJ-style position detection patterns
 * - Line and X-shaped data modules
 * - Multi-color styling for different elements
 * - Icon and backdrop support
 *
 * ## Usage
 *
 * ```swift
 * let params = EFStyleDSJParams(
 *     position: position,
 *     data: dataParams
 * )
 * 
 * let style = EFQRCodeStyleDSJ(params: params)
 * ```
 */
public class EFQRCodeStyleDSJ: EFQRCodeStyleBase {
    /// The DSJ styling parameters.
    let params: EFStyleDSJParams
    /**
     * Creates a DSJ-style QR code with the specified parameters.
     *
     * - Parameter params: The DSJ styling parameters.
     */
    public init(params: EFStyleDSJParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        var g1: [String] = []
        var g2: [String] = []
        
        let width2: CGFloat = max(0, params.data.lineSize)
        let width1: CGFloat = max(0, params.data.xSize)
        
        let posType: EFStyleParamsPositionStyle = params.position.style
        let posSize: CGFloat = max(0, params.position.size)
        
        let horizontalLineColor: String = try params.data.horizontalLineColor.hexString()
        let horizontalLineAlpha: CGFloat = try params.data.horizontalLineColor.alpha()
        
        let verticalLineColor: String = try params.data.verticalLineColor.hexString()
        let verticalLineAlpha: CGFloat = try params.data.verticalLineColor.alpha()
        
        let xColor: String = try params.data.xColor.hexString()
        let xAlpha: CGFloat = try params.data.xColor.alpha()
        
        let positionColor: String = try params.position.color.hexString()
        let positionAlpha: CGFloat = try params.position.color.alpha()
        
        var id: Int = 0
        
        var available: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        var ava2: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        
        for y in 0..<nCount {
            for x in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if isDark == false {
                    continue
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
                    if available[x][y] && ava2[x][y] && x < nCount - 2 && y < nCount - 2 {
                        var ctn: Bool = true
                        for i in 0..<3 {
                            for j in 0..<3 {
                                if ava2[x + i][y + j] == false {
                                    ctn = false
                                }
                            }
                        }
                        if ctn && qrcode.model.isDark(x + 2, y) && qrcode.model.isDark(x + 1, y + 1) && qrcode.model.isDark(x, y + 2) && qrcode.model.isDark(x + 2, y + 2) {
                            g1.append("<line key=\"\(id)\" opacity=\"\(xAlpha)\" x1=\"\(x.cgFloat + width1 / sqrt(8))\" y1=\"\(y.cgFloat + width1 / sqrt(8))\" x2=\"\(x.cgFloat + 3 - width1 / sqrt(8))\" y2=\"\(y.cgFloat + 3 - width1 / sqrt(8))\" fill=\"none\" stroke=\"\(xColor)\" stroke-width=\"\(width1)\"/>")
                            id += 1
                            g1.append("<line key=\"\(id)\" opacity=\"\(xAlpha)\" x1=\"\(x.cgFloat + 3 - width1 / sqrt(8))\" y1=\"\(y.cgFloat + width1 / sqrt(8))\" x2=\"\(x.cgFloat + width1 / sqrt(8))\" y2=\"\(y.cgFloat + 3 - width1 / sqrt(8))\" fill=\"none\" stroke=\"\(xColor)\" stroke-width=\"\(width1)\"/>")
                            id += 1
                            available[x][y] = false
                            available[x + 2][y] = false
                            available[x][y + 2] = false
                            available[x + 2][y + 2] = false
                            available[x + 1][y + 1] = false
                            for i in 0..<3 {
                                for j in 0..<3 {
                                    ava2[x + i][y + j] = false
                                }
                            }
                        }
                    }
                    if available[x][y] && ava2[x][y] && x < nCount - 1 && y < nCount - 1 {
                        var ctn: Bool = true
                        for i in 0..<2 {
                            for j in 0..<2 {
                                if ava2[x + i][y + j] == false {
                                    ctn = false
                                }
                            }
                        }
                        if ctn && qrcode.model.isDark(x + 1, y) && qrcode.model.isDark(x, y + 1) && qrcode.model.isDark(x + 1, y + 1) {
                            g1.append("<line key=\"\(id)\" opacity=\"\(xAlpha)\" x1=\"\(x.cgFloat + width1 / sqrt(8))\" y1=\"\(y.cgFloat + width1 / sqrt(8))\" x2=\"\(x.cgFloat + 2 - width1 / sqrt(8))\" y2=\"\(y.cgFloat + 2 - width1 / sqrt(8))\" fill=\"none\" stroke=\"\(xColor)\" stroke-width=\"\(width1)\"/>")
                            id += 1
                            g1.append("<line key=\"\(id)\" opacity=\"\(xAlpha)\" x1=\"\(x.cgFloat + 2 - width1 / sqrt(8))\" y1=\"\(y.cgFloat + width1 / sqrt(8))\" x2=\"\(x.cgFloat + width1 / sqrt(8))\" y2=\"\(y.cgFloat + 2 - width1 / sqrt(8))\" fill=\"none\" stroke=\"\(xColor)\" stroke-width=\"\(width1)\"/>")
                            id += 1
                            for i in 0..<2 {
                                for j in 0..<2 {
                                    available[x + i][y + j] = false
                                    ava2[x + i][y + j] = false
                                }
                            }
                        }
                    }
                    if available[x][y] && ava2[x][y] {
                        if y == 0 || (y > 0 && (!qrcode.model.isDark(x, y - 1) || !ava2[x][y - 1])) {
                            let start: Int = y
                            var end: Int = y
                            var ctn: Bool = true
                            while ctn && end < nCount {
                                if qrcode.model.isDark(x, end) && ava2[x][end] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 2 {
                                for i in start..<end {
                                    ava2[x][i] = false
                                    available[x][i] = false
                                }
                                g2.append("<rect key=\"\(id)\" opacity=\"\(verticalLineAlpha)\" width=\"\(width2)\" height=\"\(end.cgFloat - start.cgFloat - 1 - (1 - width2))\" fill=\"\(verticalLineColor)\" x=\"\(x.cgFloat + (1 - width2) / 2.0)\" y=\"\(y.cgFloat + (1 - width2) / 2.0)\"/>")
                                id += 1
                                g2.append("<rect key=\"\(id)\" opacity=\"\(verticalLineAlpha)\" width=\"\(width2)\" height=\"\(width2)\" fill=\"\(verticalLineColor)\" x=\"\(x.cgFloat + (1 - width2) / 2.0)\" y=\"\(end.cgFloat - 1 + (1 - width2) / 2.0)\"/>")
                                id += 1
                            }
                        }
                    }
                    if available[x][y] && ava2[x][y] {
                        if x == 0 || (x > 0 && (!qrcode.model.isDark(x - 1, y) || !ava2[x - 1][y])) {
                            let start: Int = x
                            var end: Int = x
                            var ctn: Bool = true
                            while ctn && end < nCount {
                                if qrcode.model.isDark(end, y) && ava2[end][y] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 1 {
                                for i in start..<end {
                                    ava2[i][y] = false
                                    available[i][y] = false
                                }
                                g2.append("<rect key=\"\(id)\" opacity=\"\(horizontalLineAlpha)\" width=\"\(end.cgFloat - start.cgFloat - (1 - width2))\" height=\"\(width2)\" fill=\"\(horizontalLineColor)\" x=\"\(x.cgFloat + (1 - width2) / 2.0)\" y=\"\(y.cgFloat + (1 - width2) / 2.0)\"/>")
                                id += 1
                            }
                        }
                    }
                    if available[x][y] {
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(horizontalLineAlpha)\" width=\"\(width2)\" height=\"\(width2)\" fill=\"\(horizontalLineColor)\" x=\"\(x.cgFloat + (1 - width2) / 2.0)\" y=\"\(y.cgFloat + (1 - width2) / 2.0)\"/>")
                        id += 1
                    }
                }
            }
        }
        
        pointList.append(contentsOf: g1)
        pointList.append(contentsOf: g2)
        
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
        return EFQRCodeStyleDSJ(params: params.copyWith(icon: icon))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, nil)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.dsj(params: self.params)
    }
}
