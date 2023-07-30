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
    
    public static let defaultMaskColor: CGColor = CGColor.createWith(rgb: 0x000000, alpha: 0.1)!
    
    let backgroundColor: CGColor
    let image: EFStyleImageFillParamsImage?
    let maskColor: CGColor
    
    public init(icon: EFStyleParamIcon? = nil, backgroundColor: CGColor = CGColor.white, image: EFStyleImageFillParamsImage?, maskColor: CGColor = EFStyleImageFillParams.defaultMaskColor) {
        self.backgroundColor = backgroundColor
        self.image = image
        self.maskColor = maskColor
        super.init(icon: icon)
    }
}

public class EFStyleImageFillParamsImage {
    let image: EFStyleParamImage
    let alpha: CGFloat
    
    public init(image: EFStyleParamImage, alpha: CGFloat = 1) {
        self.image = image
        self.alpha = alpha
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
        
        let bgColor: String = try params.backgroundColor.hexString()
        let bgOpacity: CGFloat = try params.backgroundColor.alpha()
        let color: String = try params.maskColor.hexString()
        let opacity: CGFloat = try params.maskColor.alpha()
        var id: Int = 0
        
        pointList.append("<rect opacity=\"\(bgOpacity)\" key=\"\(id)\" x=\"0\" y=\"0\" width=\"\(nCount.cgFloat)\" height=\"\(nCount.cgFloat)\" fill=\"\(bgColor)\"/>")
        id += 1
        if let image = params.image?.image, let alpha = params.image?.alpha {
            let imageOpacity: CGFloat = max(0, alpha)
            let imageLine = try image.write(id: id, rect: CGRect(x: 0, y: 0, width: nCount, height: nCount), opacity: imageOpacity)
            pointList.append(imageLine)
            id += 1
        }
        pointList.append("<rect key=\"\(id)\" x=\"0\" y=\"0\" width=\"\(nCount.cgFloat)\" height=\"\(nCount.cgFloat)\" fill=\"\(color)\" opacity=\"\(opacity)\"/>")
        id += 1
        
        for x in 0..<nCount {
            for y in 0..<nCount {
                if !qrcode.model.isDark(x, y) {
                    pointList.append("<rect opacity=\"\(bgOpacity)\" width=\"1.02\" height=\"1.02\" key=\"\(id)\" fill=\"\(bgColor)\" x=\"\(x.cgFloat - 0.01)\" y=\"\(y.cgFloat - 0.01)\"/>")
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
