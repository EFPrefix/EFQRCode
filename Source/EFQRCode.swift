//
//  EFQRCode.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/3/28.
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

#if canImport(CoreImage)
import CoreImage
#endif

public class EFQRCode {
    // MARK: - Recognizer
    #if canImport(CoreImage)
    public static func recognize(_ image: CGImage) -> [String]? {
        return EFQRCodeRecognizer(image: image).recognize()
    }
    #endif

    // MARK: - Generator
    public static func generate(
        for content: String,
        encoding: String.Encoding = .utf8,
        size: EFIntSize = EFIntSize(width: 600, height: 600),
        backgroundColor: CGColor = .white()!,
        foregroundColor: CGColor = .black()!,
        watermark: CGImage? = nil,
        watermarkMode: EFWatermarkMode = .scaleAspectFill,
        watermarkIsTransparent isWatermarkTransparent: Bool = true,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        icon: CGImage? = nil,
        iconSize: EFIntSize? = nil,
        pointShape: EFPointShape = .square,
        mode: EFQRCodeMode? = nil,
        magnification: EFIntSize? = nil,
        foregroundPointOffset: CGFloat = 0
    ) -> CGImage? {
        return EFQRCodeGenerator(content: content, encoding: encoding, size: size)
            .withWatermark(watermark, mode: watermarkMode)
            .withColors(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
            .withInputCorrectionLevel(inputCorrectionLevel)
            .withIcon(icon, size: iconSize ?? EFIntSize(width: size.width / 5, height: size.height / 5))
            .withTransparentWatermark(isWatermarkTransparent)
            .withPointShape(pointShape)
            .withMode(mode)
            .withMagnification(magnification)
            .withForegroundPointOffset(foregroundPointOffset)
            .generate()
    }

    public static func generateGIF(
        for content: String,
        encoding: String.Encoding = .utf8,
        size: EFIntSize = EFIntSize(width: 600, height: 600),
        backgroundColor: CGColor = .white()!,
        foregroundColor: CGColor = .black()!,
        watermark: Data,
        watermarkMode: EFWatermarkMode = .scaleAspectFill,
        watermarkIsTransparent isWatermarkTransparent: Bool = true,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        icon: CGImage? = nil,
        iconSize: EFIntSize? = nil,
        pointShape: EFPointShape = .square,
        mode: EFQRCodeMode? = nil,
        magnification: EFIntSize? = nil,
        foregroundPointOffset: CGFloat = 0
    ) -> Data? {
        let generator = EFQRCodeGenerator(content: content, encoding: encoding, size: size)
            .withWatermark(nil, mode: watermarkMode)
            .withColors(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
            .withInputCorrectionLevel(inputCorrectionLevel)
            .withIcon(icon, size: iconSize ?? EFIntSize(width: size.width / 5, height: size.height / 5))
            .withTransparentWatermark(isWatermarkTransparent)
            .withPointShape(pointShape)
            .withMode(mode)
            .withMagnification(magnification)
            .withForegroundPointOffset(foregroundPointOffset)
        return EFQRCode.generateGIF(using: generator, withWatermark: watermark)
    }
}
