//
//  UIImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2019/11/21.
//
//  Copyright © 2019 EyreFree. All rights reserved.
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
        let rtnValue: CGImage? = self.cgImage
        #if canImport(CoreImage)
        if nil == rtnValue {
            return ciImage?.cgImage()
        }
        #endif
        return rtnValue
    }
}


#if os(iOS)
extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        UIGraphicsBeginImageContext(size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let tryCGImage = newImage?.cgImage {
            self.init(cgImage: tryCGImage)
        } else {
            return nil
        }
    }
}

extension UIImage {

    func cornerRadiused(radius: CGFloat) -> UIImage? {
        let imageLayer: CALayer = CALayer()
        imageLayer.frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        imageLayer.contents = self.cgImage
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = radius
        UIGraphicsBeginImageContext(self.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageLayer.render(in: context)
        let roundedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage
    }

    var png: Data? {
        return self.pngData()
    }

    func jpg(compressionQuality: CGFloat = 1) -> Data? {
        return self.jpegData(compressionQuality: compressionQuality)
    }

    func resize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func nine(insets: UIEdgeInsets? = nil) -> UIImage {
        let insets: UIEdgeInsets? = insets ?? {
            let width: CGFloat = self.size.width
            let height: CGFloat = self.size.height
            if width > 3 && height > 3 {
                let hMargin: CGFloat = (width - 1) / 2
                let vMargin: CGFloat = (height - 1) / 2
                return UIEdgeInsets(top: vMargin, left: hMargin, bottom: vMargin, right: hMargin)
            }
            return nil
            } (
        )
        guard let insetsV = insets else { return self }
        return self.resizableImage(withCapInsets: insetsV, resizingMode: .stretch)
    }
}
#endif
#endif
