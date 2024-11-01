//
//  EFQRCodeX.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/1.
//
//  Copyright (c) 2017-2024 EyreFree <eyrefree@eyrefree.org>
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

import Foundation
import CoreGraphics
import ImageIO
#if canImport(MobileCoreServices)
import MobileCoreServices
#else
import CoreServices
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif
#if canImport(AVFoundation)
import AVFoundation
import CoreVideo
#endif

import QRCodeSwift
import SwiftDraw

//todo
//1. 文档
public extension EFQRCode {
    
    class Generator {
        public let qrcode: QRCode
        public let style: EFQRCodeStyleBase
        
        private var svgContentCache: String?
        
        public convenience init(
            _ text: String,
            encoding: String.Encoding = .utf8,
            errorCorrectLevel: EFCorrectionLevel = .h,
            style: EFQRCodeStyle
        ) throws {
            guard let data = text.data(using: encoding) else {
                throw EFQRCodeError.text(text, incompatibleWithEncoding: encoding)
            }
            try self.init(data, errorCorrectLevel: errorCorrectLevel, style: style)
        }
        
        public init(
            _ data: Data,
            errorCorrectLevel: EFCorrectionLevel = .h,
            style: EFQRCodeStyle
        ) throws {
            do {
                self.qrcode = try QRCode(
                    data,
                    errorCorrectLevel: errorCorrectLevel.qrErrorCorrectLevel,
                    withBorder: false,
                    needTypeTable: true
                )
            } catch {
                throw (error as? QRCodeError)?.efQRCodeError ?? error
            }
            
            self.style = style.implementation
        }
        
        public convenience init(
            _ qrcode: QRCode,
            style: EFQRCodeStyle
        ) {
            self.init(qrcode, styleImplementation: style.implementation)
        }
        
        public init(
            _ qrcode: QRCode,
            styleImplementation: EFQRCodeStyleBase
        ) {
            self.qrcode = qrcode
            self.style = styleImplementation
        }
        
        func copyWith(
            style: EFQRCodeStyle
        ) -> Generator {
            return Generator(
                qrcode,
                style: style
            )
        }
        
        public lazy var isAnimated: Bool = {
            if let svgContent = try? toSVG() {
                return svgContent.contains("<animate")
            }
            return false
        }()
        
        public func toSVG() throws -> String {
            if let svgContent = svgContentCache {
                return svgContent
            }
            let svgString = try self.style.generateSVG(qrcode: qrcode)
            self.svgContentCache = svgString
            return svgString
        }
        
#if canImport(UIKit)
        public func toImage(width: CGFloat, insets: UIEdgeInsets = .zero) throws -> UIImage {
            let imageSize: CGSize = calculateSize(width: width)
            return try toImage(size: imageSize)
        }
        
        public func toImage(height: CGFloat, insets: UIEdgeInsets = .zero) throws -> UIImage {
            let imageSize: CGSize = calculateSize(height: height)
            return try toImage(size: imageSize)
        }
        
        private func toImage(size: CGSize, insets: UIEdgeInsets = .zero) throws -> UIImage {
            let newSvgContent: String = try checkIfNeedResize(size: size)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let image = svg?.rasterize(with: size, scale: 1, insets: insets) else {
                throw EFQRCodeError.cannotCreateUIImage
            }
            
            return image
        }
#endif
        
#if canImport(AppKit)
        public func toImage(width: CGFloat, insets: NSEdgeInsets = .zero) throws -> NSImage {
            let imageSize: CGSize = calculateSize(width: width)
            return try toImage(size: imageSize)
        }
        
        public func toImage(height: CGFloat, insets: NSEdgeInsets = .zero) throws -> NSImage {
            let imageSize: CGSize = calculateSize(height: height)
            return try toImage(size: imageSize)
        }
        
        private func toImage(size: CGSize, insets: NSEdgeInsets = .zero) throws -> NSImage {
            let newSvgContent: String = try checkIfNeedResize(size: size)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let image = svg?.rasterize(with: size, scale: 1, insets: insets) else {
                throw EFQRCodeError.cannotCreateUIImage
            }
            
            return image
        }
#endif
        
        // MARK:- Video
#if canImport(AVFoundation)
        public func toMovData(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toVideoData(format: .mov, size: imageSize, insets: insets)
        }
        
