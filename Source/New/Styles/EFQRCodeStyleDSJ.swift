//
//  EFQRCodeStyleDSJ.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/4.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics
import QRCodeSwift

public class EFStyleDSJParams: EFStyleParams {
    let positionStyle: EFStyleDSJParamsPositionStyle
    let data: EFStyleDSJParamsData
    
    public init(icon: EFStyleParamIcon? = nil, positionStyle: EFStyleDSJParamsPositionStyle, data: EFStyleDSJParamsData) {
        self.positionStyle = positionStyle
        self.data = data
        super.init(icon: icon)
    }
}

public enum EFStyleDSJParamsPositionStyle {
    case rectangle
    case dsj(thickness: CGFloat)
}

public class EFStyleDSJParamsData {
    let thickness: CGFloat // (0-1]
    let xThickness: CGFloat // (0-1]
    
    public init(thickness: CGFloat, xThickness: CGFloat) {
        self.thickness = thickness
        self.xThickness = xThickness
    }
}

public class EFQRCodeStyleDSJ: EFQRCodeStyleBase {
    
    let params: EFStyleDSJParams
    
    public init(params: EFStyleDSJParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        var g1: [String] = []
        var g2: [String] = []
        
        let width2: CGFloat = max(0, params.data.thickness)
        let width1: CGFloat = max(0, params.data.xThickness)
        let posType: EFStyleDSJParamsPositionStyle = params.positionStyle
        var id: Int = 0
        
        var available: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        var ava2: [[Bool]] = Array(repeating: Array(repeating: true, count: nCount), count: nCount)
        
        for y in 0..<nCount {
            for x in 0..<nCount {
                
                if qrcode.model.isDark(x, y) == false {
                    continue
                } else if typeTable[x][y] == QRPointType.posCenter {
                    switch posType {
                    case .rectangle:
                        pointList.append("<rect width=\"1\" height=\"1\" key=\"\(id)\" fill=\"#0B2D97\" x=\"\(x)\" y=\"\(y)\"/>");
                        id += 1
                        break
                    case .dsj(let thickness):
                        let width3: CGFloat = max(0, thickness)
                        pointList.append("<rect width=\"\(3 - (1 - width3))\" height=\"\(3 - (1 - width3))\" key=\"\(id)\" fill=\"#0B2D97\" x=\"\(x.cgFloat - 1 + (1 - width3)/2.0)\" y=\"\(y.cgFloat - 1 + (1 - width3)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect width=\"\(width3)\" height=\"\(3 - (1 - width3))\" key=\"\(id)\" fill=\"#0B2D97\" x=\"\(x.cgFloat - 3 + (1 - width3)/2.0)\" y=\"\(y.cgFloat - 1 + (1 - width3)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect width=\"\(width3)\" height=\"\(3 - (1 - width3))\" key=\"\(id)\" fill=\"#0B2D97\" x=\"\(x.cgFloat + 3 + (1 - width3)/2.0)\" y=\"\(y.cgFloat - 1 + (1 - width3)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect width=\"\(3 - (1 - width3))\" height=\"\(width3)\" key=\"\(id)\" fill=\"#0B2D97\" x=\"\(x.cgFloat - 1 + (1 - width3)/2.0)\" y=\"\(y.cgFloat - 3 + (1 - width3)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect width=\"\(3 - (1 - width3))\" height=\"\(width3)\" key=\"\(id)\" fill=\"#0B2D97\" x=\"\(x.cgFloat - 1 + (1 - width3)/2.0)\" y=\"\(y.cgFloat + 3 + (1 - width3)/2.0)\"/>");
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posOther {
                    if case .rectangle = posType {
                        pointList.append("<rect width=\"1\" height=\"1\" key=\"\(id)\" fill=\"#0B2D97\" x=\"\(x)\" y=\"\(y)\"/>");
                        id += 1
                    }
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
                        if ctn && qrcode.model.isDark(x + 2, y) && qrcode.model.isDark(x + 1, y + 1) && qrcode.model.isDark(x, y + 2) && qrcode.model.isDark(x + 2, y + 2) {
                            g1.append("<line key=\"\(id)\" x1=\"\(x.cgFloat + width1 / sqrt(8))\" y1=\"\(y.cgFloat + width1 / sqrt(8))\" x2=\"\(x.cgFloat + 3 - width1 / sqrt(8))\" y2=\"\(y.cgFloat + 3 - width1 / sqrt(8))\" fill=\"none\" stroke=\"#0B2D97\" stroke-width=\"\(width1)\" />")
                            id += 1
                            g1.append("<line key=\"\(id)\" x1=\"\(x.cgFloat + 3 - width1 / sqrt(8))\" y1=\"\(y.cgFloat + width1 / sqrt(8))\" x2=\"\(x.cgFloat + width1 / sqrt(8))\" y2=\"\(y.cgFloat + 3 - width1 / sqrt(8))\" fill=\"none\" stroke=\"#0B2D97\" stroke-width=\"\(width1)\" />")
                            id += 1
                            available[x][y] = false
                            available[x + 2][y] = false
                            available[x][y + 2] = false
                            available[x + 2][y + 2] = false
                            available[x + 1][y + 1] = false
                            for i in 0..<3 {
                                for j in 0..<3 {
                                    ava2[x + i][y + j] = false
                                }
                            }
                        }
                    }
                    if available[x][y] && ava2[x][y] && x < nCount - 1 && y < nCount - 1 {
                        var ctn: Bool = true
                        for i in 0..<2 {
                            for j in 0..<2 {
                                if ava2[x + i][y + j] == false {
                                    ctn = false
                                }
                            }
                        }
                        if ctn && qrcode.model.isDark(x + 1, y) && qrcode.model.isDark(x, y + 1) && qrcode.model.isDark(x + 1, y + 1) {
                            g1.append("<line key=\"\(id)\" x1=\"\(x.cgFloat + width1 / sqrt(8))\" y1=\"\(y.cgFloat + width1 / sqrt(8))\" x2=\"\(x.cgFloat + 2 - width1 / sqrt(8))\" y2=\"\(y.cgFloat + 2 - width1 / sqrt(8))\" fill=\"none\" stroke=\"#0B2D97\" stroke-width=\"\(width1)\" />")
                            id += 1
                            g1.append("<line key=\"\(id)\" x1=\"\(x.cgFloat + 2 - width1 / sqrt(8))\" y1=\"\(y.cgFloat + width1 / sqrt(8))\" x2=\"\(x.cgFloat + width1 / sqrt(8))\" y2=\"\(y.cgFloat + 2 - width1 / sqrt(8))\" fill=\"none\" stroke=\"#0B2D97\" stroke-width=\"\(width1)\" />")
                            id += 1
                            for i in 0..<2 {
                                for j in 0..<2 {
                                    available[x + i][y + j] = false
                                    ava2[x + i][y + j] = false
                                }
                            }
                        }
                    }
                    
                    if available[x][y] && ava2[x][y] {
                        if y == 0 || (y > 0 && (!qrcode.model.isDark(x, y - 1) || !ava2[x][y - 1])) {
                            let start: Int = y
                            var end: Int = y
                            var ctn = true
                            while ctn && end < nCount {
                                if qrcode.model.isDark(x, end) && ava2[x][end] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 2 {
                                for i in start..<end {
                                    ava2[x][i] = false
                                    available[x][i] = false
                                }
                                g2.append("<rect width=\"\(width2)\" height=\"\(end.cgFloat - start.cgFloat - 1 - (1 - width2))\" key=\"\(id)\" fill=\"#E02020\" x=\"\(x.cgFloat + (1 - width2)/2.0)\" y=\"\(y.cgFloat + (1 - width2)/2.0)\"/>")
                                id += 1
                                g2.append("<rect width=\"\(width2)\" height=\"\(width2)\" key=\"\(id)\" fill=\"#E02020\" x=\"\(x.cgFloat + (1 - width2)/2.0)\" y=\"\(end.cgFloat - 1 + (1 - width2)/2.0)\"/>")
                                id += 1
                            }
                        }
                    }
                    
                    if available[x][y] && ava2[x][y] {
                        if x == 0 || (x > 0 && (!qrcode.model.isDark(x - 1, y) || !ava2[x - 1][y])) {
                            let start: Int = x
                            var end: Int = x
                            var ctn: Bool = true
                            while ctn && end < nCount {
                                if qrcode.model.isDark(end, y) && ava2[end][y] {
                                    end += 1
                                } else {
                                    ctn = false
                                }
                            }
                            if end - start > 1 {
                                for i in start..<end {
                                    ava2[i][y] = false
                                    available[i][y] = false
                                }
                                g2.append("<rect width=\"\(end.cgFloat - start.cgFloat - (1 - width2))\" height=\"\(width2)\" key=\"\(id)\" fill=\"#F6B506\" x=\"\(x.cgFloat + (1 - width2)/2.0)\" y=\"\(y.cgFloat + (1 - width2)/2.0)\"/>")
                                id += 1
                            }
                        }
                    }
                    if available[x][y] {
                        pointList.append("<rect width=\"\(width2)\" height=\"\(width2)\" key=\"\(id)\" fill=\"#F6B506\" x=\"\(x.cgFloat + (1 - width2)/2.0)\" y=\"\(y.cgFloat + (1 - width2)/2.0)\"/>")
                        id += 1
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
