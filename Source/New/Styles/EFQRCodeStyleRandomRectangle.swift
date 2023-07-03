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
    let color: CGColor
    
    public init(icon: EFStyleParamIcon? = nil, color: CGColor) {
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
        
        var randArr: [(Int, Int)] = []
        for row in 0..<nCount {
            for col in 0..<nCount {
                randArr.append((row, col))
            }
        }
        randArr.shuffle()
        
        for index in 0..<randArr.count {
            let row = randArr[index].0
            let col = randArr[index].1
            
            let rgba = params.color.rgba
            let redValue: Double = rgba?.red.double ?? 20
            let greenValue: Double = rgba?.green.double ?? 170
            let blueValue: Double = rgba?.blue.double ?? 60
            
            if qrcode.model.isDark(row, col) {
                let tempRand = Double.random(in: 0.8...1.3)
                let randNum = Double.random(in: 50...230)
                let tempRGB = [
                    "rgb(\(Int(redValue + randNum)),\(Int(greenValue - randNum / 2)),\(Int(blueValue + randNum * 2)))",
                    "rgb(\(Int(redValue - 40 + randNum)),\(Int(greenValue - 40 - randNum / 2)),\(Int(blueValue - 40 + randNum * 2)))"
                ]
                let width = 0.15
                pointList.append("<rect key=\"\(id)\" opacity=\"0.9\" fill=\"\(tempRGB[1])\" width=\"\(1 * tempRand.cgFloat + width.cgFloat)\" height=\"\(1 * tempRand.cgFloat + width.cgFloat)\" x=\"\(row.cgFloat - (tempRand.cgFloat - 1)/2)\" y=\"\(col.cgFloat - (tempRand.cgFloat - 1)/2)\"/>");
                id += 1
                pointList.append("<rect key=\"\(id)\" fill=\"\(tempRGB[0])\" width=\"\(1 * tempRand.cgFloat)\" height=\"\(1 * tempRand.cgFloat)\" x=\"\(row.cgFloat - (tempRand.cgFloat - 1)/2)\" y=\"\(col.cgFloat - (tempRand.cgFloat - 1)/2)\"/>");
                id += 1
            }
        }
        return pointList
    }
    
    override func writeIcon(qrcode: QRCode) throws -> [String] {
        return try params.icon?.write(qrcode: qrcode) ?? []
    }
}