        public func toM4vData(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toVideoData(format: .m4v, size: imageSize, insets: insets)
        }
        
        public func toMp4Data(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toVideoData(format: .mp4, size: imageSize, insets: insets)
        }
#endif
        
        // MARK:- GIF
        public func toGIFData(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toGIFData(size: imageSize, insets: insets)
        }
        
        public func toGIFData(height: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(height: height)
            return try toGIFData(size: imageSize, insets: insets)
        }
        
        private func toGIFData(size: CGSize, insets: EFEdgeInsets = .zero) throws -> Data {
            return try toAnimatedImage(format: EFAnimatedImageFormat.gif, size: size, insets: insets)
        }
        
        // MARK:- APNG
        public func toAPNGData(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toAPNGData(size: imageSize, insets: insets)
        }
        
        public func toAPNGData(height: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(height: height)
            return try toAPNGData(size: imageSize, insets: insets)
        }
        
        private func toAPNGData(size: CGSize, insets: EFEdgeInsets = .zero) throws -> Data {
            return try toAnimatedImage(format: EFAnimatedImageFormat.apng, size: size, insets: insets)
        }
        
        // MARK:- JPEG
        public func toJPEGData(width: CGFloat, compressionQuality: CGFloat = 1, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toJPEGData(size: imageSize, compressionQuality: compressionQuality, insets: insets)
        }
        
        public func toJPEGData(height: CGFloat, compressionQuality: CGFloat = 1, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(height: height)
            return try toJPEGData(size: imageSize, compressionQuality: compressionQuality, insets: insets)
        }
        
        private func toJPEGData(size: CGSize, compressionQuality: CGFloat = 1, insets: EFEdgeInsets = .zero) throws -> Data {
            let newSvgContent: String = try checkIfNeedResize(size: size)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let data = try svg?.jpegData(size: size, scale: 1, compressionQuality: compressionQuality, insets: insets) else {
                throw EFQRCodeError.cannotCreateImageData
            }
            
            return data
        }
        
        // MARK:- PNG
        public func toPNGData(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toPNGData(size: imageSize, insets: insets)
        }
        
        public func toPNGData(height: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(height: height)
            return try toPNGData(size: imageSize, insets: insets)
        }
        
        private func toPNGData(size: CGSize, insets: EFEdgeInsets = .zero) throws -> Data {
            let newSvgContent: String = try checkIfNeedResize(size: size)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let data = try svg?.pngData(size: size, scale: 1, insets: insets) else {
                throw EFQRCodeError.cannotCreateImageData
            }
            
            return data
        }

        // MARK:- PDF
        public func toPDFData(width: CGFloat, insets: SVG.Insets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toPDFData(size: imageSize, insets: insets)
        }
        
        public func toPDFData(height: CGFloat, insets: SVG.Insets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(height: height)
            return try toPDFData(size: imageSize, insets: insets)
        }
        
        private func toPDFData(size: CGSize, insets: SVG.Insets = .zero) throws -> Data {
            let newSvgContent: String = try checkIfNeedResize(size: size)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let data = try svg?.pdfData(size: size, insets: insets) else {
                throw EFQRCodeError.cannotCreateImageData
            }
            
            return data
        }
    }
}

extension EFQRCode.Generator {
    
    private func calculateSize(width: CGFloat) -> CGSize {
        let viewBox: CGRect = self.style.viewBox(qrcode: self.qrcode)
        let imageHeight: CGFloat = width / viewBox.width * viewBox.height
        return CGSize(width: width, height: imageHeight)
    }
    
    private func calculateSize(height: CGFloat) -> CGSize {
        let viewBox: CGRect = self.style.viewBox(qrcode: self.qrcode)
        let imageWidth: CGFloat = height / viewBox.height * viewBox.width
        return CGSize(width: imageWidth, height: height)
    }
    
