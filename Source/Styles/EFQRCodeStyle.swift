//
//  EFQRCodeStyle.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/1.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics

import QRCodeSwift

public class EFStyleParams {
    let icon: EFStyleParamIcon?
    
    init(icon: EFStyleParamIcon?) {
        self.icon = icon
    }
}

public enum EFStyleParamAlignStyle: CaseIterable {
    case rectangle
    case round
    case roundedRectangle
}

public enum EFStyleParamTimingStyle: CaseIterable {
    case rectangle
    case round
    case roundedRectangle
}

public enum EFStyleParamsDataStyle: CaseIterable {
    case rectangle
    case round
    case roundedRectangle
}

public enum EFStyleParamsPositionStyle: CaseIterable {
    case rectangle
    case round
    case roundedRectangle
    case planets
    case dsj
}

public class EFStyleParamIcon {
    let image: EFStyleParamImage
    let percentage: CGFloat
    let alpha: CGFloat
    let borderColor: CGColor
    
    public init(image: EFStyleParamImage, percentage: CGFloat, alpha: CGFloat, borderColor: CGColor) {
        self.image = image
        self.percentage = percentage
        self.alpha = alpha
        self.borderColor = borderColor
    }
    
    func copyWith(
        image: EFStyleParamImage? = nil,
        percentage: CGFloat? = nil,
        alpha: CGFloat? = nil,
        borderColor: CGColor? = nil
    ) -> EFStyleParamIcon {
        return EFStyleParamIcon(
            image: image ?? self.image,
            percentage: percentage ?? self.percentage,
            alpha: alpha ?? self.alpha,
            borderColor: borderColor ?? self.borderColor
        )
    }
    
    func write(qrcode: QRCode) throws -> [String] {
        struct Anchor {
            static var uniqueMark: Int = 0
        }
        
        var id: Int = 0
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        
        let scale: CGFloat = min(self.percentage, 0.33)
        let imageAlpha: CGFloat = max(0, alpha)
        
        let iconSize: CGFloat = nCount.cgFloat * scale
        let iconXY: CGFloat = (nCount.cgFloat - iconSize) / 2.0
        
        let bdColor: String = try borderColor.hexString()
        let bdAlpha: CGFloat = max(0, try borderColor.alpha())
        
        let randomIdDefs: String = "icon\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        let randomIdClips: String = "icon\(Anchor.uniqueMark)"
        Anchor.uniqueMark += 1
        
        pointList.append("<path opacity=\"\(bdAlpha)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(bdColor)\" stroke-width=\"\(100.0 / iconSize)\" fill=\"\(bdColor)\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100.0),\(iconSize / 100.0))\"/>")
        pointList.append("<g key=\"g\(id)\">")
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
            + (try image.write(id: id, rect: iconRect, opacity: imageAlpha))
            + "</g>"
            + "</g>"
        )
        id += 1
        return pointList
    }
}

public enum EFStyleParamImage {
    case `static`(image: CGImage)
    case animated(images: [CGImage], imageDelays: [CGFloat])
    
    func write(id: Int, rect: CGRect, opacity: CGFloat) throws -> String {
        struct Anchor {
            static var uniqueMark: Int = 0
        }
        switch self {
        case .static(let image):
            let imageCliped: CGImage = image.clipImageToSquare() ?? image
            let pngBase64EncodedString: String = try imageCliped.pngBase64EncodedString()
            return "<image key=\"i\(id)\" opacity=\"\(opacity)\" xlink:href=\"\(pngBase64EncodedString)\" width=\"\(rect.width)\" height=\"\(rect.height)\" x=\"\(rect.origin.x)\" y=\"\(rect.origin.y)\"/>"
        case .animated(let images, let imageDelays):
            let pngBase64EncodedStrings: [String] = try images.map {
                let imageCliped: CGImage = $0.clipImageToSquare() ?? $0
                return try imageCliped.pngBase64EncodedString()
            }
            if pngBase64EncodedStrings.isEmpty { return "" }
            Anchor.uniqueMark += 1
            let framePrefix: String = "\(Anchor.uniqueMark)fm"
            let defs: String = pngBase64EncodedStrings.enumerated().map { (index, base64Image) -> String in
                "<image id=\"\(framePrefix)\(index)\" xlink:href=\"\(base64Image)\" width=\"\(rect.width)\" height=\"\(rect.height)\" x=\"\(rect.origin.x)\" y=\"\(rect.origin.y)\" opacity=\"\(opacity)\"/>"
            }.joined()
            let totalDuration: CGFloat = imageDelays.reduce(0, +)
            let keyTimes: [CGFloat] = imageDelays.reduce(into: [0]) { result, delay in
                result.append((result.last ?? 0) + delay / totalDuration)
            }
            let use: String = """
            <use xlink:href="#\(framePrefix)0">
                <animate
                    attributeName="xlink:href"
                    values="\(pngBase64EncodedStrings.indices.map { "#\(framePrefix)\($0)" }.joined(separator: ";"))"
                    keyTimes="\(keyTimes.dropLast().map { String(format: "%.3f", $0) }.joined(separator: ";"))"
                    dur="\(totalDuration)s"
                    repeatCount="indefinite"
                    calcMode="discrete"
                />
            </use>
            """
            let svg: String = "<g key=\"g\(id)\"><defs>\(defs)</defs>\(use)</g>"
            return svg
        }
    }
}

