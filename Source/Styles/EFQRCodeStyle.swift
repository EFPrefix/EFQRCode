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
    case none
    case rectangle
    //case round
    //case roundedRectangle
}

public enum EFStyleParamsDataStyle: CaseIterable {
    case rectangle
    case round
    case roundedRectangle
}

public enum EFStyleBasicParamsPositionStyle: CaseIterable {
    case rectangle
    case round
    case planets
    case roundedRectangle
}

public enum EFStyleParamTimingStyle: CaseIterable {
    case none
    case rectangle
    //case round
    //case roundedRectangle
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
    
    func write(qrcode: QRCode) throws -> [String] {
        var id: Int = 0
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        
        let scale: CGFloat = min(self.percentage, 0.33)
        let opacity: CGFloat = max(0, alpha)
        
        let iconSize: CGFloat = nCount.cgFloat * scale
        let iconXY: CGFloat = (nCount.cgFloat - iconSize) / 2
        
        let bdColor: String = try borderColor.hexString()
        let bdOpacity: CGFloat = max(0, try borderColor.alpha())
        
        let randomIdDefs: String = EFStyleParamIcon.getIdNum()
        let randomIdClips: String = EFStyleParamIcon.getIdNum()
        
        pointList.append("<path opacity=\"\(bdOpacity)\" d=\"\(EFQRCodeStyleBasic.sq25)\" stroke=\"\(bdColor)\" stroke-width=\"\(100/iconSize * 1)\" fill=\"\(bdColor)\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\" />")
        pointList.append("<g key=\"\(id)\">")
        id += 1
        pointList.append(
            "<defs><path opacity=\"\(bdOpacity)\" id=\"defs-path\(randomIdDefs)\" d=\"\(EFQRCodeStyleBasic.sq25)\" fill=\"\(bdColor)\" transform=\"translate(\(iconXY),\(iconXY)) scale(\(iconSize / 100),\(iconSize / 100))\" /></defs>"
            + "<clipPath id=\"clip-path\(randomIdClips)\">"
            + "<use xlink:href=\"#defs-path\(randomIdDefs)\" overflow=\"visible\"/>"
            + "</clipPath>"
            + "<g clip-path=\"url(#clip-path\(randomIdClips))\">"
            + (try image.write(id: id, rect: CGRect(x: iconXY, y: iconXY, width: iconSize, height: iconSize), opacity: opacity))
            + "</g>"
            + "</g>"
        )
        id += 1
        return pointList
    }
    
    private static var idNum: Int = 0
    static func getIdNum() -> String {
        idNum += 1
        return "\(idNum)"
    }
}

public enum EFStyleParamImage {
    case `static`(image: CGImage)
    case animated(images: [CGImage], duration: CGFloat)
    
    func write(id: Int, rect: CGRect, opacity: CGFloat) throws -> String {
        struct Anchor {
            static var uniqueMark: Int = 0
        }
        switch self {
        case .static(let image):
            let pngBase64EncodedString = try image.pngBase64EncodedString()
            return "<image key=\"\(id)\" xlink:href=\"\(pngBase64EncodedString)\" width=\"\(rect.width)\" height=\"\(rect.height)\" x=\"\(rect.origin.x)\" y=\"\(rect.origin.y)\" opacity=\"\(opacity)\" />"
        case .animated(let images, let duration):
            let pngBase64EncodedStrings = try images.map { try $0.pngBase64EncodedString() }
            if pngBase64EncodedStrings.isEmpty { return "" }
            Anchor.uniqueMark += 1
            let framePrefix: String = "\(Anchor.uniqueMark)fm"
            let defs = pngBase64EncodedStrings.enumerated().map { (index, base64Image) -> String in
                "<image id=\"\(framePrefix)\(index + 1)\" xlink:href=\"\(base64Image)\" width=\"\(rect.width)\" height=\"\(rect.height)\" x=\"\(rect.origin.x)\" y=\"\(rect.origin.y)\" opacity=\"\(opacity)\" />"
            }.joined()
            let useValues = (1...pngBase64EncodedStrings.count).map { "#\(framePrefix)\($0)" }.joined(separator: ";")
            let svg = "<g key=\"\(id)\"><defs>\(defs)</defs><use xlink:href=\"#\(framePrefix)1\"><animate attributeName=\"xlink:href\" values=\"\(useValues)\" dur=\"\(duration)s\" repeatCount=\"indefinite\" /></use></g>"
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
}
