//
//  EFQRCode+ObjC.swift
//  EFQRCode
//
//  Created by Apollo Zhu on 11/25/20.
//  Copyright © 2020 EyreFree. All rights reserved.
//

import CoreGraphics
import Foundation

extension EFQRCodeGenerator {
    @available(swift, obsoleted: 1.0)
    public convenience init(content: String, encoding: UInt, size: EFIntSize) {
        let encoding = String.Encoding(rawValue: encoding)
        self.init(content: content, encoding: encoding, size: size)
    }

    @discardableResult
    @available(swift, obsoleted: 1.0)
    public func withContent(_ content: String, encoding: UInt) -> EFQRCodeGenerator {
        return withContent(content, encoding: String.Encoding(rawValue: encoding))
    }

    @discardableResult
    @available(swift, obsoleted: 1.0, renamed: "withMode")
    public func withNormalMode() -> EFQRCodeGenerator {
        return withMode(nil)
    }
    @discardableResult
    @available(swift, obsoleted: 1.0, renamed: "withMode")
    public func withGrayscaleMode() -> EFQRCodeGenerator {
        return withMode(.grayscale)
    }
    @discardableResult
    @available(swift, obsoleted: 1.0, renamed: "withMode")
    public func withBinarizationMode(threshold: CGFloat) -> EFQRCodeGenerator {
        return withMode(.binarization(threshold: threshold))
    }

    @discardableResult
    @available(swift, obsoleted: 1.0)
    public func withWatermark(_ watermark: CGImage, mode: EFWatermarkMode) -> EFQRCodeGenerator {
        return withWatermark(watermark, mode: mode)
    }

    @available(swift, obsoleted: 1.0)
    public func generateGIF(inputGIF data: Data) -> Data? {
        return EFQRCode.generateGIF(using: self, withWatermarkGIF: data)
    }

    @available(swift, obsoleted: 1.0)
    public func generateGIF(inputGIF data: Data, savingTo pathToSave: URL, delay: Double, loopCount: Int, useMultipleThreads: Bool) -> Data? {
        return EFQRCode.generateGIF(
            using: self, withWatermarkGIF: data, savingTo: pathToSave,
            delay: delay, loopCount: loopCount,
            useMultipleThreads: useMultipleThreads
        )
    }
}
