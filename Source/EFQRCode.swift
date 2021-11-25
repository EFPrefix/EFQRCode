//
//  EFQRCode.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/3/28.
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

import Foundation
import CoreGraphics

#if canImport(CoreImage)
import CoreImage
#endif

/// Swift convenient API for EFQRCode module.
public enum EFQRCode {
    // MARK: - Recognizer
    #if canImport(CoreImage)

    /// Recognizes and returns the contents of a QR code `image`.
    /// - Parameter image: a QR code to recognize.
    /// - Returns: an array of contents recognized from `image`.
    /// - Note: If the returned array is empty, there's no recognizable content in the QR code `image`.
    public static func recognize(_ image: CGImage) -> [String] {
        return EFQRCodeRecognizer(image: image).recognize()
    }
    #endif

    // MARK: - Generator
    /// Generates a QR code image.
    /// - Parameters:
    ///   - content: The message of the QR code.
    ///   - encoding: The encoding to use for `content`.
    ///   - inputCorrectionLevel: The level of error tolerance percentage.
    ///   - size: The size of the output image, ignored if `magnification` is set.
    ///   - magnification: The ratio of final size to smallest possible size
    ///   - backgroundColor: Background color of the QR code, defaults to white.
    ///   - foregroundColor: Foreground color for code points, defaults to black.
    ///   - watermark: The background image to use, if any.
    ///   - watermarkMode: How to position the `watermark`, defaults to aspect fill.
    ///   - isWatermarkTransparent: Wether to use the alpha channel in watermark image.
    ///   - icon: The icon that appears in the center of QR code image, if any.
    ///   - iconSize: Size of the `icon`, defaults to 20% of `size`.
    ///   - pointStyle: Foreground code point style, defaults to square.
    ///   - pointOffset: How much are foreground points shifted.
    ///   - isTimingPointStyled: Wether the timing points should be styled (or remain square).
    ///   - mode: The color rendering mode, defaults to original colors.
    /// - Returns: The generated QR code image.
    public static func generate(
        for content: String,
        encoding: String.Encoding = .utf8,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        size: EFIntSize = EFIntSize(width: 600, height: 600),
        magnification: EFIntSize? = nil,
        backgroundColor: CGColor = .white()!,
        foregroundColor: CGColor = .black()!,
        watermark: CGImage? = nil,
        watermarkMode: EFWatermarkMode = .scaleAspectFill,
        watermarkIsTransparent isWatermarkTransparent: Bool = true,
        icon: CGImage? = nil,
        iconSize: EFIntSize? = nil,
        pointStyle: EFPointStyle = EFSquarePointStyle.square,
        pointOffset: CGFloat = 0,
        isTimingPointStyled: Bool = false,
        mode: EFQRCodeMode? = nil
    ) -> CGImage? {
        return EFQRCodeGenerator(content: content, encoding: encoding, size: size)
            .withWatermark(watermark, mode: watermarkMode)
            .withColors(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
            .withInputCorrectionLevel(inputCorrectionLevel)
            .withIcon(icon, size: iconSize ?? EFIntSize(width: size.width / 5, height: size.height / 5))
            .withTransparentWatermark(isWatermarkTransparent)
            .withPointStyle(pointStyle)
            .withMode(mode)
            .withMagnification(magnification)
            .withPointOffset(pointOffset)
            .withStyledTimingPoint(isTimingPointStyled)
            .generate()
    }

    /// Generates an animated QR code image.
    /// - Parameters:
    ///   - content: The message of the QR code.
    ///   - encoding: The encoding to use for `content`.
    ///   - inputCorrectionLevel: The level of error tolerance percentage.
    ///   - size: The size of the output image, ignored if `magnification` is set.
    ///   - magnification: The ratio of final size to smallest possible size
    ///   - backgroundColor: Background color of the QR code, defaults to white.
    ///   - foregroundColor: Foreground color for code points, defaults to black.
    ///   - watermark: The data of background GIF to use.
    ///   - watermarkMode: How to position the `watermark`, defaults to aspect fill.
    ///   - isWatermarkTransparent: Wether to use the alpha channel in watermark image.
    ///   - icon: The icon that appears in the center of QR code image, if any.
    ///   - iconSize: Size of the `icon`, defaults to 20% of `size`.
    ///   - pointStyle: Foreground code point style, defaults to square.
    ///   - pointOffset: How much are foreground points shifted.
    ///   - isTimingPointStyled: Wether the timing points should be styled (or remain square).
    ///   - mode: The color rendering mode, defaults to original colors.
    /// - Returns: The generated QR code GIF.
    public static func generateGIF(
        for content: String,
        encoding: String.Encoding = .utf8,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        size: EFIntSize = EFIntSize(width: 600, height: 600),
        magnification: EFIntSize? = nil,
        backgroundColor: CGColor = .white()!,
        foregroundColor: CGColor = .black()!,
        watermark: Data,
        watermarkMode: EFWatermarkMode = .scaleAspectFill,
        watermarkIsTransparent isWatermarkTransparent: Bool = true,
        icon: CGImage? = nil,
        iconSize: EFIntSize? = nil,
        pointStyle: EFPointStyle = EFSquarePointStyle.square,
        pointOffset: CGFloat = 0,
        isTimingPointStyled: Bool = false,
        mode: EFQRCodeMode? = nil
    ) -> Data? {
        let generator = EFQRCodeGenerator(content: content, encoding: encoding, size: size)
            .withWatermark(nil, mode: watermarkMode)
            .withColors(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
            .withInputCorrectionLevel(inputCorrectionLevel)
            .withIcon(icon, size: iconSize ?? EFIntSize(width: size.width / 5, height: size.height / 5))
            .withTransparentWatermark(isWatermarkTransparent)
            .withPointStyle(pointStyle)
            .withMode(mode)
            .withMagnification(magnification)
            .withPointOffset(pointOffset)
            .withStyledTimingPoint(isTimingPointStyled)
        return EFQRCode.generateGIF(using: generator, withWatermarkGIF: watermark)
    }
}
