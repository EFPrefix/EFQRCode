//
//  CGImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/4/9.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
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

#if os(iOS) || os(tvOS) || os(macOS)
    import CoreImage
#endif

public extension CGImage {

    // Convert UIImage to CIImage
    // http://wiki.hawkguide.com/wiki/Swift:_Convert_between_CGImage,_CIImage_and_UIImage
    #if os(iOS) || os(tvOS) || os(macOS)
    public func toCIImage() -> CIImage {
        return CIImage(cgImage: self)
    }
    #endif

    // Get pixels from CIImage
    func pixels() -> [[EFUIntPixel]]? {
        var pixels: [[EFUIntPixel]]?
        let dataSize = width * height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * width,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
            pixels = [[EFUIntPixel]]()
            for y in 0 ..< height {
                pixels?.append([EFUIntPixel]())
                for x in 0 ..< width {
                    let offset = 4 * (x + y * width)
                    pixels?[y].append(
                        EFUIntPixel(
                            red: pixelData[offset + 0],
                            green: pixelData[offset + 1],
                            blue: pixelData[offset + 2],
                            alpha: pixelData[offset + 3]
                        )
                    )
                }
            }
        }
        return pixels
    }

    // Get avarage color
    func avarageColor() -> CGColor? {
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
        context.draw(self, in: CGRect(x: 0, y: 0, width: 1, height: 1))

        return CGColor.fromRGB(
            red: CGFloat(rgba[0]) / 255.0,
            green: CGFloat(rgba[1]) / 255.0,
            blue: CGFloat(rgba[2]) / 255.0,
            alpha: CGFloat(rgba[3]) / 255.0
        )
    }

    // Grayscale
    // http://stackoverflow.com/questions/1311014/convert-to-grayscale-too-slow
    func grayscale() -> CGImage? {
        if let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 4 * width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
            ) {
            context.draw(self, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
            return context.makeImage()
        }
        return nil
    }

    // Binarization
    // http://blog.sina.com.cn/s/blog_6b7ba99d0101js23.html
    public func binarization(
        value: CGFloat = 0.5,
        foregroundColor: CGColor = CGColor.EFWhite(),
        backgroundColor: CGColor = CGColor.EFBlack()
        ) -> CGImage? {
        let dataSize = width * height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let backgroundPixel = EFUIntPixel(color: backgroundColor),
            let foregroundPixel = EFUIntPixel(color: foregroundColor)
            else { return nil }
        if let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * width,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
            for x in 0 ..< width {
                for y in 0 ..< height {
                    let offset = 4 * (x + y * width)
                    // RGBA
                    let alpha = CGFloat(pixelData[offset + 3]) / 255.0
                    let intensity = (
                        CGFloat(pixelData[offset + 0]) + CGFloat(pixelData[offset + 1]) + CGFloat(pixelData[offset + 2])
                        ) / 3.0 / 255.0 * alpha + (1.0 - alpha)
                    let finalPixel = intensity > value ? backgroundPixel : foregroundPixel
                    pixelData[offset + 0] = finalPixel.red
                    pixelData[offset + 1] = finalPixel.green
                    pixelData[offset + 2] = finalPixel.blue
                    pixelData[offset + 3] = finalPixel.alpha
                }
            }
            return context.makeImage()
        }
        return nil
    }
}
