//
//  NSImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/11/17.
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

import Cocoa

// https://stackoverflow.com/questions/39925248/swift-on-macos-how-to-save-nsimage-to-disk
extension NSImage {

    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            return nil
        }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

#if canImport(AppKit)
import AppKit
import CoreImage

public extension NSImage {
    
    func ciImage() -> CIImage? {
        return tiffRepresentation(using: .none, factor: 0).flatMap(CIImage.init)
    }

    func cgImage() -> CGImage? {
        return cgImage(forProposedRect: nil, context: nil, hints: nil) ?? ciImage()?.cgImage()
    }
}
#endif

#if canImport(CoreImage)
import CoreImage

#if canImport(UIKit)
import UIKit
#endif

public extension CIImage {

    func cgImage() -> CGImage? {
        if #available(iOS 10, macOS 10.12, tvOS 10, watchOS 2, *) {
            if let cgImage = cgImage {
                return cgImage
            }
        }
        return CIContext().createCGImage(self, from: extent)
    }

    #if canImport(UIKit)
    func uiImage() -> UIImage {
        return UIImage(ciImage: self)
    }
    #endif
}
#endif
