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
    
    public static let defaultDataColor: CGColor = CGColor.createWith(rgb: 0x8ED1FC)!
    public static let defaultPositionColor: CGColor = CGColor.createWith(rgb: 0x0693E3)!
    
    let dataColor: CGColor
    let positionColor: CGColor
    
    public init(icon: EFStyleParamIcon? = nil, dataColor: CGColor = EFStyleBubbleParams.defaultDataColor, positionColor: CGColor = EFStyleBubbleParams.defaultPositionColor) {
        self.dataColor = dataColor
        self.positionColor = positionColor
        super.init(icon: icon)
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
        
        var id: Int = 0
        
        let otherColor = try params.dataColor.hexString()
        let otherOpacity: CGFloat = try params.dataColor.alpha()
        let posColor = try params.positionColor.hexString()
        let posOpacity: CGFloat = try params.positionColor.alpha()
        
        var available: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        var ava2: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        
        for y in 0..<nCount {
            for x in 0..<nCount {
                
                if qrcode.model.isDark(x, y) && typeTable[x][y] == .posCenter {
                    pointList.append("<circle opacity=\"\(posOpacity)\" key=\"\(id)\" fill=\"\(posColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                    id += 1
                    pointList.append("<circle opacity=\"\(posOpacity)\" key=\"\(id)\" fill=\"none\" stroke-width=\"1\" stroke=\"\(posColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\"/>")
                    id += 1
                } else if qrcode.model.isDark(x, y) && typeTable[x][y] == .posOther {
                    continue
                } else {
                    if available[x][y] && ava2[x][y] && x < nCount - 2 && y < nCount - 2 {
                        var ctn = true
                        for i in 0..<3 {
                            for j in 0..<3 {
                                if ava2[x + i][y + j] == false {
                                    ctn = false
                                }
                            }
                        }
                        if ctn && qrcode.model.isDark(x + 1, y) && qrcode.model.isDark(x + 1, y + 2) && qrcode.model.isDark(x, y + 1) && qrcode.model.isDark(x + 2, y + 1) {
                            g1.append("<circle opacity=\"\(otherOpacity)\" key=\"\(id)\" cx=\"\(x.cgFloat + 1 + 0.5)\" cy=\"\(y.cgFloat + 1 + 0.5)\" r=\"1\" fill=\"#FFFFFF\" stroke=\"\(otherColor)\" stroke-width=\"\(Double.random(in: 0.33...0.6))\" />")
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
                        if qrcode.model.isDark(x, y) && qrcode.model.isDark(x + 1, y) && qrcode.model.isDark(x, y + 1) && qrcode.model.isDark(x + 1, y + 1) {
                            g1.append("<circle opacity=\"\(otherOpacity)\" key=\"\(id)\" cx=\"\(x + 1)\" cy=\"\(y + 1)\" r=\"\(sqrt(1.0 / 2.0))\" fill=\"#FFFFFF\" stroke=\"\(otherColor)\" stroke-width=\"\(Double.random(in: 0.33...0.6))\" />")
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
                        if qrcode.model.isDark(x, y) && qrcode.model.isDark(x, y + 1) {
                            pointList.append("<circle opacity=\"\(otherOpacity)\" key=\"\(id)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y + 1)\" r=\"\(0.5 * Double.random(in: 0.95...1.05))\" fill=\"#FFFFFF\" stroke=\"\(otherColor)\" stroke-width=\"\(Double.random(in: 0.36...0.4))\" />")
                            id += 1
                            available[x][y] = false
                            available[x][y + 1] = false
                        }
                    }
                    if available[x][y] && x < nCount - 1 {
                        if qrcode.model.isDark(x, y) && qrcode.model.isDark(x + 1, y) {
                            pointList.append("<circle opacity=\"\(otherOpacity)\" key=\"\(id)\" cx=\"\(x + 1)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(0.5 * Double.random(in: 0.95...1.05))\" fill=\"#FFFFFF\" stroke=\"\(otherColor)\" stroke-width=\"\(Double.random(in: 0.36...0.4))\" />")
                            id += 1
                            available[x][y] = false
                            available[x + 1][y] = false
                        }
                    }
                    if available[x][y] {
                        if qrcode.model.isDark(x, y) {
                            pointList.append("<circle opacity=\"\(otherOpacity)\" r=\"\(0.5 * Double.random(in: 0.5...1))\" key=\"\(id)\" fill=\"\(otherColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                        } else if typeTable[x][y] == QRPointType.data {
                            if Double.random(in: 0...1) > 0.85 {
                                g2.append("<circle opacity=\"\(otherOpacity)\" r=\"\(0.5 * Double.random(in: 0.85...1.3))\" key=\"\(id)\" fill=\"#FFFFFF\" stroke=\"\(otherColor)\" stroke-width=\"\(Double.random(in: 0.15...0.33))\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
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
}
