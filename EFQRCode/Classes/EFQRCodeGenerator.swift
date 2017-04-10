//
//  EFQRCodeGenerator.swift
//  Pods
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

import CoreImage

// EFInputCorrectionLevel
public enum EFInputCorrectionLevel: Int {
    case l = 0;     // L 7%
    case m = 1;     // M 15%
    case q = 2;     // Q 25%
    case h = 3;     // H 30%
}

// Like UIViewContentMode
public enum EFWatermarkMode: Int {
    case scaleToFill        = 0;
    case scaleAspectFit     = 1;
    case scaleAspectFill    = 2;
    case center             = 3;
    case top                = 4;
    case bottom             = 5;
    case left               = 6;
    case right              = 7;
    case topLeft            = 8;
    case topRight           = 9;
    case bottomLeft         = 10;
    case bottomRight        = 11;
}

struct EFIntPoint {
    var x: Int = 0
    var y: Int = 0

    public func toCGPoint() -> CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }
}

public struct EFIcon {
    var image: CGImage?
    var size: EFIntSize?
    var isColorful: Bool = true

    public init(image: CGImage?, size: EFIntSize?, isColorful: Bool = true) {
        self.image = image
        self.size = size
        self.isColorful = isColorful
    }
}

public struct EFWatermark {
    var image: CGImage?
    var mode: EFWatermarkMode = .scaleToFill
    var isColorful: Bool = true

    public init(image: CGImage?, mode: EFWatermarkMode = .scaleToFill, isColorful: Bool = true) {
        self.image = image
        self.mode = mode
        self.isColorful = isColorful
    }
}

public struct EFExtra {
    var foregroundPointOffset: CGFloat = 0
    var allowTransparent: Bool = true

    public init(foregroundPointOffset: CGFloat = 0, allowTransparent: Bool = true) {
        self.foregroundPointOffset = foregroundPointOffset
        self.allowTransparent = allowTransparent
    }
}

// EFQRCode+Create
public class EFQRCodeGenerator {

    public var content: String? {
        didSet {
            imageQRCode = nil
            imageCodes = nil
        }
    }
    public var inputCorrectionLevel: EFInputCorrectionLevel = .h {
        didSet {
            imageQRCode = nil
            imageCodes = nil
        }
    }
    public var size: EFIntSize = EFIntSize(width: 256, height: 256) {
        didSet {
            imageQRCode = nil
        }
    }
    // If set magnification, size will be ignored.
    public var magnification: EFIntSize? {
        didSet {
            imageQRCode = nil
        }
    }
    public var backgroundColor: CIColor = CIColor.white {
        didSet {
            imageQRCode = nil
        }
    }
    public var foregroundColor: CIColor = CIColor.black {
        didSet {
            imageQRCode = nil
        }
    }
    public var icon: CGImage? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    public var iconSize: EFIntSize? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    public var isIconColorful: Bool = true {
        didSet {
            imageQRCode = nil
        }
    }
    public var watermark: CGImage? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    public var watermarkMode: EFWatermarkMode = .scaleToFill {
        didSet {
            imageQRCode = nil
        }
    }
    public var isWatermarkColorful: Bool = true {
        didSet {
            imageQRCode = nil
        }
    }

    // MARK:- Not commonly used
    public var foregroundPointOffset: CGFloat = 0 {
        didSet {
            imageQRCode = nil
        }
    }
    public var allowTransparent: Bool = true {
        didSet {
            imageQRCode = nil
        }
    }

    // MARK:- Get QRCode image
    public var image: CGImage? {
        get {
            if nil == imageQRCode {
                imageQRCode = createQRCodeImage()
            }
            return imageQRCode
        }
    }

    // MARK:- Cache
    private var imageCodes: [[Bool]]?
    private var imageQRCode: CGImage?
    private var minSuitableSize: EFIntSize!