    private func checkIfNeedResize(size: CGSize) throws -> String {
        func judgeImage(containerSize: CGSize, percentage: CGFloat, targetImage: CGImage, needRecreate: Bool) throws -> EFStyleParamImage? {
            let canvasSize: CGSize = CGSize(width: containerSize.width * percentage, height: containerSize.height * percentage)
            let imageSize: CGSize = CGSize(width: targetImage.width.cgFloat, height: targetImage.height.cgFloat)
            if imageSize.width > canvasSize.width || imageSize.height > canvasSize.height {
                let newImageSize = EFImageMode.scaleAspectFill.rectForContent(ofSize: imageSize, inCanvasOfSize: canvasSize)
                let resizedImage = try targetImage.resize(to: newImageSize.size)
                return EFStyleParamImage.static(image: resizedImage)
            }
            if needRecreate {
                return EFStyleParamImage.static(image: targetImage)
            }
            return nil
        }
        
        var (iconImage, watermarkImage) = style.getParamImages()
        var needRecreateIcon: Bool = false
        var needRecreateWatermark: Bool = false
        
        if let tryIcon = iconImage, let tryIconImage: CGImage = {
            switch tryIcon {
            case .static(let image):
                return image
            case .animated(let images, _):
                if let firstFrame = images.first {
                    needRecreateIcon = true
                    return firstFrame
                }
                return nil
            }
        }(), let resizedImage = try judgeImage(containerSize: size, percentage: 0.33, targetImage: tryIconImage, needRecreate: needRecreateIcon) {
            iconImage = resizedImage
            needRecreateIcon = true
        }
        if let tryWatermark = watermarkImage, let tryWatermarkImage: CGImage = {
            switch tryWatermark {
            case .static(let image):
                return image
            case .animated(let images, _):
                if let firstFrame = images.first {
                    needRecreateWatermark = true
                    return firstFrame
                }
                return nil
            }
        }(), let resizedImage = try judgeImage(containerSize: size, percentage: 1, targetImage: tryWatermarkImage, needRecreate: needRecreateWatermark) {
            watermarkImage = resizedImage
            needRecreateWatermark = true
        }
        
        let newSvgContent: String = try {
            if needRecreateIcon || needRecreateWatermark {
                return try style.copyWith(iconImage: iconImage, watermarkImage: watermarkImage).generateSVG(qrcode: qrcode)
            } else {
                return try toSVG()
            }
        }()
        return newSvgContent
    }
    
    private func getAnimatedFrames(size: CGSize, insets: EFEdgeInsets = .zero) throws -> ([CGImage], [CGFloat]) {
        return try {
            if self.isAnimated {
                let (iconImage, watermarkImage) = self.style.getParamImages()
                return try self.reconcileQRImages(image1: iconImage, image2: watermarkImage, style: self.style, size: size)
            } else {
                if let cgImage = try self.toImage(size: size, insets: insets).cgImage() {
                    return ([cgImage], [1])
                }
            }
            return ([], [])
        }()
    }
    
    private func toAnimatedImage(format: EFAnimatedImageFormat, size: CGSize, insets: EFEdgeInsets = .zero) throws -> Data {
        let (images, durations): ([CGImage], [CGFloat]) = try getAnimatedFrames(size: size, insets: insets)
        let animatedImageData = try self.createAnimatedImageDataWith(format: format, frames: images, frameDelays: durations)
        return animatedImageData
    }
    
