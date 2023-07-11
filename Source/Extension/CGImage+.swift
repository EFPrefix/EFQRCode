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
    
    var grayscale: CGImage? {
        guard let context = CGContext(
            data: nil,
            width: self.width,
            height: self.height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * self.width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            return nil
        }
        context.draw(self, in: CGRect(origin: .zero, size: CGSize(width: self.width, height: self.height)))
        return context.makeImage()
    }
    
    #if canImport(CoreImage)
    func ciImage() -> CIImage {
        return CIImage(cgImage: self)
    }
    #endif
}
