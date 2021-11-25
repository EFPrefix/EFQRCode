//
//  EFQRCodeGenerator.swift
//  EFQRCode
//
//  Created by EyreFree on 17/1/24.
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

#if canImport(CoreImage)
import CoreImage
#else
import QRCodeSwift
#endif
import CoreGraphics
import Foundation

/// Class for generating QR code images.
@objcMembers
public class EFQRCodeGenerator: NSObject {
    /// Update the property specified the key path to have a new value.
    /// - Parameters:
    ///   - keyPath: A property to update.
    ///   - newValue: The new value for the specified property.
    /// - Returns: `self`, allowing chaining.
    @inlinable
    @discardableResult
    public func with<T>(_ keyPath: ReferenceWritableKeyPath<EFQRCodeGenerator, T>,
                        _ newValue: T) -> EFQRCodeGenerator {
        self[keyPath: keyPath] = newValue
        return self
    }

    // MARK: - Content Parameters

    /// Content to include in the generated QR Code.
    /// - Important: Limited to at most 1273 characters.
    /// - Note: The density of the QR-lattice increases with the increases of the content length.
    public var content: String? {
        didSet {
            clearCache()
        }
    }
    /// Sets the generator to generate for content using the specified encoding.
    /// - Parameters:
    ///   - content: The new content to generate QR code for.
    ///   - encoding: The encoding to use for generating data from `content`.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withContent(_ content: String, encoding: String.Encoding? = nil) -> EFQRCodeGenerator {
        self.content = content
        if let encoding = encoding {
            return withContentEncoding(encoding)
        }
        return self
    }

    /// Encoding for `content`.
    public var contentEncoding: String.Encoding = .utf8 {
        didSet {
            clearCache()
        }
    }
    /// Sets the generator to use the specified encoding.
    /// - Parameter encoding: The encoding to use for generating data from `content`.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withContentEncoding(_ encoding: String.Encoding) -> EFQRCodeGenerator {
        return with(\.contentEncoding, encoding)
    }

    /// Level of error tolerance.
    ///
    /// - L 7%
    /// - M 15%
    /// - Q 25%
    /// - H 30%(Default)
    public var inputCorrectionLevel: EFInputCorrectionLevel = .h {
        didSet {
            clearCache()
        }
    }
    /// Sets the generator to use the specified input correction level.
    /// - Parameter inputCorrectionLevel: level of error-tolerant rate.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withInputCorrectionLevel(_ inputCorrectionLevel: EFInputCorrectionLevel) -> EFQRCodeGenerator {
        return with(\.inputCorrectionLevel, inputCorrectionLevel)
    }

    // MARK: - Style Parameters

    /// Color mode of QR Code, defaults to `nil`.
    public var mode: EFQRCodeMode? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    /// Sets the generator to use the specified coloring `mode`.
    /// - Parameter mode: The new coloring mode to use.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withMode(_ mode: EFQRCodeMode?) -> EFQRCodeGenerator {
        return with(\.mode, mode)
    }

    /// Size of the QR code, defaults to 256 by 256.
    ///
    /// - Note: Will be overridden by non-`nil` `magnification` parameter.
    public var size: EFIntSize = EFIntSize(width: 256, height: 256) {
        didSet {
            imageQRCode = nil
        }
    }
    /// Sets the generator to use the specified size.
    /// - Parameter size: The width and height desired.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withSize(_ size: EFIntSize) -> EFQRCodeGenerator {
        return with(\.size, size)
    }

    /// The ratio of actual size to the smallest possible size, defaults to `nil`.
    ///
    /// - Note: Any non-`nil` value overrides the `size` parameter.
    /// If you already have a desired size in mind, we have two helpers methods at your disposal to
    /// calculate the magnification that results in the closet dimension:
    /// - `maxMagnification(lessThanOrEqualTo:)`
    /// - `minMagnification(greaterThanOrEqualTo:)`
    ///
    /// ```
    /// let generator = EFQRCodeGenerator(...)
    ///
    /// // get max magnification where size ≤ desired size
    /// if let maxMagnification = generator
    ///     .maxMagnification(lessThanOrEqualTo: desiredSize) {
    ///     generator.magnification = EFIntSize(
    ///         width: maxMagnification,
    ///         height: maxMagnification
    ///     )
    /// }
    /// // or get min magnification where size ≥ desired size
    /// if let minMagnification = generator
    ///     .minMagnification(greaterThanOrEqualTo: desiredSize) {
    ///     generator.magnification = EFIntSize(
    ///         width: minMagnification,
    ///         height: minMagnification
    ///     )
    /// }
    ///
    /// // then generate
    /// generator.generate()
    /// ```
    public var magnification: EFIntSize? {
        didSet {
            imageQRCode = nil
        }
    }
    /// Sets the generator to use the specified magnification.
    /// - Parameter magnification: The desired scale factor in comparison to the intrinsic size.
    ///     See `magnification` for more details on how to translate your desired size to the
    ///     closest magnification.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withMagnification(_ magnification: EFIntSize?) -> EFQRCodeGenerator {
        return with(\.magnification, magnification)
    }

    /// Background color, defaults to white.
    public var backgroundColor: CGColor = CGColor.white()! {
        didSet {
            imageQRCode = nil
        }
    }
    /// Foreground color (for code points), defaults to black.
    public var foregroundColor: CGColor = CGColor.black()! {
        didSet {
            imageQRCode = nil
        }
    }
    #if canImport(CoreImage)
    /// Sets the generator to use the specified `CIColor`s.
    /// - Parameters:
    ///   - backgroundColor: The background `CIColor`.
    ///     If conversion to `CGColor` fails, will use white instead.
    ///   - foregroundColor: The foreground `CIColor` for code points.
    ///     If conversion to `CGColor` fails, will use black instead.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    @objc(withCIColorsForBackgroundColor:foregroundColor:)
    public func withColors(backgroundColor: CIColor, foregroundColor: CIColor) -> EFQRCodeGenerator {
        return withColors(backgroundColor: backgroundColor.cgColor() ?? CGColor.white()!,
                          foregroundColor: foregroundColor.cgColor() ?? CGColor.black()!)
    }
    #endif

    /// Sets the generator to use the specified `CGColor`s.
    /// - Parameters:
    ///   - backgroundColor: The background `CGColor`.
    ///   - foregroundColor: The foreground `CGColor` for code points.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    @objc(withCGColorsForBackgroundColor:foregroundColor:)
    public func withColors(backgroundColor: CGColor, foregroundColor: CGColor) -> EFQRCodeGenerator {
        return self
            .with(\.backgroundColor, backgroundColor)
            .with(\.foregroundColor, foregroundColor)
    }

    /// Icon image in the center of QR code image, defaults to `nil`.
    public var icon: CGImage? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    /// Size of the icon image, defaults to 20% of `size` if `nil`.
    public var iconSize: EFIntSize? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    /// Sets the generator to use the specified icon in the specified size.
    /// - Parameters:
    ///   - icon: Icon image in the center of QR code.
    ///   - size: Size of the icon image, `nil` means to 20% of QR code size.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withIcon(_ icon: CGImage?, size: EFIntSize?) -> EFQRCodeGenerator {
        return self
            .with(\.icon, icon)
            .with(\.iconSize, size)
    }

    /// Background watermark image, defaults to `nil`.
    public var watermark: CGImage? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    /// How to position and size the watermark, defaults to `EFWatermarkMode.scaleAspectFill`.
    public var watermarkMode: EFWatermarkMode = .scaleAspectFill {
        didSet {
            imageQRCode = nil
        }
    }
    /// Sets the generator to use the specified watermark (and mode).
    /// - Parameters:
    ///   - watermark: The background watermark image.
    ///   - mode: How to position and size the watermark,
    ///     `nil` (the default) means use the current `watermarkMode`.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withWatermark(_ watermark: CGImage?, mode: EFWatermarkMode? = nil) -> EFQRCodeGenerator {
        self.watermark = watermark

        if let mode = mode {
            self.watermarkMode = mode
        }
        return self
    }

    /// Foreground point offset, defaults to 0.
    ///
    /// - Important: Generated QR code might be hard to recognize with non-zero values.
    public var pointOffset: CGFloat = 0 {
        didSet {
            imageQRCode = nil
        }
    }
    /// Sets the generator to use the specified point offset.
    /// - Parameter pointOffset: Foreground point offset.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withPointOffset(_ pointOffset: CGFloat) -> EFQRCodeGenerator {
        return with(\.pointOffset, pointOffset)
    }

    /// If `false` (default), area of watermark where alpha is 0 will be transparent.
    public var isWatermarkOpaque: Bool = false {
        didSet {
            imageQRCode = nil
        }
    }
    /// Set generator to treat watermark image as opaque (or not).
    /// - Parameter isWatermarkOpaque: Should ignore alpha channel or not, defaults to `true`.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withOpaqueWatermark(_ isWatermarkOpaque: Bool = true) -> EFQRCodeGenerator {
        return with(\.isWatermarkOpaque, isWatermarkOpaque)
    }
    /// Set generator to treat watermark image as transparent (or not).
    /// - Parameter isTransparent: Should use alpha channel or not, defaults to `true`.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withTransparentWatermark(_ isTransparent: Bool = true) -> EFQRCodeGenerator {
        return withOpaqueWatermark(!isTransparent)
    }

    /// Style of foreground code points, defaults to `EFPointStyle.square`.
    public var pointStyle: EFPointStyle = EFSquarePointStyle.square {
        didSet {
            imageQRCode = nil
        }
    }
    /// Set generator to use the specified foreground point style.
    /// - Parameter pointStyle: Style of foreground code points.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withPointStyle(_ pointStyle: EFPointStyle) -> EFQRCodeGenerator {
        return with(\.pointStyle, pointStyle)
    }

    /// If `true` (default), points for timing pattern will be squares.
    public var isTimingPointStatic: Bool = true {
        didSet {
            imageQRCode = nil
        }
    }
    /// Set generator to use un-styled points for timing pattern (or not).
    /// - Parameter isStatic: Wether or not to use square shape for timing pattern points,
    ///     defaults to `true`.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withStaticTimingPoint(_ isStatic: Bool = true) -> EFQRCodeGenerator {
        return with(\.isTimingPointStatic, isStatic)
    }
    /// Set generator to use styled points for timing pattern (or not).
    /// - Parameter ignoreTiming: Wether or not to use current `pointStyle`
    ///     for timing pattern points, defaults to `true`.
    /// - Returns: `self`, allowing chaining.
    @discardableResult
    public func withStyledTimingPoint(_ ignoreTiming: Bool = true) -> EFQRCodeGenerator {
        return withStaticTimingPoint(!ignoreTiming)
    }

    // MARK: - Cache

    /*
     The 3 layers that constitutes the final imageQRCode (from top to bottom):

     [                    icon (or none)                    ]
     [ frontTransparentQRCodeImage ]     [ frontQRCodeImage ]
     [       watermark image       ]     [       none       ]
     */

    /// The code points.
    private var imageCodes: [[Bool]]? {
        didSet {
            frontTransparentQRCodeImage = nil
            frontQRCodeImage = nil
        }
    }
    /// The code points layer if background watermark is provided.
    private var frontTransparentQRCodeImage: CGImage?
    /// The code points layer if background watermark is nil.
    private var frontQRCodeImage: CGImage?
    /// The final result.
    private var imageQRCode: CGImage?
    /// Cache of the actual QRCode content size.
    private var minSuitableSize: EFIntSize!
    
    /// Clears the cache.
    ///
    /// - Note: You do not need to call this except for reducing memory usage.
    public func clearCache() {
        imageCodes = nil
        imageQRCode = nil
    }
    
    // MARK: - Init

    /// Initialize a QR code generator to generate a QR code of specified of size
    /// for some content with appropriate encoding.
    /// - Parameters:
    ///   - content: Information to convey in the generated QR code.
    ///   - encoding: Text encoding for generating data from `content`.
    ///   - size: The width and height of the generated QR code.
    public init(
        content: String, encoding: String.Encoding = .utf8,
        size: EFIntSize = EFIntSize(width: 256, height: 256)
    ) {
        self.content = content
        self.contentEncoding = encoding
        self.size = size
    }

    /// Fetches the final QR code image.
    /// - Returns: the generated QR code, or `nil` if failed.
    public func generate() -> CGImage? {
        if nil == imageQRCode {
            imageQRCode = createImageQRCode()
        }
        return imageQRCode
    }

    // MARK: - Draw
    private func createImageQRCode() -> CGImage? {
        var finalSize = self.size
        let finalBackgroundColor = getBackgroundColor()
        let finalForegroundColor = getForegroundColor()
        let finalIcon = self.icon
        let finalIconSize = self.iconSize
        let finalWatermark = self.watermark
        let finalWatermarkMode = self.watermarkMode

        // Get QRCodes from image
        guard let codes = generateCodes() else {
            return nil
        }

        // If magnification is not nil, reset finalSize
        if let tryMagnification = magnification {
            finalSize = EFIntSize(
                width: tryMagnification.width * codes.count,
                height: tryMagnification.height * codes.count
            )
        }

        var result: CGImage?
        if let context = createContext(size: finalSize) {

            // Cache size
            minSuitableSize = EFIntSize(
                width: minSuitableSize(greaterThanOrEqualTo: finalSize.width.cgFloat) ?? finalSize.width,
                height: minSuitableSize(greaterThanOrEqualTo: finalSize.height.cgFloat) ?? finalSize.height
            )

            // Watermark
            if let tryWatermark = finalWatermark {
                // Draw background with watermark
                drawWatermarkImage(
                    context: context,
                    image: tryWatermark,
                    colorBack: finalBackgroundColor,
                    mode: finalWatermarkMode,
                    size: finalSize.cgSize
                )
            } else {
                // Draw background without watermark
                let colorCGBack = finalBackgroundColor
                context.setFillColor(colorCGBack)
                context.fill(CGRect(origin: .zero, size: finalSize.cgSize))
            }
            
            // Draw QR Code
            if let tryFrontImage = { () -> CGImage? in
                if finalWatermark != nil {
                    if let tryFrontTransparentQRCodeImage = frontTransparentQRCodeImage {
                        return tryFrontTransparentQRCodeImage
                    }
                    frontTransparentQRCodeImage = createTransparentQRCodeImage(
                        from: codes,
                        colorBack: finalBackgroundColor,
                        colorFront: finalForegroundColor,
                        size: minSuitableSize
                    )
                    return frontTransparentQRCodeImage
                } else {
                    if let tryFrontQRCodeImage = frontQRCodeImage {
                        return tryFrontQRCodeImage
                    }
                    frontQRCodeImage = createQRCodeImage(
                        codes: codes,
                        colorBack: finalBackgroundColor,
                        colorFront: finalForegroundColor,
                        size: minSuitableSize
                    )
                    return frontQRCodeImage
                }
            }() {
                context.draw(tryFrontImage, in: CGRect(origin: .zero, size: finalSize.cgSize))
            }
            
            // Add icon
            if let tryIcon = finalIcon {
                var finalIconSizeWidth = finalSize.width.cgFloat * 0.2
                var finalIconSizeHeight = finalSize.height.cgFloat * 0.2
                if let tryFinalIconSize = finalIconSize {
                    finalIconSizeWidth = tryFinalIconSize.width.cgFloat
                    finalIconSizeHeight = tryFinalIconSize.height.cgFloat
                }
                let maxLength = [CGFloat(0.2), 0.3, 0.4, 0.5][inputCorrectionLevel.rawValue] * finalSize.width.cgFloat
                if finalIconSizeWidth > maxLength {
                    finalIconSizeWidth = maxLength
                    print("Warning: icon width too big, it has been changed.")
                }
                if finalIconSizeHeight > maxLength {
                    finalIconSizeHeight = maxLength
                    print("Warning: icon height too big, it has been changed.")
                }
                let iconSize = EFIntSize(width: Int(finalIconSizeWidth), height: Int(finalIconSizeHeight))
                drawIcon(
                    context: context,
                    icon: tryIcon,
                    size: iconSize
                )
            }

            result = context.makeImage()
        }

        // Mode apply
        switch mode {
        case .grayscale?:
            if let tryModeImage = result?.grayscale {
                result = tryModeImage
            }
        case .binarization(let threshold)?:
            if let tryModeImage = result?.binarization(
                threshold: threshold,
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor) {
                result = tryModeImage
            }
        case nil, EFQRCodeMode.none?:
            break
        }

        return result
    }

    private func getForegroundColor() -> CGColor {
        switch mode {
        case .binarization:
            return .black()!
        default:
            return foregroundColor
        }
    }

    private func getBackgroundColor() -> CGColor {
        switch mode {
        case .binarization:
            return .white()!
        default:
            return backgroundColor
        }
    }

    #if canImport(CoreImage)
    /// Create Colorful QR Image
    private func createQRCodeImage(
        codes: [[Bool]],
        colorBack: CIColor,
        colorFront: CIColor,
        size: EFIntSize
    ) -> CGImage? {
        guard let colorCGFront = colorFront.cgColor() else {
            return nil
        }
        return createQRCodeImage(codes: codes, colorFront: colorCGFront, size: size)
    }
    #endif

    private func createQRCodeImage(
        codes: [[Bool]],
        colorBack colorCGBack: CGColor? = nil,
        colorFront colorCGFront: CGColor,
        size: EFIntSize
    ) -> CGImage? {
        let codeSize = codes.count
        
        let scaleX = size.width.cgFloat / CGFloat(codeSize)
        let scaleY = size.height.cgFloat / CGFloat(codeSize)
        if scaleX < 1.0 || scaleY < 1.0 {
            print("Warning: Size too small.")
        }
        
        var points = [CGPoint]()
        if let locations = getAlignmentPatternLocations(version: getVersion(size: codeSize - 2)) {
            for indexX in locations {
                for indexY in locations {
                    let finalX = indexX + 1
                    let finalY = indexY + 1
                    if !((finalX == 7 && finalY == 7)
                            || (finalX == 7 && finalY == (codeSize - 8))
                            || (finalX == (codeSize - 8) && finalY == 7)) {
                        points.append(CGPoint(x: finalX, y: finalY))
                    }
                }
            }
        }


        var result: CGImage?
        if let context = createContext(size: size) {
            // Point
            context.setFillColor(colorCGFront)
            for indexY in 0 ..< codeSize {
                for indexX in 0 ..< codeSize where codes[indexX][indexY] {
                    // CTM-90
                    let indexXCTM = indexY
                    let indexYCTM = codeSize - indexX - 1
                    
                    let isStaticPoint = isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points)

                    drawPoint(
                        context: context,
                        rect: CGRect(
                            x: CGFloat(indexXCTM) * scaleX + pointOffset,
                            y: CGFloat(indexYCTM) * scaleY + pointOffset,
                            width: scaleX - 2 * pointOffset,
                            height: scaleY - 2 * pointOffset
                        ),
                        isStatic: isStaticPoint
                    )
                }
            }
            result = context.makeImage()
        }
        return result
    }

    #if canImport(CoreImage)
    /// Create Colorful QR Image
    private func createTransparentQRCodeImage(
        from codes: [[Bool]],
        colorBack: CIColor,
        colorFront: CIColor,
        size: EFIntSize
    ) -> CGImage? {
        guard let colorCGBack = colorBack.cgColor(),
              let colorCGFront = colorFront.cgColor()
        else { return nil }
        return createTransparentQRCodeImage(from: codes, colorBack: colorCGBack, colorFront: colorCGFront, size: size)
    }
    #endif

    private func createTransparentQRCodeImage(
        from codes: [[Bool]],
        colorBack colorCGBack: CGColor,
        colorFront colorCGFront: CGColor,
        size: EFIntSize
    ) -> CGImage? {
        let codeSize = codes.count

        let scaleX = size.width.cgFloat / CGFloat(codeSize)
        let scaleY = size.height.cgFloat / CGFloat(codeSize)
        if scaleX < 1.0 || scaleY < 1.0 {
            print("Warning: Size too small.")
        }

        let pointMinOffsetX = scaleX / 3
        let pointMinOffsetY = scaleY / 3
        let pointWidthOriX = scaleX
        let pointWidthOriY = scaleY
        let pointWidthMinX = scaleX - 2 * pointMinOffsetX
        let pointWidthMinY = scaleY - 2 * pointMinOffsetY

        // Get AlignmentPatternLocations first
        var points = [CGPoint]()
        if let locations = getAlignmentPatternLocations(version: getVersion(size: codeSize - 2)) {
            for indexX in locations {
                for indexY in locations {
                    let finalX = indexX + 1
                    let finalY = indexY + 1
                    if !((finalX == 7 && finalY == 7)
                            || (finalX == 7 && finalY == (codeSize - 8))
                            || (finalX == (codeSize - 8) && finalY == 7)) {
                        points.append(CGPoint(x: finalX, y: finalY))
                    }
                }
            }
        }

        var finalImage: CGImage?

        if let context = createContext(size: size) {
            // Back point
            context.setFillColor(colorCGBack)
            for indexY in 0 ..< codeSize {
                for indexX in 0 ..< codeSize where !codes[indexX][indexY] {
                    // CTM-90
                    let indexXCTM = indexY
                    let indexYCTM = codeSize - indexX - 1
                    if isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points) {
                        drawPoint(
                            context: context,
                            rect: CGRect(
                                x: CGFloat(indexXCTM) * scaleX,
                                y: CGFloat(indexYCTM) * scaleY,
                                width: pointWidthOriX,
                                height: pointWidthOriY
                            ),
                            isStatic: true
                        )
                    } else {
                        drawPoint(
                            context: context,
                            rect: CGRect(
                                x: CGFloat(indexXCTM) * scaleX + pointMinOffsetX,
                                y: CGFloat(indexYCTM) * scaleY + pointMinOffsetY,
                                width: pointWidthMinX,
                                height: pointWidthMinY
                            )
                        )
                    }
                }
            }
            // Front point
            context.setFillColor(colorCGFront)
            for indexY in 0 ..< codeSize {
                for indexX in 0 ..< codeSize where codes[indexX][indexY] {
                    // CTM-90
                    let indexXCTM = indexY
                    let indexYCTM = codeSize - indexX - 1
                    if isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points) {
                        drawPoint(
                            context: context,
                            rect: CGRect(
                                x: CGFloat(indexXCTM) * scaleX + pointOffset,
                                y: CGFloat(indexYCTM) * scaleY + pointOffset,
                                width: pointWidthOriX - 2 * pointOffset,
                                height: pointWidthOriY - 2 * pointOffset
                            ),
                            isStatic: true
                        )
                    } else {
                        drawPoint(
                            context: context,
                            rect: CGRect(
                                x: CGFloat(indexXCTM) * scaleX + pointMinOffsetX,
                                y: CGFloat(indexYCTM) * scaleY + pointMinOffsetY,
                                width: pointWidthMinX,
                                height: pointWidthMinY
                            )
                        )
                    }
                }
            }

            finalImage = context.makeImage()
        }
        return finalImage
    }
    
    // MARK: - Pre
    
    #if canImport(CoreImage)
    private func drawWatermarkImage(
        context: CGContext,
        image: CGImage,
        colorBack: CIColor,
        mode: EFWatermarkMode,
        size: CGSize
    ) {
        drawWatermarkImage(context: context, image: image,
                           colorBack: colorBack.cgColor(),
                           mode: mode, size: size)
    }
    #endif

    private func drawWatermarkImage(
        context: CGContext,
        image: CGImage,
        colorBack: CGColor?,
        mode: EFWatermarkMode,
        size: CGSize
    ) {
        // BGColor
        if let tryColor = colorBack {
            context.setFillColor(tryColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
        if !isWatermarkOpaque {
            guard let codes = generateCodes() else {
                return
            }
            if let tryCGImage = createQRCodeImage(
                codes: codes,
                colorBack: getBackgroundColor(),
                colorFront: getForegroundColor(),
                size: minSuitableSize
            ) {
                context.draw(tryCGImage, in: CGRect(origin: .zero, size: size))
            }
        }
        // Image
        let imageRect: CGRect = mode.rectForWatermark(
            ofSize: CGSize(width: image.width, height: image.height),
            inCanvasOfSize: size
        )
        context.draw(image, in: imageRect)
    }

    private func drawIcon(context: CGContext, icon: CGImage, size: EFIntSize) {
        context.draw(
            icon,
            in: CGRect(
                origin: CGPoint(
                    x: CGFloat(context.width - size.width) / 2.0,
                    y: CGFloat(context.height - size.height) / 2.0
                ),
                size: size.cgSize
            )
        )
    }
    
    private func drawPoint(context: CGContext, rect: CGRect, isStatic: Bool = false) {
        pointStyle.fillRect(context: context, rect: rect, isStatic: isStatic)
    }

    private func createContext(size: EFIntSize) -> CGContext? {
        return CGContext(
            data: nil, width: size.width, height: size.height,
            bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        )
    }

    // MARK: - Data
    
    #if canImport(CoreImage)
    private func getPixels() -> [[EFUIntPixel]]? {
        guard let finalContent = content else {
            return nil
        }
        let finalInputCorrectionLevel = inputCorrectionLevel
        let finalContentEncoding = contentEncoding

        guard let tryQRImagePixels = CIImage
                .generateQRCode(
                    finalContent, using: finalContentEncoding,
                    inputCorrectionLevel: finalInputCorrectionLevel
                )?
                .cgImage()?
                .pixels()
        else {
            print("Warning: Content too large.")
            return nil
        }
        return tryQRImagePixels
    }
    #endif

    /// Get QRCodes from pixels.
    private func getCodes(pixels: [[EFUIntPixel]]) -> [[Bool]] {
        return pixels.map { $0.map { pixel in
            pixel.red == 0 && pixel.green == 0 && pixel.blue == 0
        } }
    }

    /// Get QRCodes from pixels.
    private func generateCodes() -> [[Bool]]? {
        if let tryImageCodes = imageCodes {
            return tryImageCodes
        }

        func fetchPixels() -> [[Bool]]? {
            #if canImport(CoreImage)
            // Get pixels from image
            guard let tryQRImagePixels = getPixels() else {
                return nil
            }
            // Get QRCodes from image
            return getCodes(pixels: tryQRImagePixels)
            #else
            let level = inputCorrectionLevel.qrErrorCorrectLevel
            return content.flatMap {
                try? QRCode($0, encoding: contentEncoding,
                            errorCorrectLevel: level, withBorder: true
                )
                .imageCodes
            }
            #endif
        }

        imageCodes = fetchPixels()
        return imageCodes
    }

    /// Special Points of QRCode
    private func isStatic(x: Int, y: Int, size: Int, APLPoints: [CGPoint]) -> Bool {
        // Empty border
        if x == 0 || y == 0 || x == (size - 1) || y == (size - 1) {
            return true
        }

        // Finder Patterns
        if (x <= 8 && y <= 8) || (x <= 8 && y >= (size - 9)) || (x >= (size - 9) && y <= 8) {
            return true
        }

        if isTimingPointStatic {
            // Timing Patterns
            if x == 7 || y == 7 {
                return true
            }
        }

        // Alignment Patterns
        return APLPoints.contains { point in
            x >= Int(point.x - 2)
                && x <= Int(point.x + 2)
                && y >= Int(point.y - 2)
                && y <= Int(point.y + 2)
        }
    }

    /// [Alignment Pattern Locations](
    /// http://stackoverflow.com/questions/13238704/calculating-the-position-of-qr-code-alignment-patterns
    /// )
    private func getAlignmentPatternLocations(version: Int) -> [Int]? {
        if version == 1 {
            return nil
        }
        let divs = 2 + version / 7
        let size = getSize(version: version)
        let total_dist = size - 7 - 6
        let divisor = 2 * (divs - 1)

        // Step must be even, for alignment patterns to agree with timing patterns
        let step = (total_dist + divisor / 2 + 1) / divisor * 2 // Get the rounding right
        var coords = [6]

        // divs-2 down to 0, inclusive
        coords += ( 0...(divs - 2) ).map { i in
            size - 7 - (divs - 2 - i) * step
        }
        return coords
    }

    /// QRCode version.
    private func getVersion(size: Int) -> Int {
        return (size - 21) / 4 + 1
    }

    /// QRCode size.
    private func getSize(version: Int) -> Int {
        return 17 + 4 * version
    }

    // MARK: - Recommended Magnification

    /// Calculates and returns the magnification such that multiplied to intrinsic size  >= the given size.
    /// - Parameter size: Desired final size of generated QR code.
    /// - Returns: The recommended value to set as a side of `magnification`.
    public func minMagnification(greaterThanOrEqualTo size: CGFloat) -> Int? {
        guard let codes = generateCodes() else {
            return nil
        }
        let finalWatermark = watermark

        let baseMagnification = max(1, Int(size / CGFloat(codes.count)))
        for offset in 0 ... 3 {
            let tempMagnification = baseMagnification + offset
            if CGFloat(tempMagnification * codes.count) >= size {
                if finalWatermark == nil {
                    return tempMagnification
                } else if tempMagnification.isMultiple(of: 3) {
                    return tempMagnification
                }
            }
        }
        return nil
    }

    /// Calculates and returns the magnification such that multiplied to intrinsic size  <= the given size.
    /// - Parameter size: Desired final size of generated QR code.
    /// - Returns: The recommended value to set as a side of `magnification`.
    public func maxMagnification(lessThanOrEqualTo size: CGFloat) -> Int? {
        guard let codes = generateCodes() else {
            return nil
        }
        let finalWatermark = watermark

        let baseMagnification = max(1, Int(size / CGFloat(codes.count)))
        for offset in [0, -1, -2, -3] {
            let tempMagnification = baseMagnification + offset
            if tempMagnification <= 0 {
                return finalWatermark == nil ? 1 : 3
            }
            if CGFloat(tempMagnification * codes.count) <= size {
                if finalWatermark == nil {
                    return tempMagnification
                } else if tempMagnification.isMultiple(of: 3) {
                    return tempMagnification
                }
            }
        }
        return nil
    }

    /// Calculate suitable size.
    private func minSuitableSize(greaterThanOrEqualTo size: CGFloat) -> Int? {
        guard let codes = generateCodes() else {
            return nil
        }

        let baseSuitableSize = Int(size)
        for offset in codes.indices {
            let tempSuitableSize = baseSuitableSize + offset
            if tempSuitableSize.isMultiple(of: codes.count) {
                return tempSuitableSize
            }
        }
        return nil
    }
}
