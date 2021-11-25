//
//  EFQRCode+Migration-v6.swift
//  EFQRCode
//
//  Created by Apollo Zhu on 11/25/20.
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

import CoreGraphics
import Foundation

// MARK: - Deprecated
extension EFQRCode {
    @available(*, deprecated, renamed: "generate(for:encoding:size:backgroundColor:foregroundColor:watermark:watermarkMode:inputCorrectionLevel:icon:iconSize:watermarkIsTransparent:pointShape:mode:magnification:pointOffset:)")
    public static func generate(
        content: String,
        contentEncoding: String.Encoding = .utf8,
        size: EFIntSize = EFIntSize(width: 600, height: 600),
        backgroundColor: CGColor = CGColor.white()!,
        foregroundColor: CGColor = CGColor.black()!,
        watermark: CGImage? = nil,
        watermarkMode: EFWatermarkMode = .scaleAspectFill,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        icon: CGImage? = nil,
        iconSize: EFIntSize? = nil,
        allowTransparent: Bool = true,
        pointShape: EFPointShape = .square,
        mode: EFQRCodeMode = .none,
        magnification: EFIntSize? = nil,
        foregroundPointOffset: CGFloat = 0
    ) -> CGImage? {
        return generate(
            for: content, encoding: contentEncoding,
            inputCorrectionLevel: inputCorrectionLevel,
            size: size, magnification: magnification,
            backgroundColor: backgroundColor, foregroundColor: foregroundColor,
            watermark: watermark, watermarkMode: watermarkMode, watermarkIsTransparent: allowTransparent,
            icon: icon, iconSize: iconSize,
            pointShape: pointShape, pointOffset: foregroundPointOffset,
            mode: mode
        )
    }
    
    @available(*, deprecated, renamed: "generateGIF(for:encoding:size:backgroundColor:foregroundColor:watermark:watermarkMode:inputCorrectionLevel:icon:iconSize:watermarkIsTransparent:pointShape:mode:magnification:pointOffset:)")
    public static func generateWithGIF(
        content: String,
        contentEncoding: String.Encoding = .utf8,
        size: EFIntSize = EFIntSize(width: 600, height: 600),
        backgroundColor: CGColor = CGColor.white()!,
        foregroundColor: CGColor = CGColor.black()!,
        watermark: Data,
        watermarkMode: EFWatermarkMode = .scaleAspectFill,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        icon: CGImage? = nil,
        iconSize: EFIntSize? = nil,
        allowTransparent: Bool = true,
        pointShape: EFPointShape = .square,
        mode: EFQRCodeMode = .none,
        magnification: EFIntSize? = nil,
        foregroundPointOffset: CGFloat = 0
    ) -> Data? {
        return generateGIF(
            for: content, encoding: contentEncoding,
            inputCorrectionLevel: inputCorrectionLevel,
            size: size, magnification: magnification,
            backgroundColor: backgroundColor, foregroundColor: foregroundColor,
            watermark: watermark, watermarkMode: watermarkMode, watermarkIsTransparent: allowTransparent,
            icon: icon, iconSize: iconSize,
            pointShape: pointShape, pointOffset: foregroundPointOffset,
            mode: mode
        )
    }
    
    @available(*, deprecated, renamed: "generate(for:encoding:inputCorrectionLevel:size:magnification:backgroundColor:foregroundColor:watermark:watermarkMode:watermarkIsTransparent:icon:iconSize:pointStyle:pointOffset:isTimingPointStyled:mode:)")
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
        pointShape: EFPointShape,
        pointOffset: CGFloat = 0,
        isTimingPointStyled: Bool = false,
        mode: EFQRCodeMode? = nil
    ) -> CGImage? {
        return generate(
            for: content, encoding: encoding,
            inputCorrectionLevel: inputCorrectionLevel,
            size: size, magnification: magnification,
            backgroundColor: backgroundColor, foregroundColor: foregroundColor,
            watermark: watermark, watermarkMode: watermarkMode,
            watermarkIsTransparent: isWatermarkTransparent,
            icon: icon, iconSize: iconSize,
            pointStyle: pointShape.efPointStyle, pointOffset: pointOffset,
            isTimingPointStyled: isTimingPointStyled,
            mode: mode
        )
    }
    
    @available(*, deprecated, renamed: "generateGIF(for:encoding:inputCorrectionLevel:size:magnification:backgroundColor:foregroundColor:watermark:watermarkMode:watermarkIsTransparent:icon:iconSize:pointStyle:pointOffset:isTimingPointStyled:mode:)")
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
        pointShape: EFPointShape,
        pointOffset: CGFloat = 0,
        isTimingPointStyled: Bool = false,
        mode: EFQRCodeMode? = nil
    ) -> Data? {
        return generateGIF(
            for: content, encoding: encoding,
            inputCorrectionLevel: inputCorrectionLevel,
            size: size, magnification: magnification,
            backgroundColor: backgroundColor, foregroundColor: foregroundColor,
            watermark: watermark, watermarkMode: watermarkMode,
            watermarkIsTransparent: isWatermarkTransparent,
            icon: icon, iconSize: iconSize,
            pointStyle: pointShape.efPointStyle, pointOffset: pointOffset,
            isTimingPointStyled: isTimingPointStyled,
            mode: mode
        )
    }
    
    @available(*, deprecated, renamed: "generateGIF(withWatermarkGIF:using:savingTo:delay:loopCount:useMultipleThreads:)")
    public static func generateWithGIF(
        data: Data, generator: EFQRCodeGenerator, pathToSave: URL? = nil,
        delay: Double? = nil, loopCount: Int? = nil,
        useMultipleThread: Bool = false
    ) -> Data? {
        return generateGIF(using: generator, withWatermarkGIF: data,
                           delay: delay, loopCount: loopCount,
                           useMultipleThreads: useMultipleThread)
    }
}

