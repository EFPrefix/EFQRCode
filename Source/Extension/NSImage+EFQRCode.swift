//
//  NSImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2024/7/27.
//  Copyright © 2024 EyreFree. All rights reserved.
//

#if !canImport(UIKit)
import AppKit
import CoreImage

extension NSImage {
    func ciImage() -> CIImage? {
        return self.tiffRepresentation(using: .none, factor: 0).flatMap(CIImage.init)
    }

    func cgImage() -> CGImage? {
        return self.cgImage(forProposedRect: nil, context: nil, hints: nil) ?? ciImage()?.cgImage()
    }
}
#endif
