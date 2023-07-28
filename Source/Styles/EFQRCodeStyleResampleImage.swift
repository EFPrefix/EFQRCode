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
    let image: EFStyleResampleImageParamsImage?
    let alignStyle: EFStyleResampleImageParamAlignStyle
    let timingStyle: EFStyleResampleImageParamTimingStyle
    let positionColor: CGColor
    let dataColor: CGColor
    
    public init(icon: EFStyleParamIcon? = nil, image: EFStyleResampleImageParamsImage? = nil, alignStyle: EFStyleResampleImageParamAlignStyle, timingStyle: EFStyleResampleImageParamTimingStyle, positionColor: CGColor, dataColor: CGColor) {
        self.image = image
        self.alignStyle = alignStyle
        self.timingStyle = timingStyle
        self.positionColor = positionColor
        self.dataColor = dataColor
        super.init(icon: icon)
    }
}

public enum EFStyleResampleImageParamAlignStyle: CaseIterable {
    case none
    case white
    case whiteAndBlack
}

public enum EFStyleResampleImageParamTimingStyle: CaseIterable {
    case none
    case white
    case whiteAndBlack
}

public class EFStyleResampleImageParamsImage {
    let image: EFStyleParamImage
    let contrast: CGFloat
    let exposure: CGFloat
    
    public init(image: EFStyleParamImage, contrast: CGFloat, exposure: CGFloat) {
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
        let alignType: EFStyleResampleImageParamAlignStyle = params.alignStyle
        let timingType: EFStyleResampleImageParamTimingStyle = params.timingStyle
        let posColor: String = try params.positionColor.hexString()
        var id: Int = 0
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                let posX: CGFloat = 3 * x.cgFloat
                let posY: CGFloat = 3 * y.cgFloat
                if typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther {
                    if (qrcode.model.isDark(x, y)) {
                        if alignType == .whiteAndBlack {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#B-black\" x=\"\(posX - 0.03)\" y=\"\(posY - 0.03)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#S-black\" x=\"\(posX + 1 - 0.01)\" y=\"\(posY + 1 - 0.01)\"/>")
                            id += 1
                        }
                    } else {
                        if alignType == .none {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#S-white\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#B-white\" x=\"\(posX - 0.03)\" y=\"\(posY - 0.03)\"/>")
                            id += 1
                        }
                    }
                } else if typeTable[x][y] == QRPointType.timing {
                    if (qrcode.model.isDark(x, y)) {
                        if timingType == .whiteAndBlack {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#B-black\" x=\"\(posX - 0.03)\" y=\"\(posY - 0.03)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#S-black\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        }
                    } else {
                        if timingType == .none {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#S-white\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#B-white\" x=\"\(posX - 0.03)\" y=\"\(posY - 0.03)\"/>")
                            id += 1
                        }
                    }
                } else if typeTable[x][y] == QRPointType.posCenter {
                    if (qrcode.model.isDark(x, y)) {
                        pointList.append("<use key=\"\(id)\" fill=\"\(posColor)\" xlink:href=\"#B\" x=\"\(posX - 0.03)\" y=\"\(posY - 0.03)\"/>")
                        id += 1
                    }
                } else if typeTable[x][y] == QRPointType.posOther {
                    if (qrcode.model.isDark(x, y)) {
                        pointList.append("<use key=\"\(id)\" fill=\"\(posColor)\" xlink:href=\"#B\" x=\"\(posX - 0.03)\" y=\"\(posY - 0.03)\"/>")
                        id += 1
                    } else {
                        pointList.append("<use key=\"\(id)\" xlink:href=\"#B-white\" x=\"\(posX - 0.03)\" y=\"\(posY - 0.03)\"/>")
                        id += 1
                    }
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
        guard let icon = params.icon else { return [] }
        
        var id: Int = 0
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        
        let scale: CGFloat = min(icon.percentage, 0.33)
        let opacity: CGFloat = max(0, icon.alpha)
        
        let iconSize: CGFloat = nCount.cgFloat * scale * 3
        let iconXY: CGFloat = (nCount.cgFloat * 3 - iconSize) / 2
        
        let randomIdDefs: String = EFStyleParamIcon.getIdNum()
        let randomIdClips: String = EFStyleParamIcon.getIdNum()
        
        pointList.append("<path d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"#FFF\" stroke-width=\"\(100 / iconSize * 3)\" fill=\"#FFF\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\" />")
        pointList.append("<g key=\"\(id)\">")
        id += 1
        pointList.append(
            "<defs><path id=\"defs-path\(randomIdDefs)\" d=\"\(EFQRCodeStyleBasic.sq25)\" fill=\"#FFF\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\" /></defs>"
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
            let svg = "<g><defs>\(defs)</defs><use xlink:href=\"#resfm\"><animate attributeName=\"xlink:href\" values=\"\(useValues)\" dur=\"\(duration)s\" repeatCount=\"indefinite\" /></use></g>"
            return svg
        }
    }
    
    override func viewBox(qrcode: QRCode) -> String {
        let nCount = qrcode.model.moduleCount * 3
        return "\(-nCount.cgFloat / 5) \(-nCount.cgFloat / 5) \(nCount.cgFloat + nCount.cgFloat / 5 * 2) \(nCount.cgFloat + nCount.cgFloat / 5 * 2)"
    }
    
    override func generateSVG(qrcode: QRCode) throws -> String {
        let otherOpacity: CGFloat = max(0, try params.dataColor.alpha())
        let otherColor: String = try params.dataColor.hexString()
        let size: Int = qrcode.model.moduleCount
        return "<svg className=\"Qr-item-svg\" width=\"100%\" height=\"100%\" viewBox=\"\(viewBox(qrcode: qrcode))\" fill=\"white\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"
        + "<defs>"
        + "<rect opacity=\"\(otherOpacity)\" id=\"B-black\" fill=\"\(otherColor)\" width=\"3.08\" height=\"3.08\"/>"
        + "<rect id=\"B-white\" fill=\"white\" width=\"3.08\" height=\"3.08\"/>"
        + "<rect opacity=\"\(otherOpacity)\" id=\"S-black\" fill=\"\(otherColor)\" width=\"1.02\" height=\"1.02\"/>"
        + "<rect id=\"S-white\" fill=\"white\" width=\"1.02\" height=\"1.02\"/>"
        + "<rect id=\"B\" width=\"3.08\" height=\"3.08\"/>"
        + "<rect id=\"S\" width=\"1.02\" height=\"1.02\"/>"
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
                    gpl.append("<use key=\"g_\(x)_\(y)\" x=\"\(x)\" y=\"\(y)\" xlink:href=\"\(color)\" />")
                }
            }
        }
        return gpl
    }
}
