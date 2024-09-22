//
//  EFQRCodeStyleBubble.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/4.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics

import QRCodeSwift

public class EFStyleBubbleParams: EFStyleParams {
    
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    public static let defaultDataColor: CGColor = CGColor.createWith(rgb: 0x8ED1FC)!
    public static let defaultDataCenterColor: CGColor = CGColor.createWith(rgb: 0xffffff)!
    public static let defaultPosition: EFStyleBubbleParamsPosition = EFStyleBubbleParamsPosition()
    
    let dataColor: CGColor
    let dataCenterColor: CGColor
    let position: EFStyleBubbleParamsPosition
    
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleBubbleParams.defaultBackdrop,
        dataColor: CGColor = EFStyleBubbleParams.defaultDataColor,
        dataCenterColor: CGColor = EFStyleBubbleParams.defaultDataCenterColor,
        position: EFStyleBubbleParamsPosition = EFStyleBubbleParams.defaultPosition
    ) {
        self.dataColor = dataColor
        self.dataCenterColor = dataCenterColor
        self.position = position
        super.init(icon: icon, backdrop: backdrop)
    }
    
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        dataColor: CGColor? = nil,
        dataCenterColor: CGColor? = nil,
        position: EFStyleBubbleParamsPosition? = nil
    ) -> EFStyleBubbleParams {
        return EFStyleBubbleParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            dataColor: dataColor ?? self.dataColor,
            dataCenterColor: dataCenterColor ?? self.dataCenterColor,
            position: position ?? self.position
        )
    }
}

public class EFStyleBubbleParamsPosition {
    
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x0693E3)!
    
    let style: EFStyleParamsPositionStyle
    let size: CGFloat
    let color: CGColor
    
    public init(
        style: EFStyleParamsPositionStyle = .round,
        size: CGFloat = 1,
        color: CGColor = EFStyleBasicParamsPosition.defaultColor
    ) {
        self.color = color
        self.style = style
        self.size = size
    }
}

public class EFQRCodeStyleBubble: EFQRCodeStyleBase {
    
    let params: EFStyleBubbleParams
    
