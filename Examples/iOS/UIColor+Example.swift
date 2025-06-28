//
//  UIColor+Example.swift
//  iOS Example
//
//  Created by EyreFree on 2025/6/28.
//  Copyright © 2025 EyreFree. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import CoreGraphics

public extension UIColor {

    convenience init(hexRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hexRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexRGB & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    convenience init?(hexRGBString: String?, alpha: CGFloat = 1.0) {
        guard let intString = hexRGBString?.replacingOccurrences(of: "#", with: "") else { return nil }
        guard let hex = UInt(intString, radix: 16) else {
            return nil
        }
        self.init(hexRGB: hex, alpha: alpha)
    }
    
    #if canImport(CoreImage)
    func ciColor() -> CIColor {
        return CIColor(color: self)
    }
    #endif

    func cgColor() -> CGColor {
        return cgColor
    }
    
    static func white(white: CGFloat = 1.0, alpha: CGFloat = 1.0) -> UIColor {
        return self.init(white: white, alpha: alpha)
    }
    
    static func black(black: CGFloat = 1.0, alpha: CGFloat = 1.0) -> UIColor {
        let white: CGFloat = 1.0 - black
        return self.white(white: white, alpha: alpha)
    }
}
#endif
