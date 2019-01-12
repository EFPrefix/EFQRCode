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

#if os(iOS) || os(tvOS) || os(macOS)
import CoreImage
#endif

@objcMembers
public class EFQRCode: NSObject {

    // MARK: - Recognizer
    #if os(iOS) || os(tvOS) || os(macOS)
    public static func recognize(image: CGImage) -> [String]? {
        return EFQRCodeRecognizer(image: image).recognize()
    }
    #endif

    // MARK: - Generator
    public static func generate(
        content: String,
        size: EFIntSize = EFIntSize(width: 600, height: 600),
        backgroundColor: CGColor = CGColor.EFWhite(),
        foregroundColor: CGColor = CGColor.EFBlack(),
        watermark: CGImage? = nil,
        watermarkMode: EFWatermarkMode = .scaleAspectFill,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        icon: CGImage? = nil,
        iconSize: EFIntSize? = nil,
        allowTransparent: Bool = true,
        pointShape: EFPointShape = .square,
        mode: EFQRCodeMode = .none,
        binarizationThreshold: CGFloat = 0.5,
        magnification: EFIntSize? = nil,
        foregroundPointOffset: CGFloat = 0
        ) -> CGImage? {

        let generator = EFQRCodeGenerator(content: content, size: size)
        generator.setWatermark(watermark: watermark, mode: watermarkMode)
        generator.setColors(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        generator.setInputCorrectionLevel(inputCorrectionLevel: inputCorrectionLevel)
        generator.setIcon(icon: icon, size: iconSize ?? EFIntSize(width: size.width / 5, height: size.height / 5))
        generator.setAllowTransparent(allowTransparent: allowTransparent)
        generator.setPointShape(pointShape: pointShape)
        generator.setMode(mode: mode)
        generator.setBinarizationThreshold(binarizationThreshold: binarizationThreshold)
        generator.setMagnification(magnification: magnification)
        generator.setForegroundPointOffset(foregroundPointOffset: foregroundPointOffset)
        return generator.generate()
    }

    public static func generateWithGIF(
        content: String,
        size: EFIntSize = EFIntSize(width: 600, height: 600),
        backgroundColor: CGColor = CGColor.EFWhite(),
        foregroundColor: CGColor = CGColor.EFBlack(),
        watermark: Data,
        watermarkMode: EFWatermarkMode = .scaleAspectFill,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        icon: CGImage? = nil,
        iconSize: EFIntSize? = nil,
        allowTransparent: Bool = true,
        pointShape: EFPointShape = .square,
        mode: EFQRCodeMode = .none,
        binarizationThreshold: CGFloat = 0.5,
        magnification: EFIntSize? = nil,
        foregroundPointOffset: CGFloat = 0
        ) -> Data? {

        let generator = EFQRCodeGenerator(content: content, size: size)
        generator.setWatermark(watermark: nil, mode: watermarkMode)
        generator.setColors(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        generator.setInputCorrectionLevel(inputCorrectionLevel: inputCorrectionLevel)
        generator.setIcon(icon: icon, size: iconSize ?? EFIntSize(width: size.width / 5, height: size.height / 5))
        generator.setAllowTransparent(allowTransparent: allowTransparent)
        generator.setPointShape(pointShape: pointShape)
        generator.setMode(mode: mode)
        generator.setBinarizationThreshold(binarizationThreshold: binarizationThreshold)
        generator.setMagnification(magnification: magnification)
        generator.setForegroundPointOffset(foregroundPointOffset: foregroundPointOffset)
        return EFQRCode.generateWithGIF(data: watermark, generator: generator)
    }
}
