//
//  CGImage++.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/3.
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
#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif
#if canImport(MobileCoreServices)
import MobileCoreServices
#endif
#if canImport(CoreImage)
import CoreImage
#endif

/**
 * Extensions for CGImage to support QR code generation and processing.
 *
 * This extension provides utility methods for CGImage that are used throughout
 * the EFQRCode library for image processing, format conversion, and manipulation.
 *
 * ## Features
 *
 * - PNG data generation and base64 encoding
 * - Grayscale conversion for QR code recognition
 * - Image clipping and transparency handling
 * - Core Image integration for advanced processing
 * - Image resizing and cropping operations
 */
extension CGImage {
    
    /**
     * Converts the CGImage to PNG data.
     *
     * This method creates PNG data from the CGImage using Core Graphics
     * image destination APIs. The resulting data can be used for file
     * saving or network transmission.
     *
     * - Returns: PNG data representation of the image.
     * - Throws: `EFQRCodeError` if PNG data creation fails.
     */
    func pngData() throws -> Data {
        let imageIdentifier: CFString = {
            if #available(iOS 14, macOS 11, tvOS 14, watchOS 7, *) {
                return UTType.png.identifier as CFString
            } else {
                return kUTTypePNG
            }
        }()
        guard let mutableData = CFDataCreateMutable(nil, 0) else {
            throw EFQRCodeError.cannotCreateMutableData
        }
        guard let destination = CGImageDestinationCreateWithData(mutableData, imageIdentifier, 1, nil) else {
            throw EFQRCodeError.cannotCreateCGImageDestination
        }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else {
            throw EFQRCodeError.cannotFinalizeCGImageDestination
        }
        return mutableData as Data
    }
    
    /**
     * Converts the CGImage to a base64-encoded PNG data URL.
     *
     * This method creates a data URL that can be used directly in HTML
     * or web applications. The format is: `data:image/png;base64,<base64-data>`
     *
     * - Returns: A base64-encoded PNG data URL string.
     * - Throws: `EFQRCodeError` if PNG data creation fails.
     */
    func pngBase64EncodedString() throws -> String {
        return "data:image/png;base64," + (try pngData().base64EncodedString())
    }
    
    /**
     * Converts the CGImage to grayscale.
     *
     * This method creates a grayscale version of the image, which is useful
     * for QR code recognition when the original image has poor contrast or
     * when trying to improve recognition accuracy.
     *
     * - Returns: A grayscale CGImage, or nil if conversion fails.
     * - Throws: `EFQRCodeError` if grayscale conversion fails.
     */
    func grayscale() throws -> CGImage? {
        guard let context = CGContext(
            data: nil,
            width: self.width,
            height: self.height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * self.width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            throw EFQRCodeError.cannotCreateCGContext
        }
        context.draw(self, in: CGRect(origin: .zero, size: CGSize(width: self.width, height: self.height)))
        return context.makeImage()
    }
    
#if canImport(CoreImage)
    /**
     * Converts the CGImage to a CIImage.
     *
     * This method creates a CIImage from the CGImage, enabling the use of
     * Core Image filters and processing capabilities.
     *
     * - Returns: A CIImage representation of the CGImage.
     */
    func ciImage() -> CIImage {
        return CIImage(cgImage: self)
    }
#endif
    
    /**
     * Clips the image to the specified rectangle and handles transparency.
     *
     * This method crops the image to the specified rectangle and handles
     * transparency expansion. If the rectangle matches the image bounds,
     * the original image is returned unchanged.
     *
     * - Parameter rect: The rectangle to clip the image to.
     * - Returns: A clipped CGImage.
     * - Throws: `EFQRCodeError` if image clipping fails.
     */
    func clipAndExpandingTransparencyWith(rect: CGRect) throws -> CGImage {
        let imageWidth: CGFloat = self.width.cgFloat
        let imageHeight: CGFloat = self.height.cgFloat
        
        if rect.minX == 0 && rect.minY == 0 && rect.width == imageWidth && rect.height == imageHeight {
            return self
        }
        if rect.minX >= 0 && rect.minY >= 0 && rect.maxX <= imageWidth && rect.maxY <= imageHeight {
            guard let imageResized = self.cropping(to: rect) else {
                throw EFQRCodeError.cannotCreateCGImage
            }
            return imageResized
        }
        
        let newWidth: Int = rect.width.int
        let newHeight: Int = rect.height.int
        guard let context = CGContext(
            data: nil,
            width: newWidth,
            height: newHeight,
            bitsPerComponent: 8,
            bytesPerRow: 4 * newWidth,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw EFQRCodeError.cannotCreateCGContext
        }
        context.clear(CGRect(origin: .zero, size: rect.size))
        let drawRect: CGRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: imageWidth, height: imageHeight)
        context.draw(self, in: drawRect)
        guard let imageResized = context.makeImage() else {
            throw EFQRCodeError.cannotCreateCGImage
        }
        return imageResized
    }
    
    func resize(to newSize: CGSize) throws -> CGImage {
        if newSize.width == self.width.cgFloat && newSize.height == self.height.cgFloat { return self }
        
        let newWidth: Int = newSize.width.int
        let newHeight: Int = newSize.height.int
        guard let context = CGContext(
            data: nil,
            width: newWidth,
            height: newHeight,
            bitsPerComponent: 8,
            bytesPerRow: 4 * newWidth,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw EFQRCodeError.cannotCreateCGContext
        }
        context.draw(self, in: CGRect(origin: .zero, size: CGSize(width: newWidth, height: newHeight)))
        guard let imageResized = context.makeImage() else {
            throw EFQRCodeError.cannotCreateCGImage
        }
        return imageResized
    }
}