extension EFQRCodeGenerator {
    @available(*, deprecated, renamed: "withContent(_:)")
    public func setContent(content: String) {
        withContent(content)
    }
    @available(*, deprecated, renamed: "withContentEncoding(_:)")
    public func setContentEncoding(encoding: String.Encoding) {
        withContentEncoding(encoding)
    }
    @available(*, deprecated, renamed: "withMode(_:)")
    public func setMode(mode: EFQRCodeMode) {
        withMode(mode)
    }
    @available(*, deprecated, renamed: "withInputCorrectionLevel(_:)")
    public func setInputCorrectionLevel(inputCorrectionLevel: EFInputCorrectionLevel) {
        withInputCorrectionLevel(inputCorrectionLevel)
    }
    @available(*, deprecated, renamed: "withSize(_:)")
    public func setSize(size: EFIntSize) {
        withSize(size)
    }
    @available(*, deprecated, renamed: "withMagnification(_:)")
    public func setMagnification(magnification: EFIntSize?) {
        withMagnification(magnification)
    }
    @available(*, deprecated, renamed: "withColors(backgroundColor:foregroundColor:)")
    public func setColors(backgroundColor: CGColor, foregroundColor: CGColor) {
        withColors(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
    }
    @available(*, deprecated, renamed: "withIcon(_:size:)")
    public func setIcon(icon: CGImage?, size: EFIntSize?) {
        self.icon = icon
        self.iconSize = size
    }
    @available(*, deprecated, renamed: "withWatermark(_:mode:)")
    public func setWatermark(watermark: CGImage?, mode: EFWatermarkMode? = nil) {
        withWatermark(watermark, mode: mode)
    }
    @available(*, deprecated, renamed: "withPointOffset(_:)")
    public func setForegroundPointOffset(foregroundPointOffset: CGFloat) {
        withPointOffset(foregroundPointOffset)
    }
    @available(*, deprecated, renamed: "withTransparentWatermark(_:)")
    public func setAllowTransparent(allowTransparent: Bool) {
        withTransparentWatermark(allowTransparent)
    }
    @available(*, deprecated, renamed: "withPointShape(_:)")
    public func setPointShape(pointShape: EFPointShape) {
        withPointShape(pointShape)
    }
    @available(*, deprecated, renamed: "withStyledTimingPoint(_:)")
    public func setIgnoreTiming(ignoreTiming isTimingStyled: Bool) {
        withStyledTimingPoint(isTimingStyled)
    }
    @available(*, deprecated, renamed: "minMagnification(greaterThanOrEqualTo:)")
    public func minMagnificationGreaterThanOrEqualTo(size: CGFloat) -> Int? {
        return minMagnification(greaterThanOrEqualTo: size)
    }
    @available(*, deprecated, renamed: "maxMagnification(lessThanOrEqualTo:)")
    public func maxMagnificationLessThanOrEqualTo(size: CGFloat) -> Int? {
        return maxMagnification(lessThanOrEqualTo: size)
    }
}

#if canImport(CoreImage)
import CoreImage

extension EFQRCode {
    @available(*, deprecated, renamed: "recognize(_:)")
    public static func recognize(image: CGImage?) -> [String]? {
        guard let image = image else { return nil }
        return recognize(image)
    }
}

extension EFQRCodeRecognizer {
    @available(*, deprecated, message: "Set `image` property directly.")
    public func setImage(image: CGImage) {
        self.image = image
    }
}

extension EFQRCodeGenerator {
    @nonobjc
    @available(*, deprecated, renamed: "withColors(backgroundColor:foregroundColor:)")
    public func setColors(backgroundColor: CIColor, foregroundColor: CIColor) {
        withColors(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
    }
}
#endif

extension CGColor {
    @available(*, deprecated, renamed: "white(_:alpha:)")
    static func white(white: CGFloat, alpha: CGFloat = 1.0) -> CGColor? {
        return CGColor.white(white, alpha: alpha)
    }

    @available(*, deprecated, renamed: "black(_:alpha:)")
    static func black(black: CGFloat, alpha: CGFloat = 1.0) -> CGColor? {
        return CGColor.black(black, alpha: alpha)
    }
}

/// Shapes of foreground code points.
@available(*, deprecated, message: "Use EFPointStyle instead.")
@objc public enum EFPointShape: Int {
    /// Classical QR code look and feel 🔳.
    case square         = 0
    /// More well rounded 🔘.
    case circle         = 1
    /// Sparkling ✨.
    case diamond        = 2
    
    fileprivate var efPointStyle: EFPointStyle {
        switch self {
        case .square: return EFSquarePointStyle.square
        case .circle: return EFCirclePointStyle.circle
        case .diamond: return EFDiamondPointStyle.diamond
        }
    }
}

extension EFQRCodeGenerator {
    /// Shape of foreground code points, defaults to `EFPointShape.square`.
    @available(*, deprecated, renamed: "pointStyle")
    public var pointShape: EFPointShape {
        get {
            switch pointStyle {
            case is EFSquarePointStyle: return .square
            case is EFCirclePointStyle: return .circle
            case is EFDiamondPointStyle: return .diamond
            default: fatalError("Custom pointStyle not supported in pointShape API")
            }
        }
        set {
            pointStyle = newValue.efPointStyle
        }
    }
    /// Set generator to use the specified foreground point shape.
    /// - Parameter pointShape: Shape of foreground code points.
    /// - Returns: `self`, allowing chaining.
    @available(*, deprecated, renamed: "withPointStyle(_:)")
    @discardableResult
    public func withPointShape(_ pointShape: EFPointShape) -> EFQRCodeGenerator {
        return with(\.pointShape, pointShape)
    }
}
