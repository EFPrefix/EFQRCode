//
//  CGImage+.swift
//  Pods
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

import CoreImage

public struct EFUIntPixel {
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var alpha: UInt8 = 0
}

public class EFIntSize {
    private(set) var width: Int = 0
    private(set) var height: Int = 0

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    public func toCGSize() -> CGSize {
        return CGSize(width: self.width, height: self.height)
    }

    public func widthCGFloat() -> CGFloat {
        return CGFloat(width)
    }

    public func heightCGFloat() -> CGFloat {
        return CGFloat(height)
    }
}

public extension CGImage {

    public func toCIImage() -> CIImage {
        return CIImage(cgImage: self)
    }

    // Get pixels from CIImage
    func pixels() -> [[EFUIntPixel]]? {
        var pixels: [[EFUIntPixel]]?
        if let pixelData = self.dataProvider?.data {
            let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
            pixels = [[EFUIntPixel]]()
            for indexY in 0 ..< self.height {
                pixels?.append([EFUIntPixel]())
                for indexX in 0 ..< self.width {
                    let pixelInfo: Int = ((Int(self.width) * Int(indexY)) + Int(indexX)) * 4
                    pixels?[indexY].append(
                        EFUIntPixel(
                            red: data[pixelInfo],
                            green: data[pixelInfo + 1],
                            blue: data[pixelInfo + 2],
                            alpha: data[pixelInfo + 3]
                        )
                    )
                }
            }
            return pixels
        }
        return nil
    }

    // Grayscale
    // http://stackoverflow.com/questions/1311014/convert-to-grayscale-too-slow
    func grayscale() -> CGImage? {
        if let context = CGContext(
            data: nil, width: self.width, height: self.height,
            bitsPerComponent: 8, bytesPerRow: 4 * width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
            ) {
            context.draw(self, in: CGRect(origin: CGPoint.zero, size: CGSize(width: self.width, height: self.height)))
            return context.makeImage()
        }
        return nil
    }

    // Resize
    private func resize(size: EFIntSize) -> CGImage? {
        if let context = CGContext(
            data: nil, width: size.width, height: size.height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
            ) {
            context.draw(self, in: CGRect(origin: CGPoint.zero, size: size.toCGSize()))
            return context.makeImage()
        }
        return nil
    }
}
