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

    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    public static let defaultAlign: EFStyleImageParamsAlign = EFStyleImageParamsAlign()
    public static let defaultTiming: EFStyleImageParamsTiming = EFStyleImageParamsTiming()
    public static let defaultData: EFStyleImageParamsData = EFStyleImageParamsData()
    public static let defaultPosition: EFStyleImageParamsPosition = EFStyleImageParamsPosition()
    
    let align: EFStyleImageParamsAlign
    let timing: EFStyleImageParamsTiming
    let position: EFStyleImageParamsPosition
    let data: EFStyleImageParamsData
    let image: EFStyleImageParamsImage?
    
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleImageParams.defaultBackdrop,
        align: EFStyleImageParamsAlign = EFStyleImageParams.defaultAlign,
        timing: EFStyleImageParamsTiming = EFStyleImageParams.defaultTiming,
        position: EFStyleImageParamsPosition = EFStyleImageParams.defaultPosition,
        data: EFStyleImageParamsData = EFStyleImageParams.defaultData,
        image: EFStyleImageParamsImage?
    ) {
        self.align = align
        self.timing = timing
        self.position = position
        self.data = data
        self.image = image
        super.init(icon: icon, backdrop: backdrop)
    }
    
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        align: EFStyleImageParamsAlign? = nil,
        timing: EFStyleImageParamsTiming? = nil,
        position: EFStyleImageParamsPosition? = nil,
        data: EFStyleImageParamsData? = nil,
        image: EFStyleImageParamsImage? = nil
    ) -> EFStyleImageParams {
        return EFStyleImageParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            align: align ?? self.align,
            timing: timing ?? self.timing,
            position: position ?? self.position,
            data: data ?? self.data,
            image: image ?? self.image
        )
    }
}

public enum EFStyleImageParamAlignStyle: CaseIterable {
    case none
    case rectangle
    case round
    case roundedRectangle
}

public class EFStyleImageParamsAlign {
    
    public static let defaultColorDark: CGColor = CGColor.createWith(rgb: 0x000000)!
    public static let defaultColorLight: CGColor = CGColor.createWith(rgb: 0xffffff)!
    
    let style: EFStyleImageParamAlignStyle
    let size: CGFloat
    let colorDark: CGColor
    let colorLight: CGColor
    
    public init(
        style: EFStyleImageParamAlignStyle = .rectangle,
        size: CGFloat = 1,
        colorDark: CGColor = EFStyleImageParamsAlign.defaultColorDark,
        colorLight: CGColor = EFStyleImageParamsAlign.defaultColorLight
    ) {
        self.style = style
        self.size = size
        self.colorDark = colorDark
        self.colorLight = colorLight
    }
}

public enum EFStyleImageParamTimingStyle: CaseIterable {
    case none
    case rectangle
    case round
    case roundedRectangle
}

public class EFStyleImageParamsTiming {
    
    public static let defaultColorDark: CGColor = CGColor.createWith(rgb: 0x000000)!
    public static let defaultColorLight: CGColor = CGColor.createWith(rgb: 0xffffff)!
    
    let style: EFStyleImageParamTimingStyle
    let size: CGFloat
    let colorDark: CGColor
    let colorLight: CGColor
    
    public init(
        style: EFStyleImageParamTimingStyle = .rectangle,
        size: CGFloat = 1,
        colorDark: CGColor = EFStyleImageParamsTiming.defaultColorDark,
        colorLight: CGColor = EFStyleImageParamsTiming.defaultColorLight
    ) {
        self.style = style
        self.size = size
        self.colorDark = colorDark
        self.colorLight = colorLight
    }
}

public class EFStyleImageParamsImage {
    
    let image: EFStyleParamImage
    let mode: EFImageMode
    let alpha: CGFloat
    
    public init(
        image: EFStyleParamImage,
        mode: EFImageMode = .scaleAspectFill,
        alpha: CGFloat = 1
    ) {
        self.image = image
        self.mode = mode
        self.alpha = alpha
    }
    
    func copyWith(
        image: EFStyleParamImage? = nil,
        mode: EFImageMode? = nil,
        alpha: CGFloat? = nil
    ) -> EFStyleImageParamsImage {
        return EFStyleImageParamsImage(
            image: image ?? self.image,
            mode: mode ?? self.mode,
            alpha: alpha ?? self.alpha
        )
    }
}

public class EFStyleImageParamsPosition {
    
    public static let defaultColorDark: CGColor = CGColor.createWith(rgb: 0x000000)!
    public static let defaultColorLight: CGColor = CGColor.createWith(rgb: 0xffffff)!
    
