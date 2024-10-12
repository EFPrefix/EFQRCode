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
    
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    public static let defaultTopColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    public static let defaultLeftColor: CGColor = CGColor.createWith(rgb: 0x000000, alpha: 0.2)!
    public static let defaultRightColor: CGColor = CGColor.createWith(rgb: 0x000000, alpha: 0.6)!
    
    let dataHeight: CGFloat
    let positionHeight: CGFloat
    let topColor: CGColor
    let leftColor: CGColor
    let rightColor: CGColor
    
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyle25DParams.defaultBackdrop,
        dataHeight: CGFloat = 1,
        positionHeight: CGFloat = 1,
        topColor: CGColor = EFStyle25DParams.defaultTopColor,
        leftColor: CGColor = EFStyle25DParams.defaultLeftColor,
        rightColor: CGColor = EFStyle25DParams.defaultRightColor
    ) {
        self.dataHeight = dataHeight
        self.positionHeight = positionHeight
        self.topColor = topColor
        self.leftColor = leftColor
        self.rightColor = rightColor
        super.init(icon: icon, backdrop: backdrop)
    }
    
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        dataHeight: CGFloat? = nil,
        positionHeight: CGFloat? = nil,
        topColor: CGColor? = nil,
        leftColor: CGColor? = nil,
        rightColor: CGColor? = nil
    ) -> EFStyle25DParams {
        return EFStyle25DParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            dataHeight: dataHeight ?? self.dataHeight,
            positionHeight: positionHeight ?? self.positionHeight,
            topColor: topColor ?? self.topColor,
            leftColor: leftColor ?? self.leftColor,
            rightColor: rightColor ?? self.rightColor
        )
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
        let upOpacity: CGFloat = try params.topColor.alpha()
        
        let leftColor: String = try params.leftColor.hexString()
        let leftOpacity: CGFloat = try params.leftColor.alpha()
        
        let rightColor: String = try params.rightColor.hexString()
        let rightOpacity: CGFloat = try params.rightColor.alpha()
        
        var id: Int = 0
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if !isDark {
                    continue
                } else if typeTable[x][y] == QRPointType.posOther || typeTable[x][y] == QRPointType.posCenter {
                    let xValue: CGFloat = x.cgFloat + (1.0 - size2) / 2.0
                    let yValue: CGFloat = y.cgFloat + (1.0 - size2) / 2.0
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(upOpacity)\" width=\"\(size2)\" height=\"\(size2)\" fill=\"\(upColor)\" x=\"\(xValue)\" y=\"\(yValue)\" transform=\"\(matrixString)\"/>")
                    id += 1
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(leftOpacity)\" width=\"\(height2)\" height=\"\(size2)\" fill=\"\(leftColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(xValue + size2),\(yValue)) skewY(45)\"/>")
                    id += 1
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(rightOpacity)\" width=\"\(size2)\" height=\"\(height2)\" fill=\"\(rightColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(xValue),\(yValue + size2)) skewX(45)\"/>")
                    id += 1
                } else {
                    let xValue: CGFloat = x.cgFloat + (1.0 - size) / 2.0
                    let yValue: CGFloat = y.cgFloat + (1.0 - size) / 2.0
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(upOpacity)\" width=\"\(size)\" height=\"\(size)\" fill=\"\(upColor)\" x=\"\(xValue)\" y=\"\(yValue)\" transform=\"\(matrixString)\"/>")
                    id += 1
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(leftOpacity)\" width=\"\(height)\" height=\"\(size)\" fill=\"\(leftColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(xValue + size),\(yValue)) skewY(45)\"/>")
                    id += 1
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(rightOpacity)\" width=\"\(size)\" height=\"\(height)\" fill=\"\(rightColor)\" x=\"0\" y=\"0\" transform=\"\(matrixString)translate(\(xValue),\(yValue + size)) skewX(45)\"/>")
                    id += 1
                }
            }
        }
        
        return pointList
    }
    
    override func writeIcon(qrcode: QRCode) throws -> [String] {
        struct Anchor {
            static var uniqueMark: Int = 0
        }
        
        guard let icon = params.icon else { return [] }
        
        var id: Int = 0
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        
        let scale: CGFloat = min(icon.percentage, 0.33)
        let opacity: CGFloat = max(0, icon.alpha)
        
        let iconSize: CGFloat = nCount.cgFloat * scale
        let iconXY: CGFloat = (nCount.cgFloat - iconSize) / 2
        
        let bdColor: String = try icon.borderColor.hexString()
        let bdAlpha: CGFloat = max(0, try icon.borderColor.alpha())
        
        let randomIdDefs: String = "25d\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        let randomIdClips: String = "25d\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        
        pointList.append("<g opacity=\"\(bdAlpha)\" transform=\"\(matrixString)\"><path d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(bdColor)\" stroke-width=\"\(100 / iconSize)\" fill=\"\(bdColor)\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\"/></g>")
        pointList.append("<g key=\"g\(id)\" transform=\"\(matrixString)\">")
        id += 1
        
        let iconOffset: CGFloat = iconXY * 0.024
        let rectXY: CGFloat = iconXY - iconOffset
        let length: CGFloat = iconSize + 2.0 * iconOffset
        let iconRect: CGRect = CGRect(x: rectXY, y: rectXY, width: length, height: length)
        pointList.append(
            "<defs><path id=\"\(randomIdDefs)\" d=\"\(EFQRCodeStyleBasic.sq25)\"/>"
            + "<mask id=\"\(randomIdClips)\">"
            + "<use xlink:href=\"#\(randomIdDefs)\" overflow=\"visible\" fill=\"#ffffff\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100.0),\(iconSize / 100.0))\"/>"
            + "</mask>"
            + "</defs>"
            + "<g mask=\"url(#\(randomIdClips))\">"
            + (try icon.image.write(id: id, rect: iconRect, opacity: opacity, mode: icon.mode))
            + "</g>"
            + "</g>"
        )
        id += 1
        return pointList
    }
    
    override func viewBox(qrcode: QRCode) -> CGRect {
        let moduleCount: Int = qrcode.model.moduleCount
        if let quietzone = params.backdrop.quietzone {
            return CGRect(
                x: -moduleCount.cgFloat * (quietzone.left + 1),
                y: -moduleCount.cgFloat * (quietzone.top + 0.5),
                width: moduleCount.cgFloat * (quietzone.left + 2 + quietzone.right),
                height: moduleCount.cgFloat * (quietzone.top + 2 + quietzone.bottom)
            )
        }
        return CGRect(x: -moduleCount.cgFloat, y: -moduleCount.cgFloat / 2.0, width: moduleCount.cgFloat * 2, height: moduleCount.cgFloat * 2)
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
        return EFQRCodeStyle25D(params: params.copyWith(icon: icon))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, nil)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.d25(params: self.params)
    }
}
