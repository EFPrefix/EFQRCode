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
    
    public static let defaultAlign: EFStyleBasicParamsAlign = EFStyleBasicParamsAlign()
    public static let defaultTiming: EFStyleBasicParamsTiming = EFStyleBasicParamsTiming()
    public static let defaultData: EFStyleBasicParamsData = EFStyleBasicParamsData()
    public static let defaultPosition: EFStyleBasicParamsPosition = EFStyleBasicParamsPosition()
    
    let data: EFStyleBasicParamsData
    let position: EFStyleBasicParamsPosition
    let align: EFStyleBasicParamsAlign
    let timing: EFStyleBasicParamsTiming
    
    public init(icon: EFStyleParamIcon? = nil, position: EFStyleBasicParamsPosition = EFStyleBasicParams.defaultPosition, data: EFStyleBasicParamsData = EFStyleBasicParams.defaultData, align: EFStyleBasicParamsAlign = EFStyleBasicParams.defaultAlign, timing: EFStyleBasicParamsTiming = EFStyleBasicParams.defaultTiming) {
        self.data = data
        self.position = position
        self.align = align
        self.timing = timing
        super.init(icon: icon)
    }
}

public class EFStyleBasicParamsAlign {
    
    let style: EFStyleParamAlignStyle
    let size: CGFloat
    let color: CGColor
    
    public init(style: EFStyleParamAlignStyle = .rectangle, size: CGFloat = 1, color: CGColor = CGColor.black) {
        self.style = style
        self.size = size
        self.color = color
    }
}

public class EFStyleBasicParamsTiming {
    
    let style: EFStyleParamTimingStyle
    let size: CGFloat
    let color: CGColor
    
    public init(style: EFStyleParamTimingStyle = .rectangle, size: CGFloat = 1, color: CGColor = CGColor.black) {
        self.style = style
        self.size = size
        self.color = color
    }
}

public class EFStyleBasicParamsData {
    
    let style: EFStyleBasicParamsDataStyle
    let scale: CGFloat
    let color: CGColor
    
    public init(style: EFStyleBasicParamsDataStyle = .rectangle, scale: CGFloat = 1, color: CGColor = CGColor.black) {
        self.color = color
        self.scale = scale
        self.style = style
    }
}

public class EFStyleBasicParamsPosition {
    
    let style: EFStyleParamsPositionStyle
    let size: CGFloat
    let color: CGColor
    
    public init(style: EFStyleParamsPositionStyle = .rectangle, size: CGFloat = 1, color: CGColor = CGColor.black) {
        self.color = color
        self.style = style
        self.size = size
    }
}

public enum EFStyleBasicParamsDataStyle: CaseIterable {
    case rectangle
    case round
    case roundedRectangle
    case randomRound
}

public class EFQRCodeStyleBasic: EFQRCodeStyleBase {
    
    let params: EFStyleBasicParams
    
    static let sq25: String = "M32.048565,-1.29480038e-15 L67.951435,1.29480038e-15 C79.0954192,-7.52316311e-16 83.1364972,1.16032014 87.2105713,3.3391588 C91.2846454,5.51799746 94.4820025,8.71535463 96.6608412,12.7894287 C98.8396799,16.8635028 100,20.9045808 100,32.048565 L100,67.951435 C100,79.0954192 98.8396799,83.1364972 96.6608412,87.2105713 C94.4820025,91.2846454 91.2846454,94.4820025 87.2105713,96.6608412 C83.1364972,98.8396799 79.0954192,100 67.951435,100 L32.048565,100 C20.9045808,100 16.8635028,98.8396799 12.7894287,96.6608412 C8.71535463,94.4820025 5.51799746,91.2846454 3.3391588,87.2105713 C1.16032014,83.1364972 5.01544207e-16,79.0954192 -8.63200256e-16,67.951435 L8.63200256e-16,32.048565 C-5.01544207e-16,20.9045808 1.16032014,16.8635028 3.3391588,12.7894287 C5.51799746,8.71535463 8.71535463,5.51799746 12.7894287,3.3391588 C16.8635028,1.16032014 20.9045808,7.52316311e-16 32.048565,-1.29480038e-15 Z"
    static let planetsVw: [CGFloat] = [3, -3]
    static let planetsVh: [CGFloat] = [3, -3]
    
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
                if qrcode.model.isDark(x, y) == false {
                    continue
                }
                
