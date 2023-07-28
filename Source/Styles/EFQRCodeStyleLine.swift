//
//  EFQRCodeStyleLine.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/3.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics
import QRCodeSwift

public class EFStyleLineParams: EFStyleParams {
    let position: EFStyleLineParamsPosition
    let line: EFStyleLineParamsLine
    
    public init(icon: EFStyleParamIcon? = nil, position: EFStyleLineParamsPosition, line: EFStyleLineParamsLine) {
        self.position = position
        self.line = line
        super.init(icon: icon)
    }
}

public class EFStyleLineParamsPosition: EFStyleBasicParamsPosition {
    
}

public class EFStyleLineParamsLine {
    let direction: EFStyleLineParamsLineDirection
    let thickness: CGFloat // (0-1]
    let color: CGColor
    
    public init(direction: EFStyleLineParamsLineDirection, thickness: CGFloat, color: CGColor) {
        self.direction = direction
        self.thickness = thickness
        self.color = color
    }
}

public enum EFStyleLineParamsLineDirection: CaseIterable {
    case horizontal
    case vertical
    case cross
    case loopback
    case topLeftToBottomRight
    case topRightToBottomLeft
    case x
}

public class EFQRCodeStyleLine: EFQRCodeStyleBase {
    
    let params: EFStyleLineParams
    
