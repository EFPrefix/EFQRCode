//
//  EFQRCode+Migration-v6.swift
//  EFQRCode
//
//  Created by Apollo Zhu on 11/25/20.
//  Copyright © 2020 EyreFree. All rights reserved.
//

#if canImport(CoreImage)
import CoreImage
#endif
import CoreGraphics
import Foundation

extension EFQRCode {
    #if canImport(CoreImage)
    @available(*, deprecated, renamed: "recognize(_:)")
    public static func recognize(image: CGImage) -> [String]? {
        return recognize(image)
    }
    #endif


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
            for: content, encoding: contentEncoding, size: size,
            backgroundColor: backgroundColor, foregroundColor: foregroundColor,
            watermark: watermark, watermarkMode: watermarkMode, watermarkIsTransparent: allowTransparent,
            inputCorrectionLevel: inputCorrectionLevel,
            icon: icon, iconSize: iconSize,
            pointShape: pointShape, pointOffset: foregroundPointOffset,
            mode: mode, magnification: magnification
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
            size: size,
            backgroundColor: backgroundColor, foregroundColor: foregroundColor,
            watermark: watermark, watermarkMode: watermarkMode, watermarkIsTransparent: allowTransparent,
            inputCorrectionLevel: inputCorrectionLevel,
            icon: icon, iconSize: iconSize,
            pointShape: pointShape, pointOffset: foregroundPointOffset,
            mode: mode, magnification: magnification
        )
    }

    @available(*, deprecated, renamed: "generateGIF(withIntputGIF:using:savingTo:delay:loopCount:useMultipleThreads:)")
    public static func generateWithGIF(data: Data, generator: EFQRCodeGenerator, pathToSave: URL? = nil, delay: Double? = nil, loopCount: Int? = nil, useMultipleThread:Bool = false) -> Data? {
        return generateGIF(using: generator, withIntputGIF: data,
                           savingTo: pathToSave,
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
    #if canImport(CoreImage)
    @nonobjc
    @available(*, deprecated, renamed: "withColors(backgroundColor:foregroundColor:)")
    public func setColors(backgroundColor: CIColor, foregroundColor: CIColor) {
        withColors(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
    }
    #endif
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
}

#if canImport(CoreImage)
extension EFQRCodeRecognizer {
    @available(*, deprecated, message: "Set `image` property directly.")
    public func setImage(image: CGImage?) {
        self.image = image
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
