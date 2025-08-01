//
//  EFQRCodeStyleFunction.swift
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
 * Parameters for function-based QR code styling.
 *
 * This class defines the styling parameters for function-based QR codes, which use
 * mathematical functions to determine the appearance of data modules. This creates
 * QR codes with dynamic, algorithmically generated patterns.
 *
 * ## Features
 *
 * - Function-based data module generation
 * - Mathematical pattern algorithms
 * - Position detection pattern styling
 * - Icon and backdrop support
 * - Dynamic, algorithmic appearance
 *
 * ## Usage
 *
 * ```swift
 * let dataParams = EFStyleFunctionParamsData(
 *     function: .fade(),
 *     style: .round
 * )
 * 
 * let params = EFStyleFunctionParams(
 *     icon: icon,
 *     backdrop: backdrop,
 *     position: position,
 *     data: dataParams
 * )
 * 
 * let style = EFQRCodeStyle.function(params)
 * ```
 *
 * ## Visual Characteristics
 *
 * - Data modules are generated using mathematical functions
 * - Patterns can be fade, wave, or other algorithmic effects
 * - Creates dynamic, visually interesting QR codes
 * - Maintains QR code structure and scannability
 */
public class EFStyleFunctionParams: EFStyleParams {
    /// The default backdrop configuration for function QR codes.
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    /// The default position detection pattern configuration.
    public static let defaultPosition: EFStyleFunctionParamsPosition = EFStyleFunctionParamsPosition()
    /// The default data module configuration.
    public static let defaultData: EFStyleFunctionParamsData = EFStyleFunctionParamsData()
    /// Position detection pattern styling parameters.
    let position: EFStyleFunctionParamsPosition
    /// Data module styling parameters.
    let data: EFStyleFunctionParamsData
    /**
     * Creates function-based QR code styling parameters.
     *
     * - Parameters:
     *   - icon: The icon to display in the center of the QR code. Defaults to nil.
     *   - backdrop: The backdrop configuration. Defaults to default backdrop.
     *   - position: The position detection pattern configuration. Defaults to default position.
     *   - data: The data module configuration. Defaults to default data.
     */
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleFunctionParams.defaultBackdrop,
        position: EFStyleFunctionParamsPosition = EFStyleFunctionParams.defaultPosition,
        data: EFStyleFunctionParamsData = EFStyleFunctionParams.defaultData
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
     * - Returns: A new EFStyleFunctionParams with the specified modifications.
     */
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        position: EFStyleFunctionParamsPosition? = nil,
        data: EFStyleFunctionParamsData? = nil
    ) -> EFStyleFunctionParams {
        return EFStyleFunctionParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            position: position ?? self.position,
            data: data ?? self.data
        )
    }
}

/// Position detection pattern styling parameters for function QR codes.
public class EFStyleFunctionParamsPosition {
    /// Default color for position detection patterns (black).
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
     *   - style: The style of the position detection pattern. Defaults to .round.
     *   - size: The size of the position detection pattern. Defaults to 1.0.
     *   - color: The color of the position detection pattern. Defaults to black.
     */
    public init(
        style: EFStyleParamsPositionStyle = .round,
        size: CGFloat = 1,
        color: CGColor = EFStyleFunctionParamsPosition.defaultColor
    ) {
        self.style = style
        self.size = size
        self.color = color
    }
}

/// Data module styling parameters for function QR codes.
public class EFStyleFunctionParamsData {
    /// The mathematical function used to generate data modules.
    let function: EFStyleFunctionParamsDataFunction
    /// The style of the data modules.
    let style: EFStyleFunctionParamsDataStyle
    /**
     * Creates data module styling parameters.
     *
     * - Parameters:
     *   - function: The mathematical function for data module generation. Defaults to fade function.
     *   - style: The style of the data modules. Defaults to .round.
     */
    public init(
        function: EFStyleFunctionParamsDataFunction = EFStyleFunctionParamsDataFunction.fade(),
        style: EFStyleFunctionParamsDataStyle = .round
    ) {
        self.function = function
        self.style = style
    }
}

/// Mathematical functions for data module generation.
public enum EFStyleFunctionParamsDataFunction {
    /// Default color for function-based data modules (black).
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    /// Fade function that creates a gradient effect based on distance from center.
    case fade(dataColor: CGColor = EFStyleFunctionParamsDataFunction.defaultColor)
    /// Circle function that creates circular patterns with different colors.
    case circle(dataColor: CGColor = EFStyleFunctionParamsDataFunction.defaultColor, circleColor: CGColor = EFStyleFunctionParamsDataFunction.defaultColor)
}

/// Data module style options for function QR codes.
public enum EFStyleFunctionParamsDataStyle: CaseIterable {
    case rectangle
    case round
}

/**
 * Function-based QR code implementation.
 *
 * This class implements the function-based QR code rendering, creating QR codes
 * with mathematical functions that determine the appearance of data modules.
 *
 * ## Features
 *
 * - Mathematical function-based data module generation
 * - Dynamic patterns using fade and circle functions
 * - Position detection pattern styling
 * - Icon and backdrop support
 *
 * ## Usage
 *
 * ```swift
 * let params = EFStyleFunctionParams(
 *     position: position,
 *     data: dataParams
 * )
 * 
 * let style = EFQRCodeStyleFunction(params: params)
 * ```
 */
