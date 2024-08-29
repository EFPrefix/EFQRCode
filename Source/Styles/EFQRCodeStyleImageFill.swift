//
//  EFQRCodeStyleImageFill.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/4.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics

import QRCodeSwift

public class EFStyleImageFillParams: EFStyleParams {
    
    public static let defaultBackgroundColor: CGColor = CGColor.createWith(rgb: 0xffffff)!
    public static let defaultMaskColor: CGColor = CGColor.createWith(rgb: 0x000000, alpha: 0.1)!
    
    let image: EFStyleImageFillParamsImage?
    let backgroundColor: CGColor
    let maskColor: CGColor
    
    public init(icon: EFStyleParamIcon? = nil, image: EFStyleImageFillParamsImage?, backgroundColor: CGColor = EFStyleImageFillParams.defaultBackgroundColor, maskColor: CGColor = EFStyleImageFillParams.defaultMaskColor) {
        self.image = image
        self.backgroundColor = backgroundColor
        self.maskColor = maskColor
        super.init(icon: icon)
    }
    
    func copyWith(
        icon: EFStyleParamIcon? = nil,
        image: EFStyleImageFillParamsImage? = nil,
        backgroundColor: CGColor? = nil,
        maskColor: CGColor? = nil
    ) -> EFStyleImageFillParams {
        return EFStyleImageFillParams(
            icon: icon ?? self.icon,
            image: image ?? self.image,
            backgroundColor: backgroundColor ?? self.backgroundColor,
            maskColor: maskColor ?? self.maskColor
        )
    }
}

public class EFStyleImageFillParamsImage {
    
    let image: EFStyleParamImage
    let alpha: CGFloat
    
    public init(image: EFStyleParamImage, alpha: CGFloat = 1) {
        self.image = image
        self.alpha = alpha
    }
    
    func copyWith(
        image: EFStyleParamImage? = nil,
        alpha: CGFloat? = nil
    ) -> EFStyleImageFillParamsImage {
        return EFStyleImageFillParamsImage(
            image: image ?? self.image,
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
        
        pointList.append("<rect key=\"\(id)\" opacity=\"\(backgroundAlpha)\" x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" fill=\"\(backgroundColor)\"/>")
        id += 1
        
        if let image = params.image?.image, let alpha = params.image?.alpha {
            let imageAlpha: CGFloat = max(0, alpha)
            let imageLine: String = try image.write(id: id, rect: CGRect(x: 0, y: 0, width: nCount, height: nCount), opacity: imageAlpha)
            pointList.append(imageLine)
            id += 1
        }
        
        pointList.append("<rect key=\"\(id)\" opacity=\"\(maskAlpha)\" x=\"0\" y=\"0\" width=\"\(nCount)\" height=\"\(nCount)\" fill=\"\(maskColor)\"/>")
        id += 1
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                let isDark: Bool = qrcode.model.isDark(x, y)
                if !isDark {
                    pointList.append("<rect key=\"\(id)\" opacity=\"\(backgroundAlpha)\" width=\"1.02\" height=\"1.02\" fill=\"\(backgroundColor)\" x=\"\(x.cgFloat - 0.01)\" y=\"\(y.cgFloat - 0.01)\"/>")
                    id += 1
                }
            }
        }
        return pointList
    }
    
    override func writeIcon(qrcode: QRCode) throws -> [String] {
        return try params.icon?.write(qrcode: qrcode) ?? []
    }
}