    public init(params: EFStyleLineParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        
        let type: EFStyleLineParamsLineDirection = params.line.direction
        let size: CGFloat = max(0, params.line.thickness)
        let opacity: CGFloat = max(0, try params.line.color.alpha())
        let posType: EFStyleBasicParamsPositionStyle = params.position.style
        var id: Int = 0
        let otherColor: String = try params.line.color.hexString()
        let posColor: String = try params.position.color.hexString()
        
        let vw: [CGFloat] = [3, -3]
        let vh: [CGFloat] = [3, -3]
        
        var available: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        var ava2: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                if qrcode.model.isDark(x, y) == false {
                    continue
                }
                
                if typeTable[x][y] == QRPointType.posCenter {
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
                        pointList.append("<path key=\"\(id)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(posColor)\" stroke-width=\"\(100.cgFloat / 6 * (1 - (1 - size) * 0.75))\" fill=\"none\" transform=\"translate(\(x.cgFloat - 2.5),\(y.cgFloat - 2.5)) scale(\(6.cgFloat / 100),\(6.cgFloat / 100))\" />")
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
                    case .horizontal:
                        if x == 0 || (x > 0 && (!qrcode.model.isDark(x - 1, y) || !ava2[x - 1][y])) {
                            let start: Int = 0
                            var end: Int = 0
                            var ctn: Bool = true
                            
                            while ctn && x + end < nCount {
                                if qrcode.model.isDark(x + end, y) && ava2[x + end][y] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 1 {
                                for i in start..<end {
                                    ava2[x + i][y] = false
                                    available[x + i][y] = false
                                }
                                pointList.append("<line opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 0.5)\" y2=\"\(y.cgFloat + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\" key=\"\(id)\"/>")
                                id += 1
                            }
                        }
                        
                        if available[x][y] {
                            pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                        }
                        break
                    case .vertical:
                        if y == 0 || (y > 0 && (!qrcode.model.isDark(x, y - 1) || !ava2[x][y - 1])) {
                            let start: Int = 0
                            var end: Int = 0
                            var ctn: Bool = true
                            
                            while ctn && y + end < nCount {
                                if qrcode.model.isDark(x, y + end) && ava2[x][y + end] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 1 {
                                for i in start..<end {
                                    ava2[x][y + i] = false
                                    available[x][y + i] = false
                                }
                                pointList.append("<line opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + 0.5)\" y2=\"\(y.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\" key=\"\(id)\"/>")
                                id += 1
                            }
                        }
                        
                        if available[x][y] {
                            pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                        }
                        break
                    case .cross:
                        if y == 0 || (y > 0 && (!qrcode.model.isDark(x, y - 1) || !ava2[x][y - 1])) {
                            let start: Int = 0
                            var end: Int = 0
                            var ctn: Bool = true
                            
                            while ctn && y + end < nCount && end - start <= 3 {
                                if qrcode.model.isDark(x, y + end) && ava2[x][y + end] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 1 {
                                for i in start..<end {
                                    ava2[x][y + i] = false
                                    available[x][y + i] = false
                                }
                                pointList.append("<line opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + 0.5)\" y2=\"\(y.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\" key=\"\(id)\"/>")
                                id += 1
                            }
                        }
                        
                        if x == 0 || (x > 0 && (!qrcode.model.isDark(x - 1, y) || !ava2[x - 1][y])) {
                            let start: Int = 0
                            var end: Int = 0
                            var ctn: Bool = true
                            
                            while ctn && x + end < nCount && end - start <= 3 {
                                if qrcode.model.isDark(x + end, y) && ava2[x + end][y] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 1 {
                                for i in start..<end {
                                    ava2[x + i][y] = false
                                    available[x + i][y] = false
                                }
                                pointList.append("<line opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 0.5)\" y2=\"\(y.cgFloat + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\" key=\"\(id)\"/>")
                                id += 1
                            }
                        }
                        
                        if available[x][y] {
                            pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                        }
                        break
                    case .loopback:
                        if (x > y) != (x + y < nCount) {
                            if y == 0 || (y > 0 && (!qrcode.model.isDark(x, y - 1) || !ava2[x][y - 1])) {
                                let start: Int = 0
                                var end: Int = 0
                                var ctn: Bool = true
                                
                                while ctn && y + end < nCount && end - start <= 3 {
                                    if qrcode.model.isDark(x, y + end) && ava2[x][y + end] {
                                        end += 1
                                    } else {
                                        ctn = false
                                    }
                                }
                                if end - start > 1 {
                                    for i in start..<end {
                                        ava2[x][y + i] = false
                                        available[x][y + i] = false
                                    }
                                    pointList.append("<line opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + 0.5)\" y2=\"\(y.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\" key=\"\(id)\"/>")
                                    id += 1
                                }
                            }
                        } else {
                            if x == 0 || (x > 0 && (!qrcode.model.isDark(x - 1, y) || !ava2[x - 1][y])) {
                                let start: Int = 0
                                var end: Int = 0
                                var ctn: Bool = true
                                
                                while ctn && x + end < nCount && end - start <= 3 {
                                    if qrcode.model.isDark(x + end, y) && ava2[x + end][y] {
                                        end += 1
                                    } else {
                                        ctn = false
                                    }
                                }
                                if end - start > 1 {
                                    for i in start..<end {
                                        ava2[x + i][y] = false
                                        available[x + i][y] = false
                                    }
                                    pointList.append("<line opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 0.5)\" y2=\"\(y.cgFloat + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\" key=\"\(id)\"/>")
                                    id += 1
                                }
                            }
                        }
                        
                        if available[x][y] {
                            pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                        }
                        break
                    case .topLeftToBottomRight:
                        if y == 0 || x == 0 || ((y > 0 && x > 0) && (!qrcode.model.isDark(x - 1, y - 1) || !ava2[x - 1][y - 1])) {
                            let start: Int = 0
                            var end: Int = 0
                            var ctn: Bool = true
                            while ctn && y + end < nCount && x + end < nCount {
                                if qrcode.model.isDark(x + end, y + end) && ava2[x + end][y + end] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 1 {
                                for i in start..<end {
                                    ava2[x + i][y + i] = false
                                    available[x + i][y + i] = false
                                }
                                pointList.append("<line opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" y2=\"\(y.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\" key=\"\(id)\"/>")
                                id += 1
                            }
                        }
                        if available[x][y] {
                            pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                        }
                        break
                    case .topRightToBottomLeft:
                        if x == 0 || y == nCount - 1 || ((x > 0 && y < nCount - 1) && (!qrcode.model.isDark(x - 1, y + 1) || !ava2[x - 1][y + 1])) {
                            let start: Int = 0
                            var end: Int = 0
                            var ctn: Bool = true
                            while ctn && x + end < nCount && y - end >= 0 {
                                if qrcode.model.isDark(x + end, y - end) && available[x + end][y - end] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 1 {
                                for i in start..<end {
                                    ava2[x + i][y - i] = false
                                    available[x + i][y - i] = false
                                }
                                pointList.append("<line opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" y2=\"\(y.cgFloat - end.cgFloat + start.cgFloat + 1 + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\" key=\"\(id)\"/>")
                                id += 1
                            }
                        }
                        if available[x][y] {
                            pointList.append("<circle opacity=\"\(opacity)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                        }
                        break
                    case .x:
                        if x == 0 || y == nCount - 1 || ((x > 0 && y < nCount - 1) && (!qrcode.model.isDark(x - 1, y + 1) || !ava2[x - 1][y + 1])) {
                            let start: Int = 0
                            var end: Int = 0
                            var ctn: Bool = true
                            while ctn && x + end < nCount && y - end >= 0 {
                                if qrcode.model.isDark(x + end, y - end) && ava2[x + end][y - end] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 1 {
                                for i in start..<end {
                                    ava2[x + i][y - i] = false
                                }
                                pointList.append("<line opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" y2=\"\(y.cgFloat - end.cgFloat + start.cgFloat + 1 + 0.5)\" stroke-width=\"\(size / 2 * CGFloat.random(in: 0.3...1))\" stroke=\"\(otherColor)\" stroke-linecap=\"round\" key=\"\(id)\"/>")
                                id += 1
                            }
                        }
                        if y == 0 || x == 0 || ((y > 0 && x > 0) && (!qrcode.model.isDark(x - 1, y - 1) || !available[x - 1][y - 1])) {
                            let start: Int = 0
                            var end: Int = 0
                            var ctn: Bool = true
                            while ctn && y + end < nCount && x + end < nCount {
                                if qrcode.model.isDark(x + end, y + end) && available[x + end][y + end] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 1 {
                                for i in start..<end {
                                    available[x + i][y + i] = false
                                }
                                pointList.append("<line opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" y2=\"\(y.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" stroke-width=\"\(size / 2 * CGFloat.random(in: 0.3...1))\" stroke=\"\(otherColor)\" stroke-linecap=\"round\" key=\"\(id)\"/>")
                                id += 1
                            }
                        }
                        pointList.append("<circle opacity=\"\(opacity)\" r=\"\(0.5 * CGFloat.random(in: 0.33...0.9))\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
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
