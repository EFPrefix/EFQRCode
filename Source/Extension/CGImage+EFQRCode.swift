//
//  CGImage++.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/3.
//  Copyright © 2023 EyreFree. All rights reserved.
//

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

extension CGImage {
    
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
    
    func pngBase64EncodedString() throws -> String {
        return "data:image/png;base64," + (try pngData().base64EncodedString())
    }
    
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
    func ciImage() -> CIImage {
        return CIImage(cgImage: self)
    }
#endif
    
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
            bytesPerRow: newWidth * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw EFQRCodeError.cannotCreateCGContext
        }
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
            bytesPerRow: newWidth * 4,
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