    let style: EFStyleParamsPositionStyle
    let size: CGFloat
    let colorDark: CGColor
    let colorLight: CGColor
    
    public init(
        style: EFStyleParamsPositionStyle = .rectangle,
        size: CGFloat = 1,
        colorDark: CGColor = EFStyleImageParamsPosition.defaultColorDark,
        colorLight: CGColor = EFStyleImageParamsPosition.defaultColorLight
    ) {
        self.style = style
        self.size = size
        self.colorDark = colorDark
        self.colorLight = colorLight
    }
}

public class EFStyleImageParamsData {
    
    public static let defaultColorDark: CGColor = CGColor.createWith(rgb: 0x000000)!
    public static let defaultColorLight: CGColor = CGColor.createWith(rgb: 0xffffff)!
    
    let style: EFStyleParamsDataStyle
    let scale: CGFloat // (0-1]
    let colorDark: CGColor
    let colorLight: CGColor
    
    public init(
        style: EFStyleParamsDataStyle = .rectangle,
        scale: CGFloat = 1,
        colorDark: CGColor = EFStyleImageParamsData.defaultColorDark,
        colorLight: CGColor = EFStyleImageParamsData.defaultColorLight
    ) {
        self.style = style
        self.scale = scale
        self.colorDark = colorDark
        self.colorLight = colorLight
    }
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
        
        let type: EFStyleParamsDataStyle = params.data.style
        let size: CGFloat = max(0, params.data.scale)
        let opacityDark: CGFloat = max(0, try params.data.colorDark.alpha())
        let opacityLight: CGFloat = max(0, try params.data.colorLight.alpha())
        let otherColorDark: String = try params.data.colorDark.hexString()
        let otherColorLight: String = try params.data.colorLight.hexString()
        
        let posType: EFStyleParamsPositionStyle = params.position.style
        let posDarkColor: String = try params.position.colorDark.hexString()
        let posDarkAlpha: CGFloat = try params.position.colorDark.alpha()
        let posLightColor: String = try params.position.colorLight.hexString()
        let posLightAlpha: CGFloat = try params.position.colorLight.alpha()
        let posSize: CGFloat = params.position.size
        
        let alignType: EFStyleImageParamAlignStyle = params.align.style
        let alignDarkColor: String = try params.align.colorDark.hexString()
        let alignDarkAlpha: CGFloat = try params.align.colorDark.alpha()
        let alignLightColor: String = try params.align.colorLight.hexString()
        let alignLightAlpha: CGFloat = try params.align.colorLight.alpha()
        let alignSize: CGFloat = params.align.size
        
        let timingType: EFStyleImageParamTimingStyle = params.timing.style
        let timingDarkColor: String = try params.timing.colorDark.hexString()
        let timingDarkAlpha: CGFloat = try params.timing.colorDark.alpha()
        let timingLightColor: String = try params.timing.colorLight.hexString()
        let timingLightAlpha: CGFloat = try params.timing.colorLight.alpha()
        let timingSize: CGFloat = params.timing.size
        
        var id: Int = 0
        
        var imageLineIndex: Int? = nil
        if let image = params.image {
            let line = try image.image.write(id: id, rect: CGRect(x: 0, y: 0, width: nCount, height: nCount), opacity: image.alpha, mode: image.mode)
            imageLineIndex = pointList.count
            pointList.append(line)
            id += 1
        }
        
