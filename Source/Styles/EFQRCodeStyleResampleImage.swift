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
    
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    public static let defaultAlign: EFStyleResampleImageParamsAlign = EFStyleResampleImageParamsAlign()
    public static let defaultTiming: EFStyleResampleImageParamsTiming = EFStyleResampleImageParamsTiming()
    public static let defaultPosition: EFStyleResampleImageParamsPosition = EFStyleResampleImageParamsPosition()
    public static let defaultDataColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    let image: EFStyleResampleImageParamsImage?
    let align: EFStyleResampleImageParamsAlign
    let timing: EFStyleResampleImageParamsTiming
    let position: EFStyleResampleImageParamsPosition
    let dataColor: CGColor
    
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleResampleImageParams.defaultBackdrop,
        image: EFStyleResampleImageParamsImage?,
        align: EFStyleResampleImageParamsAlign = EFStyleResampleImageParams.defaultAlign,
        timing: EFStyleResampleImageParamsTiming = EFStyleResampleImageParams.defaultTiming,
        position: EFStyleResampleImageParamsPosition = EFStyleResampleImageParams.defaultPosition,
        dataColor: CGColor = EFStyleResampleImageParams.defaultDataColor
    ) {
        self.image = image
        self.align = align
        self.timing = timing
        self.position = position
        self.dataColor = dataColor
        super.init(icon: icon, backdrop: backdrop)
    }
    
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        image: EFStyleResampleImageParamsImage? = nil,
        align: EFStyleResampleImageParamsAlign? = nil,
        timing: EFStyleResampleImageParamsTiming? = nil,
        position: EFStyleResampleImageParamsPosition? = nil,
        dataColor: CGColor? = nil
    ) -> EFStyleResampleImageParams {
        return EFStyleResampleImageParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            image: image ?? self.image,
            align: align ?? self.align,
            timing: timing ?? self.timing,
            position: position ?? self.position,
            dataColor: dataColor ?? self.dataColor
        )
    }
}

public enum EFStyleResampleImageParamAlignStyle: CaseIterable {
    case none
    case rectangle
    case round
    case roundedRectangle
}

public class EFStyleResampleImageParamsAlign {
    
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    let style: EFStyleResampleImageParamAlignStyle
    let onlyWhite: Bool
    let size: CGFloat
    let color: CGColor
    
    public init(
        style: EFStyleResampleImageParamAlignStyle = .rectangle,
        onlyWhite: Bool = false,
        size: CGFloat = 1,
        color: CGColor = EFStyleResampleImageParamsAlign.defaultColor
    ) {
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
    
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    let style: EFStyleResampleImageParamTimingStyle
    let onlyWhite: Bool
    let size: CGFloat
    let color: CGColor
    
    public init(
        style: EFStyleResampleImageParamTimingStyle = .rectangle,
        onlyWhite: Bool = false,
        size: CGFloat = 1,
        color: CGColor = EFStyleResampleImageParamsTiming.defaultColor
    ) {
        self.style = style
        self.onlyWhite = onlyWhite
        self.size = size
        self.color = color
    }
}

public class EFStyleResampleImageParamsPosition {
    
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x000000)!
    
    let style: EFStyleParamsPositionStyle
    let size: CGFloat
    let color: CGColor
    
    public init(
        style: EFStyleParamsPositionStyle = .rectangle,
        size: CGFloat = 1,
        color: CGColor = EFStyleResampleImageParamsPosition.defaultColor
    ) {
        self.style = style
        self.size = size
        self.color = color
    }
}

public class EFStyleResampleImageParamsImage {
    let image: EFStyleParamImage
    let mode: EFImageMode
    let contrast: CGFloat
    let exposure: CGFloat
    
    public init(
        image: EFStyleParamImage,
        mode: EFImageMode = .scaleAspectFill,
        contrast: CGFloat = 0,
        exposure: CGFloat = 0
    ) {
        self.image = image
        self.mode = mode
        self.contrast = contrast
        self.exposure = exposure
    }
    