    public init(
        content: String,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        size: EFIntSize = EFIntSize(width: 256, height: 256),
        magnification: EFIntSize? = nil,
        backgroundColor: CIColor = CIColor.white,
        foregroundColor: CIColor = CIColor.black
        ) {
        self.content = content
        self.inputCorrectionLevel = inputCorrectionLevel
        self.size = size
        self.magnification = magnification
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    func setIcon(icon: EFIcon) {
        self.icon = icon.image
        self.iconSize = icon.size
        self.isIconColorful = icon.isColorful
    }

    func setWatermark(watermark: EFWatermark) {
        self.watermark = watermark.image
        self.watermarkMode = watermark.mode
        self.isWatermarkColorful = watermark.isColorful
    }

    func setExtra(extra: EFExtra) {
        self.foregroundPointOffset = extra.foregroundPointOffset
        self.allowTransparent = extra.allowTransparent
    }

    func CreateContext(size: EFIntSize) -> CGContext? {
        return CGContext(
            data: nil,
            width: size.width, height: size.height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        )
    }

    private func createQRCodeImage() -> CGImage? {
        var finalSize = self.size
        let finalBackgroundColor = self.backgroundColor
        let finalForegroundColor = self.foregroundColor
        let finalIcon = self.icon
        let finalIconSize = self.iconSize
        let finalIsIconColorful = self.isIconColorful
        let finalWatermark = self.watermark
        let finalWatermarkMode = self.watermarkMode
        let finalIsWatermarkColorful = self.isWatermarkColorful

        // Get QRCodes from image
        guard let codes = generateCodes() else {
            return nil
        }

        // If magnification is not nil, reset finalSize
        if let tryMagnification = magnification {
            finalSize = EFIntSize(width: tryMagnification.width * codes.count, height: tryMagnification.height * codes.count)
        }

        var result: CGImage?
        if let context = CreateContext(size: finalSize) {

            // Cache size
            let minSuitableWidth = minSuitableSizeGreaterThanOrEqualTo(size: finalSize.widthCGFloat()) ?? finalSize.width
            minSuitableSize = EFIntSize(
                width: minSuitableWidth, height: Int(finalSize.heightCGFloat() / finalSize.widthCGFloat() * CGFloat(minSuitableWidth))
            )

            // Watermark
            if let tryWatermark = finalIsWatermarkColorful ? finalWatermark : finalWatermark?.grayscale() {
                // Has watermark
                if let tryBackImage = drawWatermarkImage(
                    image: tryWatermark,
                    colorBack: finalBackgroundColor,
                    mode: finalWatermarkMode,
                    intSize: finalSize
                    ) {
                    context.draw(tryBackImage, in: CGRect(origin: .zero, size: finalSize.toCGSize()))
                }

                if let tryFrontImage = drawQRCodeImageTransparent(
                    codes: codes, colorBack: finalBackgroundColor, colorFront: finalForegroundColor, size: minSuitableSize
                    ) {
                    context.draw(tryFrontImage, in: CGRect(origin: .zero, size: finalSize.toCGSize()))
                }
            } else {
                // No watermark
                if let tryImage = drawQRCodeImage(
                    codes: codes, colorBack: finalBackgroundColor, colorFront: finalForegroundColor, size: minSuitableSize
                    ) {
                    context.draw(tryImage, in: CGRect(origin: .zero, size: finalSize.toCGSize()))
                }
            }

            // Add icon
            if let tryIcon = finalIsIconColorful ? finalIcon : finalIcon?.grayscale() {
                var iconSize = finalIconSize ?? EFIntSize(
                    width: Int(CGFloat(finalSize.width) * 0.2), height: Int(CGFloat(finalSize.height) * 0.2)
                )
                let maxScale = [CGFloat(0.26), 0.38, 0.5, 0.54][inputCorrectionLevel.rawValue]
                if CGFloat(iconSize.width) / CGFloat(finalSize.width) > maxScale {
                    iconSize = EFIntSize(width: Int(finalSize.widthCGFloat() * maxScale), height: iconSize.height)
                    print("Warning: icon width too big, it has been changed.")
                } else if CGFloat(iconSize.height) / CGFloat(finalSize.height) > maxScale {
                    iconSize = EFIntSize(width: finalSize.width, height: Int(finalSize.heightCGFloat() * maxScale))
                    print("Warning: icon height too big, it has been changed.")
                }
                context.draw(
                    tryIcon,
                    in: CGRect(
                        origin: CGPoint(
                            x: CGFloat(context.width - iconSize.width) / 2.0,
                            y: CGFloat(context.height - iconSize.height) / 2.0
                        ),
                        size: iconSize.toCGSize()
                    )
                )
            }

            result = context.makeImage()
        }

        return result
    }

    private func getPixels() -> [[EFUIntPixel]]? {
        guard let finalContent = self.content else {
            return nil
        }
        let finalInputCorrectionLevel = self.inputCorrectionLevel

        guard let tryQRImagePixels = CIImage.generateQRCode(
            string: finalContent, inputCorrectionLevel: finalInputCorrectionLevel
            )?.toCGImage()?.pixels() else {
                print("Warning: Content too large.")
                return nil
        }
        return tryQRImagePixels
    }

    // Get QRCodes from pixels
    private func getCodes(pixels: [[EFUIntPixel]]) -> [[Bool]] {
        var codes = [[Bool]]()
        for indexY in 0 ..< pixels.count {
            codes.append([Bool]())
            for indexX in 0 ..< pixels[0].count {
                codes[indexY].append(
                    pixels[indexY][indexX].red == 0
                        && pixels[indexY][indexX].green == 0
                        && pixels[indexY][indexX].blue == 0
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

        // Get pixels from image
        guard let tryQRImagePixels = getPixels() else {
            return nil
        }

        // Get QRCodes from image
        imageCodes = getCodes(pixels: tryQRImagePixels)

        return imageCodes
    }

    // Create Colorful QR Image
    private func drawQRCodeImage(codes: [[Bool]], colorBack: CIColor, colorFront: CIColor, size: EFIntSize) -> CGImage? {
        let scaleX = CGFloat(size.width) / CGFloat(codes.count)
        let scaleY = CGFloat(size.height) / CGFloat(codes.count)
        if scaleX < 1.0 || scaleY < 1.0 {
            print("Warning: Size too small.")
        }

        let codeSize = codes.count
        guard let colorCGBack = colorBack.toCGColor(), let colorCGFront = colorFront.toCGColor() else {
            return nil
        }

        var result: CGImage?
        if let context = CreateContext(size: size) {
            // Back
            context.setFillColor(colorCGBack)
            context.fill(CGRect(origin: .zero, size: size.toCGSize()))
            // Point
            context.setFillColor(colorCGFront)
            for indexY in 0 ..< codeSize {
                for indexX in 0 ..< codeSize {
                    if true == codes[indexY][indexX] {
                        // CTM-90
                        let indexXCTM = indexY
                        let indexYCTM = codeSize - indexX - 1
                        context.fill(
                            CGRect(
                                x: CGFloat(indexXCTM) * scaleX + foregroundPointOffset,
                                y: CGFloat(indexYCTM) * scaleY + foregroundPointOffset,
                                width: scaleX - 2 * foregroundPointOffset,
                                height: scaleY - 2 * foregroundPointOffset
                            )
                        )
                    }
                }
            }
            result = context.makeImage()
        }
        return result
    }

    // Create Colorful QR Image
    private func drawQRCodeImageTransparent(codes: [[Bool]], colorBack: CIColor, colorFront: CIColor, size: EFIntSize) -> CGImage? {
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
        var points = [EFIntPoint]()
        if let locations = getAlignmentPatternLocations(version: getVersion(size: codeSize - 2)) {
            for indexX in locations {
                for indexY in locations {
                    let finalX = indexX + 1
                    let finalY = indexY + 1
                    if !((finalX == 7 && finalY == 7)
                        || (finalX == 7 && finalY == (codeSize - 8))
                        || (finalX == (codeSize - 8) && finalY == 7)) {
                        points.append(EFIntPoint(x: finalX, y: finalY))
                    }
                }
            }
        }

        guard let colorCGBack = colorBack.toCGColor(), let colorCGFront = colorFront.toCGColor() else {
            return nil
        }

        var finalImage: CGImage?

        if let context = CreateContext(size: size) {
            // Back point
            context.setFillColor(colorCGBack)
            for indexY in 0 ..< codeSize {
                for indexX in 0 ..< codeSize {
                    if false == codes[indexY][indexX] {
                        // CTM-90
                        let indexXCTM = indexY
                        let indexYCTM = codeSize - indexX - 1
                        if isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points) {
                            context.fill(
                                CGRect(
                                    x: CGFloat(indexXCTM) * scaleX, y: CGFloat(indexYCTM) * scaleY,
                                    width: pointWidthOriX, height: pointWidthOriY
                                )
                            )
                        } else {
                            context.fill(
                                CGRect(
                                    x: CGFloat(indexXCTM) * scaleX + pointMinOffsetX,
                                    y: CGFloat(indexYCTM) * scaleY + pointMinOffsetY,
                                    width: pointWidthMinX, height: pointWidthMinY
                                )
                            )
                        }
                    }
                }
            }
            // Front point
            context.setFillColor(colorCGFront)
            for indexY in 0 ..< codeSize {
                for indexX in 0 ..< codeSize {
                    if true == codes[indexY][indexX] {
                        // CTM-90
                        let indexXCTM = indexY
                        let indexYCTM = codeSize - indexX - 1
                        if isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points) {
                            context.fill(
                                CGRect(
                                    x: CGFloat(indexXCTM) * scaleX + foregroundPointOffset,
                                    y: CGFloat(indexYCTM) * scaleY + foregroundPointOffset,
                                    width: pointWidthOriX - 2 * foregroundPointOffset,
                                    height: pointWidthOriY - 2 * foregroundPointOffset
                                )
                            )
                        } else {
                            context.fill(
                                CGRect(
                                    x: CGFloat(indexXCTM) * scaleX + pointMinOffsetX,
                                    y: CGFloat(indexYCTM) * scaleY + pointMinOffsetY,
                                    width: pointWidthMinX, height: pointWidthMinY
                                )
                            )
                        }
                    }
                }
            }

            finalImage = context.makeImage()
        }
        return finalImage
    }

    // Special Points of QRCode
    private func isStatic(x: Int, y: Int, size: Int, APLPoints: [EFIntPoint]) -> Bool {
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
            if x >= (point.x - 2) && x <= (point.x + 2) && y >= (point.y - 2) && y <= (point.y + 2) {
                return true
            }
        }

        return false
    }

    private func getAlignmentPatternLocations(version: Int) -> [Int]? {
        // http://stackoverflow.com/questions/13238704/calculating-the-position-of-qr-code-alignment-patterns
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

    private func getVersion(size: Int) -> Int {
        return (size - 21) / 4 + 1
    }

    private func getSize(version: Int) -> Int {
        return 17 + 4 * version
    }

    // Pre
    private func drawWatermarkImage(image: CGImage, colorBack: CIColor, mode: EFWatermarkMode, intSize: EFIntSize) -> CGImage? {
        let size = intSize.toCGSize()
        var result: CGImage?
        if let context = CreateContext(size: intSize) {
            if allowTransparent {
                guard let codes = generateCodes() else {
                    return nil
                }
                let finalBackgroundColor = self.backgroundColor
                let finalForegroundColor = self.foregroundColor

                if let tryCGImage = drawQRCodeImage(
                    codes: codes,
                    colorBack: finalBackgroundColor,
                    colorFront: finalForegroundColor,
                    size: minSuitableSize
                    ) {
                    context.draw(tryCGImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                }
            } else {
                if let tryColor = colorBack.toCGColor() {
                    context.setFillColor(tryColor)
                    context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
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
                break
            case .bottomLeft:
                finalSize = imageSize
                finalOrigin = CGPoint(x: 0, y: 0)
                break
            case .bottomRight:
                finalSize = imageSize
                finalOrigin = CGPoint(x: size.width - imageSize.width, y: 0)
                break
            case .center:
                finalSize = imageSize
                finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0, y: (size.height - imageSize.height) / 2.0)
                break
            case .left:
                finalSize = imageSize
                finalOrigin = CGPoint(x: 0, y: (size.height - imageSize.height) / 2.0)
                break
            case .right:
                finalSize = imageSize
                finalOrigin = CGPoint(x: size.width - imageSize.width, y: (size.height - imageSize.height) / 2.0)
                break
            case .top:
                finalSize = imageSize
                finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0, y: size.height - imageSize.height)
                break
            case .topLeft:
                finalSize = imageSize
                finalOrigin = CGPoint(x: 0, y: size.height - imageSize.height)
                break
            case .topRight:
                finalSize = imageSize
                finalOrigin = CGPoint(x: size.width - imageSize.width, y: size.height - imageSize.height)
                break
            case .scaleAspectFill:
                let scale = max(size.width / imageSize.width, size.height / imageSize.height)
                finalSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
                finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0, y: (size.height - finalSize.height) / 2.0)
                break
            case .scaleAspectFit:
                let scale = max(imageSize.width / size.width, imageSize.height / size.height)
                finalSize = CGSize(width: imageSize.width / scale, height: imageSize.height / scale)
                finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0, y: (size.height - finalSize.height) / 2.0)
                break
            default:
                break
            }
            context.draw(image, in: CGRect(origin: finalOrigin, size: finalSize))
            result = context.makeImage()
        }
        return result
    }