        var imageMask: String = "<defs><mask id=\"hole\"><rect x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" fill=\"white\"/>"
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if alignType != .none && (typeTable[x][y] == QRPointType.alignCenter || typeTable[x][y] == QRPointType.alignOther) {
                    let thisAlignColor: String = isDark ? alignDarkColor : alignLightColor
                    let thisAlignAlpha: CGFloat = isDark ? alignDarkAlpha : alignLightAlpha
                    let kof: String = "key=\"\(id)\" opacity=\"\(thisAlignAlpha)\" fill=\"\(thisAlignColor)\" "
                    let alignLine: String = {
                        var newLine: String = ""
                        switch alignType {
                        case .none:
                            break
                        case .rectangle:
                            newLine = "<rect \(kof)width=\"\(alignSize)\" height=\"\(alignSize)\" x=\"\(x.cgFloat + (1 - alignSize) / 2)\" y=\"\(y.cgFloat + (1 - alignSize) / 2)\"/>"
                            id += 1
                            break
                        case .round:
                            newLine = "<circle \(kof)r=\"\(alignSize / 2)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>"
                            id += 1
                            break
                        case .roundedRectangle:
                            let cd: CGFloat = alignSize / 4.0
                            newLine = "<rect \(kof)x=\"\(x.cgFloat + (1 - alignSize) / 2)\" y=\"\(y.cgFloat + (1 - alignSize) / 2)\" width=\"\(alignSize)\" height=\"\(alignSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>"
                            id += 1
                            break
                        }
                        return newLine
                    }()
                    pointList.append(alignLine)
                    if let _ = imageLineIndex, !alignLine.isEmpty && !isDark {
                        imageMask += alignLine.replace(kof, with: "fill=\"black\" ")
                    }
                } else if timingType != .none && typeTable[x][y] == QRPointType.timing {
                    let thisTimingColor: String = isDark ? timingDarkColor : timingLightColor
                    let thisTimingAlpha: CGFloat = isDark ? timingDarkAlpha : timingLightAlpha
                    let kof: String = "key=\"\(id)\" opacity=\"\(thisTimingAlpha)\" fill=\"\(thisTimingColor)\" "
                    let timingLine: String = {
                        var newLine: String = ""
                        switch timingType {
                        case .none:
                            break
                        case .rectangle:
                            newLine += "<rect \(kof)width=\"\(timingSize)\" height=\"\(timingSize)\" x=\"\(x.cgFloat + (1 - timingSize) / 2)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\"/>"
                            id += 1
                            break
                        case .round:
                            newLine += "<circle \(kof)r=\"\(timingSize / 2)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>"
                            id += 1
                            break
                        case .roundedRectangle:
                            let cd: CGFloat = timingSize / 4.0
                            newLine += "<rect \(kof)x=\"\(x.cgFloat + (1 - timingSize) / 2)\" y=\"\(y.cgFloat + (1 - timingSize) / 2)\" width=\"\(timingSize)\" height=\"\(timingSize)\" rx=\"\(cd)\" ry=\"\(cd)\"/>"
                            id += 1
                            break
                        }
                        return newLine
                    }()
                    pointList.append(timingLine)
                    if let _ = imageLineIndex, !timingLine.isEmpty && !isDark {
                        imageMask += timingLine.replace(kof, with: "fill=\"black\" ")
                    }
                } else if typeTable[x][y] == QRPointType.posCenter {
                    let markArr: [CGFloat] = {
                        if x > y {
                            return [0, -1]
                        } else if x < y {
                            return [-1, 0]
                        }
                        return [-1, -1]
                    }()
                    let kof: String = "key=\"\(id)\" opacity=\"\(posLightAlpha)\" fill=\"\(posLightColor)\" "
                    let posBGLine: String = "<rect \(kof)width=\"8\" height=\"8\" x=\"\(x.cgFloat - 4 - markArr[0])\" y=\"\(y.cgFloat - 4 - markArr[1])\"/>"
                    pointList.append(posBGLine)
                    if let _ = imageLineIndex {
                        imageMask += posBGLine.replace(kof, with: "fill=\"black\" ")
                    }
                    id += 1
                    switch posType {
                    case .rectangle:
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"3\" height=\"3\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(x.cgFloat - 1)\" y=\"\(y.cgFloat - 1)\"/>")
                        id += 1
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"\(1 * posSize)\" stroke=\"\(posDarkColor)\" x=\"\(x.cgFloat - 2.5)\" y=\"\(y.cgFloat - 2.5)\" width=\"6\" height=\"6\"/>")
                        id += 1
                        break
                    case .round:
                        pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"\(1 * posSize)\" stroke=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\"/>")
                        id += 1
                        break
                    case .roundedRectangle:
                        pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<path opacity=\"\(posDarkAlpha)\" key=\"\(id)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(posDarkColor)\" stroke-width=\"\(100.cgFloat / 6 * posSize)\" fill=\"none\" transform=\"translate(\(x.cgFloat - 2.5),\(y.cgFloat - 2.5)) scale(\(6.cgFloat / 100),\(6.cgFloat / 100))\"/>")
                        id += 1
                        break
                    case .planets:
                        pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"1.5\"/>")
                        id += 1
                        pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"none\" stroke-width=\"0.15\" stroke-dasharray=\"0.5,0.5\" stroke=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"3\"/>")
                        id += 1
                        for w in 0..<EFQRCodeStyleBasic.planetsVw.count {
                            pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"\(posDarkColor)\" cx=\"\(x.cgFloat + EFQRCodeStyleBasic.planetsVw[w] + 0.5)\" cy=\"\(y.cgFloat + 0.5)\" r=\"\(0.5 * posSize)\"/>")
                            id += 1
                        }
                        for h in 0..<EFQRCodeStyleBasic.planetsVh.count {
                            pointList.append("<circle opacity=\"\(posDarkAlpha)\" key=\"\(id)\" fill=\"\(posDarkColor)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + EFQRCodeStyleBasic.planetsVh[h] + 0.5)\" r=\"\(0.5 * posSize)\"/>")
                            id += 1
                        }
                        break
                    case .dsj:
                        let widthValue: CGFloat = 3.0 - (1.0 - posSize)
                        let xTempValue: CGFloat = x.cgFloat + (1.0 - posSize) / 2.0
                        let yTempValue: CGFloat = y.cgFloat + (1.0 - posSize) / 2.0
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"\(widthValue)\" height=\"\(widthValue)\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue - 1)\"/>")
                        id += 1
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"\(posSize)\" height=\"\(widthValue)\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(xTempValue - 3)\" y=\"\(yTempValue - 1)\"/>")
                        id += 1
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"\(posSize)\" height=\"\(widthValue)\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(xTempValue + 3)\" y=\"\(yTempValue - 1)\"/>")
                        id += 1
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"\(widthValue)\" height=\"\(posSize)\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue - 3)\"/>")
                        id += 1
                        pointList.append("<rect opacity=\"\(posDarkAlpha)\" width=\"\(widthValue)\" height=\"\(posSize)\" key=\"\(id)\" fill=\"\(posDarkColor)\" x=\"\(xTempValue - 1)\" y=\"\(yTempValue + 3)\"/>")
                        id += 1
                        break
                    }
                } else if typeTable[x][y] == QRPointType.posOther {
                    continue
                } else {
                    if isDark {
                        switch type {
                        case .rectangle:
                            pointList.append("<rect opacity=\"\(opacityDark)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(otherColorDark)\" x=\"\(x.cgFloat + (1.0 - size) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\"/>")
                            id += 1
                            break
                        case .round:
                            pointList.append("<circle opacity=\"\(opacityDark)\" r=\"\(size / 2)\" key=\"\(id)\" fill=\"\(otherColorDark)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                            break
                        case .roundedRectangle:
                            let cd: CGFloat = size / 4.0
                            pointList.append("<rect key=\"\(id)\" opacity=\"\(opacityDark)\" fill=\"\(otherColorDark)\" x=\"\(x.cgFloat + (1.0 - size) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\" width=\"\(size)\" height=\"\(size)\" rx=\"\(cd)\" ry=\"\(cd)\"/>")
                            id += 1
                            break
                        }
                    } else {
                        switch type {
                        case .rectangle:
                            pointList.append("<rect opacity=\"\(opacityLight)\" width=\"\(size)\" height=\"\(size)\" key=\"\(id)\" fill=\"\(otherColorLight)\" x=\"\(x.cgFloat + (1.0 - size) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\"/>")
                            id += 1
                            break
                        case .round:
                            pointList.append("<circle opacity=\"\(opacityLight)\" r=\"\(size / 2.0)\" key=\"\(id)\" fill=\"\(otherColorLight)\" cx=\"\(x.cgFloat + 0.5)\" cy=\"\(y.cgFloat + 0.5)\"/>")
                            id += 1
                            break
                        case .roundedRectangle:
                            let cd: CGFloat = size / 4.0
                            pointList.append("<rect key=\"\(id)\" opacity=\"\(opacityLight)\" fill=\"\(otherColorLight)\" x=\"\(x.cgFloat + (1.0 - size) / 2.0)\" y=\"\(y.cgFloat + (1.0 - size) / 2.0)\" width=\"\(size)\" height=\"\(size)\" rx=\"\(cd)\" ry=\"\(cd)\"/>")
                            id += 1
                            break
                        }
                    }
                    
                }
            }
        }
        if let imageLineIndex = imageLineIndex {
            imageMask += "</mask></defs>"
            let oldImageLine: String = pointList[imageLineIndex]
            pointList[imageLineIndex] = "\(imageMask)<g x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" mask=\"url(#hole)\">\(oldImageLine)</g>"
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
        let image: EFStyleImageParamsImage? = params.image?.copyWith(image: watermarkImage)
        return EFQRCodeStyleImage(params: params.copyWith(icon: icon, image: image))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, params.image?.image)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.image(params: self.params)
    }
}
