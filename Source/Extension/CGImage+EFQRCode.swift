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
    
    func clipImageToSquare() -> CGImage? {
        let width: CGFloat = self.width.cgFloat
        let height: CGFloat = self.height.cgFloat
        if width == height { return self }
        
        let squareSize: CGFloat = min(width, height)
        let x: CGFloat = (width - squareSize) / 2.0
        let y: CGFloat = (height - squareSize) / 2.0
        let rect: CGRect = CGRect(x: x, y: y, width: squareSize, height: squareSize)
        
        let croppedCGImage = self.cropping(to: rect)
        return croppedCGImage
    }
    
    func resize(to newSize: CGSize) throws -> CGImage? {
        let newWidth: Int = newSize.width.int
        let newHeight: Int = newSize.height.int
        let bitsPerComponent = self.bitsPerComponent
        let bytesPerRow = newWidth * self.bytesPerRow / self.width
        let colorSpace = self.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = self.bitmapInfo
        guard let context = CGContext(
            data: nil,
            width: newWidth,
            height: newHeight,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            throw EFQRCodeError.cannotCreateCGContext
        }
        context.draw(self, in: CGRect(origin: .zero, size: CGSize(width: newWidth, height: newHeight)))
        return context.makeImage()
    }
}
