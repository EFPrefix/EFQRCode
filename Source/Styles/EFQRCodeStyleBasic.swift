//
//  EFQRCodeStyleBasic.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/1.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics
import QRCodeSwift

public class EFStyleBasicParams: EFStyleParams {
    let data: EFStyleBasicParamsData
    let position: EFStyleBasicParamsPosition
    
    public init(icon: EFStyleParamIcon? = nil, position: EFStyleBasicParamsPosition, data: EFStyleBasicParamsData) {
        self.data = data
        self.position = position
        super.init(icon: icon)
    }
}

public class EFStyleBasicParamsData {
    let style: EFStyleBasicParamsDataStyle
    let color: CGColor
    let scale: CGFloat
    
    public init(style: EFStyleBasicParamsDataStyle, scale: CGFloat, color: CGColor) {
        self.color = color
        self.scale = scale
        self.style = style
    }
}

public class EFStyleBasicParamsPosition {
    let style: EFStyleBasicParamsPositionStyle
    let color: CGColor
    
    public init(style: EFStyleBasicParamsPositionStyle, color: CGColor) {
        self.color = color
        self.style = style
    }
}

public enum EFStyleBasicParamsDataStyle: CaseIterable {
    case rectangle
    case round
    case randomRound
}

public class EFQRCodeStyleBasic: EFQRCodeStyleBase {
    
    let params: EFStyleBasicParams
    
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
        let posType: EFStyleBasicParamsPositionStyle = params.position.style
        var id: Int = 0
        let otherColor: String = try params.data.color.hexString()
        let posColor: String = try params.position.color.hexString()
        
        let vw: [CGFloat] = [3, -3]
        let vh: [CGFloat] = [3, -3]
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                if qrcode.model.isDark(x, y) == false {
                    continue
                }
                
                if typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther || typeTable[x][y] == QRPointType.timing {
                    switch type {
                    case .rectangle:
                        pointList.append("<rect opacity=\"\(opacity)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(otherColor)\" x=\"\(x.cgFloat + (1 - size) / 2)\" y=\"\(y.cgFloat + (1 - size) / 2)\" />")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" />")
                        id += 1
                        break
                    case .randomRound:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(opacity)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(size / 2)\" />")
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posCenter {
                    switch posType {
                    case .rectangle:
                        pointList.append("<rect width=\"1\" height=\"1\" key=\"\(id)\" fill=\"\(posColor)\" x=\"\(x)\" y=\"\(y)\" />")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle key=\"\(id)\" fill=\"\(posColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\" />")
                        id += 1
                        pointList.append("<circle key=\"\(id)\" fill=\"none\" stroke-width=\"1\" stroke=\"\(posColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\" />")
                        id += 1
                        break
                    case .planets:
                        pointList.append("<circle key=\"\(id)\" fill=\"\(posColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\" />")
                        id += 1
                        pointList.append("<circle key=\"\(id)\" fill=\"none\" stroke-width=\"0.15\" stroke-dasharray=\"0.5,0.5\" stroke=\"\(posColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\" />")
                        id += 1
                        for w in 0..<vw.count {
                            pointList.append("<circle key=\"\(id)\" fill=\"\(posColor)\" cx=\"\(x.cgFloat + vw[w] + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"0.5\" />")
                            id += 1
                        }
                        for h in 0..<vh.count {
                            pointList.append("<circle key=\"\(id)\" fill=\"\(posColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + vh[h] + 0.5)\" r=\"0.5\" />")
                            id += 1
                        }
                        break
                    case .roundedRectangle:
                        pointList.append("<circle key=\"\(id)\" fill=\"\(posColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\" />")
                        id += 1
                        pointList.append("<path key=\"\(id)\" d=\"\(EFSVG.sq25)\" stroke=\"\(posColor)\" stroke-width=\"\(100.cgFloat / 6 * (1 - (1 - size) * 0.75))\" fill=\"none\" transform=\"translate(\(x.cgFloat - 2.5),\(y.cgFloat - 2.5)) scale(\(6.cgFloat / 100),\(6.cgFloat / 100))\" />")
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posOther {
                    if posType == .rectangle {
                        pointList.append("<rect width=\"1\" height=\"1\" key=\"\(id)\" fill=\"\(posColor)\" x=\"\(x)\" y=\"\(y)\" />")
                        id += 1
                    }
                } else {
                    switch type {
                    case .rectangle:
                        pointList.append("<rect opacity=\"\(opacity)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(otherColor)\" x=\"\(x.cgFloat + (1 - size) / 2)\" y=\"\(y.cgFloat + (1 - size) / 2)\" />")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" />")
                        id += 1
                        break
                    case .randomRound:
                        pointList.append("<circle opacity=\"\(opacity)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(0.5 * Double.random(in: 0.33..<1.0))\" />")
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
}