                if typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther {
                    switch alignType {
                    case .rectangle:
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(alignAlpha)\" width=\"\(alignSize)\" height=\"\(alignSize)\" fill=\"\(alignColor)\" x=\"\(x.cgFloat + (1 - alignSize) / 2)\" y=\"\(y.cgFloat + (1 - alignSize) / 2)\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(alignAlpha)\" r=\"\(alignSize / 2)\" fill=\"\(alignColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        let cd: CGFloat = alignSize / 4.0
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" x=\"\(x.cgFloat + (1 - alignSize) / 2)\" y=\"\(y.cgFloat + (1 - alignSize) / 2)\" width=\"\(alignSize)\" height=\"\(alignSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>")
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.timing {
                    switch timingType {
                    case .rectangle:
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(timingAlpha)\" width=\"\(timingSize)\" height=\"\(timingSize)\" fill=\"\(timingColor)\" x=\"\(x.cgFloat + (1 - timingSize) / 2)\" y=\"\(y.cgFloat + (1 - size) / 2)\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(timingAlpha)\" r=\"\(timingSize / 2)\" fill=\"\(timingColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        let cd: CGFloat = timingSize / 4.0
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" x=\"\(x.cgFloat + (1 - timingSize) / 2)\" y=\"\(y.cgFloat + (1 - timingSize) / 2)\" width=\"\(timingSize)\" height=\"\(timingSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>")
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posCenter {
                    switch posType {
                    case .rectangle:
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"3\" height=\"3\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(x.cgFloat - 1)\" y=\"\(y.cgFloat - 1)\"/>");
                        id += 1
                        pointList.append("<rect opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"\(1 * posSize)\" stroke=\"\(positionColor)\" x=\"\(x.cgFloat - 2.5)\" y=\"\(y.cgFloat - 2.5)\" width=\"6\" height=\"6\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"\(1 * posSize)\" stroke=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<path opacity=\"\(positionAlpha)\" key=\"\(id)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(positionColor)\" stroke-width=\"\(100.cgFloat / 6 * posSize)\" fill=\"none\" transform=\"translate(\(x.cgFloat - 2.5),\(y.cgFloat - 2.5)) scale(\(6.cgFloat / 100),\(6.cgFloat / 100))\"/>")
                        id += 1
                        break
                    case .planets:
                        pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"0.15\" stroke-dasharray=\"0.5,0.5\" stroke=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\"/>")
                        id += 1
                        for w in 0..<EFQRCodeStyleBasic.planetsVw.count {
                            pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"\(positionColor)\" cx=\"\(x.cgFloat + EFQRCodeStyleBasic.planetsVw[w] + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(0.5 * posSize)\"/>")
                            id += 1
                        }
                        for h in 0..<EFQRCodeStyleBasic.planetsVh.count {
                            pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"\(positionColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + EFQRCodeStyleBasic.planetsVh[h] + 0.5)\" r=\"\(0.5 * posSize)\"/>")
                            id += 1
                        }
                        break
                    case .dsj:
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"\(3 - (1 - posSize))\" height=\"\(3 - (1 - posSize))\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(x.cgFloat - 1 + (1 - posSize)/2.0)\" y=\"\(y.cgFloat - 1 + (1 - posSize)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"\(posSize)\" height=\"\(3 - (1 - posSize))\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(x.cgFloat - 3 + (1 - posSize)/2.0)\" y=\"\(y.cgFloat - 1 + (1 - posSize)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"\(posSize)\" height=\"\(3 - (1 - posSize))\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(x.cgFloat + 3 + (1 - posSize)/2.0)\" y=\"\(y.cgFloat - 1 + (1 - posSize)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"\(3 - (1 - posSize))\" height=\"\(posSize)\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(x.cgFloat - 1 + (1 - posSize)/2.0)\" y=\"\(y.cgFloat - 3 + (1 - posSize)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"\(3 - (1 - posSize))\" height=\"\(posSize)\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(x.cgFloat - 1 + (1 - posSize)/2.0)\" y=\"\(y.cgFloat + 3 + (1 - posSize)/2.0)\"/>");
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posOther {
                    continue
                } else {
                    switch type {
                    case .rectangle:
                        pointList.append("<rect opacity=\"\(opacity)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(otherColor)\" x=\"\(x.cgFloat + (1 - size) / 2)\" y=\"\(y.cgFloat + (1 - size) / 2)\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                        id += 1
                        break
                    case .randomRound:
                        pointList.append("<circle opacity=\"\(opacity)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(0.5 * Double.random(in: 0.33..<1.0))\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        let cd: CGFloat = size / 4.0
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(opacity)\" fill=\"\(otherColor)\" x=\"\(x.cgFloat + (1 - size) / 2)\" y=\"\(y.cgFloat + (1 - size) / 2)\" width=\"\(size)\" height=\"\(size)\" rx=\"\(cd)\" ry=\"\(cd)\"/>")
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
