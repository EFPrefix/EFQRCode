//
//  EFQRCodeStyleLine.swift
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

public class EFStyleLineParams: EFStyleParams {
    
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    public static let defaultPosition: EFStyleLineParamsPosition = EFStyleLineParamsPosition()
    public static let defaultLine: EFStyleLineParamsLine = EFStyleLineParamsLine()
    
    let position: EFStyleLineParamsPosition
    let line: EFStyleLineParamsLine
    
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleLineParams.defaultBackdrop,
        position: EFStyleLineParamsPosition = EFStyleLineParams.defaultPosition,
        line: EFStyleLineParamsLine = EFStyleLineParams.defaultLine
    ) {
        self.position = position
        self.line = line
        super.init(icon: icon, backdrop: backdrop)
    }
    
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        position: EFStyleLineParamsPosition? = nil,
        line: EFStyleLineParamsLine? = nil
    ) -> EFStyleLineParams {
        return EFStyleLineParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            position: position ?? self.position,
            line: line ?? self.line
        )
    }
}

public class EFStyleLineParamsPosition {
    
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    let style: EFStyleParamsPositionStyle
    let size: CGFloat
    let color: CGColor
    
    public init(
        style: EFStyleParamsPositionStyle = .rectangle,
        size: CGFloat = 1,
        color: CGColor = EFStyleLineParamsPosition.defaultColor
    ) {
        self.style = style
        self.size = size
        self.color = color
    }
}

public class EFStyleLineParamsLine {
    
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    let direction: EFStyleLineParamsLineDirection
    let thickness: CGFloat // (0-1]
    let color: CGColor
    
    public init(
        direction: EFStyleLineParamsLineDirection = .x,
        thickness: CGFloat = 0.5, color: CGColor = EFStyleLineParamsLine.defaultColor
    ) {
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
        let otherColor: String = try params.line.color.hexString()
        
        let posType: EFStyleParamsPositionStyle = params.position.style
        let positionColor: String = try params.position.color.hexString()
        let positionAlpha: CGFloat = try params.position.color.alpha()
        let posSize: CGFloat = params.position.size
        
        var id: Int = 0
        
        var available: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        var ava2: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if !isDark {
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
                                pointList.append("<line key=\"\(id)\" opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 0.5)\" y2=\"\(y.cgFloat + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\"/>")
                                id += 1
                            }
                        }
                        
                        if available[x][y] {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(opacity)\" r=\"\(size / 2)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
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
                                pointList.append("<line key=\"\(id)\" opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + 0.5)\" y2=\"\(y.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\"/>")
                                id += 1
                            }
                        }
                        
                        if available[x][y] {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(opacity)\" r=\"\(size / 2)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
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
                                pointList.append("<line key=\"\(id)\" opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + 0.5)\" y2=\"\(y.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\"/>")
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
                                pointList.append("<line key=\"\(id)\" opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 0.5)\" y2=\"\(y.cgFloat + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\"/>")
                                id += 1
                            }
                        }
                        
                        if available[x][y] {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(opacity)\" r=\"\(size / 2)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
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
                                    pointList.append("<line key=\"\(id)\" opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + 0.5)\" y2=\"\(y.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\"/>")
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
                                    pointList.append("<line key=\"\(id)\" opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 0.5)\" y2=\"\(y.cgFloat + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\"/>")
                                    id += 1
                                }
                            }
                        }
                        
                        if available[x][y] {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(opacity)\" r=\"\(size / 2)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
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
                                pointList.append("<line key=\"\(id)\" opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" y2=\"\(y.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\"/>")
                                id += 1
                            }
                        }
                        if available[x][y] {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(opacity)\" r=\"\(size / 2)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
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
                                pointList.append("<line key=\"\(id)\" opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" y2=\"\(y.cgFloat - end.cgFloat + start.cgFloat + 1 + 0.5)\" stroke-width=\"\(size)\" stroke=\"\(otherColor)\" stroke-linecap=\"round\"/>")
                                id += 1
                            }
                        }
                        if available[x][y] {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(opacity)\" r=\"\(size / 2)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
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
                                pointList.append("<line key=\"\(id)\" opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" y2=\"\(y.cgFloat - end.cgFloat + start.cgFloat + 1 + 0.5)\" stroke-width=\"\(size / 2 * CGFloat.random(in: 0.3...1))\" stroke=\"\(otherColor)\" stroke-linecap=\"round\"/>")
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
                                pointList.append("<line key=\"\(id)\" opacity=\"\(opacity)\" x1=\"\(x.cgFloat + 0.5)\" y1=\"\(y.cgFloat + 0.5)\" x2=\"\(x.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" y2=\"\(y.cgFloat + end.cgFloat - start.cgFloat - 1 + 0.5)\" stroke-width=\"\(size / 2 * CGFloat.random(in: 0.3...1))\" stroke=\"\(otherColor)\" stroke-linecap=\"round\"/>")
                                id += 1
                            }
                        }
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(opacity)\" r=\"\(0.5 * CGFloat.random(in: 0.33...0.9))\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
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
        return EFQRCodeStyleLine(params: params.copyWith(icon: icon))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, nil)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.line(params: self.params)
    }
}
