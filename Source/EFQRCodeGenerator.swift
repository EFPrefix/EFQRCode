//
//  EFQRCodeGenerator.swift
//  EFQRCode
//
//  Created by EyreFree on 17/1/24.
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

#if os(watchOS)
import CoreGraphics
import swift_qrcodejs
#else
import CoreImage
#endif

// EFQRCode+Create
@objcMembers
public class EFQRCodeGenerator: NSObject {

    // MARK: - Parameters

    // Content of QR Code
    private var content: String? {
        didSet {
            imageQRCode = nil
            imageCodes = nil
        }
    }
    public func setContent(content: String) {
        self.content = content
    }

    // Mode of QR Code
    private var mode: EFQRCodeMode = .none {
        didSet {
            imageQRCode = nil
        }
    }
    public func setMode(mode: EFQRCodeMode) {
        self.mode = mode
    }

    // Error-tolerant rate
    // L 7%
    // M 15%
    // Q 25%
    // H 30%(Default)
    private var inputCorrectionLevel: EFInputCorrectionLevel = .h {
        didSet {
            imageQRCode = nil
            imageCodes = nil
        }
    }
    public func setInputCorrectionLevel(inputCorrectionLevel: EFInputCorrectionLevel) {
        self.inputCorrectionLevel = inputCorrectionLevel
    }

    // Size of QR Code
    private var size: EFIntSize = EFIntSize(width: 256, height: 256) {
        didSet {
            imageQRCode = nil
        }
    }
    public func setSize(size: EFIntSize) {
        self.size = size
    }

    // Magnification of QRCode compare with the minimum size,
    // (Parameter size will be ignored if magnification is not nil).
    private var magnification: EFIntSize? {
        didSet {
            imageQRCode = nil
        }
    }
    public func setMagnification(magnification: EFIntSize?) {
        self.magnification = magnification
    }

    // backgroundColor
    private var backgroundColor: CGColor = CGColor.EFWhite() {
        didSet {
            imageQRCode = nil
        }
    }
    // foregroundColor
    private var foregroundColor: CGColor = CGColor.EFBlack() {
        didSet {
            imageQRCode = nil
        }
    }
    #if os(iOS) || os(tvOS) || os(macOS)
    @nonobjc public func setColors(backgroundColor: CIColor, foregroundColor: CIColor) {
        self.backgroundColor = backgroundColor.toCGColor() ?? .EFWhite()
        self.foregroundColor = foregroundColor.toCGColor() ?? .EFBlack()
    }
    #endif

    public func setColors(backgroundColor: CGColor, foregroundColor: CGColor) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    // Icon in the middle of QR Code
    private var icon: CGImage? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    // Size of icon
    private var iconSize: EFIntSize? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    public func setIcon(icon: CGImage?, size: EFIntSize?) {
        self.icon = icon
        self.iconSize = size
    }

    // Watermark
    private var watermark: CGImage? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    // Mode of watermark
    private var watermarkMode: EFWatermarkMode = .scaleAspectFill {
        didSet {
            imageQRCode = nil
        }
    }
    public func setWatermark(watermark: CGImage?, mode: EFWatermarkMode? = nil) {
        self.watermark = watermark

        if let mode = mode {
            self.watermarkMode = mode
        }
    }

    // Offset of foreground point
    private var foregroundPointOffset: CGFloat = 0 {
        didSet {
            imageQRCode = nil
        }
    }
    public func setForegroundPointOffset(foregroundPointOffset: CGFloat) {
        self.foregroundPointOffset = foregroundPointOffset
    }

    // Alpha 0 area of watermark will transparent
    private var allowTransparent: Bool = true {
        didSet {
            imageQRCode = nil
        }
    }
    public func setAllowTransparent(allowTransparent: Bool) {
        self.allowTransparent = allowTransparent
    }

    // Shape of foreground point
    private var pointShape: EFPointShape = .square {
        didSet {
            imageQRCode = nil
        }
    }
    public func setPointShape(pointShape: EFPointShape) {
        self.pointShape = pointShape
    }