public class EFQRCodeStyleBase {
    
    func writeQRCode(qrcode: QRCode) throws -> [String] {
        Utils.ShowNotImplementedError()
        return []
    }
    
    func writeIcon(qrcode: QRCode) throws -> [String] {
        Utils.ShowNotImplementedError()
        return []
    }
    
    func viewBox(qrcode: QRCode) -> String {
        let nCount: Int = qrcode.model.moduleCount
        return "\(-nCount.cgFloat / 5) \(-nCount.cgFloat / 5) \(nCount.cgFloat + nCount.cgFloat / 5 * 2) \(nCount.cgFloat + nCount.cgFloat / 5 * 2)"
    }
    
    func generateSVG(qrcode: QRCode) throws -> String {
        return "<svg className=\"Qr-item-svg\" width=\"100%\" height=\"100%\" viewBox=\"\(viewBox(qrcode: qrcode))\" fill=\"white\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"
        + (try writeQRCode(qrcode: qrcode)).joined()
        + (try writeIcon(qrcode: qrcode)).joined()
        + "</svg>"
    }
}

public enum EFQRCodeStyle {
    case basic(params: EFStyleBasicParams)
    case bubble(params: EFStyleBubbleParams)
    case d25(params: EFStyle25DParams)
    case dsj(params: EFStyleDSJParams)
    case function(params: EFStyleFunctionParams)
    case image(params: EFStyleImageParams)
    case imageFill(params: EFStyleImageFillParams)
    case line(params: EFStyleLineParams)
    case randomRectangle(params: EFStyleRandomRectangleParams)
    case resampleImage(params: EFStyleResampleImageParams)
    
    var style: EFQRCodeStyleBase {
        switch self {
        case .basic(let params):
            return EFQRCodeStyleBasic(params: params)
        case .bubble(let params):
            return EFQRCodeStyleBubble(params: params)
        case .d25(let params):
            return EFQRCodeStyle25D(params: params)
        case .dsj(let params):
            return EFQRCodeStyleDSJ(params: params)
        case .function(let params):
            return EFQRCodeStyleFunction(params: params)
        case .image(let params):
            return EFQRCodeStyleImage(params: params)
        case .imageFill(let params):
            return EFQRCodeStyleImageFill(params: params)
        case .line(let params):
            return EFQRCodeStyleLine(params: params)
        case .randomRectangle(let params):
            return EFQRCodeStyleRandomRectangle(params: params)
        case .resampleImage(let params):
            return EFQRCodeStyleResampleImage(params: params)
        }
    }
    
    func generateSVG(qrcode: QRCode) throws -> String {
        return try style.generateSVG(qrcode: qrcode)
    }
    
    func copyWith(
        iconImage: EFStyleParamImage? = nil,
        watermarkImage: EFStyleParamImage? = nil
    ) -> EFQRCodeStyleBase {
        switch self {
        case .basic(let params):
            let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
            return EFQRCodeStyleBasic(params: params.copyWith(icon: icon))
        case .bubble(let params):
            let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
            return EFQRCodeStyleBubble(params: params.copyWith(icon: icon))
        case .d25(let params):
            let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
            return EFQRCodeStyle25D(params: params.copyWith(icon: icon))
        case .dsj(let params):
            let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
            return EFQRCodeStyleDSJ(params: params.copyWith(icon: icon))
        case .function(let params):
            let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
            return EFQRCodeStyleFunction(params: params.copyWith(icon: icon))
        case .image(let params):
            let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
            let image: EFStyleImageParamsImage? = params.image?.copyWith(image: watermarkImage)
            return EFQRCodeStyleImage(params: params.copyWith(icon: icon, image: image))
        case .imageFill(let params):
            let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
            let image: EFStyleImageFillParamsImage? = params.image?.copyWith(image: watermarkImage)
            return EFQRCodeStyleImageFill(params: params.copyWith(icon: icon, image: image))
        case .line(let params):
            let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
            return EFQRCodeStyleLine(params: params.copyWith(icon: icon))
        case .randomRectangle(let params):
            let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
            return EFQRCodeStyleRandomRectangle(params: params.copyWith(icon: icon))
        case .resampleImage(let params):
            let icon: EFStyleParamIcon? = params.icon?.copyWith(image: iconImage)
            let image: EFStyleResampleImageParamsImage? = params.image?.copyWith(image: watermarkImage)
            return EFQRCodeStyleResampleImage(params: params.copyWith(icon: icon, image: image))
        }
    }
    
    func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        switch self {
        case .basic(let params):
            return (params.icon?.image, nil)
        case .bubble(let params):
            return (params.icon?.image, nil)
        case .dsj(let params):
            return (params.icon?.image, nil)
        case .function(let params):
            return (params.icon?.image, nil)
        case .image(let params):
            return (params.icon?.image, params.image?.image)
        case .imageFill(let params):
            return (params.icon?.image, params.image?.image)
        case .line(let params):
            return (params.icon?.image, nil)
        case .randomRectangle(let params):
            return (params.icon?.image, nil)
        case .resampleImage(let params):
            return (params.icon?.image, params.image?.image)
        case .d25(let params):
            return (params.icon?.image, nil)
        }
    }
}
