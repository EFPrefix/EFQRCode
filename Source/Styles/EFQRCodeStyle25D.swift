//
//  EFQRCodeStyle25D.swift
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
 * Parameters for 2.5D QR code styling.
 *
 * This class defines the styling parameters for 2.5D QR codes, which create
 * a three-dimensional appearance using shading and depth effects. The 2.5D style
 * simulates depth by using different colors for the top, left, and right faces
 * of each module.
 *
 * ## Features
 *
 * - Three-dimensional appearance with depth simulation
 * - Customizable height for data and position modules
 * - Multi-color shading (top, left, right faces)
 * - Icon and backdrop support
 * - Realistic 3D visual effect
 *
 * ## Usage
 *
 * ```swift
 * let params = EFStyle25DParams(
 *     icon: icon,
 *     backdrop: backdrop,
 *     dataHeight: 1.0,
 *     positionHeight: 1.0,
 *     topColor: .black,
 *     leftColor: .darkGray,
 *     rightColor: .lightGray
 * )
 * 
 * let style = EFQRCodeStyle.style25D(params)
 * ```
 *
 * ## Visual Characteristics
 *
 * - Modules appear to have depth and volume
 * - Different colors create shading effects
 * - Height parameters control the 3D appearance
 * - Creates a modern, sophisticated look
 */
public class EFStyle25DParams: EFStyleParams {
    
    /// The default backdrop configuration for 2.5D QR codes.
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    
    /// The default color for the top face of modules (black).
    public static let defaultTopColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    /// The default color for the left face of modules (semi-transparent black).
    public static let defaultLeftColor: CGColor = CGColor.createWith(rgb: 0x000000, alpha: 0.2)!
    
    /// The default color for the right face of modules (semi-transparent black).
    public static let defaultRightColor: CGColor = CGColor.createWith(rgb: 0x000000, alpha: 0.6)!
    
    /// The height of data modules for 3D effect.
    let dataHeight: CGFloat
    
    /// The height of position detection patterns for 3D effect.
    let positionHeight: CGFloat
    
    /// The color of the top face of modules.
    let topColor: CGColor
    
    /// The color of the left face of modules.
    let leftColor: CGColor
    
    /// The color of the right face of modules.
    let rightColor: CGColor
    
    /**
     * Creates 2.5D QR code styling parameters.
     *
     * - Parameters:
     *   - icon: The icon to display in the center of the QR code. Defaults to nil.
     *   - backdrop: The backdrop configuration. Defaults to default backdrop.
     *   - dataHeight: The height of data modules for 3D effect. Defaults to 1.0.
     *   - positionHeight: The height of position detection patterns for 3D effect. Defaults to 1.0.
     *   - topColor: The color of the top face of modules. Defaults to black.
     *   - leftColor: The color of the left face of modules. Defaults to semi-transparent black.
     *   - rightColor: The color of the right face of modules. Defaults to semi-transparent black.
     */
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyle25DParams.defaultBackdrop,
        dataHeight: CGFloat = 1,
        positionHeight: CGFloat = 1,
        topColor: CGColor = EFStyle25DParams.defaultTopColor,
        leftColor: CGColor = EFStyle25DParams.defaultLeftColor,
        rightColor: CGColor = EFStyle25DParams.defaultRightColor
    ) {
        self.dataHeight = dataHeight
        self.positionHeight = positionHeight
        self.topColor = topColor
        self.leftColor = leftColor
        self.rightColor = rightColor
        super.init(icon: icon, backdrop: backdrop)
    }
    
    /**
     * Creates a copy of the parameters with optional modifications.
     *
     * - Parameters:
     *   - icon: The new icon. If nil, keeps the current icon.
     *   - backdrop: The new backdrop. If nil, keeps the current backdrop.
     *   - dataHeight: The new data height. If nil, keeps the current data height.
     *   - positionHeight: The new position height. If nil, keeps the current position height.
     *   - topColor: The new top color. If nil, keeps the current top color.
     *   - leftColor: The new left color. If nil, keeps the current left color.
     *   - rightColor: The new right color. If nil, keeps the current right color.
     * - Returns: A new EFStyle25DParams with the specified modifications.
     */
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        dataHeight: CGFloat? = nil,
        positionHeight: CGFloat? = nil,
        topColor: CGColor? = nil,
        leftColor: CGColor? = nil,
        rightColor: CGColor? = nil
    ) -> EFStyle25DParams {
        return EFStyle25DParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            dataHeight: dataHeight ?? self.dataHeight,
            positionHeight: positionHeight ?? self.positionHeight,
            topColor: topColor ?? self.topColor,
            leftColor: leftColor ?? self.leftColor,
            rightColor: rightColor ?? self.rightColor
        )
    }
}

/**
 * 2.5D QR code implementation.
 *
 * This class implements the 2.5D QR code rendering, creating QR codes with
 * a three-dimensional appearance using shading and depth effects. The 2.5D style
 * simulates depth by rendering each module with multiple faces using different colors.
 *
 * ## Features
 *
 * - Three-dimensional appearance with depth simulation
 * - Multi-color shading for realistic 3D effect
 * - Customizable height for different module types
 * - Icon and backdrop support
 * - Sophisticated visual appearance
 *
 * ## Usage
 *
 * ```swift
 * let params = EFStyle25DParams(
 *     dataHeight: 1.0,
 *     positionHeight: 1.0,
 *     topColor: .black,
 *     leftColor: .darkGray,
 *     rightColor: .lightGray
 * )
 * 
 * let style = EFQRCodeStyle25D(params: params)
 * ```
 */
