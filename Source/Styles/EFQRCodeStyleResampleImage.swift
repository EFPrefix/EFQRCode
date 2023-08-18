//
//  EFQRCodeStyleResampleImage.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/4.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics
import QRCodeSwift

public class EFStyleResampleImageParams: EFStyleParams {
    
    public static let defaultAlign: EFStyleResampleImageParamsAlign = EFStyleResampleImageParamsAlign()
    public static let defaultTiming: EFStyleResampleImageParamsTiming = EFStyleResampleImageParamsTiming()
    public static let defaultPosition: EFStyleResampleImageParamsPosition = EFStyleResampleImageParamsPosition()
    
    let image: EFStyleResampleImageParamsImage?
    let align: EFStyleResampleImageParamsAlign
    let timing: EFStyleResampleImageParamsTiming
    let position: EFStyleResampleImageParamsPosition
    let dataColor: CGColor
    
    public init(icon: EFStyleParamIcon? = nil, image: EFStyleResampleImageParamsImage?, align: EFStyleResampleImageParamsAlign = EFStyleResampleImageParams.defaultAlign, timing: EFStyleResampleImageParamsTiming = EFStyleResampleImageParams.defaultTiming, position: EFStyleResampleImageParamsPosition = EFStyleResampleImageParams.defaultPosition, dataColor: CGColor = CGColor.black) {
        self.image = image
        self.align = align
        self.timing = timing
        self.position = position
        self.dataColor = dataColor
        super.init(icon: icon)
    }
}

public enum EFStyleResampleImageParamAlignStyle: CaseIterable {
    case none
    case rectangle
    case round
    case roundedRectangle
}

public class EFStyleResampleImageParamsAlign {
    
    let style: EFStyleResampleImageParamAlignStyle
    let onlyWhite: Bool
    let size: CGFloat
    let color: CGColor
    
    public init(style: EFStyleResampleImageParamAlignStyle = .rectangle, onlyWhite: Bool = false, size: CGFloat = 1, color: CGColor = CGColor.black) {
        self.style = style
        self.onlyWhite = onlyWhite
        self.size = size
        self.color = color
    }
}

public enum EFStyleResampleImageParamTimingStyle: CaseIterable {
    case none
    case rectangle
    case round
    case roundedRectangle
}

public class EFStyleResampleImageParamsTiming {
    
    let style: EFStyleResampleImageParamTimingStyle
    let onlyWhite: Bool
    let size: CGFloat
    let color: CGColor
    
    public init(style: EFStyleResampleImageParamTimingStyle = .rectangle, onlyWhite: Bool = false, size: CGFloat = 1, color: CGColor = CGColor.black) {
        self.style = style
        self.onlyWhite = onlyWhite
        self.size = size
        self.color = color
    }
}

public class EFStyleResampleImageParamsPosition {
    
    let style: EFStyleParamsPositionStyle
    let size: CGFloat
    let color: CGColor
    
    public init(style: EFStyleParamsPositionStyle = .rectangle, size: CGFloat = 1, color: CGColor = CGColor.black) {
        self.style = style
        self.size = size
        self.color = color
    }
}

public class EFStyleResampleImageParamsImage {
    let image: EFStyleParamImage
    let contrast: CGFloat
    let exposure: CGFloat
    
    public init(image: EFStyleParamImage, contrast: CGFloat = 0, exposure: CGFloat = 0) {
        self.image = image
        self.contrast = contrast
        self.exposure = exposure
    }
}

public class EFQRCodeStyleResampleImage: EFQRCodeStyleBase {
    
    let params: EFStyleResampleImageParams
    