    private func reconcileQRImages(image1: EFStyleParamImage?, image2: EFStyleParamImage?, style: EFQRCodeStyleBase, size: CGSize) throws -> ([CGImage], [CGFloat]) {
        let (iconFrames, watermarkFrames, delays) = self.reconcileFrameImages(image1: image1, image2: image2)
        var qrFrames = [CGImage?](repeating: nil, count: delays.count)
        
        let processorCount: Int = ProcessInfo.processInfo.activeProcessorCount
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = max(2, processorCount - 1)
        var encounteredError: Error?
        let errorLock = NSLock()
        
        for index in 0..<delays.count {
            queue.addOperation {
                autoreleasepool {
                    do {
                        let iconImage: EFStyleParamImage? = iconFrames.isEmpty ? nil : EFStyleParamImage.static(image: iconFrames[index])
                        let watermarkImage: EFStyleParamImage? = watermarkFrames.isEmpty ? nil : EFStyleParamImage.static(image: watermarkFrames[index])
                        let frameStyle: EFQRCodeStyleBase = style.copyWith(iconImage: iconImage, watermarkImage: watermarkImage)
                        let tempGenerator: EFQRCode.Generator = EFQRCode.Generator(self.qrcode, styleImplementation: frameStyle)
                        let qrFrame = try tempGenerator.toImage(size: size)
                        guard let qrFrameCGImage = qrFrame.cgImage() else {
                            throw EFQRCodeError.cannotCreateCGImage
                        }
                        qrFrames[index] = qrFrameCGImage
                    } catch {
                        errorLock.lock()
                        if encounteredError == nil {
                            encounteredError = error
                            queue.cancelAllOperations()
                        }
                        errorLock.unlock()
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        if let error = encounteredError {
            throw error
        }
        
        let finalQRFrames = qrFrames.compactMap { $0 }
        return (finalQRFrames, delays)
    }
    
    private func reconcileFrameImages(image1: EFStyleParamImage?, image2: EFStyleParamImage?) -> ([CGImage], [CGImage], [CGFloat]) {
        if let image1 = image1 {
            if let image2 = image2 {
                let (frames1, delays1) = self.frameImages(image: image1)
                let (frames2, delays2) = self.frameImages(image: image2)
                
                if frames1.count == 1 {
                    let resultImages1 = [CGImage](repeating: frames1[0], count: frames2.count)
                    return (resultImages1, frames2, delays2)
                } else if frames2.count == 1 {
                    let resultImages2 = [CGImage](repeating: frames2[0], count: frames1.count)
                    return (frames1, resultImages2, delays1)
                } else {
                    let duration1: CGFloat = delays1.reduce(0, +)
                    let duration2: CGFloat = delays2.reduce(0, +)
                    let duration: CGFloat = lcm(duration1, duration2)
                    let repeatCount1: Int = lround(duration / duration1)
                    let repeatCount2: Int = lround(duration / duration2)
                    
                    var resultImages1: [CGImage] = [], resultImages2: [CGImage] = [], resultDelays: [CGFloat] = []
                    let imagesCount1: Int = frames1.count
                    let imagesCount2: Int = frames2.count
                    let maxIndex1: Int = repeatCount1 * imagesCount1 - 1
                    let maxIndex2: Int = repeatCount2 * imagesCount2 - 1
                    var index1: Int = 0, index2: Int = 0
                    var remainDelay: CGFloat = 0
                    var remainIs1: Bool = true
                    var durationLeft: CGFloat = duration
                    
                    repeat {
                        let arrayIndex1: Int = index1 % imagesCount1
                        let arrayIndex2: Int = index2 % imagesCount2
                        let frame1: CGImage = frames1[arrayIndex1]
                        let frame2: CGImage = frames2[arrayIndex2]
                        let delay1: CGFloat = delays1[arrayIndex1]
                        let delay2: CGFloat = delays2[arrayIndex2]
                        var currentDelay: CGFloat = delay1
                        
                        if remainDelay == 0 {
                            if delay1 < delay2 {
                                index1 += 1
                                remainDelay = delay2 - delay1
                                remainIs1 = false
                                currentDelay = delay1
                            } else if delay1 > delay2 {
                                index2 += 1
                                remainDelay = delay1 - delay2
                                remainIs1 = true
                                currentDelay = delay2
                            } else {
                                index1 += 1
                                index2 += 1
                                remainDelay = 0
                                remainIs1 = true
                                currentDelay = delay1
                            }
                        } else {
                            if remainIs1 {
                                if remainDelay < delay2 {
                                    index1 += 1
                                    remainDelay = delay2 - remainDelay
                                    remainIs1 = false
                                    currentDelay = remainDelay
                                } else if remainDelay > delay2 {
                                    index2 += 1
                                    remainDelay = remainDelay - delay2
                                    remainIs1 = true
                                    currentDelay = delay2
                                } else {
                                    index1 += 1
                                    index2 += 1
                                    remainDelay = 0
                                    remainIs1 = true
                                    currentDelay = delay1
                                }
                            } else {
                                if delay1 < remainDelay {
                                    index1 += 1
                                    remainDelay = remainDelay - delay1
                                    remainIs1 = false
                                    currentDelay = delay1
                                } else if delay1 > remainDelay {
                                    index2 += 1
                                    remainDelay = delay1 - remainDelay
                                    remainIs1 = true
                                    currentDelay = remainDelay
                                } else {
                                    index1 += 1
                                    index2 += 1
                                    remainDelay = 0
                                    remainIs1 = true
                                    currentDelay = delay1
                                }
                            }
                        }
                        
                        resultImages1.append(frame1)
                        resultImages2.append(frame2)
                        
                        let tryDurationLeft: CGFloat = durationLeft - currentDelay
                        if tryDurationLeft <= 0.001 {
                            resultDelays.append(durationLeft)
                        } else {
                            resultDelays.append(currentDelay)
                        }
                        durationLeft = tryDurationLeft
                        
                        if durationLeft <= 0.001 || index1 > maxIndex1 || index2 > maxIndex2 {
                            break
                        }
                    } while (true)
                    
                    return (resultImages1, resultImages2, resultDelays)
                }
            } else {
                let (frames, delays) = frameImages(image: image1)
                return (frames, [], delays)
            }
        } else {
            if let image2 = image2 {
                let (frames, delays) = frameImages(image: image2)
                return ([], frames, delays)
            }
        }
        return ([], [], [])
    }
    
    private func frameImages(image: EFStyleParamImage) -> ([CGImage], [CGFloat]) {
        switch image {
        case .static(let image):
            return ([image], [1])
        case .animated(let images, let imageDelays):
            return (images, imageDelays)
        }
    }
    
    private func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a, b = b
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return abs(a)
    }
    
    private func lcm(_ a: Int, _ b: Int) -> Int {
        return (a / gcd(a, b)) * b
    }
    
    private func rationalApproximation(of x: Double, withPrecision eps: Double = 1.0E-6) -> (Int, Int) {
        var x = x
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0 / (x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    
    private func lcm(_ a: CGFloat, _ b: CGFloat, precision: Int = 1) -> CGFloat {
        let precision = 1.0 / pow(10, Double(precision))
        let (num1, den1) = rationalApproximation(of: Double(a), withPrecision: precision)
        let (num2, den2) = rationalApproximation(of: Double(b), withPrecision: precision)
        let lcmDen = lcm(den1, den2)
        let lcmNum = lcm(num1 * (lcmDen / den1), num2 * (lcmDen / den2))
        return CGFloat(lcmNum) / CGFloat(lcmDen)
    }
    
    private func createAnimatedImageDataWith(format: EFAnimatedImageFormat, frames: [CGImage], frameDelays: [CGFloat]) throws -> Data {
        if frames.isEmpty || frames.count != frameDelays.count {
            throw EFQRCodeError.cannotCreateAnimatedImage
        }
        let (framePropertiesArray, fileProperties): ([CFDictionary], CFDictionary) = {
            switch format {
            case .gif:
                return (
                    frameDelays.map { delay in
                        [kCGImagePropertyGIFDictionary as String: [
                            kCGImagePropertyGIFDelayTime as String: delay,
                            kCGImagePropertyGIFUnclampedDelayTime as String: delay
                        ]]
                    } as [CFDictionary],
                    [
                        kCGImagePropertyGIFDictionary as String: [
                            kCGImagePropertyGIFLoopCount as String: 0
                        ]
                    ] as CFDictionary
                )
            case .apng:
                return (
                    frameDelays.map { delay in
                        [kCGImagePropertyPNGDictionary as String: [
                            kCGImagePropertyAPNGDelayTime as String: delay,
                            kCGImagePropertyAPNGUnclampedDelayTime as String: delay
                        ]]
                    } as [CFDictionary],
                    [
                        kCGImagePropertyPNGDictionary as String: [
                            kCGImagePropertyAPNGLoopCount as String: 0
                        ]
                    ] as CFDictionary
                )
            }
        }()
        return try self.createAnimatedImageDataWith(
            format: format,
            frames: frames,
            framePropertiesArray: framePropertiesArray,
            fileProperties: fileProperties
        )
    }
    
    private func createAnimatedImageDataWith(format: EFAnimatedImageFormat, frames: [CGImage], framePropertiesArray: [CFDictionary], fileProperties: CFDictionary) throws -> Data {
        guard let mutableData = CFDataCreateMutable(nil, 0) else {
            throw EFQRCodeError.cannotCreateMutableData
        }
        guard let destination = CGImageDestinationCreateWithData(mutableData, format.identifier, frames.count, nil) else {
            throw EFQRCodeError.cannotCreateCGImageDestination
        }
        CGImageDestinationSetProperties(destination, fileProperties)
        for (index, image) in frames.enumerated() {
            CGImageDestinationAddImage(destination, image, framePropertiesArray[index])
        }
        guard CGImageDestinationFinalize(destination) else {
            throw EFQRCodeError.cannotFinalizeCGImageDestination
        }
        return mutableData as Data
    }
    
#if canImport(AVFoundation)
    private func toVideoData(format: EFVideoFormat, size: CGSize, insets: EFEdgeInsets = .zero) throws -> Data {
        let (images, durations): ([CGImage], [CGFloat]) = try getAnimatedFrames(size: size, insets: insets)
        let animatedImageData = try self.createVideoDataWith(format: format, frames: images, frameDelays: durations)
        return animatedImageData
    }
    
    private func createVideoDataWith(format: EFVideoFormat, frames: [CGImage], frameDelays: [CGFloat]) throws -> Data {
        if frames.isEmpty || frames.count != frameDelays.count {
            throw EFQRCodeError.cannotCreateVideo
        }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + "." + format.fileExtension)
        
        let width = frames[0].width
        let height = frames[0].height
        let fps: Float = 30.0
        let frameDuration = 1.0 / Double(fps)
        
        guard let assetWriter = try? AVAssetWriter(outputURL: outputURL, fileType: format.fileType) else {
            throw EFQRCodeError.cannotCreateVideo
        }
        
        let videoSettings = format.videoSettings.merging([
            AVVideoWidthKey: width,
            AVVideoHeightKey: height
        ]) { (_, new) in new }
        
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        writerInput.expectsMediaDataInRealTime = false
        
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: writerInput,
            sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
                kCVPixelBufferWidthKey as String: width,
                kCVPixelBufferHeightKey as String: height
            ]
        )
        
        assetWriter.add(writerInput)
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: .zero)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let attributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
            kCVPixelBufferIOSurfacePropertiesKey as String: [:]
        ]
        
        var pixelBufferPool: CVPixelBufferPool?
        CVPixelBufferPoolCreate(kCFAllocatorDefault, nil, attributes as CFDictionary, &pixelBufferPool)
        
        guard let pool = pixelBufferPool else {
            throw EFQRCodeError.cannotCreateVideo
        }
        
        let frameQueue = DispatchQueue(label: "com.ef.qrcode.frameQueue")
        writerInput.requestMediaDataWhenReady(on: frameQueue) {
            var accumulatedTime: Double = 0.0
            
            for (frameIndex, (frame, originalDelay)) in zip(frames, frameDelays).enumerated() {
                let targetTime = accumulatedTime + Double(originalDelay)
                
                while accumulatedTime < targetTime {
                    var pixelBuffer: CVPixelBuffer?
                    CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &pixelBuffer)
                    
                    guard let buffer = pixelBuffer else { return }
                    
                    CVPixelBufferLockBaseAddress(buffer, [])
                    let pixelData = CVPixelBufferGetBaseAddress(buffer)
                    let colorSpace = CGColorSpaceCreateDeviceRGB()
                    
                    guard let context = CGContext(
                        data: pixelData,
                        width: width,
                        height: height,
                        bitsPerComponent: 8,
                        bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                        space: colorSpace,
                        bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
                    ) else {
                        CVPixelBufferUnlockBaseAddress(buffer, [])
                        return
                    }
                    
                    context.clear(CGRect(x: 0, y: 0, width: width, height: height))
                    context.draw(frame, in: CGRect(x: 0, y: 0, width: width, height: height))
                    CVPixelBufferUnlockBaseAddress(buffer, [])
                    
                    let remainingTime = targetTime - accumulatedTime
                    if remainingTime < frameDuration * 0.5 && frameIndex < frames.count - 1 {
                        break
                    }
                    
                    let presentationTime = CMTime(
                        seconds: accumulatedTime,
                        preferredTimescale: CMTimeScale(fps * 10)
                    )
                    
                    while !writerInput.isReadyForMoreMediaData {
                        Thread.sleep(forTimeInterval: 0.1)
                    }
                    
                    adaptor.append(buffer, withPresentationTime: presentationTime)
                    accumulatedTime += frameDuration
                }
            }
            
            writerInput.markAsFinished()
            assetWriter.finishWriting {
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        
        if assetWriter.status == .failed {
            throw assetWriter.error ?? EFQRCodeError.cannotCreateVideo
        }
        
        let videoData = try Data(contentsOf: outputURL)
        try? FileManager.default.removeItem(at: outputURL)
        return videoData
    }
#endif
}
