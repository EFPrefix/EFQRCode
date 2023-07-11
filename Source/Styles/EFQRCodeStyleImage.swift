//
//  EFQRCodeStyleImage.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/4.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics
import QRCodeSwift

public class EFStyleImageParams: EFStyleParams {
    let alignStyle: EFStyleParamAlignStyle
    let timingStyle: EFStyleParamTimingStyle
    let position: EFStyleImageParamsPosition
    let data: EFStyleImageParamsData
    let image: EFStyleImageParamsImage?
    
    public init(icon: EFStyleParamIcon? = nil, alignStyle: EFStyleParamAlignStyle, timingStyle: EFStyleParamTimingStyle, position: EFStyleImageParamsPosition, data: EFStyleImageParamsData, image: EFStyleImageParamsImage?) {
        self.alignStyle = alignStyle
        self.timingStyle = timingStyle
        self.position = position
        self.data = data
        self.image = image
        super.init(icon: icon)
    }
}

public class EFStyleImageParamsImage {
    let image: EFStyleParamImage
    let alpha: CGFloat
    
    public init(image: EFStyleParamImage, alpha: CGFloat) {
        self.image = image
        self.alpha = alpha
    }
}

public class EFStyleImageParamsPosition {
    let style: EFStyleImageParamsPositionStyle
    let color: CGColor
    
    public init(style: EFStyleImageParamsPositionStyle, color: CGColor) {
        self.style = style
        self.color = color
    }
}

public enum EFStyleImageParamsPositionStyle: CaseIterable {
    case rectangle
    case round
    case planets
}

public class EFStyleImageParamsData {
    let style: EFStyleImageParamsDataStyle
    let scale: CGFloat // (0-1]
    let alpha: CGFloat // (0-1]
    let colorDark: CGColor
    let colorLight: CGColor
    
    public init(style: EFStyleImageParamsDataStyle, scale: CGFloat, alpha: CGFloat, colorDark: CGColor, colorLight: CGColor) {
        self.style = style
        self.scale = scale
        self.alpha = alpha
        self.colorDark = colorDark
        self.colorLight = colorLight
    }
}

public enum EFStyleImageParamsDataStyle: CaseIterable {
    case rectangle
    case round
}

public class EFQRCodeStyleImage: EFQRCodeStyleBase {
    
    let params: EFStyleImageParams
    
    public init(params: EFStyleImageParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        
        let type: EFStyleImageParamsDataStyle = params.data.style
        let size: CGFloat = max(0, params.data.scale)
        let opacity: CGFloat = max(0, params.data.alpha)
        let otherColorDark: String = try params.data.colorDark.hexString()
        let otherColorLight: String = try params.data.colorLight.hexString()
        let posType: EFStyleImageParamsPositionStyle = params.position.style
        let posColor: String = try params.position.color.hexString()
        var id: Int = 0
        
        let vw: [CGFloat] = [3, -3]
        let vh: [CGFloat] = [3, -3]
        
        if let image = params.image {
            let line = try image.image.write(id: id, rect: CGRect(x: 0, y: 0, width: nCount, height: nCount), opacity: image.alpha)
            pointList.append(line)
            id += 1
        }
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                if typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther || typeTable[x][y] == QRPointType.timing {
                    let isDark = qrcode.model.isDark(x, y)
                    let hit: Bool = typeTable[x][y] == QRPointType.timing && params.timingStyle != EFStyleParamTimingStyle.none || (typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther) && params.alignStyle != EFStyleParamAlignStyle.none
                    let pointColor: String = isDark ? otherColorDark : otherColorLight
                    let pointSize: CGFloat = hit ? 1 : size
                    if hit {
                        pointList.append("<rect opacity=\"\(opacity)\" width=\"\(pointSize)\" height=\"\(pointSize)\" key=\"\(id)\" fill=\"\(pointColor)\" x=\"\(x.cgFloat + (1 - pointSize) / 2.0)\" y=\"\(y.cgFloat + (1 - pointSize) / 2.0)\"/>")
                        id += 1
                    } else {
                        switch type {
                        case .rectangle:
                            pointList.append("<rect opacity=\"\(opacity)\" width=\"\(pointSize)\" height=\"\(pointSize)\" key=\"\(id)\" fill=\"\(pointColor)\" x=\"\(x.cgFloat + (1 - pointSize) / 2.0)\" y=\"\(y.cgFloat + (1 - pointSize) / 2.0)\"/>")
                            id += 1
                            break
                        case .round:
                            pointList.append("<circle opacity=\"\(opacity)\" r=\"\(pointSize / 2.0)\" key=\"\(id)\" fill=\"\(pointColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                            break
                        }
                    }
                } else if typeTable[x][y] == QRPointType.posCenter {
                    if qrcode.model.isDark(x, y) {
                        switch posType {
                        case .rectangle:
                            pointList.append("<rect width=\"1\" height=\"1\" key=\"\(id)\" fill=\"\(posColor)\" x=\"\(x)\" y=\"\(y)\"/>")
                            id += 1
                            break
                        case .round:
                            pointList.append("<circle key=\"\(id)\" fill=\"white\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"5\" />")
                            id += 1
                            pointList.append("<circle key=\"\(id)\" fill=\"\(posColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\" />")
                            id += 1
                            pointList.append("<circle key=\"\(id)\" fill=\"none\" stroke-width=\"1\" stroke=\"\(posColor)\"  cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(3)\" />")
                            id += 1
                            break
                        case .planets:
                            pointList.append("<circle key=\"\(id)\" fill=\"white\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"5\" />")
                            id += 1
                            pointList.append("<circle key=\"\(id)\" fill=\"\(posColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\" />")
                            id += 1
                            pointList.append("<circle key=\"\(id)\" fill=\"none\" stroke-width=\"0.15\" stroke-dasharray=\"0.5,0.5\" stroke=\"\(posColor)\"  cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(3)\" />")
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
                        }
                    }
                    
                } else if typeTable[x][y] == QRPointType.posOther {
                    if qrcode.model.isDark(x, y) {
                        if posType == .rectangle {
                            pointList.append("<rect width=\"1\" height=\"1\" key=\"\(id)\" fill=\"\(posColor)\" x=\"\(x)\" y=\"\(y)\"/>")
                            id += 1
                        }
                    } else {
                        if posType == .rectangle {
                            pointList.append("<rect width=\"1\" height=\"1\" key=\"\(id)\" fill=\"white\" x=\"\(x)\" y=\"\(y)\"/>")
                            id += 1
                        }
                    }
                    
                } else {
                    if qrcode.model.isDark(x, y) {
                        switch type {
                        case .rectangle:
                            pointList.append("<rect opacity=\"\(opacity)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(otherColorDark)\" x=\"\(x.cgFloat + (1 - size) / 2.0)\" y=\"\(y.cgFloat + (1 - size) / 2.0)\"/>")
                            id += 1
                            break
                        case .round:
                            pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColorDark)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                            break
                        }
                    } else {
                        switch type {
                        case .rectangle:
                            pointList.append("<rect opacity=\"\(opacity)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(otherColorLight)\" x=\"\(x.cgFloat + (1 - size) / 2.0)\" y=\"\(y.cgFloat + (1 - size) / 2.0)\"/>")
                            id += 1
                            break
                        case .round:
                            pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2.0)\" key=\"\(id)\" fill=\"\(otherColorLight)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                            break
                        }
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