    public init(params: EFStyleBubbleParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        var g1: [String] = []
        var g2: [String] = []
        
        let otherColor = try params.dataColor.hexString()
        let otherOpacity: CGFloat = try params.dataColor.alpha()
        
        let otherCenterColor = try params.dataCenterColor.hexString()
        let otherCenterOpacity: CGFloat = try params.dataCenterColor.alpha()
        
        let posType: EFStyleParamsPositionStyle = params.position.style
        let posSize: CGFloat = max(0, params.position.size)
        let positionColor: String = try params.position.color.hexString()
        let positionAlpha: CGFloat = try params.position.color.alpha()
        
        var id: Int = 0
        
        var available: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        var ava2: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        
        for y in 0..<nCount {
            for x in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if typeTable[x][y] == QRPointType.posCenter {
                    switch posType {
                    case .rectangle:
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"3\" height=\"3\" fill=\"\(positionColor)\" x=\"\(x.cgFloat - 1)\" y=\"\(y.cgFloat - 1)\"/>");
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
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue - 1)\"/>");
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(posSize)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 3)\" y=\"\(yTempValue - 1)\"/>");
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(posSize)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue + 3)\" y=\"\(yTempValue - 1)\"/>");
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(posSize)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue - 3)\"/>");
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(posSize)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue + 3)\"/>");
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
                        if ctn && qrcode.model.isDark(x + 1, y) && qrcode.model.isDark(x + 1, y + 2) && qrcode.model.isDark(x, y + 1) && qrcode.model.isDark(x + 2, y + 1) {
                            g1.append("<circle key=\"\(id)\" cx=\"\(x.cgFloat + 1 + 0.5)\" cy=\"\(y.cgFloat + 1 + 0.5)\" r=\"1\" fill=\"\(otherCenterColor)\" fill-opacity=\"\(otherCenterOpacity)\" stroke=\"\(otherColor)\" stroke-opacity=\"\(otherOpacity)\" stroke-width=\"\(Double.random(in: 0.33...0.6))\"/>")
                            id += 1
                            if qrcode.model.isDark(x + 1, y + 1) {
                                g1.append("<circle opacity=\"\(otherOpacity)\" r=\"\(0.5 * Double.random(in: 0.5...1))\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 1 + 0.5)\" cy=\"\(y.cgFloat + 1 + 0.5)\"/>")
                                id += 1
                            }
                            available[x + 1][y] = false
                            available[x][y + 1] = false
                            available[x + 2][y + 1] = false
                            available[x + 1][y + 2] = false
                            for i in 0..<3 {
                                for j in 0..<3 {
                                    ava2[x + i][y + j] = false
                                }
                            }
                        }
                    }
                    if x < nCount - 1 && y < nCount - 1 {
                        if isDark && qrcode.model.isDark(x + 1, y) && qrcode.model.isDark(x, y + 1) && qrcode.model.isDark(x + 1, y + 1) {
                            g1.append("<circle key=\"\(id)\" cx=\"\(x + 1)\" cy=\"\(y + 1)\" r=\"\(sqrt(1.0 / 2.0))\" fill=\"\(otherCenterColor)\" fill-opacity=\"\(otherCenterOpacity)\" stroke=\"\(otherColor)\" stroke-opacity=\"\(otherOpacity)\" stroke-width=\"\(Double.random(in: 0.33...0.6))\"/>")
                            id += 1
                            for i in 0..<2 {
                                for j in 0..<2 {
                                    available[x + i][y + j] = false
                                    ava2[x + i][y + j] = false
                                }
                            }
                        }
                    }
                    if available[x][y] && y < nCount - 1 {
                        if isDark && qrcode.model.isDark(x, y + 1) {
                            pointList.append("<circle key=\"\(id)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y + 1)\" r=\"\(0.5 * Double.random(in: 0.95...1.05))\" fill=\"\(otherCenterColor)\" fill-opacity=\"\(otherCenterOpacity)\" stroke=\"\(otherColor)\" stroke-opacity=\"\(otherOpacity)\" stroke-width=\"\(Double.random(in: 0.36...0.4))\"/>")
                            id += 1
                            available[x][y] = false
                            available[x][y + 1] = false
                        }
                    }
                    if available[x][y] && x < nCount - 1 {
                        if isDark && qrcode.model.isDark(x + 1, y) {
                            pointList.append("<circle key=\"\(id)\" cx=\"\(x + 1)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(0.5 * Double.random(in: 0.95...1.05))\" fill=\"\(otherCenterColor)\" fill-opacity=\"\(otherCenterOpacity)\" stroke=\"\(otherColor)\" stroke-opacity=\"\(otherOpacity)\" stroke-width=\"\(Double.random(in: 0.36...0.4))\"/>")
                            id += 1
                            available[x][y] = false
                            available[x + 1][y] = false
                        }
                    }
                    if available[x][y] {
                        if isDark {
                            pointList.append("<circle opacity=\"\(otherOpacity)\" r=\"\(0.5 * Double.random(in: 0.5...1))\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                        } else if typeTable[x][y] == QRPointType.data {
                            if Double.random(in: 0...1) > 0.85 {
                                g2.append("<circle r=\"\(0.5 * Double.random(in: 0.85...1.3))\" key=\"\(id)\" fill=\"\(otherCenterColor)\" fill-opacity=\"\(otherCenterOpacity)\" stroke=\"\(otherColor)\" stroke-opacity=\"\(otherOpacity)\" stroke-width=\"\(Double.random(in: 0.15...0.33))\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                                id += 1
                            }
                        }
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
        return EFQRCodeStyleBubble(params: params.copyWith(icon: icon))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, nil)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.bubble(params: self.params)
    }
}
