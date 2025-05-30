//
//  EFQRCodeStyle.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/1.
//
//  Copyright (c) 2017-2024 EyreFree <eyrefree@eyrefree.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import CoreGraphics

import QRCodeSwift

public class EFStyleParams {
    
    let icon: EFStyleParamIcon?
    let backdrop: EFStyleParamBackdrop
    
    init(
        icon: EFStyleParamIcon?,
        backdrop: EFStyleParamBackdrop
    ) {
        self.icon = icon
        self.backdrop = backdrop
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
    let mode: EFImageMode
    let alpha: CGFloat
    let borderColor: CGColor
    let percentage: CGFloat
    
    public init(
        image: EFStyleParamImage,
        mode: EFImageMode = .scaleAspectFill,
        alpha: CGFloat = 1,
        borderColor: CGColor,
        percentage: CGFloat = 0.2
    ) {
        self.image = image
        self.mode = mode
        self.alpha = alpha
        self.borderColor = borderColor
        self.percentage = percentage
    }
    
    func copyWith(
        image: EFStyleParamImage? = nil,
        mode: EFImageMode? = nil,
        alpha: CGFloat? = nil,
        borderColor: CGColor? = nil,
        percentage: CGFloat? = nil
    ) -> EFStyleParamIcon {
        return EFStyleParamIcon(
            image: image ?? self.image,
            mode: mode ?? self.mode,
            alpha: alpha ?? self.alpha,
            borderColor: borderColor ?? self.borderColor,
            percentage: percentage ?? self.percentage
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
            + (try image.write(id: id, rect: iconRect, opacity: imageAlpha, mode: mode))
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
    
    func write(id: Int, rect: CGRect, opacity: CGFloat, mode: EFImageMode) throws -> String {
        struct Anchor {
            static var uniqueMark: Int = 0
        }
        switch self {
        case .static(let image):
            let imageCliped: CGImage = try mode.imageForContent(ofImage: image, inCanvasOfRatio: rect.size)
            let pngBase64EncodedString: String = try imageCliped.pngBase64EncodedString()
            return "<image key=\"i\(id)\" opacity=\"\(opacity)\" xlink:href=\"\(pngBase64EncodedString)\" width=\"\(rect.width)\" height=\"\(rect.height)\" x=\"\(rect.origin.x)\" y=\"\(rect.origin.y)\"/>"
        case .animated(let images, let imageDelays):
            let pngBase64EncodedStrings: [String] = try images.map {
                let imageCliped: CGImage = try mode.imageForContent(ofImage: $0, inCanvasOfRatio: rect.size)
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

public class EFStyleParamBackdrop {
    
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0xffffff)!
    
    let cornerRadius: CGFloat
    let color: CGColor
    let image: EFStyleParamBackdropImage?
    let quietzone: EFEdgeInsets?
    
    public init(
        cornerRadius: CGFloat = 0,
        color: CGColor = EFStyleParamBackdrop.defaultColor,
        image: EFStyleParamBackdropImage? = nil,
        quietzone: EFEdgeInsets? = nil
    ) {
        self.cornerRadius = cornerRadius
        self.color = color
        self.image = image
        self.quietzone = quietzone
    }
    
    func viewBox(moduleCount: Int) -> CGRect {
        if let quietzone = quietzone {
            return CGRect(
                x: -moduleCount.cgFloat * quietzone.left,
                y: -moduleCount.cgFloat * quietzone.top,
                width: moduleCount.cgFloat * (quietzone.left + 1 + quietzone.right),
                height: moduleCount.cgFloat * (quietzone.top + 1 + quietzone.bottom)
            )
        }
        return CGRect(x: -1, y: -1, width: moduleCount.cgFloat + 2, height: moduleCount.cgFloat + 2)
    }
    
    func generateSVG(qrcode: QRCode, viewBoxRect: CGRect) throws -> (String, String) {
        let bgColor: String = try color.hexString()
        let bgAlpha: CGFloat = max(0, try color.alpha())
        return (
            """
            <svg className="Qr-item-svg" width="\(viewBoxRect.width)" height="\(viewBoxRect.height)" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                <defs>
                    <clipPath id="rounded-corners">
                        <rect width="\(viewBoxRect.width)" height="\(viewBoxRect.height)" rx="\(cornerRadius)" ry="\(cornerRadius)"/>
                    </clipPath>
                </defs>
                <g clip-path="url(#rounded-corners)">
                    <rect width="\(viewBoxRect.width)" height="\(viewBoxRect.height)" opacity=\"\(bgAlpha)\" fill="\(bgColor)"/>
                    \(try image?.write(size: viewBoxRect.size) ?? "")
                    <g width="\(viewBoxRect.width)" height="\(viewBoxRect.height)" transform="translate(\(-viewBoxRect.minX), \(-viewBoxRect.minY))">
            """,
            """
                    </g>
                </g>
            </svg>
            """
        )
    }
}

public class EFStyleParamBackdropImage {
    let image: CGImage
    let alpha: CGFloat
    let mode: EFImageMode
    
    public init(
        image: CGImage,
        alpha: CGFloat = 1,
        mode: EFImageMode = .scaleAspectFill
    ) {
        self.image = image
        self.alpha = alpha
        self.mode = mode
    }
    
    func write(size: CGSize) throws -> String {
        let imageCliped: CGImage = try self.mode.imageForContent(ofImage: image, inCanvasOfRatio: size)
        let pngBase64EncodedString: String = try imageCliped.pngBase64EncodedString()
        return "<image key=\"bi\" opacity=\"\(alpha)\" xlink:href=\"\(pngBase64EncodedString)\" width=\"\(size.width)\" height=\"\(size.height)\" x=\"0\" y=\"0\"/>"
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
    
    func viewBox(qrcode: QRCode) -> CGRect {
        Utils.ShowNotImplementedError()
        return CGRect.zero
    }
    
    func generateSVG(qrcode: QRCode) throws -> String {
        Utils.ShowNotImplementedError()
        return ""
    }
    
    func copyWith(
        iconImage: EFStyleParamImage? = nil,
        watermarkImage: EFStyleParamImage? = nil
    ) -> EFQRCodeStyleBase {
        Utils.ShowNotImplementedError()
        return self
    }
    
    func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        Utils.ShowNotImplementedError()
        return (nil, nil)
    }
    
    func toQRCodeStyle() -> EFQRCodeStyle {
        Utils.ShowNotImplementedError()
        return .basic(params: .init())
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
    
    var implementation: EFQRCodeStyleBase {
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
}