    func copyWith(
        image: EFStyleParamImage? = nil,
        mode: EFImageMode? = nil,
        contrast: CGFloat? = nil,
        exposure: CGFloat? = nil
    ) -> EFStyleResampleImageParamsImage {
        return EFStyleResampleImageParamsImage(
            image: image ?? self.image,
            mode: mode ?? self.mode,
            contrast: contrast ?? self.contrast,
            exposure: exposure ?? self.exposure
        )
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
                let isDark: Bool = qrcode.model.isDark(x, y)
                let posX: CGFloat = 3 * x.cgFloat
                let posY: CGFloat = 3 * y.cgFloat
                if typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther {
                    if isDark {
                        if alignType != .none && alignOnlyWhite == false {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Bab\" x=\"\(posX - 0.01)\" y=\"\(posY - 0.01)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Sab\" x=\"\(posX + 1 - 0.01)\" y=\"\(posY + 1 - 0.01)\"/>")
                            id += 1
                        }
                    } else {
                        if alignType == .none {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Sw\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Bw\" x=\"\(posX - 0.01)\" y=\"\(posY - 0.01)\"/>")
                            id += 1
                        }
                    }
                } else if typeTable[x][y] == QRPointType.timing {
                    if isDark {
                        if timingType != .none && timingOnlyWhite == false {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Btb\" x=\"\(posX - 0.01)\" y=\"\(posY - 0.01)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Stb\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        }
                    } else {
                        if timingType == .none {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Sw\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
                            id += 1
                        } else {
                            pointList.append("<use key=\"\(id)\" xlink:href=\"#Bw\" x=\"\(posX - 0.01)\" y=\"\(posY - 0.01)\"/>")
                            id += 1
                        }
                    }
                } else if typeTable[x][y] == QRPointType.posCenter {
                    let markArr: [CGFloat] = {
                        if x > y {
                            return [0, -3]
                        } else if x < y {
                            return [-3, 0]
                        }
                        return [-3, -3]
                    }()
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"24\" height=\"24\" fill=\"#FFFFFF\" x=\"\(posX - 12 - markArr[0])\" y=\"\(posY - 12 - markArr[1])\"/>");
                    id += 1
                    switch positionType {
                    case .rectangle:
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"9\" height=\"9\" fill=\"\(positionColor)\" x=\"\(posX - 3)\" y=\"\(posY - 3)\"/>");
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"none\" stroke-width=\"\(3 * positionSize)\" stroke=\"\(positionColor)\" x=\"\(posX - 7.5)\" y=\"\(posY - 7.5)\" width=\"18\" height=\"18\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"4.5\"/>")
                        id += 1
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"none\" stroke-width=\"\(3 * positionSize)\" stroke=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"9\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"4.5\"/>")
                        id += 1
                        pointList.append("<path key=\"\(id)\" opacity=\"\(positionAlpha)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(positionColor)\" stroke-width=\"\(100.cgFloat / 6 * positionSize)\" fill=\"none\" transform=\"translate(\(posX - 7.5),\(posY - 7.5)) scale(\(18.cgFloat / 100),\(18.cgFloat / 100))\"/>")
                        id += 1
                        break
                    case .planets:
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"4.5\"/>")
                        id += 1
                        pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"none\" stroke-width=\"0.45\" stroke-dasharray=\"1.5,1.5\" stroke=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 1.5)\" r=\"9\"/>")
                        id += 1
                        for w in 0..<EFQRCodeStyleBasic.planetsVw.count {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(posX + 3 * EFQRCodeStyleBasic.planetsVw[w] + 1.5)\" cy=\"\(posY + 1.5)\" r=\"\(1.5 * positionSize)\"/>")
                            id += 1
                        }
                        for h in 0..<EFQRCodeStyleBasic.planetsVh.count {
                            pointList.append("<circle key=\"\(id)\" opacity=\"\(positionAlpha)\" fill=\"\(positionColor)\" cx=\"\(posX + 1.5)\" cy=\"\(posY + 3 * EFQRCodeStyleBasic.planetsVh[h] + 1.5)\" r=\"\(1.5 * positionSize)\"/>")
                            id += 1
                        }
                        break
                    case .dsj:
                        let widthValue: CGFloat = (3.0 - (1.0 - positionSize)) * 3
                        let xTempValue: CGFloat = (x.cgFloat + (1.0 - positionSize) / 2.0) * 3
                        let yTempValue: CGFloat = (y.cgFloat + (1.0 - positionSize) / 2.0) * 3
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 3)\" y=\"\(yTempValue - 3)\"/>");
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(3 * positionSize)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 9)\" y=\"\(yTempValue - 3)\"/>");
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(3 * positionSize)\" height=\"\(widthValue)\" fill=\"\(positionColor)\" x=\"\(xTempValue + 9)\" y=\"\(yTempValue - 3)\"/>");
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(3 * positionSize)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 3)\" y=\"\(yTempValue - 9)\"/>");
                        id += 1
                        pointList.append("<rect key=\"\(id)\" opacity=\"\(positionAlpha)\" width=\"\(widthValue)\" height=\"\(3 * positionSize)\" fill=\"\(positionColor)\" x=\"\(xTempValue - 3)\" y=\"\(yTempValue + 9)\"/>");
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posOther {
                    continue
                } else {
                    if isDark {
                        pointList.append("<use key=\"\(id)\" xlink:href=\"#Sb\" x=\"\(posX + 1)\" y=\"\(posY + 1)\"/>")
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
        
        pointList.append("<path opacity=\"\(bdAlpha)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(bdColor)\" stroke-width=\"\(100 / iconSize * 3)\" fill=\"\(bdColor)\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\"/>")
        pointList.append("<g key=\"g\(id)\">")
        id += 1
        
        let iconOffset: CGFloat = iconXY * 0.024
        let rectXY: CGFloat = iconXY - iconOffset
        let length: CGFloat = iconSize + 2.0 * iconOffset
        let iconRect: CGRect = CGRect(x: rectXY, y: rectXY, width: length, height: length)
        pointList.append(
            "<defs><path id=\"\(randomIdDefs)\" d=\"\(EFQRCodeStyleBasic.sq25)\"/>"
            + "<mask id=\"\(randomIdClips)\">"
            + "<use xlink:href=\"#\(randomIdDefs)\" overflow=\"visible\" fill=\"#ffffff\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\"/>"
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
    
    func writeResImage(image: EFStyleResampleImageParamsImage?, newWidth: Int, newHeight: Int, color: String) throws -> String {
        guard let image = image else { return "" }
        
        let contrast: CGFloat = image.contrast
        let exposure: CGFloat = image.exposure
        let mode: EFImageMode = image.mode
        switch image.image {
        case .static(let image):
            let imageCliped: CGImage = try mode.imageForContent(ofImage: image, inCanvasOfRatio: CGSize(width: newWidth, height: newHeight))
            return try imageCliped.getGrayPointList(newWidth: newWidth, newHeight: newHeight, contrast: contrast, exposure: exposure, color: color).joined()
        case .animated(let images, let imageDelays):
            let resFrames: [String] = try images.map {
                let imageCliped: CGImage = try mode.imageForContent(ofImage: $0, inCanvasOfRatio: CGSize(width: newWidth, height: newHeight))
                return try imageCliped.getGrayPointList(newWidth: newWidth, newHeight: newHeight, contrast: contrast, exposure: exposure, color: color).joined()
            }
            if resFrames.isEmpty { return "" }
            let framePrefix: String = "resfm"
            let defs = resFrames.enumerated().map { (index, resFrame) -> String in
                "<g id=\"\(framePrefix)\(index)\">\(resFrame)</g>"
            }.joined()
            let totalDuration: CGFloat = imageDelays.reduce(0, +)
            let keyTimes: [CGFloat] = imageDelays.reduce(into: [0]) { result, delay in
                result.append((result.last ?? 0) + delay / totalDuration)
            }
            let use = """
            <use xlink:href="#\(framePrefix)0">
                <animate
                    attributeName="xlink:href"
                    values="\(resFrames.indices.map { "#\(framePrefix)\($0)" }.joined(separator: ";"))"
                    keyTimes="\(keyTimes.dropLast().map { String(format: "%.3f", $0) }.joined(separator: ";"))"
                    dur="\(totalDuration)s"
                    repeatCount="indefinite"
                    calcMode="discrete"
                />
            </use>
            """
            let svg = "<g><defs>\(defs)</defs>\(use)</g>"
            return svg
        }
    }
    
    override func viewBox(qrcode: QRCode) -> CGRect {
        let moduleCount: CGFloat = qrcode.model.moduleCount.cgFloat * 3.0
        if let quietzone = params.backdrop.quietzone {
            return CGRect(
                x: -moduleCount.cgFloat * quietzone.left,
                y: -moduleCount.cgFloat * quietzone.top,
                width: moduleCount.cgFloat * (quietzone.left + 1 + quietzone.right),
                height: moduleCount.cgFloat * (quietzone.top + 1 + quietzone.bottom)
            )
        }
        return CGRect(x: -3.0, y: -3.0, width: moduleCount + 6.0, height: moduleCount + 6.0)
    }
    
    override func generateSVG(qrcode: QRCode) throws -> String {
        let viewBoxRect: CGRect = viewBox(qrcode: qrcode)
        let (part1, part2) = try params.backdrop.generateSVG(qrcode: qrcode, viewBoxRect: viewBoxRect)
        return part1
        + (try customSVG(qrcode: qrcode))
        + part2
    }
    
    func customSVG(qrcode: QRCode) throws -> String {
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
            // Bab is short for Big-align-black
            switch alignType {
            case .none:
                return "<rect id=\"Bab\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" width=\"\(1.02 * alignSize)\" height=\"\(1.02 * alignSize)\"/>"
            case .rectangle:
                return "<rect id=\"Bab\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" width=\"\(3.02 * alignSize)\" height=\"\(3.02 * alignSize)\"/>"
            case .round:
                let roundR: CGFloat = 3.02 * alignSize / 2
                return "<circle id=\"Bab\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" cx=\"\(roundR)\" cy=\"\(roundR)\" r=\"\(roundR)\"/>"
            case .roundedRectangle:
                let cd: CGFloat = 3.02 * alignSize / 4.0
                return "<rect id=\"Bab\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" width=\"\(3.02 * alignSize)\" height=\"\(3.02 * alignSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>"
            }
        }()
        let timingElement: String = {
            // Btb is short for Big-timing-black
            switch timingType {
            case .none:
                return "<rect id=\"Btb\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" width=\"\(1.02 * timingSize)\" height=\"\(1.02 * timingSize)\"/>"
            case .rectangle:
                return "<rect id=\"Btb\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" width=\"\(3.02 * timingSize)\" height=\"\(3.02 * timingSize)\"/>"
            case .round:
                let roundR: CGFloat = 3.02 * timingSize / 2.0
                return "<circle id=\"Btb\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" cx=\"\(roundR)\" cy=\"\(roundR)\" r=\"\(roundR)\"/>"
            case .roundedRectangle:
                let cd: CGFloat = 3.02 * timingSize / 4.0
                return "<rect id=\"Btb\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" width=\"\(3.02 * timingSize)\" height=\"\(3.02 * timingSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>"
            }
        }()
        
        // Sab is short for Small-align-black
        // Stb is short for Small-timing-black
        // Bb is short for Big-black
        // Sb is short for Small-black
        // Bw is short for Big-white
        // Sw is short for Small-white
        return "<defs>"
        + alignElement
        + "<rect id=\"Sab\" opacity=\"\(alignAlpha)\" fill=\"\(alignColor)\" width=\"\(1.02 * alignSize)\" height=\"\(1.02 * alignSize)\"/>"
        + timingElement
        + "<rect id=\"Stb\" opacity=\"\(timingAlpha)\" fill=\"\(timingColor)\" width=\"\(1.02 * timingSize)\" height=\"\(1.02 * timingSize)\"/>"
        + "<rect id=\"Bb\" opacity=\"\(otherOpacity)\" fill=\"\(otherColor)\" width=\"3.02\" height=\"3.02\"/>"
        + "<rect id=\"Sb\" opacity=\"\(otherOpacity)\" fill=\"\(otherColor)\" width=\"1.02\" height=\"1.02\"/>"
        + "<rect id=\"Bw\" fill=\"white\" width=\"3.02\" height=\"3.02\"/>"
        + "<rect id=\"Sw\" fill=\"white\" width=\"1.02\" height=\"1.02\"/>"
        + "</defs>"
        + (try writeResImage(image: params.image, newWidth: size * 3, newHeight: size * 3, color: "#Sb"))
        + (try writeQRCode(qrcode: qrcode)).joined()
        + (try writeIcon(qrcode: qrcode)).joined()
    }
    
    override func copyWith(
        iconImage: EFStyleParamImage? = nil,
        watermarkImage: EFStyleParamImage? = nil
    ) -> EFQRCodeStyleBase {
        let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
        let image: EFStyleResampleImageParamsImage? = params.image?.copyWith(image: watermarkImage)
        return EFQRCodeStyleResampleImage(params: params.copyWith(icon: icon, image: image))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, params.image?.image)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.resampleImage(params: self.params)
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
                let offset: Int = 4 * (x + y * newWidth)
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
