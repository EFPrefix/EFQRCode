//
//  EFQRCode+ObjC.swift
//  EFQRCode
//
//  Created by Apollo Zhu on 11/25/20.
//
//  Copyright (c) 2020 EyreFree <eyrefree@eyrefree.org>
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
    public func generateGIF(watermarkGIF data: Data) -> Data? {
        return EFQRCode.generateGIF(using: self, withWatermarkGIF: data)
    }

    @available(swift, obsoleted: 1.0)
    public func generateGIF(watermarkGIF data: Data,
                            delay: Double, loopCount: Int,
                            useMultipleThreads: Bool) -> Data? {
        return EFQRCode.generateGIF(
            using: self, withWatermarkGIF: data,
            delay: delay, loopCount: loopCount,
            useMultipleThreads: useMultipleThreads
        )
    }
}
