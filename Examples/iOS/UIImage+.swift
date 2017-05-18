//
//  UIImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/4/6.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

extension UIImage {

    // Get avarage color
    func avarageColor() -> UIColor? {
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        guard let context = CGContext(
            data: rgba,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else {
                return nil
        }
        if let cgImage = self.cgImage {
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: 1, height: 1))

            return UIColor(
                red: CGFloat(rgba[0]) / 255.0,
                green: CGFloat(rgba[1]) / 255.0,
                blue: CGFloat(rgba[2]) / 255.0,
                alpha: CGFloat(rgba[3]) / 255.0
            )
        }
        return nil
    }
}