    public init(params: EFStyleResampleImageParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        let typeTable: [[QRPointType]] = qrcode.model.getTypeTable()
        var pointList: [String] = []
        let alignType: EFStyleResampleImageParamAlignStyle = params.align.style
        let alignOnlyWhite: Bool = params.align.onlyWhite
        let timingType: EFStyleResampleImageParamTimingStyle = params.timing.style
        let timingOnlyWhite: Bool = params.timing.onlyWhite
        let positionType: EFStyleParamsPositionStyle = params.position.style
        let positionColor: String = try params.position.color.hexString()
        let positionAlpha: CGFloat = try params.position.color.alpha()
        let positionSize: CGFloat = params.position.size
        var id: Int = 0
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                let posX: CGFloat = 3 * x.cgFloat
                let posY: CGFloat = 3 * y.cgFloat
                if typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther {
                    if (qrcode.model.isDark(x, y)) {
                        if alignType != .none && alignOnlyWhite == false {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#B-align-black\" x=\"\(posX - 0.02)\" y=\"\(posY - 0.02)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#S-align-black\" x=\"\(posX + 1 - 0.01)\" y=\"\(posY + 1 - 0.01)\"/>")
                            id += 1
                        }
                    } else {
                        if alignType == .none {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#S-white\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#B-white\" x=\"\(posX - 0.02)\" y=\"\(posY - 0.02)\"/>")
                            id += 1
                        }
                    }
                } else if typeTable[x][y] == QRPointType.timing {
                    if (qrcode.model.isDark(x, y)) {
                        if timingType != .none && timingOnlyWhite == false {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#B-timing-black\" x=\"\(posX - 0.02)\" y=\"\(posY - 0.02)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#S-timing-black\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        }
                    } else {
                        if timingType == .none {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#S-white\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#B-white\" x=\"\(posX - 0.02)\" y=\"\(posY - 0.02)\"/>")
                            id += 1
                        }
                    }
                } else if typeTable[x][y] == QRPointType.posCenter {
                    var markArr: [CGFloat] = [-3, -3]
                    if x > y {
                        markArr = [0, -3]
                    } else if x < y {
                        markArr = [-3, 0]
                    }
                    pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"24\" height=\"24\" key=\"\(id)\" fill=\"#FFFFFF\" x=\"\(posX - 12 - markArr[0])\" y=\"\(posY - 12 - markArr[1])\"/>");
                    id += 1
                    switch positionType {
                    case .rectangle:
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"9\" height=\"9\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(posX - 3)\" y=\"\(posY - 3)\"/>");
                        id += 1
                        pointList.append("<rect opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"\(3 * positionSize)\" stroke=\"\(positionColor)\" x=\"\(posX - 7.5)\" y=\"\(posY - 7.5)\" width=\"18\" height=\"18\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"4.5\"/>")
                        id += 1
                        pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"\(3 * positionSize)\" stroke=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"9\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"4.5\"/>")
                        id += 1
                        pointList.append("<path opacity=\"\(positionAlpha)\" key=\"\(id)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(positionColor)\" stroke-width=\"\(100.cgFloat / 6 * positionSize)\" fill=\"none\" transform=\"translate(\(posX - 7.5),\(posY - 7.5)) scale(\(18.cgFloat / 100),\(18.cgFloat / 100))\"/>")
                        id += 1
                        break
                    case .planets:
                        pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"4.5\"/>")
                        id += 1
                        pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"0.45\" stroke-dasharray=\"1.5,1.5\" stroke=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"9\"/>")
                        id += 1
                        for w in 0..<EFQRCodeStyleBasic.planetsVw.count {
                            pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"\(positionColor)\" cx=\"\(posX + 3 * EFQRCodeStyleBasic.planetsVw[w] + 1.5)\" cy=\"\(posY + 1.5)\" r=\"\(1.5 * positionSize)\"/>")
                            id += 1
                        }
                        for h in 0..<EFQRCodeStyleBasic.planetsVh.count {
                            pointList.append("<circle opacity=\"\(positionAlpha)\" key=\"\(id)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 3 * EFQRCodeStyleBasic.planetsVh[h] + 1.5)\" r=\"\(1.5 * positionSize)\"/>")
                            id += 1
                        }
                        break
                    case .dsj:
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"\(9 - 3 * (1 - positionSize))\" height=\"\(9 - 3 * (1 - positionSize))\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(posX - 3 + 3 * (1 - positionSize)/2.0)\" y=\"\(posY - 3 + 3 * (1 - positionSize)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"\(3 * positionSize)\" height=\"\(9 - 3 * (1 - positionSize))\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(posX - 9 + 3 * (1 - positionSize)/2.0)\" y=\"\(posY - 3 + 3 * (1 - positionSize)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"\(3 * positionSize)\" height=\"\(9 - 3 * (1 - positionSize))\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(posX + 9 + 3 * (1 - positionSize)/2.0)\" y=\"\(posY - 3 + 3 * (1 - positionSize)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"\(9 - 3 * (1 - positionSize))\" height=\"\(3 * positionSize)\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(posX - 3 + 3 * (1 - positionSize)/2.0)\" y=\"\(posY - 9 + 3 * (1 - positionSize)/2.0)\"/>");
                        id += 1
                        pointList.append("<rect opacity=\"\(positionAlpha)\" width=\"\(9 - 3 * (1 - positionSize))\" height=\"\(3 * positionSize)\" key=\"\(id)\" fill=\"\(positionColor)\" x=\"\(posX - 3 + 3 * (1 - positionSize)/2.0)\" y=\"\(posY + 9 + 3 * (1 - positionSize)/2.0)\"/>");
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posOther {
                    continue
                } else {
                    if (qrcode.model.isDark(x, y)) {
                        pointList.append("<use key=\"\(id)\" xlink:href=\"#S-black\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                        id += 1
                    }
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
        
        let iconSize: CGFloat = nCount.cgFloat * scale * 3
        let iconXY: CGFloat = (nCount.cgFloat * 3 - iconSize) / 2
        
        let bdColor: String = try icon.borderColor.hexString()
        let bdAlpha: CGFloat = max(0, try icon.borderColor.alpha())
        
        let randomIdDefs: String = "res\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        let randomIdClips: String = "res\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        
        pointList.append("<path d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(bdColor)\" stroke-width=\"\(100 / iconSize * 3)\" fill=\"\(bdColor)\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\"/>")
        pointList.append("<g key=\"\(id)\">")
        id += 1
        
        let iconOffset: CGFloat = iconXY * 0.024
        let rectXY: CGFloat = iconXY - iconOffset
        let length: CGFloat = iconSize + 2.0 * iconOffset
        let iconRect: CGRect = CGRect(x: rectXY, y: rectXY, width: length, height: length)
        pointList.append(
            "<defs><path id=\"\(randomIdDefs)\" d=\"\(EFQRCodeStyleBasic.sq25)\" fill=\"\(bdColor)\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\"/></defs>"
            + "<clipPath id=\"\(randomIdClips)\">"
            + "<use xlink:href=\"#\(randomIdDefs)\" overflow=\"visible\"/>"
            + "</clipPath>"
            + "<g clip-path=\"url(#\(randomIdClips))\">"
            + (try icon.image.write(id: id, rect: iconRect, opacity: opacity))
            + "</g>"
            + "</g>"
        )
        id += 1
        return pointList
    }
    
    func writeResImage(image: EFStyleResampleImageParamsImage?, newWidth: Int, newHeight: Int, color: String) throws -> String {
        guard let image = image else { return "" }
        
        let contrast: CGFloat = image.contrast
        let exposure: CGFloat = image.exposure
        switch image.image {
        case .static(let image):
            return try image.getGrayPointList(newWidth: newWidth, newHeight: newHeight, contrast: contrast, exposure: exposure, color: color).joined()
        case .animated(let images, let duration):
            let resFrames: [[String]] = try images.map { try $0.getGrayPointList(newWidth: newWidth, newHeight: newHeight, contrast: contrast, exposure: exposure, color: color) }
            if resFrames.isEmpty { return "" }
            let defs = resFrames.enumerated().map { (index, resFrame) -> String in
                "<g id=\"resfm\(index + 1)\">\(resFrame.joined())</g>"
            }.joined()
            let useValues = (1...resFrames.count).map { "#resfm\($0)" }.joined(separator: ";")
            let svg = "<g><defs>\(defs)</defs><use xlink:href=\"#resfm\"><animate attributeName=\"xlink:href\" values=\"\(useValues)\" dur=\"\(duration)s\" repeatCount=\"indefinite\"/></use></g>"
            return svg
        }
    }
    
    override func viewBox(qrcode: QRCode) -> String {
        let nCount = qrcode.model.moduleCount * 3
        return "\(-nCount.cgFloat / 5) \(-nCount.cgFloat / 5) \(nCount.cgFloat + nCount.cgFloat / 5 * 2) \(nCount.cgFloat + nCount.cgFloat / 5 * 2)"
    }
    
    override func generateSVG(qrcode: QRCode) throws -> String {
        let alignType: EFStyleResampleImageParamAlignStyle = params.align.style
        let alignColor: String = try params.align.color.hexString()
        let alignAlpha: CGFloat = try params.align.color.alpha()
        let alignSize: CGFloat = params.align.size
        let timingType: EFStyleResampleImageParamTimingStyle = params.timing.style
        let timingColor: String = try params.timing.color.hexString()
        let timingAlpha: CGFloat = try params.timing.color.alpha()
        let timingSize: CGFloat = params.timing.size
        let otherOpacity: CGFloat = max(0, try params.dataColor.alpha())
        let otherColor: String = try params.dataColor.hexString()
        let size: Int = qrcode.model.moduleCount
        
        let alignElement: String = {
            switch alignType {
            case .none:
                return "<rect opacity=\"\(alignAlpha)\" id=\"B-align-black\" fill=\"\(alignColor)\" width=\"\(1.02 * alignSize)\" height=\"\(1.02 * alignSize)\"/>"
            case .rectangle:
                return "<rect opacity=\"\(alignAlpha)\" id=\"B-align-black\" fill=\"\(alignColor)\" width=\"\(3.02 * alignSize)\" height=\"\(3.02 * alignSize)\"/>"
            case .round:
                let roundR: CGFloat = 3.02 * alignSize / 2
                return "<circle opacity=\"\(alignAlpha)\" id=\"B-align-black\" fill=\"\(alignColor)\" cx=\"\(roundR)\" cy=\"\(roundR)\" r=\"\(roundR)\"/>"
            case .roundedRectangle:
                let cd: CGFloat = 3.02 * alignSize / 4.0
                return "<rect opacity=\"\(alignAlpha)\" id=\"B-align-black\" fill=\"\(alignColor)\" width=\"\(3.02 * alignSize)\" height=\"\(3.02 * alignSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>"
            }
        }()
        let timingElement: String = {
            switch timingType {
            case .none:
                return "<rect opacity=\"\(timingAlpha)\" id=\"B-timing-black\" fill=\"\(timingColor)\" width=\"\(1.02 * timingSize)\" height=\"\(1.02 * timingSize)\"/>"
            case .rectangle:
                return "<rect opacity=\"\(timingAlpha)\" id=\"B-timing-black\" fill=\"\(timingColor)\" width=\"\(3.02 * timingSize)\" height=\"\(3.02 * timingSize)\"/>"
            case .round:
                let roundR: CGFloat = 3.02 * timingSize / 2.0
                return "<circle opacity=\"\(timingAlpha)\" id=\"B-timing-black\" fill=\"\(timingColor)\" cx=\"\(roundR)\" cy=\"\(roundR)\" r=\"\(roundR)\"/>"
            case .roundedRectangle:
                let cd: CGFloat = 3.02 * timingSize / 4.0
                return "<rect opacity=\"\(timingAlpha)\" id=\"B-timing-black\" fill=\"\(timingColor)\" width=\"\(3.02 * timingSize)\" height=\"\(3.02 * timingSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>"
            }
        }()
        
        return "<svg className=\"Qr-item-svg\" width=\"100%\" height=\"100%\" viewBox=\"\(viewBox(qrcode: qrcode))\" fill=\"white\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"
        + "<defs>"
        + alignElement
        + "<rect opacity=\"\(alignAlpha)\" id=\"S-align-black\" fill=\"\(alignColor)\" width=\"\(1.02 * alignSize)\" height=\"\(1.02 * alignSize)\"/>"
        + timingElement
        + "<rect opacity=\"\(timingAlpha)\" id=\"S-timing-black\" fill=\"\(timingColor)\" width=\"\(1.02 * timingSize)\" height=\"\(1.02 * timingSize)\"/>"
        + "<rect opacity=\"\(otherOpacity)\" id=\"B-black\" fill=\"\(otherColor)\" width=\"3.02\" height=\"3.02\"/>"
        + "<rect opacity=\"\(otherOpacity)\" id=\"S-black\" fill=\"\(otherColor)\" width=\"1.02\" height=\"1.02\"/>"
        + "<rect id=\"B-white\" fill=\"white\" width=\"3.02\" height=\"3.02\"/>"
        + "<rect id=\"S-white\" fill=\"white\" width=\"1.02\" height=\"1.02\"/>"
        + "</defs>"
        + (try writeResImage(image: params.image, newWidth: size * 3, newHeight: size * 3, color: "#S-black"))
        + (try writeQRCode(qrcode: qrcode)).joined()
        + (try writeIcon(qrcode: qrcode)).joined()
        + "</svg>"
    }
}

