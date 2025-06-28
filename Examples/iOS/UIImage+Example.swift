//
//  UIImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/4/6.
//
//  Copyright (c) 2017-2021 EyreFree <eyrefree@eyrefree.org>
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
    
    #if canImport(CoreImage)
    func ciImage() -> CIImage? {
        return ciImage ?? CIImage(image: self)
    }
    #endif
    
    func cgImage() -> CGImage? {
        let rtnValue: CGImage? = cgImage
        #if canImport(CoreImage)
        if nil == rtnValue {
            return ciImage()?.cgImage()
        }
        #endif
        return rtnValue
    }
}

public extension CIImage {
    
    func cgImage() -> CGImage? {
        if #available(iOS 10, macOS 10.12, tvOS 10, watchOS 2, *) {
            if let cgImage = cgImage {
                return cgImage
            }
        }
        return CIContext().createCGImage(self, from: extent)
    }
}

// GIF
fileprivate struct AssociatedObjectKeys {
    static var dataGifKey: String = "dataGifKey"
}

public extension UIImage {

    var dataGif: Data? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKeys.dataGifKey) as? Data
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.dataGifKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    static func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        let image: UIImage? = UIImage.animatedImageWithSource(source)
        image?.dataGif = data
        return image
    }

    static func gif(url: String) -> UIImage? {
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        return gif(data: imageData)
    }

    static func gif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        return gif(data: imageData)
    }

    internal static func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay: Double = 0.1
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        delay = delayObject as? Double ?? 0
        if delay < 0.1 {
            delay = 0.1
        }
        return delay
    }

    internal static func gcdForPair(_ paramA: Int?, _ paramB: Int?) -> Int {
        guard var a = paramA, var b = paramB else {
            if let paramB = paramB {
                return paramB
            } else if let paramA = paramA {
                return paramA
            }
            return 0
        }
        if a < b {
            let c = a
            a = b
            b = c
        }
        var rest: Int
        while true {
            rest = a % b
            if rest == 0 {
                return b
            } else {
                a = b
                b = rest
            }
        }
    }

    internal static func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd: Int = array[0]
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        return gcd
    }

    internal static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count: Int = CGImageSourceGetCount(source)
        var images: [CGImage] = [CGImage]()
        var delays: [Int] = [Int]()

        for i in 0 ..< count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            let delaySeconds: Double = UIImage.delayForImageAtIndex(Int(i), source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }

        let duration: Int = {
            var sum: Int = 0
            for val: Int in delays {
                sum += val
            }
            return sum
        }()

        let gcd: Int = gcdForArray(delays)
        var frames: [UIImage] = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0 ..< count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            for _ in 0 ..< frameCount {
                frames.append(frame)
            }
        }

        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        return animation
    }
}
