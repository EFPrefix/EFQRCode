//
//  EFQRCodeStyleRandomRectangle.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/3.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics
import QRCodeSwift

public class EFStyleRandomRectangleParams: EFStyleParams {
    
    public static let defaultColor: CGColor = CGColor.createWith(rgb: 0x14AA3C)!
    
    let color: CGColor
    
    public init(icon: EFStyleParamIcon? = nil, color: CGColor = EFStyleRandomRectangleParams.defaultColor) {
        self.color = color
        super.init(icon: icon)
    }
}

public class EFQRCodeStyleRandomRectangle: EFQRCodeStyleBase {
    
    let params: EFStyleRandomRectangleParams
    
    public init(params: EFStyleRandomRectangleParams) {
        self.params = params
        super.init()
    }
    
    override func writeQRCode(qrcode: QRCode) throws -> [String] {
        let nCount: Int = qrcode.model.moduleCount
        var pointList: [String] = []
        var id: Int = 0
        
        let rgba = try params.color.rgba()
        let redValue: Double = rgba.red.double// ?? 20
        let greenValue: Double = rgba.green.double// ?? 170
        let blueValue: Double = rgba.blue.double// ?? 60
        let alphaValue: Double = rgba.alpha
        
        var randArr: [(Int, Int)] = []
        for row in 0..<nCount {
            for col in 0..<nCount {
                randArr.append((row, col))
            }
        }
        randArr.shuffle()
        
        for randItem in randArr {
            let row: Int = randItem.0
            let col: Int = randItem.1
            
            let isDark: Bool = qrcode.model.isDark(row, col)
            if isDark {
                let tempRand = Double.random(in: 0.8...1.3)
                let randNum = Double.random(in: 50...230)
                let tempRGB = [
                    "rgb(\(Int(redValue + randNum)),\(Int(greenValue - randNum / 2)),\(Int(blueValue + randNum * 2)))",
                    "rgb(\(Int(redValue - 40 + randNum)),\(Int(greenValue - 40 - randNum / 2)),\(Int(blueValue - 40 + randNum * 2)))"
                ]
                let width: CGFloat = 0.15
                pointList.append("<rect key=\"\(id)\" opacity=\"\(0.9 * alphaValue)\" fill=\"\(tempRGB[1])\" width=\"\(1 * tempRand.cgFloat + width.cgFloat)\" height=\"\(1 * tempRand.cgFloat + width.cgFloat)\" x=\"\(row.cgFloat - (tempRand.cgFloat - 1) / 2.0)\" y=\"\(col.cgFloat - (tempRand.cgFloat - 1) / 2.0)\"/>");
                id += 1
                pointList.append("<rect key=\"\(id)\" opacity=\"\(alphaValue)\" fill=\"\(tempRGB[0])\" width=\"\(1 * tempRand.cgFloat)\" height=\"\(1 * tempRand.cgFloat)\" x=\"\(row.cgFloat - (tempRand.cgFloat - 1) / 2.0)\" y=\"\(col.cgFloat - (tempRand.cgFloat - 1) / 2.0)\"/>");
                id += 1
            }
        }
        return pointList
    }
    
    override func writeIcon(qrcode: QRCode) throws -> [String] {
        return try params.icon?.write(qrcode: qrcode) ?? []
    }
}