public class EFQRCodeStyle25D: EFQRCodeStyleBase {
    
    /// The 2.5D styling parameters.
    let params: EFStyle25DParams
    
    /**
     * Transformation matrix for creating 3D perspective effect.
     */
    private lazy var matrixString: String = {
        let matrixX = [sqrt(3.0) / 2, 0.5]
        let matrixY = [-sqrt(3.0) / 2, 0.5]
        let matrixZ = [0.0, 0.0]
        return "matrix(\(matrixX[0]),\(matrixX[1]),\(matrixY[0]),\(matrixY[1]),\(matrixZ[0]),\(matrixZ[1]))"
    }()
    
    /**
     * Creates a 2.5D QR code with the specified parameters.
     *
     * - Parameter params: The 2.5D styling parameters.
     */
    public init(params: EFStyle25DParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        
        let size: CGFloat = 1
        let size2: CGFloat = 1
        let height: CGFloat = max(0, params.dataHeight)
        let height2: CGFloat = max(0, params.positionHeight)
        
        let upColor: String = try params.topColor.hexString()
        let upOpacity: CGFloat = try params.topColor.alpha()
        
        let leftColor: String = try params.leftColor.hexString()
        let leftOpacity: CGFloat = try params.leftColor.alpha()
        
        let rightColor: String = try params.rightColor.hexString()
        let rightOpacity: CGFloat = try params.rightColor.alpha()
        
        var id: Int = 0
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if !isDark {
                    continue
                } else if typeTable[x][y] == QRPointType.posOther || typeTable[x][y] == QRPointType.posCenter {
                    let xValue: CGFloat = x.cgFloat + (1.0 - size2) / 2.0
                    let yValue: CGFloat = y.cgFloat + (1.0 - size2) / 2.0
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(upOpacity)\" width=\"\(size2)\" height=\"\(size2)\" fill=\"\(upColor)\" x=\"\(xValue)\" y=\"\(yValue)\" transform=\"\(matrixString)\"/>")
                    id += 1
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(leftOpacity)\" width=\"\(height2)\" height=\"\(size2)\" fill=\"\(leftColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(xValue + size2),\(yValue)) skewY(45)\"/>")
                    id += 1
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(rightOpacity)\" width=\"\(size2)\" height=\"\(height2)\" fill=\"\(rightColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(xValue),\(yValue + size2)) skewX(45)\"/>")
                    id += 1
                } else {
                    let xValue: CGFloat = x.cgFloat + (1.0 - size) / 2.0
                    let yValue: CGFloat = y.cgFloat + (1.0 - size) / 2.0
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(upOpacity)\" width=\"\(size)\" height=\"\(size)\" fill=\"\(upColor)\" x=\"\(xValue)\" y=\"\(yValue)\" transform=\"\(matrixString)\"/>")
                    id += 1
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(leftOpacity)\" width=\"\(height)\" height=\"\(size)\" fill=\"\(leftColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(xValue + size),\(yValue)) skewY(45)\"/>")
                    id += 1
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(rightOpacity)\" width=\"\(size)\" height=\"\(height)\" fill=\"\(rightColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(xValue),\(yValue + size)) skewX(45)\"/>")
                    id += 1
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
        
        let iconSize: CGFloat = nCount.cgFloat * scale
        let iconXY: CGFloat = (nCount.cgFloat - iconSize) / 2
        
        let bdColor: String = try icon.borderColor.hexString()
        let bdAlpha: CGFloat = max(0, try icon.borderColor.alpha())
        
        let randomIdDefs: String = "25d\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        let randomIdClips: String = "25d\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        
        pointList.append("<g opacity=\"\(bdAlpha)\" transform=\"\(matrixString)\"><path d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(bdColor)\" stroke-width=\"\(100 / iconSize)\" fill=\"\(bdColor)\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\"/></g>")
        pointList.append("<g key=\"g\(id)\" transform=\"\(matrixString)\">")
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
            + (try icon.image.write(id: id, rect: iconRect, opacity: opacity, mode: icon.mode))
            + "</g>"
            + "</g>"
        )
        id += 1
        return pointList
    }
    
    override func viewBox(qrcode: QRCode) -> CGRect {
        let moduleCount: Int = qrcode.model.moduleCount
        if let quietzone = params.backdrop.quietzone {
            return CGRect(
                x: -moduleCount.cgFloat * (quietzone.left + 1),
                y: -moduleCount.cgFloat * (quietzone.top + 0.5),
                width: moduleCount.cgFloat * (quietzone.left + 2 + quietzone.right),
                height: moduleCount.cgFloat * (quietzone.top + 2 + quietzone.bottom)
            )
        }
        return CGRect(x: -moduleCount.cgFloat, y: -moduleCount.cgFloat / 2.0, width: moduleCount.cgFloat * 2, height: moduleCount.cgFloat * 2)
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
        return EFQRCodeStyle25D(params: params.copyWith(icon: icon))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, nil)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.d25(params: self.params)
    }
}