    // MARK:- Recommand magnification
    public func minMagnificationGreaterThanOrEqualTo(size: CGFloat) -> Int? {
        guard let codes = generateCodes() else {
            return nil
        }
        let finalWatermark = self.watermark

        let baseMagnification = max(1, Int(size / CGFloat(codes.count)))
        for offset in [Int(0), 1, 2, 3] {
            let tempMagnification = baseMagnification + offset
            if CGFloat(Int(tempMagnification) * codes.count) >= size {
                if finalWatermark == nil {
                    return tempMagnification
                } else {
                    if tempMagnification % 3 == 0 {
                        return tempMagnification
                    }
                }
            }
        }
        return nil
    }

    public func maxMagnificationLessThanOrEqualTo(size: CGFloat) -> Int? {
        guard let codes = generateCodes() else {
            return nil
        }
        let finalWatermark = self.watermark

        let baseMagnification = max(1, Int(size / CGFloat(codes.count)))
        for offset in [0, -1, -2, -3] {
            let tempMagnification = baseMagnification + offset
            if tempMagnification <= 0 {
                return finalWatermark == nil ? 1 : 3
            }
            if CGFloat(tempMagnification * codes.count) <= size {
                if finalWatermark == nil {
                    return Int(tempMagnification)
                } else {
                    if tempMagnification % 3 == 0 {
                        return Int(tempMagnification)
                    }
                }
            }
        }
        return nil
    }

    // MARK:- calculateSuitableSize
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
