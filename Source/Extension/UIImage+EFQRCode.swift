//
//  UIImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2024/7/27.
//  Copyright © 2024 EyreFree. All rights reserved.
//

import CoreGraphics
import ImageIO
#if canImport(UIKit)
import UIKit
#if canImport(CoreImage)
import CoreImage
#endif

extension UIImage {
    #if canImport(CoreImage)
    func ciImage() -> CIImage? {
        return self.ciImage ?? CIImage(image: self)
    }
    #endif

    func cgImage() -> CGImage? {
        let rtnValue = self.cgImage
        #if canImport(CoreImage)
        return rtnValue ?? ciImage()?.cgImage()
        #else
        return rtnValue
        #endif
    }
}
#endif
