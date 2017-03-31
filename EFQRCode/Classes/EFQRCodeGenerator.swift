//
//  EFQRCodeGenerator.swift
//  Pods
//
//  Created by EyreFree on 17/1/24.
//
//

import Foundation

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
class EFQRCodeGenerator {

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
    public var size: CGFloat = 256 {
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
    public var backgroundColor: UIColor = UIColor.white {
        didSet {
            imageQRCode = nil
        }
    }
    public var foregroundColor: UIColor = UIColor.black {
        didSet {
            imageQRCode = nil
        }
    }
    public var icon: UIImage? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    public var iconSize: CGFloat? = nil {
        didSet {
            imageQRCode = nil
        }
    }
    public var isIconColorful: Bool = true {
        didSet {
            imageQRCode = nil
        }
    }
    public var watermark: UIImage? = nil {
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
    var image: UIImage? {
        get {
            if nil == imageQRCode {
                imageQRCode = createQRCodeImage()
            }
            return imageQRCode
        }
    }

    // MARK:- Cache
    private var QRImageCodes: [[Bool]]?
    private var imageQRCode: UIImage?
    private var minSuitableSize: CGFloat?

    public init(
        content: String,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        size: CGFloat = 256,
        magnification: UInt? = nil,
        backgroundColor: UIColor = UIColor.white,
        foregroundColor: UIColor = UIColor.black,
        icon: UIImage? = nil,
        iconSize: CGFloat? = nil,
        isIconColorful: Bool = true,
        watermark: UIImage? = nil,
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

    private func createQRCodeImage() -> UIImage? {

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
            finalSize = CGFloat(tryMagnification * UInt(QRCodes.count))
        }

        var finalImage: UIImage?

        // Cache size
        minSuitableSize = minSuitableSizeGreaterThanOrEqualTo(size: finalSize)

        // Watermark
        if let tryWatermark = finalIsWatermarkColorful ? finalWatermark : finalWatermark?.greyScale() {
            // Has watermark
            finalImage = createQRUIImageTransparent(
                codes: QRCodes,
                colorBack: finalBackgroundColor,
                colorFront: finalForegroundColor,
                size: minSuitableSize ?? finalSize
            )

            // Position of WatermarkImage
            guard let tryPreWatermarkImage = preWatermarkImage(
                image: tryWatermark,
                colorBack: finalBackgroundColor,
                mode: finalWatermarkMode,
                size: CGSize(width: finalSize, height: finalSize)
                ) else {
                    return nil
            }

            // Mix QRCode and watermark
            finalImage = mixImage(
                backImage: tryPreWatermarkImage,
                backImageSize: CGSize(width: finalSize, height: finalSize),
                frontImage: finalImage
            )
        } else {
            //No watermark
            finalImage = createQRUIImage(
                codes: QRCodes,
                colorBack: finalBackgroundColor,
                colorFront: finalForegroundColor,
                size: minSuitableSize ?? finalSize
            )
        }

        // Add icon
        if let tryIcon = finalIsIconColorful ? finalIcon : finalIcon?.greyScale(), let tryFinalImage = finalImage {
            let maxIconSize = finalSize * [0.26, 0.38, 0.5, 0.54][inputCorrectionLevel.rawValue]
            var iconSize = finalIconSize ?? finalSize * 0.2
            if iconSize > maxIconSize {
                print("Warning: iconSize too big, it has been modified to \(maxIconSize)")
            }

            iconSize = min(maxIconSize, iconSize)
            finalImage = mixImage(
                backImage: tryFinalImage,
                backImageSize: CGSize(width: finalSize, height: finalSize),
                frontImage: tryIcon,
                frontImageSize: CGSize(width: iconSize, height: iconSize)
            )
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
    private func createQRUIImage(codes: [[Bool]], colorBack: UIColor, colorFront: UIColor, size: CGFloat) -> UIImage? {
        let scale = size / CGFloat(codes.count)
        if scale < 1.0 {
            print("Warning: Size too small.")
        }

        let codeSize = codes.count

        var finalImage: UIImage?
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        if let context = UIGraphicsGetCurrentContext() {
            // Back
            context.setFillColor(colorBack.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size, height: size))
            // Point
            context.setFillColor(colorFront.cgColor)
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

            finalImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()

        return finalImage
    }

    // Create Colorful QR Image
    private func createQRUIImageTransparent(
        codes: [[Bool]],
        colorBack: UIColor,
        colorFront: UIColor,
        size: CGFloat
        ) -> UIImage? {

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

        var finalImage: UIImage?
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        if let context = UIGraphicsGetCurrentContext() {
            // Back point
            context.setFillColor(colorBack.cgColor)
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
            context.setFillColor(colorFront.cgColor)
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

            finalImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()

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
    private func preWatermarkImage(image: UIImage, colorBack: UIColor, mode: EFWatermarkMode, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            // Back
            if allowTransparent {
                guard let QRCodes = generateCodes() else {
                    return nil
                }
                let finalBackgroundColor = self.backgroundColor
                let finalForegroundColor = self.foregroundColor

                createQRUIImage(
                    codes: QRCodes,
                    colorBack: finalBackgroundColor,
                    colorFront: finalForegroundColor,
                    size: minSuitableSize ?? size.width
                )?.draw(in: CGRect(origin: CGPoint.zero, size: size))
            } else {
                context.setFillColor(colorBack.cgColor)
                context.fill(CGRect(origin: CGPoint.zero, size: size))
            }
        }
        // Image
        var finalSize = size
        var finalOrigin = CGPoint.zero
        switch mode {
        case .bottom:
            finalSize = image.size
            finalOrigin = CGPoint(x: (size.width - image.size.width) / 2.0, y: size.height - image.size.height)
            break
        case .bottomLeft:
            finalSize = image.size
            finalOrigin = CGPoint(x: 0, y: size.height - image.size.height)
            break
        case .bottomRight:
            finalSize = image.size
            finalOrigin = CGPoint(x: size.width - image.size.width, y: size.height - image.size.height)
            break
        case .center:
            finalSize = image.size
            finalOrigin = CGPoint(x: (size.width - image.size.width) / 2.0, y: (size.height - image.size.height) / 2.0)
            break
        case .left:
            finalSize = image.size
            finalOrigin = CGPoint(x: 0, y: (size.height - image.size.height) / 2.0)
            break
        case .right:
            finalSize = image.size
            finalOrigin = CGPoint(x: size.width - image.size.width, y: (size.height - image.size.height) / 2.0)
            break
        case .top:
            finalSize = image.size
            finalOrigin = CGPoint(x: (size.width - image.size.width) / 2.0, y: 0)
            break
        case .topLeft:
            finalSize = image.size
            finalOrigin = CGPoint(x: 0, y: 0)
            break
        case .topRight:
            finalSize = image.size
            finalOrigin = CGPoint(x: size.width - image.size.width, y: 0)
            break
        case .scaleAspectFill:
            let scale = max(size.width / image.size.width, size.height / image.size.height)
            finalSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0, y: (size.height - finalSize.height) / 2.0)
            break
        case .scaleAspectFit:
            let scale = max(image.size.width / size.width, image.size.height / size.height)
            finalSize = CGSize(width: image.size.width / scale, height: image.size.height / scale)
            finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0, y: (size.height - finalSize.height) / 2.0)
            break
        default:
            break
        }
        image.draw(in: CGRect(origin: finalOrigin, size: finalSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    // Mix
    private func mixImage(
        backImage: UIImage,
        backImageSize: CGSize,
        frontImage: UIImage?,
        frontImageSize: CGSize? = nil
        ) -> UIImage? {

        if let tryBackCIImage = backImage.toCIImage() {
            let extent = tryBackCIImage.extent.integral
            let scaleX: CGFloat = backImageSize.width / extent.width
            let scaleY: CGFloat = backImageSize.height / extent.height

            // Create bitmap
            let width  = size_t(extent.width.multiplied(by: scaleX))
            let height = size_t(extent.height.multiplied(by: scaleY))

            if let bitmapRef = CGContext(
                data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
                ) {
                let context = CIContext(options: nil)
                if let bitmapImage = context.createCGImage(tryBackCIImage, from: extent) {
                    bitmapRef.interpolationQuality = CGInterpolationQuality.none
                    bitmapRef.scaleBy(x: scaleX, y: scaleY)
                    bitmapRef.draw(bitmapImage, in: extent)

                    // Save bitmap to image
                    if let scaledImage = bitmapRef.makeImage() {
                        // Back image
                        let outputImage = UIImage(cgImage: scaledImage)
                        UIGraphicsBeginImageContextWithOptions(outputImage.size, false, UIScreen.main.scale)
                        outputImage.draw(in: CGRect(x: 0, y: 0, width: backImageSize.width, height: backImageSize.height))

                        // Front image
                        if let waterimage = frontImage {
                            let waterImageSize: CGSize = frontImageSize ?? backImageSize
                            waterimage.draw(
                                in: CGRect(
                                    x: (backImageSize.width - waterImageSize.width) / 2.0,
                                    y: (backImageSize.height - waterImageSize.height) / 2.0,
                                    width: waterImageSize.width,
                                    height: waterImageSize.height
                                )
                            )
                        }

                        // Final Image
                        let newPic = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        return newPic
                    }
                }
            }
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
