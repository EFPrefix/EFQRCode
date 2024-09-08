//
//  EFQRCodeX.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/1.
//  Copyright © 2023 EyreFree. All rights reserved.
//

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

import QRCodeSwift
import SwiftDraw

public extension EFQRCode {
    
    @objcMembers
    class Generator {
        private let qrcode: QRCode
        private var style: EFQRCodeStyle
        
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
            
            self.style = style
        }
        
        public func changeStyle(to style: EFQRCodeStyle) {
            self.style = style
            self.svgContent = nil
        }
        
        private var svgContent: String?
        public func generateSVG() throws -> String {
            if let svgContent = svgContent {
                return svgContent
            }
            let svgString = try self.style.generateSVG(qrcode: qrcode)
            self.svgContent = svgString
            return svgString
        }
        
        public lazy var isAnimated: Bool = {
            if let svgContent = try? generateSVG() {
                return svgContent.contains("<animate")
            }
            return false
        }()
        
        func checkIfNeedResize(size: CGSize, svgContent: String) throws -> String {
            var newSvgContent: String = svgContent
            if self.isAnimated == false {
                var (iconImage, watermarkImage) = self.style.getParamImages()
                var needResize: Bool = false
                if let tryIcon = iconImage, case .static(let tryIconImage) = tryIcon {
                    let canvasSize: CGSize = CGSize(width: size.width * 0.33, height: size.height * 0.33)
                    let imageSize: CGSize = CGSize(width: tryIconImage.width.cgFloat, height: tryIconImage.height.cgFloat)
                    if imageSize.width > canvasSize.width || imageSize.height > canvasSize.height {
                        let newImageSize = EFWatermarkMode.scaleAspectFill.rectForWatermark(ofSize: imageSize, inCanvasOfSize: canvasSize)
                        if let resizedImage = try tryIconImage.resize(to: newImageSize.size) {
                            iconImage = EFStyleParamImage.static(image: resizedImage)
                            needResize = true
                        }
                    }
                }
                if let tryWatermark = watermarkImage, case .static(let tryWatermarkImage) = tryWatermark {
                    let canvasSize: CGSize = CGSize(width: size.width, height: size.height)
                    let imageSize: CGSize = CGSize(width: tryWatermarkImage.width.cgFloat, height: tryWatermarkImage.height.cgFloat)
                    if imageSize.width > canvasSize.width || imageSize.height > canvasSize.height {
                        let newImageSize = EFWatermarkMode.scaleAspectFill.rectForWatermark(ofSize: imageSize, inCanvasOfSize: canvasSize)
                        if let resizedImage = try tryWatermarkImage.resize(to: newImageSize.size) {
                            watermarkImage = EFStyleParamImage.static(image: resizedImage)
                            needResize = true
                        }
                    }
                }
                if needResize {
                    newSvgContent = try self.style.copyWith(iconImage: iconImage, watermarkImage: watermarkImage).generateSVG(qrcode: self.qrcode)
                }
            }
            return newSvgContent
        }
        
#if canImport(UIKit)
        public func toImage(size: CGSize) throws -> UIImage {
            let svgContent = try generateSVG()
            return try self.toImage(size: size, svgContent: svgContent)
        }
        
        func toImage(size: CGSize, svgContent: String) throws -> UIImage {
            let newSvgContent: String = try checkIfNeedResize(size: size, svgContent: svgContent)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let image = svg?.rasterize(with: size, scale: 1) else {
                throw EFQRCodeError.cannotCreateUIImage
            }
            
            return image
        }
#endif
        
#if canImport(AppKit)
        public func toImage(size: CGSize) throws -> NSImage {
            let svgContent = try generateSVG()
            return try self.toImage(size: size, svgContent: svgContent)
        }
        
        func toImage(size: CGSize, svgContent: String) throws -> NSImage {
            let newSvgContent: String = try checkIfNeedResize(size: size, svgContent: svgContent)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let image = svg?.rasterize(with: size, scale: 1) else {
                throw EFQRCodeError.cannotCreateUIImage
            }
            
            return image
        }
#endif
        
        public func toAnimatedImage(format: EFAnimatedImageFormat, size: CGSize) throws -> Data {
            let (images, durations): ([CGImage], [CGFloat]) = try {
                if self.isAnimated {
                    let (iconImage, watermarkImage) = self.style.getParamImages()
                    return try self.reconcileQRImages(image1: iconImage, image2: watermarkImage, style: self.style, size: size)
                } else {
                    if let cgImage = try self.toImage(size: size).cgImage() {
                        return ([cgImage], [1])
                    }
                }
                return ([], [])
            }()
            let animatedImageData = try self.createAnimatedImageDataWith(format: format, frames: images, frameDelays: durations)
            return animatedImageData
        }
    }
}

extension EFQRCode.Generator {
    
    private func reconcileQRImages(image1: EFStyleParamImage?, image2: EFStyleParamImage?, style: EFQRCodeStyle, size: CGSize) throws -> ([CGImage], [CGFloat]) {
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
                        let svgContent: String = try frameStyle.generateSVG(qrcode: self.qrcode)
                        let qrFrame = try self.toImage(size: size, svgContent: svgContent)
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
}