extension CGImage {
    
    // red, green, blue: [0, 255]
    // alpha: [0, 1]
    // return: [0, 255]
    func gamma(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> CGFloat {
        let gray: CGFloat = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        let weightedGray: CGFloat = gray * alpha + (1 - alpha) * 255.0
        return weightedGray
    }
    
    func getGrayPointList(newWidth: Int, newHeight: Int, contrast: CGFloat = 0, exposure: CGFloat = 0, color: String) throws -> [String] {
        let dataSize = newWidth * newHeight * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: &pixelData,
            width: newWidth,
            height: newHeight,
            bitsPerComponent: 8,
            bytesPerRow: 4 * newWidth,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw EFQRCodeError.cannotCreateCGContext
        }
        
        context.draw(self, in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        var gpl: [String] = []
        for x in 0 ..< newWidth {
            for y in 0 ..< newHeight {
                let offset = 4 * (x + y * newWidth)
                // RGBA
                let alpha: CGFloat = CGFloat(pixelData[offset + 3]) / 255.0
                let red: CGFloat = pixelData[offset + 0].cgFloat
                let green: CGFloat = pixelData[offset + 1].cgFloat
                let blue: CGFloat = pixelData[offset + 2].cgFloat
                
                let gray: CGFloat = gamma(red, green, blue, alpha)
                if Double.random(in: 0..<1) > ((gray / 255.0) + exposure - 0.5) * (contrast + 1) + 0.5 && (x % 3 != 1 || y % 3 != 1) {
                    gpl.append("<use key=\"g_\(x)_\(y)\" x=\"\(x)\" y=\"\(y)\" xlink:href=\"\(color)\"/>")
                }
            }
        }
        return gpl
    }
}