    // Threshold for binarization (Only for mode binarization).
    private var binarizationThreshold: CGFloat = 0.5 {
        didSet {
            imageQRCode = nil
        }
    }
    public func setBinarizationThreshold(binarizationThreshold: CGFloat) {
        self.binarizationThreshold = binarizationThreshold
    }

    // Cache
    private var imageCodes: [[Bool]]?
    private var imageQRCode: CGImage?
    private var minSuitableSize: EFIntSize!

    // MARK: - Init
    public init(
        content: String,
        size: EFIntSize = EFIntSize(width: 256, height: 256)
        ) {
        self.content = content
        self.size = size
    }

    // Final QRCode image
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
                width: tryMagnification.width * codes.count, height: tryMagnification.height * codes.count
            )
        }

        var result: CGImage?
        if let context = createContext(size: finalSize) {

            // Cache size
            minSuitableSize = EFIntSize(
                width: minSuitableSizeGreaterThanOrEqualTo(size: finalSize.widthCGFloat()) ?? finalSize.width,
                height: minSuitableSizeGreaterThanOrEqualTo(size: finalSize.heightCGFloat()) ?? finalSize.height
            )

            // Watermark
            if let tryWatermark = finalWatermark {
                // Draw background with watermark
                drawWatermarkImage(
                    context: context,
                    image: tryWatermark,
                    colorBack: finalBackgroundColor,
                    mode: finalWatermarkMode,
                    size: finalSize.toCGSize()
                )
                // Draw QR Code
                if let tryFrontImage = createQRCodeImageTransparent(
                    codes: codes,
                    colorBack: finalBackgroundColor,
                    colorFront: finalForegroundColor,
                    size: minSuitableSize
                    ) {
                    context.draw(tryFrontImage, in: CGRect(origin: .zero, size: finalSize.toCGSize()))
                }
            } else {
                // Draw background without watermark
                let colorCGBack = finalBackgroundColor
                context.setFillColor(colorCGBack)
                context.fill(CGRect(origin: .zero, size: finalSize.toCGSize()))

                // Draw QR Code
                if let tryImage = createQRCodeImage(
                    codes: codes,
                    colorBack: finalBackgroundColor,
                    colorFront: finalForegroundColor,
                    size: minSuitableSize
                    ) {
                    context.draw(tryImage, in: CGRect(origin: .zero, size: finalSize.toCGSize()))
                }
            }

            // Add icon
            if let tryIcon = finalIcon {
                var finalIconSizeWidth = CGFloat(finalSize.width) * 0.2
                var finalIconSizeHeight = CGFloat(finalSize.width) * 0.2
                if let tryFinalIconSize = finalIconSize {
                    finalIconSizeWidth = CGFloat(tryFinalIconSize.width)
                    finalIconSizeHeight = CGFloat(tryFinalIconSize.height)
                }
                let maxLength = [CGFloat(0.2), 0.3, 0.4, 0.5][inputCorrectionLevel.rawValue] * CGFloat(finalSize.width)
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
        case .grayscale:
            if let tryModeImage = result?.grayscale() {
                result = tryModeImage
            }
        case .binarization:
            if let tryModeImage = result?.binarization(
                value: binarizationThreshold,
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor
                ) {
                result = tryModeImage
            }
        default:
            break
        }

        return result
    }

    private func getForegroundColor() -> CGColor {
        if mode == .binarization {
            return CGColor.EFBlack()
        }
        return foregroundColor
    }

    private func getBackgroundColor() -> CGColor {
        if mode == .binarization {
            return CGColor.EFWhite()
        }
        return backgroundColor
    }

    // Create Colorful QR Image
    #if os(iOS) || os(tvOS) || os(macOS)
    private func createQRCodeImage(
        codes: [[Bool]],
        colorBack: CIColor,
        colorFront: CIColor,
        size: EFIntSize) -> CGImage? {
        guard let colorCGFront = colorFront.toCGColor() else {
            return nil
        }
        return createQRCodeImage(codes: codes, colorFront: colorCGFront, size: size)
    }
    #endif

    private func createQRCodeImage(
        codes: [[Bool]],
        colorBack colorCGBack: CGColor? = nil,
        colorFront colorCGFront: CGColor,
        size: EFIntSize) -> CGImage? {
        
        let scaleX = CGFloat(size.width) / CGFloat(codes.count)
        let scaleY = CGFloat(size.height) / CGFloat(codes.count)
        if scaleX < 1.0 || scaleY < 1.0 {
            print("Warning: Size too small.")
        }

        let codeSize = codes.count
        
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
                for indexX in 0 ..< codeSize where true == codes[indexX][indexY] {
                    // CTM-90
                    let indexXCTM = indexY
                    let indexYCTM = codeSize - indexX - 1
                    
                    let isStaticPoint = isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points)

                    drawPoint(
                        context: context,
                        rect: CGRect(
                            x: CGFloat(indexXCTM) * scaleX + foregroundPointOffset,
                            y: CGFloat(indexYCTM) * scaleY + foregroundPointOffset,
                            width: scaleX - 2 * foregroundPointOffset,
                            height: scaleY - 2 * foregroundPointOffset
                        ),
                        isStatic: isStaticPoint
                    )
                }
            }
            result = context.makeImage()
        }
        return result
    }

    // Create Colorful QR Image
    #if os(iOS) || os(tvOS) || os(macOS)
    private func createQRCodeImageTransparent(
        codes: [[Bool]],
        colorBack: CIColor,
        colorFront: CIColor,
        size: EFIntSize) -> CGImage? {
        guard let colorCGBack = colorBack.toCGColor(), let colorCGFront = colorFront.toCGColor() else {
            return nil
        }
        return createQRCodeImageTransparent(codes: codes, colorBack: colorCGBack, colorFront: colorCGFront, size: size)
    }
    #endif

    private func createQRCodeImageTransparent(
        codes: [[Bool]],
        colorBack colorCGBack: CGColor,
        colorFront colorCGFront: CGColor,
        size: EFIntSize) -> CGImage? {
        let scaleX = CGFloat(size.width) / CGFloat(codes.count)
        let scaleY = CGFloat(size.height) / CGFloat(codes.count)
        if scaleX < 1.0 || scaleY < 1.0 {
            print("Warning: Size too small.")
        }

        let codeSize = codes.count
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
                for indexX in 0 ..< codeSize where false == codes[indexX][indexY] {
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
                for indexX in 0 ..< codeSize where true == codes[indexX][indexY] {
                    // CTM-90
                    let indexXCTM = indexY
                    let indexYCTM = codeSize - indexX - 1
                    if isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points) {
                        drawPoint(
                            context: context,
                            rect: CGRect(
                                x: CGFloat(indexXCTM) * scaleX + foregroundPointOffset,
                                y: CGFloat(indexYCTM) * scaleY + foregroundPointOffset,
                                width: pointWidthOriX - 2 * foregroundPointOffset,
                                height: pointWidthOriY - 2 * foregroundPointOffset
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

    // Pre
    #if os(iOS) || os(tvOS) || os(macOS)
    private func drawWatermarkImage(
        context: CGContext,
        image: CGImage,
        colorBack: CIColor,
        mode: EFWatermarkMode,
        size: CGSize) {
        drawWatermarkImage(context: context, image: image, colorBack: colorBack.toCGColor(), mode: mode, size: size)
    }
    #endif

    private func drawWatermarkImage(
        context: CGContext,
        image: CGImage,
        colorBack: CGColor?,
        mode: EFWatermarkMode,
        size: CGSize) {
        // BGColor
        if let tryColor = colorBack {
            context.setFillColor(tryColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        if allowTransparent {
            guard let codes = generateCodes() else {
                return
            }
            if let tryCGImage = createQRCodeImage(
                codes: codes,
                colorBack: getBackgroundColor(),
                colorFront: getForegroundColor(),
                size: minSuitableSize
                ) {
                context.draw(tryCGImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
        }
        // Image
        var finalSize = size
        var finalOrigin = CGPoint.zero
        let imageSize = CGSize(width: image.width, height: image.height)
        switch mode {
        case .bottom:
            finalSize = imageSize
            finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0, y: 0)
        case .bottomLeft:
            finalSize = imageSize
            finalOrigin = CGPoint(x: 0, y: 0)
        case .bottomRight:
            finalSize = imageSize
            finalOrigin = CGPoint(x: size.width - imageSize.width, y: 0)
        case .center:
            finalSize = imageSize
            finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0, y: (size.height - imageSize.height) / 2.0)
        case .left:
            finalSize = imageSize
            finalOrigin = CGPoint(x: 0, y: (size.height - imageSize.height) / 2.0)
        case .right:
            finalSize = imageSize
            finalOrigin = CGPoint(x: size.width - imageSize.width, y: (size.height - imageSize.height) / 2.0)
        case .top:
            finalSize = imageSize
            finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0, y: size.height - imageSize.height)
        case .topLeft:
            finalSize = imageSize
            finalOrigin = CGPoint(x: 0, y: size.height - imageSize.height)
        case .topRight:
            finalSize = imageSize
            finalOrigin = CGPoint(x: size.width - imageSize.width, y: size.height - imageSize.height)
        case .scaleAspectFill:
            let scale = max(size.width / imageSize.width, size.height / imageSize.height)
            finalSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
            finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0, y: (size.height - finalSize.height) / 2.0)
        case .scaleAspectFit:
            let scale = max(imageSize.width / size.width, imageSize.height / size.height)
            finalSize = CGSize(width: imageSize.width / scale, height: imageSize.height / scale)
            finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0, y: (size.height - finalSize.height) / 2.0)
        default:
            break
        }
        context.draw(image, in: CGRect(origin: finalOrigin, size: finalSize))
    }

    private func drawIcon(context: CGContext, icon: CGImage, size: EFIntSize) {
        context.draw(
            icon,
            in: CGRect(
                origin: CGPoint(
                    x: CGFloat(context.width - size.width) / 2.0,
                    y: CGFloat(context.height - size.height) / 2.0
                ),
                size: size.toCGSize()
            )
        )
    }
    
    private func fillDiamond(context: CGContext, rect: CGRect) {
        // shrink rect edge
        let drawingRect = rect.insetBy(dx: -2, dy: -2)
        
        // create path
        let path = CGMutablePath()
        // Bezier Control Point
        let controlPoint = CGPoint(x: drawingRect.midX , y: drawingRect.midY)
        // Bezier Start Point
        let startPoint = CGPoint(x: drawingRect.minX, y: drawingRect.midY)
        // the other point of diamond
        let otherPoints = [CGPoint(x: drawingRect.midX, y: drawingRect.maxY),
                      CGPoint(x: drawingRect.maxX, y: drawingRect.midY),
                      CGPoint(x: drawingRect.midX, y: drawingRect.minY)]
        path.move(to: startPoint)
        for point in otherPoints {
            path.addQuadCurve(to: point, control: controlPoint)
        }
        path.addQuadCurve(to: startPoint, control: controlPoint)
        context.addPath(path)
        context.fillPath()

    }

    private func drawPoint(context: CGContext, rect: CGRect, isStatic: Bool = false) {
        switch pointShape {
            case .circle:
                context.fillEllipse(in: rect)
            case .diamond:
                if isStatic {
                    context.fill(rect)
                } else {
                    fillDiamond(context: context, rect: rect)
                }
            default:
                context.fill(rect)
        }
    }

    private func createContext(size: EFIntSize) -> CGContext? {
        return CGContext(
            data: nil, width: size.width, height: size.height,
            bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        )
    }

    #if os(iOS) || os(tvOS) || os(macOS)
    // MARK: - Data
    private func getPixels() -> [[EFUIntPixel]]? {
        guard let finalContent = content else {
            return nil
        }
        let finalInputCorrectionLevel = inputCorrectionLevel

        guard let tryQRImagePixels = CIImage.generateQRCode(
            string: finalContent, inputCorrectionLevel: finalInputCorrectionLevel
            )?.toCGImage()?.pixels() else {
                print("Warning: Content too large.")
                return nil
        }
        return tryQRImagePixels
    }
    #endif

    // Get QRCodes from pixels
    private func getCodes(pixels: [[EFUIntPixel]]) -> [[Bool]] {
        var codes = [[Bool]]()
        for indexY in 0 ..< pixels.count {
            codes.append([Bool]())
            for indexX in 0 ..< pixels[0].count {
                let pixel = pixels[indexY][indexX]
                codes[indexY].append(
                    pixel.red == 0 && pixel.green == 0 && pixel.blue == 0
                )
            }
        }
        return codes
    }

    // Get QRCodes from pixels
    private func generateCodes() -> [[Bool]]? {
        if let tryImageCodes = imageCodes {
            return tryImageCodes
        }

        func fetchPixels() -> [[Bool]]? {
            #if os(iOS) || os(macOS) || os(tvOS)
            // Get pixels from image
            guard let tryQRImagePixels = getPixels() else {
                return nil
            }
            // Get QRCodes from image
            return getCodes(pixels: tryQRImagePixels)
            #else
            let level = inputCorrectionLevel.qrErrorCorrectLevel
            if let finalContent = content {
                return QRCode(finalContent, errorCorrectLevel: level, withBorder: true)?.imageCodes
            }
            return nil
            #endif
        }

        imageCodes = fetchPixels()
        return imageCodes
    }

    // Special Points of QRCode
    private func isStatic(x: Int, y: Int, size: Int, APLPoints: [CGPoint]) -> Bool {
        // Empty border
        if x == 0 || y == 0 || x == (size - 1) || y == (size - 1) {
            return true
        }

        // Finder Patterns
        if (x <= 8 && y <= 8) || (x <= 8 && y >= (size - 9)) || (x >= (size - 9) && y <= 8) {
            return true
        }

        // Timing Patterns
        if x == 7 || y == 7 {
            return true
        }

        // Alignment Patterns
        for point in APLPoints {
            if x >= Int(point.x - 2) && x <= Int(point.x + 2) && y >= Int(point.y - 2) && y <= Int(point.y + 2) {
                return true
            }
        }

        return false
    }

    // Alignment Pattern Locations
    // http://stackoverflow.com/questions/13238704/calculating-the-position-of-qr-code-alignment-patterns
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
        for i in 0...(divs - 2) {
            coords.append(size - 7 - (divs - 2 - i) * step)
        }
        return coords
    }

    // QRCode version
    private func getVersion(size: Int) -> Int {
        return (size - 21) / 4 + 1
    }

    // QRCode size
    private func getSize(version: Int) -> Int {
        return 17 + 4 * version
    }

    // Recommand magnification
    public func minMagnificationGreaterThanOrEqualTo(size: CGFloat) -> Int? {
        guard let codes = generateCodes() else {
            return nil
        }
        let finalWatermark = watermark

        let baseMagnification = max(1, Int(size / CGFloat(codes.count)))
        for offset in [0, 1, 2, 3] {
            let tempMagnification = baseMagnification + offset
            if CGFloat(Int(tempMagnification) * codes.count) >= size {
                if finalWatermark == nil {
                    return tempMagnification
                } else if tempMagnification % 3 == 0 {
                    return tempMagnification
                }
            }
        }
        return nil
    }

    public func maxMagnificationLessThanOrEqualTo(size: CGFloat) -> Int? {
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
                } else if tempMagnification % 3 == 0 {
                    return tempMagnification
                }
            }
        }
        return nil
    }

    // Calculate suitable size
    private func minSuitableSizeGreaterThanOrEqualTo(size: CGFloat) -> Int? {
        guard let codes = generateCodes() else {
            return nil
        }

        let baseSuitableSize = Int(size)
        for offset in 0...codes.count {
            let tempSuitableSize = baseSuitableSize + offset
            if tempSuitableSize % codes.count == 0 {
                return tempSuitableSize
            }
        }
        return nil
    }
}
