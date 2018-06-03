//
//  EFQRCode+GIF.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/10/23.
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

import Foundation
import CoreGraphics
import ImageIO

#if os(macOS)
import CoreServices
#else
import MobileCoreServices
#endif

public extension EFQRCode {

    private static let framesPerSecond = 24
    public static var tempResultPath: URL?

    private static func batchWatermark(frames: inout [CGImage], generator: EFQRCodeGenerator, start: Int, end: Int) {
        var index =  start
        while index <= end {
            generator.setWatermark(watermark: frames[index])
            if let frameWithCode = generator.generate() {
                frames[index] = frameWithCode
            }
            index += 1
        }
    }
    
    public static func generateWithGIF(data: Data, generator: EFQRCodeGenerator, pathToSave: URL? = nil, delay: Double? = nil, loopCount: Int? = nil, useMultipleThread:Bool = false) -> Data? {
        if let source = CGImageSourceCreateWithData(data as CFData, nil) {
            var frames = source.toCGImages()

            var fileProperties = CGImageSourceCopyProperties(source, nil)
            var framePropertiesArray = [CFDictionary]()

            var index: Int = 0
            while frames.count > index {
                if let framePropertie = CGImageSourceCopyPropertiesAtIndex(source, index, nil) {
                    framePropertiesArray.append(framePropertie)
                }

                index += 1
            }

            if let delay = delay {
                for (index, value) in framePropertiesArray.enumerated() {
                    if var tempDict = value as? [String: Any] {
                        if var gifDict = tempDict[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                            gifDict.updateValue(delay, forKey: kCGImagePropertyGIFDelayTime as String)
                            tempDict.updateValue(gifDict, forKey: kCGImagePropertyGIFDictionary as String)
                        }
                        framePropertiesArray[index] = tempDict as CFDictionary
                    }
                }
            }

            if let loopCount = loopCount {
                if var tempDict = fileProperties as? [String: Any] {
                    if var gifDict = tempDict[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                        gifDict.updateValue(loopCount, forKey: kCGImagePropertyGIFLoopCount as String)
                        tempDict.updateValue(gifDict, forKey: kCGImagePropertyGIFDictionary as String)
                    }
                    fileProperties = tempDict as CFDictionary
                }
            }

            if useMultipleThread {
                let group = DispatchGroup()

                let threshold = frames.count / framesPerSecond
                var i: Int = 0

                while i < threshold {
                    let local = i
                    group.enter()
                    DispatchQueue.global(qos: .default).async {
                        batchWatermark(frames: &frames, generator: generator, start: local * framesPerSecond, end: (local + 1) * framesPerSecond - 1)
                        group.leave()
                    }
                    i += 1
                }

                group.enter()
                DispatchQueue.global(qos: .default).async {
                    batchWatermark(frames: &frames, generator: generator, start: i * 20, end: frames.count - 1)
                    group.leave()
                }

                group.wait()
                
            } else {
                // Clear watermark
                for (index, frame) in frames.enumerated() {
                    generator.setWatermark(watermark: frame)
                    if let frameWithCode = generator.generate() {
                        frames[index] = frameWithCode
                    }
                }
            }
            
            if let fileProperties = fileProperties, framePropertiesArray.count == frames.count {
                if let url = frames.saveToGIFFile(framePropertiesArray: framePropertiesArray, fileProperties: fileProperties, url: pathToSave) {
                    return try? Data(contentsOf: url)
                }
            }
        }
        return nil
    }
}

public extension CGImageSource {

    // GIF
    public func toCGImages() -> [CGImage] {
        var frames = [CGImage]()
        let gifCount = CGImageSourceGetCount(self)
        for index in 0 ..< gifCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(self, index, nil) {
                frames.append(cgImage)
            }
        }
        return frames
    }
}

extension Array where Element: CGImage {

    public func saveToGIFFile(framePropertiesArray: [CFDictionary], fileProperties: CFDictionary, url: URL? = nil) -> URL? {
        var fileURL = url
        if nil == fileURL {
            let documentsDirectoryURL: URL? = try? FileManager.default.url(
                for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
            )
            // The URL to write to. If the URL already exists, the data at this location is overwritten.
            fileURL = documentsDirectoryURL?.appendingPathComponent("EFQRCode_temp.gif")
        }
        EFQRCode.tempResultPath = fileURL

        if let url = fileURL as CFURL? {
            if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, self.count, nil) {
                CGImageDestinationSetProperties(destination, fileProperties)
                for (index, image) in self.enumerated() {
                    CGImageDestinationAddImage(destination, image, framePropertiesArray[index])
                }
                if !CGImageDestinationFinalize(destination) {
                    // Failed to finalize the image destination
                    return nil
                }
                return fileURL
            }
        }
        // Can't create path
        return nil
    }
}
