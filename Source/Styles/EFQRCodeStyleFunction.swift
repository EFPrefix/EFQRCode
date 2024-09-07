//
//  EFQRCodeStyleFunction.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/4.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics

import QRCodeSwift

public class EFStyleFunctionParams: EFStyleParams {
    
    public static let defaultPosition: EFStyleFunctionParamsPosition = EFStyleFunctionParamsPosition()
    public static let defaultData: EFStyleFunctionParamsData = EFStyleFunctionParamsData()
    
    let position: EFStyleFunctionParamsPosition
    let data: EFStyleFunctionParamsData
    
    public init(
        icon: EFStyleParamIcon? = nil,
        position: EFStyleFunctionParamsPosition = EFStyleFunctionParams.defaultPosition,
        data: EFStyleFunctionParamsData = EFStyleFunctionParams.defaultData
    ) {
        self.position = position
        self.data = data
        super.init(icon: icon)
    }
    
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        position: EFStyleFunctionParamsPosition? = nil,
        data: EFStyleFunctionParamsData? = nil
    ) -> EFStyleFunctionParams {
        return EFStyleFunctionParams(
            icon: icon ?? self.icon,
            position: position ?? self.position,
            data: data ?? self.data
        )
    }
}

public class EFStyleFunctionParamsPosition {
    
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    let style: EFStyleParamsPositionStyle
    let size: CGFloat
    let color: CGColor
    
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

public class EFStyleFunctionParamsData {
    
    let function: EFStyleFunctionParamsDataFunction
    let style: EFStyleFunctionParamsDataStyle
    
    public init(
        function: EFStyleFunctionParamsDataFunction = EFStyleFunctionParamsDataFunction.fade(),
        style: EFStyleFunctionParamsDataStyle = .round
    ) {
        self.function = function
        self.style = style
    }
}

public enum EFStyleFunctionParamsDataFunction {
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    case fade(dataColor: CGColor = EFStyleFunctionParamsDataFunction.defaultColor)
    case circle(dataColor: CGColor = EFStyleFunctionParamsDataFunction.defaultColor, circleColor: CGColor = EFStyleFunctionParamsDataFunction.defaultColor)
}

public enum EFStyleFunctionParamsDataStyle: CaseIterable {
    case rectangle
    case round
}

public class EFQRCodeStyleFunction: EFQRCodeStyleBase {
    
    let params: EFStyleFunctionParams
    
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
}
