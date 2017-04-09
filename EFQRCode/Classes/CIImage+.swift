//
//  CIImage+.swift
//  Pods
//
//  Created by EyreFree on 2017/3/29.
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

public extension CIImage {

    static func create(color: CIColor, size: CGSize) -> CIImage? {
        return CIImage(color: color).clip(rect: CGRect(origin: CGPoint.zero, size: size))
    }

    // Resize
    // https://gist.github.com/darcwader/bd346656db880666007e0dff6a1727fc
    func resize(size: CGSize) -> CIImage? {
        let scale = size.width / self.extent.width
        if let tryFilter = CIFilter(name: "CILanczosScaleTransform") {
            tryFilter.setValue(self, forKey: kCIInputImageKey)
            tryFilter.setValue(NSNumber(value: Double(scale)), forKey: kCIInputScaleKey)
            tryFilter.setValue(1.0, forKey: kCIInputAspectRatioKey)
            return tryFilter.outputImage
        }
        return nil
    }

    // Greyscale
    // http://stackoverflow.com/questions/40178846/convert-uiimage-to-grayscale-keeping-image-quality
    func greyscale() -> CIImage? {
        if let tryFilter = CIFilter(name: "CIPhotoEffectNoir") {
            tryFilter.setValue(self, forKey: kCIInputImageKey)
            return tryFilter.outputImage
        }
        return nil
    }

    // Color
    // https://github.com/objcio/issue-16-functional-apis/blob/master/FunctionalCoreImage/CoreImage.swift
    func color(color: CIColor) -> CIImage? {
        if let tryFilter = CIFilter(name: "CIConstantColorGenerator") {
            tryFilter.setValue(color, forKey: kCIInputColorKey)
            return tryFilter.outputImage
        }
        return nil
    }

    // Draw
    // https://github.com/objcio/issue-16-functional-apis/blob/master/FunctionalCoreImage/CoreImage.swift
    func draw(image: CIImage, loaction: CGPoint = .zero) -> CIImage? {
        if let tryFilter = CIFilter(name: "CISourceOverCompositing") {
            tryFilter.setValue(self, forKey: kCIInputBackgroundImageKey)
            tryFilter.setValue(image.applying(CGAffineTransform(translationX: loaction.x, y: loaction.y)), forKey: kCIInputImageKey)
            return tryFilter.outputImage
        }
        return nil
    }

    // Draw in rect
    func draw(image: CIImage, rect: CGRect) -> CIImage? {
        if let tryImage = image.resize(size: rect.size) {
            return image.draw(image: tryImage, loaction: rect.origin)
        }
        return nil
    }

    // Clip
    func clip(rect: CGRect) -> CIImage? {
        return self.cropping(to: rect)
    }

    // Get pixels from CIImage
    func pixels() -> [[EFUIntPixel]]? {
        var pixels: [[EFUIntPixel]]?
        if let tryCGImage = self.toCGImage() {
            if let pixelData = tryCGImage.dataProvider?.data {
                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                pixels = [[EFUIntPixel]]()
                for indexY in 0 ..< tryCGImage.height {
                    pixels?.append([EFUIntPixel]())
                    for indexX in 0 ..< tryCGImage.width {
                        let pixelInfo: Int = ((Int(tryCGImage.width) * Int(indexY)) + Int(indexX)) * 4
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
        }
        return nil
    }

    // Size
    func size() -> CGSize {
        return self.extent.size
    }

    // Convert CIImage To CGImage
    // http://wiki.hawkguide.com/wiki/Swift:_Convert_between_CGImage,_CIImage_and_UIImage
    public func toCGImage() -> CGImage? {
        return CIContext(options: nil).createCGImage(self, from: self.extent)
    }
}
