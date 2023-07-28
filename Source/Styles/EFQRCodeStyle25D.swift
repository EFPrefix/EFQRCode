//
//  EFQRCodeStyle25D.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/3.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics
import QRCodeSwift

public class EFStyle25DParams: EFStyleParams {
    let dataHeight: CGFloat
    let positionHeight: CGFloat
    let topColor: CGColor
    let leftColor: CGColor
    let rightColor: CGColor
    
    public init(icon: EFStyleParamIcon? = nil, dataHeight: CGFloat, positionHeight: CGFloat, topColor: CGColor, leftColor: CGColor, rightColor: CGColor) {
        self.dataHeight = dataHeight
        self.positionHeight = positionHeight
        self.topColor = topColor
        self.leftColor = leftColor
        self.rightColor = rightColor
        super.init(icon: icon)
    }
}

public class EFQRCodeStyle25D: EFQRCodeStyleBase {
    
    let params: EFStyle25DParams
    
    private lazy var matrixString: String = {
        let matrixX = [sqrt(3.0) / 2, 0.5]
        let matrixY = [-sqrt(3.0) / 2, 0.5]
        let matrixZ = [0.0, 0.0]
        return "matrix(\(matrixX[0]),\(matrixX[1]),\(matrixY[0]),\(matrixY[1]),\(matrixZ[0]),\(matrixZ[1]))"
    }()
    
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
        let upOpacity: CGFloat = max(0, try params.topColor.alpha())
        let leftColor: String = try params.leftColor.hexString()
        let leftOpacity: CGFloat = max(0, try params.leftColor.alpha())
        let rightColor: String = try params.rightColor.hexString()
        let rightOpacity: CGFloat = max(0, try params.rightColor.alpha())
        var id: Int = 0
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                if qrcode.model.isDark(x, y) == false {
                    continue
                } else if (typeTable[x][y] == QRPointType.posOther || typeTable[x][y] == QRPointType.posCenter) {
                    pointList.append("<rect opacity=\"\(upOpacity)\" width=\"\(size2)\" height=\"\(size2)\" key=\"\(id)\" fill=\"\(upColor)\" x=\"\(x.cgFloat + (1.0 - size2) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size2) / 2.0)\" transform=\"\(matrixString)\"/>");
                    id += 1
                    pointList.append("<rect opacity=\"\(leftOpacity)\" width=\"\(height2)\" height=\"\(size2)\" key=\"\(id)\" fill=\"\(leftColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(x.cgFloat + (1 - size2) / 2 + size2),\(y.cgFloat + (1 - size2) / 2)) skewY(45)\"/>");
                    id += 1
                    pointList.append("<rect opacity=\"\(rightOpacity)\" width=\"\(size2)\" height=\"\(height2)\" key=\"\(id)\" fill=\"\(rightColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(x.cgFloat + (1 - size2) / 2),\(y.cgFloat + size2 + (1 - size2) / 2)) skewX(45)\"/>");
                    id += 1
                } else {
                    pointList.append("<rect opacity=\"\(upOpacity)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(upColor)\" x=\"\(x.cgFloat + (1 - size)/2)\" y=\"\(y.cgFloat + (1 - size)/2)\" transform=\"\(matrixString)\"/>");
                    id += 1
                    pointList.append("<rect opacity=\"\(leftOpacity)\" width=\"\(height)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(leftColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(x.cgFloat + (1 - size) / 2 + size),\(y.cgFloat + (1 - size) / 2)) skewY(45)\"/>");
                    id += 1
                    pointList.append("<rect opacity=\"\(rightOpacity)\" width=\"\(size)\" height=\"\(height)\" key=\"\(id)\" fill=\"\(rightColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(x.cgFloat + (1 - size) / 2),\(y.cgFloat + size + (1 - size) / 2)) skewX(45)\"/>");
                    id += 1
                }
            }
        }
        
        return pointList
    }
    
    override func writeIcon(qrcode: QRCode) throws -> [String] {
        guard let icon = params.icon else { return [] }
        
        var id: Int = 0
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        
        let scale: CGFloat = min(icon.percentage, 0.33)
        let opacity: CGFloat = max(0, icon.alpha)
        
        let iconSize: CGFloat = nCount.cgFloat * scale
        let iconXY: CGFloat = (nCount.cgFloat - iconSize) / 2
        
        let randomIdDefs: String = EFStyleParamIcon.getIdNum()
        let randomIdClips: String = EFStyleParamIcon.getIdNum()
        
        pointList.append("<g transform=\"\(matrixString)\"><path d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"#FFF\" stroke-width=\"\(100/iconSize * 1)\" fill=\"#FFF\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\" /></g>")
        pointList.append("<g key=\"\(id)\" transform=\"\(matrixString)\">")
        id += 1
        pointList.append(
            "<defs><path id=\"defs-path\(randomIdDefs)\" d=\"\(EFQRCodeStyleBasic.sq25)\" fill=\"#FFF\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize/100),\(iconSize/100))\" /></defs>"
            + "<clipPath id=\"clip-path\(randomIdClips)\">"
            + "<use xlink:href=\"#defs-path\(randomIdDefs)\" overflow=\"visible\"/>"
            + "</clipPath>"
            + "<g clip-path=\"url(#clip-path\(randomIdClips))\">"
            + (try icon.image.write(id: id, rect: CGRect(x: iconXY, y: iconXY, width: iconSize, height: iconSize), opacity: opacity))
            + "</g>"
            + "</g>"
        )
        id += 1
        return pointList
    }
    
    override func viewBox(qrcode: QRCode) -> String {
        let nCount: Int = qrcode.model.moduleCount
        return "\(-nCount) \(-nCount / 2) \(nCount * 2) \(nCount * 2)"
    }
}