public class EFQRCodeStyleFunction: EFQRCodeStyleBase {
    /// The function styling parameters.
    let params: EFStyleFunctionParams
    /**
     * Creates a function-based QR code with the specified parameters.
     *
     * - Parameter params: The function styling parameters.
     */
    public init(params: EFStyleFunctionParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        
        let type: EFStyleFunctionParamsDataStyle = params.data.style
        var opacity: CGFloat = 1
        var opacity2: CGFloat = 1
        let funcType: EFStyleFunctionParamsDataFunction = params.data.function
        let posType: EFStyleParamsPositionStyle = params.position.style
        var id: Int = 0
        
        var otherColor: String = "#000000"
        var otherColor2: String = "#000000"
        switch funcType {
        case .fade(let dataColor):
            otherColor = try dataColor.hexString()
            opacity = max(0, try dataColor.alpha())
            break
        case .circle(let dataColor, let circleColor):
            otherColor = try dataColor.hexString()
            opacity = max(0, try dataColor.alpha())
            otherColor2 = try circleColor.hexString()
            opacity2 = max(0, try circleColor.alpha())
            break
        }
        let positionColor: String = try params.position.color.hexString()
        let positionAlpha: CGFloat = try params.position.color.alpha()
        let posSize: CGFloat = params.position.size
        
        if case .circle(_, _) = funcType {
            if type == .round {
                pointList.append("<circle opacity=\"\(opacity2)\" key=\"\(id)\" fill=\"none\" stroke-width=\"\(nCount.cgFloat / 15.0)\" stroke=\"\(otherColor2)\"  cx=\"\(nCount.cgFloat/2.0)\" cy=\"\(nCount.cgFloat/2.0)\" r=\"\(nCount.cgFloat / 2.0 * sqrt(2) * 13.0 / 40.0)\"/>")
                id += 1
            }
        }
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if typeTable[x][y] == QRPointType.posCenter {
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
                    let dist = sqrt(pow(CGFloat(nCount.cgFloat - 1) / 2.0 - CGFloat(x), 2) + pow(CGFloat(nCount.cgFloat - 1) / 2.0 - CGFloat(y), 2)) / (CGFloat(nCount) / 2.0 * sqrt(2))
                    switch funcType {
                    case .fade(_):
                        let sizeF: CGFloat = (1 - cos(.pi * dist)) / 6.0 + 1 / 5.0
                        let colorF: String = otherColor
                        let pointVisible: Bool = isDark
                        
                        if pointVisible {
                            switch type {
                            case .rectangle:
                                let sizeF = sizeF + 0.2
                                pointList.append("<rect opacity=\"\(opacity)\" width=\"\(sizeF)\" height=\"\(sizeF)\" key=\"\(id)\" fill=\"\(colorF)\" x=\"\(x.cgFloat + (1 - sizeF) / 2.0)\" y=\"\(y.cgFloat + (1 - sizeF) / 2.0)\"/>")
                                id += 1
                                break
                            case .round:
                                pointList.append("<circle opacity=\"\(opacity)\" r=\"\(sizeF)\" key=\"\(id)\" fill=\"\(colorF)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                                id += 1
                                break
                            }
                        }
                        break
                    case .circle(_, _):
                        var sizeF: CGFloat = 0.0
                        var opacityF: CGFloat = opacity
                        var colorF: String = otherColor
                        var pointVisible: Bool = isDark
                        if dist > 5.0 / 20.0 && dist < 8.0 / 20.0 {
                            sizeF = 5.0 / 10.0
                            colorF = otherColor2
                            opacityF = opacity2
                            pointVisible = true
                        } else {
                            sizeF = 1 / 4.0
                            if type == .rectangle {
                                sizeF = 1 / 4.0 - 0.1
                            }
                        }
                        if pointVisible {
                            switch type {
                            case .rectangle:
                                let sizeF = 2 * sizeF + 0.1
                                if isDark {
                                    pointList.append("<rect opacity=\"\(opacityF)\" width=\"\(sizeF)\" height=\"\(sizeF)\" key=\"\(id)\" fill=\"\(colorF)\" x=\"\(x.cgFloat + (1 - sizeF) / 2.0)\" y=\"\(y.cgFloat + (1 - sizeF) / 2.0)\"/>")
                                    id += 1
                                } else {
                                    let sizeF = sizeF - 0.1
                                    pointList.append("<rect opacity=\"\(opacityF)\" width=\"\(sizeF)\" height=\"\(sizeF)\" key=\"\(id)\" stroke=\"\(colorF)\" stroke-width=\"\(0.1)\" fill=\"white\" x=\"\(x.cgFloat + (1 - sizeF) / 2.0)\" y=\"\(y.cgFloat + (1 - sizeF) / 2.0)\"/>")
                                    id += 1
                                }
                                break
                            case .round:
                                if isDark {
                                    pointList.append("<circle opacity=\"\(opacityF)\" r=\"\(sizeF)\" key=\"\(id)\" fill=\"\(colorF)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                                    id += 1
                                } else {
                                    pointList.append("<circle opacity=\"\(opacityF)\" r=\"\(sizeF)\" key=\"\(id)\" stroke=\"\(colorF)\" stroke-width=\"\(0.1)\" fill=\"white\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                                    id += 1
                                }
                                break
                            }
                        }
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
        return EFQRCodeStyleFunction(params: params.copyWith(icon: icon))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, nil)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.function(params: self.params)
    }
}
