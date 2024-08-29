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
        
#if canImport(UIKit)
        public func toImage(size: CGSize) throws -> UIImage {
            let svgContent = try generateSVG()
            return try self.toImage(size: size, svgContent: svgContent)
        }
        
        func toImage(size: CGSize, svgContent: String) throws -> UIImage {
            guard let svgData = svgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(svgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let image = svg?.rasterize(with: size) else {
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
            guard let svgData = svgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(svgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let image = svg?.rasterize(with: size) else {
                throw EFQRCodeError.cannotCreateUIImage
            }
            
            return image
        }
#endif
        
        public func toGIFData(size: CGSize) throws -> Data {
            let (images, durations) = try {
                if self.isAnimated {
                    let (iconImage, watermarkImage) = self.style.getParamImages()
                    return try self.reconcileQRImages(image1: iconImage, image2: watermarkImage, style: self.style, size: size)
                }
                if let cgImage = try self.toImage(size: size).cgImage() {
                    return ([cgImage], [0.02])
                }
                return ([], [])
            }()
            
            return try self.createGIFDataWith(frames: images, frameDelays: durations)
        }
    }
}

extension EFQRCode.Generator {
    
    // todo 这里可以加多线程
    private func reconcileQRImages(image1: EFStyleParamImage?, image2: EFStyleParamImage?, style: EFQRCodeStyle, size: CGSize) throws -> ([CGImage], [CGFloat]) {
        let (iconFrames, watermarkFrames, delays) = self.reconcileFrameImages(image1: image1, image2: image2)
        print(delays.count)
        var qrFrames: [CGImage] = []
        for index in 0..<delays.count {
            let iconImage: EFStyleParamImage? = iconFrames.isEmpty ? nil : EFStyleParamImage.static(image: iconFrames[index])
            let watermarkImage: EFStyleParamImage? = watermarkFrames.isEmpty ? nil : EFStyleParamImage.static(image: watermarkFrames[index])
            let frameStyle: EFQRCodeStyleBase = style.copyWith(iconImage: iconImage, watermarkImage: watermarkImage)
            let svgContent: String = try frameStyle.generateSVG(qrcode: self.qrcode)
            let qrFrame = try self.toImage(size: size, svgContent: svgContent)
            guard let qrFrameCGImage = qrFrame.cgImage() else {
                throw EFQRCodeError.cannotCreateCGImage
            }
            qrFrames.append(qrFrameCGImage)
        }
        
        return (qrFrames, delays)
    }
    
    // todo 这里可以优化两图合并算法
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
            } else {
                return ([], [], [])
            }
        }
    }
    
    private func frameImages(image: EFStyleParamImage) -> ([CGImage], [CGFloat]) {
        switch image {
        case .static(let image):
            return ([image], [0.02])
        case .animated(let images, let imageDelays):
            return (images, imageDelays)
        }
    }
    
    private func gcd(_ a: Int, _ b: Int) -> Int {
        let r = a % b
        return r != 0 ? gcd(b, r) : b
    }
    
    private func lcm(_ a: Int, _ b: Int) -> Int {
        return a * b / gcd(a, b)
    }
    
    private func lcm(_ a: CGFloat, _ b: CGFloat, precision: Int = 1) -> CGFloat {
        let factor = CGFloat(pow(10, Double(precision)))
        let intA = Int(a * factor)
        let intB = Int(b * factor)
        let lcmInt = lcm(intA, intB)
        return CGFloat(lcmInt) / factor
    }
    
    private func createGIFDataWith(frames: [CGImage], frameDelays: [CGFloat]) throws -> Data {
        if frames.isEmpty || frames.count != frameDelays.count {
            throw EFQRCodeError.cannotCreateGIF
        }
        let framePropertiesArray: [[String: Any]] = frameDelays.map { delay in
            [kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFDelayTime as String: delay,
                kCGImagePropertyGIFUnclampedDelayTime as String: delay
            ]]
        }
        let fileProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFLoopCount as String: 0,
                kCGImagePropertyGIFHasGlobalColorMap as String: true
            ],
            kCGImageDestinationLossyCompressionQuality as String: 1.0
        ]
        return try self.createGIFDataWith(
            frames: frames,
            framePropertiesArray: framePropertiesArray as [CFDictionary],
            fileProperties: fileProperties as CFDictionary
        )
    }
    
    private func createGIFDataWith(frames: [CGImage], framePropertiesArray: [CFDictionary], fileProperties: CFDictionary) throws -> Data {
        guard let mutableData = CFDataCreateMutable(nil, 0) else {
            throw EFQRCodeError.cannotCreateMutableData
        }
        guard let destination = CGImageDestinationCreateWithData(mutableData, kUTTypeGIF, frames.count, nil) else {
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
