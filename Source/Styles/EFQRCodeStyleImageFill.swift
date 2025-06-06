//
//  EFQRCodeStyleImageFill.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/4.
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

public class EFStyleImageFillParams: EFStyleParams {
    
    public static let defaultBackdrop: EFStyleParamBackdrop = EFStyleParamBackdrop()
    public static let defaultBackgroundColor: CGColor = CGColor.createWith(rgb: 0xffffff)!
    public static let defaultMaskColor: CGColor = CGColor.createWith(rgb: 0x000000, alpha: 0.1)!
    
    let image: EFStyleImageFillParamsImage?
    let backgroundColor: CGColor
    let maskColor: CGColor
    
    public init(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop = EFStyleImageFillParams.defaultBackdrop,
        image: EFStyleImageFillParamsImage?,
        backgroundColor: CGColor = EFStyleImageFillParams.defaultBackgroundColor,
        maskColor: CGColor = EFStyleImageFillParams.defaultMaskColor
    ) {
        self.image = image
        self.backgroundColor = backgroundColor
        self.maskColor = maskColor
        super.init(icon: icon, backdrop: backdrop)
    }
    
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        backdrop: EFStyleParamBackdrop? = nil,
        image: EFStyleImageFillParamsImage? = nil,
        backgroundColor: CGColor? = nil,
        maskColor: CGColor? = nil
    ) -> EFStyleImageFillParams {
        return EFStyleImageFillParams(
            icon: icon ?? self.icon,
            backdrop: backdrop ?? self.backdrop,
            image: image ?? self.image,
            backgroundColor: backgroundColor ?? self.backgroundColor,
            maskColor: maskColor ?? self.maskColor
        )
    }
}

public class EFStyleImageFillParamsImage {
    
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
    ) -> EFStyleImageFillParamsImage {
        return EFStyleImageFillParamsImage(
            image: image ?? self.image,
            mode: mode ?? self.mode,
            alpha: alpha ?? self.alpha
        )
    }
}

public class EFQRCodeStyleImageFill: EFQRCodeStyleBase {
    
    let params: EFStyleImageFillParams
    
    public init(params: EFStyleImageFillParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        
        let backgroundColor: String = try params.backgroundColor.hexString()
        let backgroundAlpha: CGFloat = try params.backgroundColor.alpha()
        
        let maskColor: String = try params.maskColor.hexString()
        let maskAlpha: CGFloat = try params.maskColor.alpha()
        
        var id: Int = 0
        
        pointList.append("<defs><mask id=\"hole\"><rect x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" fill=\"black\"/>")
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if isDark {
                    pointList.append("<rect x=\"\(x.cgFloat - 0.01)\" y=\"\(y.cgFloat - 0.01)\" width=\"1.02\" height=\"1.02\" fill=\"white\"/>")
                }
            }
        }
        pointList.append("</mask></defs>")
        
        pointList.append("<g x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" mask=\"url(#hole)\">")
        pointList.append("<rect key=\"\(id)\" opacity=\"\(backgroundAlpha)\" x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" fill=\"\(backgroundColor)\"/>")
        id += 1
        
        if let paramsImage = params.image {
            let imageAlpha: CGFloat = max(0, paramsImage.alpha)
            let imageLine: String = try paramsImage.image.write(id: id, rect: CGRect(x: 0, y: 0, width: nCount, height: nCount), opacity: imageAlpha, mode: paramsImage.mode)
            pointList.append(imageLine)
            id += 1
        }
        
        pointList.append("<rect key=\"\(id)\" opacity=\"\(maskAlpha)\" x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" fill=\"\(maskColor)\"/>")
        id += 1
        
        pointList.append("</g>")
        
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
        let image: EFStyleImageFillParamsImage? = params.image?.copyWith(image: watermarkImage)
        return EFQRCodeStyleImageFill(params: params.copyWith(icon: icon, image: image))
    }
    
    override func getParamImages() -> (iconImage: EFStyleParamImage?, watermarkImage: EFStyleParamImage?) {
        return (params.icon?.image, params.image?.image)
    }
    
    override func toQRCodeStyle() -> EFQRCodeStyle {
        return EFQRCodeStyle.imageFill(params: self.params)
    }
}
