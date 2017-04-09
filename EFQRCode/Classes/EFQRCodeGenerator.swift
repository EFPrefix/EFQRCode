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
}

// EFQRCode+Create
public class EFQRCodeGenerator {

    public var content: String? {
        didSet {
            imageQRCode = nil
            QRImageCodes = nil
        }
    }
    public var inputCorrectionLevel: EFInputCorrectionLevel = .h {
        didSet {
            imageQRCode = nil
            QRImageCodes = nil
        }
    }
    public var size: UInt = 256 {
        didSet {
            imageQRCode = nil
        }
    }
    // If set this, size will be ignored.
    public var magnification: UInt? {
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
    public var iconSize: UInt? = nil {
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
    private var QRImageCodes: [[Bool]]?
    private var imageQRCode: CGImage?
    private var minSuitableSize: CGFloat?

    public init(
        content: String,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        size: UInt = 256,
        magnification: UInt? = nil,
        backgroundColor: CIColor = CIColor.white,
        foregroundColor: CIColor = CIColor.black,
        icon: CGImage? = nil,
        iconSize: UInt? = nil,
        isIconColorful: Bool = true,
        watermark: CGImage? = nil,
        watermarkMode: EFWatermarkMode = .scaleToFill,
        isWatermarkColorful: Bool = true
        ) {

        self.content = content
        self.inputCorrectionLevel = inputCorrectionLevel
        self.size = size
        self.magnification = magnification
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.icon = icon
        self.iconSize = iconSize
        self.isIconColorful = isIconColorful
        self.watermark = watermark
        self.watermarkMode = watermarkMode
        self.isWatermarkColorful = isWatermarkColorful
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
        guard let QRCodes = generateCodes() else {
            return nil
        }

        // If magnification is not nil, reset finalSize
        if let tryMagnification = magnification {
            finalSize = tryMagnification * UInt(QRCodes.count)
        }

        var finalImage: CGImage?

        // Cache size
        minSuitableSize = minSuitableSizeGreaterThanOrEqualTo(size: CGFloat(finalSize))

        // Watermark
        if let tryWatermark = finalIsWatermarkColorful ? finalWatermark : finalWatermark?.toCIImage().greyscale()?.toCGImage() {
            // Has watermark
            finalImage = createQRUIImageTransparent(
                codes: QRCodes,
                colorBack: finalBackgroundColor,
                colorFront: finalForegroundColor,
                size: minSuitableSize ?? CGFloat(finalSize)
            )

            // Position of WatermarkImage
            guard let tryPreWatermarkImage = preWatermarkImage(
                image: tryWatermark.toCIImage(),
                colorBack: finalBackgroundColor,
                mode: finalWatermarkMode,
                size: CGSize(width: CGFloat(finalSize), height: CGFloat(finalSize))
                ) else {
                    return nil
            }

            // Mix QRCode and watermark
            finalImage = mixImageCenter(
                back: tryPreWatermarkImage,
                backSize: CGSize(width: CGFloat(finalSize), height: CGFloat(finalSize)),
                fore: finalImage?.toCIImage()
            )?.toCGImage()
        } else {
            //No watermark
            finalImage = createQRUIImage(
                codes: QRCodes,
                colorBack: finalBackgroundColor,
                colorFront: finalForegroundColor,
                size: minSuitableSize ?? CGFloat(finalSize)
            )
        }

        // Add icon
        if let tryIcon = finalIsIconColorful ? finalIcon : finalIcon?.toCIImage().greyscale()?.toCGImage(), let tryFinalImage = finalImage {
            let maxIconSize = CGFloat(finalSize) * [0.26, 0.38, 0.5, 0.54][inputCorrectionLevel.rawValue]
            var iconSize = CGFloat(finalIconSize ?? UInt(CGFloat(finalSize) * 0.2))
            if iconSize > maxIconSize {
                print("Warning: iconSize too big, it has been modified to \(maxIconSize)")
            }

            iconSize = min(maxIconSize, iconSize)
            finalImage = mixImageCenter(
                back: tryFinalImage.toCIImage(),
                backSize: CGSize(width: CGFloat(finalSize), height: CGFloat(finalSize)),
                fore: tryIcon.toCIImage(),
                foreSize: CGSize(width: iconSize, height: iconSize)
            )?.toCGImage()
        }

        return finalImage
    }

    // Create QR CIImage
    private func createQRCIImage(string: String, inputCorrectionLevel: EFInputCorrectionLevel = .m) -> CIImage? {
        let stringData = string.data(using: String.Encoding.utf8)
        if let qrFilter = CIFilter(name: "CIQRCodeGenerator") {
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue(["L", "M", "Q", "H"][inputCorrectionLevel.rawValue], forKey: "inputCorrectionLevel")
            return qrFilter.outputImage
        }
        return nil
    }

    private func getPixels() -> [[EFUIntPixel]]? {
        guard let finalContent = self.content else {
            return nil
        }
        let finalInputCorrectionLevel = self.inputCorrectionLevel

        guard let tryQRImagePixels = createQRCIImage(
            string: finalContent, inputCorrectionLevel: finalInputCorrectionLevel
            )?.pixels() else {
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
        if let tryQRImageCodes = QRImageCodes {
            return tryQRImageCodes
        }

        // Get pixels from image
        guard let tryQRImagePixels = getPixels() else {
            return nil
        }

        // Get QRCodes from image
        QRImageCodes = getCodes(pixels: tryQRImagePixels)

        return QRImageCodes
    }

    // Create Colorful QR Image
    private func createQRUIImage(codes: [[Bool]], colorBack: CIColor, colorFront: CIColor, size: CGFloat) -> CGImage? {
        let scale = size / CGFloat(codes.count)
        if scale < 1.0 {
            print("Warning: Size too small.")
        }

        let codeSize = codes.count

        guard let colorCGBack = colorBack.toCGColor(), let colorCGFront = colorFront.toCGColor() else {
            return nil
        }

        var finalImage: CGImage?

        if let context = CGContext.init(
            data: nil, width: Int(size), height: Int(size),
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) {
            // Back
            context.setFillColor(colorCGBack)
            context.fill(CGRect(x: 0, y: 0, width: size, height: size))
            // Point
            context.setFillColor(colorCGFront)
            for indexY in 0 ..< codeSize {
                for indexX in 0 ..< codeSize {
                    if true == codes[indexY][indexX] {
                        context.fill(
                            CGRect(
                                x: CGFloat(indexX) * scale + foregroundPointOffset,
                                y: CGFloat(indexY) * scale + foregroundPointOffset,
                                width: scale - 2 * foregroundPointOffset,
                                height: scale - 2 * foregroundPointOffset
                            )
                        )
                    }
                }
            }

            finalImage = context.makeImage()
        }
        return finalImage
    }

    // Create Colorful QR Image
    private func createQRUIImageTransparent(codes: [[Bool]], colorBack: CIColor, colorFront: CIColor, size: CGFloat) -> CGImage? {
        let scale = size / CGFloat(codes.count)
        if scale < 3.0 {
            print("Warning: Size too small.")
        }

        let codeSize = codes.count
        let pointMinOffset = scale / 3
        let pointWidthOri = scale
        let pointWidthMin = scale - 2 * pointMinOffset

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

        if let context = CGContext.init(
            data: nil, width: Int(size), height: Int(size),
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) {
            // Back point
            context.setFillColor(colorCGBack)
            for indexY in 0 ..< codeSize {
                for indexX in 0 ..< codeSize {
                    if false == codes[indexY][indexX] {
                        if isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points) {
                            context.fill(
                                CGRect(
                                    x: CGFloat(indexX) * scale, y: CGFloat(indexY) * scale,
                                    width: pointWidthOri, height: pointWidthOri
                                )
                            )
                        } else {
                            context.fill(
                                CGRect(
                                    x: CGFloat(indexX) * scale + pointMinOffset,
                                    y: CGFloat(indexY) * scale + pointMinOffset,
                                    width: pointWidthMin, height: pointWidthMin
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
                        if isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points) {
                            context.fill(
                                CGRect(
                                    x: CGFloat(indexX) * scale + foregroundPointOffset,
                                    y: CGFloat(indexY) * scale + foregroundPointOffset,
                                    width: pointWidthOri - 2 * foregroundPointOffset,
                                    height: pointWidthOri - 2 * foregroundPointOffset
                                )
                            )
                        } else {
                            context.fill(
                                CGRect(
                                    x: CGFloat(indexX) * scale + pointMinOffset,
                                    y: CGFloat(indexY) * scale + pointMinOffset,
                                    width: pointWidthMin,
                                    height: pointWidthMin
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
    private func preWatermarkImage(image: CIImage, colorBack: CIColor, mode: EFWatermarkMode, size: CGSize) -> CIImage? {
        let finalImage: CIImage!
        if allowTransparent {
            guard let QRCodes = generateCodes() else {
                return nil
            }
            let finalBackgroundColor = self.backgroundColor
            let finalForegroundColor = self.foregroundColor

            finalImage = createQRUIImage(
                codes: QRCodes,
                colorBack: finalBackgroundColor,
                colorFront: finalForegroundColor,
                size: minSuitableSize ?? size.width
                )?.toCIImage().resize(size: size)
        } else {
            finalImage = CIImage.create(color: colorBack, size: size)
        }
        guard let _ = finalImage else {
            return nil
        }

        // Image
        var finalSize = size
        var finalOrigin = CGPoint.zero
        switch mode {
        case .bottom:
            finalSize = image.size()
            finalOrigin = CGPoint(x: (size.width - image.size().width) / 2.0, y: 0)
            break
        case .bottomLeft:
            finalSize = image.size()
            finalOrigin = CGPoint(x: 0, y: 0)
            break
        case .bottomRight:
            finalSize = image.size()
            finalOrigin = CGPoint(x: size.width - image.size().width, y: 0)
            break
        case .center:
            finalSize = image.size()
            finalOrigin = CGPoint(x: (size.width - image.size().width) / 2.0, y: (size.height - image.size().height) / 2.0)
            break
        case .left:
            finalSize = image.size()
            finalOrigin = CGPoint(x: 0, y: (size.height - image.size().height) / 2.0)
            break
        case .right:
            finalSize = image.size()
            finalOrigin = CGPoint(x: size.width - image.size().width, y: (size.height - image.size().height) / 2.0)
            break
        case .top:
            finalSize = image.size()
            finalOrigin = CGPoint(x: (size.width - image.size().width) / 2.0, y: size.height - image.size().height)
            break
        case .topLeft:
            finalSize = image.size()
            finalOrigin = CGPoint(x: 0, y: size.height - image.size().height)
            break
        case .topRight:
            finalSize = image.size()
            finalOrigin = CGPoint(x: size.width - image.size().width, y: size.height - image.size().height)
            break
        case .scaleAspectFill:
            let scale = max(size.width / image.size().width, size.height / image.size().height)
            finalSize = CGSize(width: image.size().width * scale, height: image.size().height * scale)
            finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0, y: (size.height - finalSize.height) / 2.0)
            break
        case .scaleAspectFit:
            let scale = max(image.size().width / size.width, image.size().height / size.height)
            finalSize = CGSize(width: image.size().width / scale, height: image.size().height / scale)
            finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0, y: (size.height - finalSize.height) / 2.0)
            break
        default:
            break
        }
        return finalImage?.draw(image: image, rect: CGRect(origin: finalOrigin, size: finalSize))?.clip(
            rect: CGRect(origin: .zero, size: size)
        )
    }

    // Mix
    private func mixImageCenter(back: CIImage, backSize: CGSize, fore: CIImage?, foreSize: CGSize? = nil) -> CIImage? {
        if let tryNewBack = back.resize(size: backSize) {
            let tryForeSize = foreSize ?? backSize
            if let tryFore = fore, let tryNewBack = tryFore.resize(size: tryForeSize) {
                return tryNewBack.draw(
                    image: tryNewBack,
                    loaction: CGPoint(
                        x: (backSize.width - tryForeSize.width) / 2.0,
                        y: (backSize.height - tryForeSize.height) / 2.0
                    )
                )
            }
            return tryNewBack
        }
        return nil
    }

    // MARK:- Recommand magnification
    public func minMagnificationGreaterThanOrEqualTo(size: CGFloat) -> UInt? {
        guard let QRCodes = generateCodes() else {
            return nil
        }
        let finalWatermark = self.watermark

        let baseMagnification = max(1, UInt(size / CGFloat(QRCodes.count)))
        for offset in [UInt(0), 1, 2, 3] {
            let tempMagnification = baseMagnification + offset
            if CGFloat(Int(tempMagnification) * QRCodes.count) >= size {
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

    public func maxMagnificationLessThanOrEqualTo(size: CGFloat) -> UInt? {
        guard let QRCodes = generateCodes() else {
            return nil
        }
        let finalWatermark = self.watermark

        let baseMagnification = max(1, Int(size / CGFloat(QRCodes.count)))
        for offset in [0, -1, -2, -3] {
            let tempMagnification = baseMagnification + offset
            if tempMagnification <= 0 {
                return finalWatermark == nil ? 1 : 3
            }
            if CGFloat(tempMagnification * QRCodes.count) <= size {
                if finalWatermark == nil {
                    return UInt(tempMagnification)
                } else {
                    if tempMagnification % 3 == 0 {
                        return UInt(tempMagnification)
                    }
                }
            }
        }
        return nil
    }

    // MARK:- calculateSuitableSize
    private func minSuitableSizeGreaterThanOrEqualTo(size: CGFloat) -> CGFloat? {
        guard let QRCodes = generateCodes() else {
            return nil
        }
        
        let baseSuitableSize = Int(size)
        for offset in 0...QRCodes.count {
            let tempSuitableSize = baseSuitableSize + offset
            if tempSuitableSize % QRCodes.count == 0 {
                return CGFloat(tempSuitableSize)
            }
        }
        return nil
    }
}
