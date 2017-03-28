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

// Quality
public enum EFQuality: Int {
    case min    = 0;
    case low    = 1;
    case middle = 2;
    case high   = 3;
    case max    = 4;
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

public struct EFUIntPixel {
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var alpha: UInt8 = 0
}

public struct EFIntPoint {
    var x: Int = 0
    var y: Int = 0
}

// EFQRCode+Create
class EFQRCodeGenerator {
    //
    private static let qualityList = [3, 9, 27, 81, 243]

    // MARK:- Public

    // Create image from QRCode string (Basic)
    public static func createQRImage(string: String, inputCorrectionLevel: EFInputCorrectionLevel = .m) -> UIImage? {
        if let tryCIImage = EFQRCodeGenerator.createQRCIImage(string: string, inputCorrectionLevel: inputCorrectionLevel) {
            return UIImage(ciImage: tryCIImage)
        }
        return nil
    }

    // Create image from QRCode string
    public static func createQRImage(
        string: String,
        inputCorrectionLevel: EFInputCorrectionLevel = .m,
        size: CGFloat? = nil,
        quality :EFQuality = EFQuality.middle,
        backColor: UIColor = UIColor.white,
        frontColor: UIColor = UIColor.black,
        icon: UIImage? = nil,
        iconSize: CGFloat? = nil,
        iconColorful: Bool = true,
        watermark: UIImage? = nil,
        watermarkMode: EFWatermarkMode = .scaleToFill,
        watermarkColorful: Bool = true
        ) -> UIImage? {
        var resultUIImage: UIImage?

        // Create original QRCode image
        if let originalQRCodeCIImage = EFQRCodeGenerator.createQRCIImage(string: string, inputCorrectionLevel: inputCorrectionLevel) {

            // Get pixels from image
            if let QRImagePixels = EFQRCodeGenerator.getPixels(inputImage: originalQRCodeCIImage) {

                // Get QRCodes from image
                let QRCodes = EFQRCodeGenerator.getCodes(pixels: QRImagePixels)

                // Get final size
                var finalSize: CGFloat = CGFloat(QRCodes.count)

                if let tryWatermarkUIImage = watermark {

                    // Has watermark
                    finalSize = max(size ?? CGFloat(QRCodes.count * 3), CGFloat(QRCodes.count * 3))

                    // Create colorful QRCode UIImage with trans transparent
                    if let colorfulQRCodeWaterarkUIImage = EFQRCodeGenerator.createFinalQRImage(codes: QRCodes, colorBack: backColor, colorFront: frontColor, quality: quality) {

                        // Get if gray watermark image
                        if let tryGreyImage = watermarkColorful ? tryWatermarkUIImage : EFQRCode.greyScale(image: tryWatermarkUIImage) {

                            // Get if tansform watermark image
                            if let tryGreyImageAfterTrans = EFQRCodeGenerator.preWatermarkImage(image: tryGreyImage, colorBack: backColor, mode: watermarkMode, size: CGSize(width: finalSize, height: finalSize)) {

                                // Mix QRCode and watermark
                                resultUIImage = EFQRCodeGenerator.mixImage(
                                    backImage: tryGreyImageAfterTrans,
                                    backImageSize: CGSize(width: finalSize, height: finalSize),
                                    frontImage: colorfulQRCodeWaterarkUIImage
                                )
                            }
                        }
                    }
                } else {

                    //No watermark
                    finalSize = max(size ?? CGFloat(QRCodes.count), CGFloat(QRCodes.count))

                    // Create colorful QRCode UIImage without transparent
                    if let colorfulQRCodeUIImage = EFQRCodeGenerator.createColorfulQRImage(codes: QRCodes, colorBack: backColor, colorFront: frontColor, quality: quality) {
                        resultUIImage = colorfulQRCodeUIImage
                    }
                }

                // Resize & Add icon
                if let tryResultUIImage = resultUIImage {
                    let maxIconSize = finalSize * [0.26, 0.38, 0.5, 0.54][inputCorrectionLevel.rawValue]
                    let iconSize = min(maxIconSize, iconSize ?? finalSize * 0.2)
                    resultUIImage = EFQRCodeGenerator.mixImage(
                        backImage: tryResultUIImage,
                        backImageSize: CGSize(width: finalSize, height: finalSize),
                        frontImage: iconColorful ? icon : EFQRCode.greyScale(image: icon),
                        frontImageSize: CGSize(width: iconSize, height: iconSize)
                    )
                }

            }
        }
        return resultUIImage
    }

    // MARK:- Private

    // Create QR CIImage
    private static func createQRCIImage(string: String, inputCorrectionLevel: EFInputCorrectionLevel = .m) -> CIImage? {
        let stringData = string.data(using: String.Encoding.utf8)
        if let qrFilter = CIFilter(name: "CIQRCodeGenerator") {
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue(["L", "M", "Q", "H"][inputCorrectionLevel.rawValue], forKey: "inputCorrectionLevel")
            return qrFilter.outputImage
        }
        return nil
    }

    // Get QRCodes from pixels
    private static func getCodes(pixels: [[EFUIntPixel]]) -> [[Bool]] {
        var codes = [[Bool]]()
        for indexY in 0 ..< pixels.count {
            codes.append([Bool]())
            for indexX in 0 ..< pixels[0].count {
                codes[indexY].append(
                    pixels[indexY][indexX].red == 0 && pixels[indexY][indexX].green == 0 && pixels[indexY][indexX].blue == 0
                )
            }
        }
        return codes
    }

    // Get pixels from image
    private static func getPixels(inputImage: CIImage) -> [[EFUIntPixel]]? {
        var pixels: [[EFUIntPixel]]?
        if let tryCGImage = EFQRCodeGenerator.convertCIImageToCGImage(inputImage: inputImage) {
            if let pixelData = tryCGImage.dataProvider?.data {
                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                pixels = [[EFUIntPixel]]()
                for indexY in 0 ..< tryCGImage.height {
                    pixels?.append([EFUIntPixel]())
                    for indexX in 0 ..< tryCGImage.width {
                        let pixelInfo: Int = ((Int(tryCGImage.width) * Int(indexY)) + Int(indexX)) * 4
                        pixels?[indexY].append(
                            EFUIntPixel(
                                red: data[pixelInfo],
                                green: data[pixelInfo + 1],
                                blue: data[pixelInfo + 2],
                                alpha: data[pixelInfo + 3]
                            )
                        )
                    }
                }
                return pixels
            }
        }
        return nil
    }

    // http://wiki.hawkguide.com/wiki/Swift:_Convert_between_CGImage,_CIImage_and_UIImage
    // Convert CIImage To CGImage
    private static func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        return CIContext(options: nil).createCGImage(inputImage, from: inputImage.extent)
    }

    // Convert UIImage to CIImage
    private static func convertUIImageToCIImage(inputImage: UIImage) -> CIImage? {
        return CIImage(image: inputImage)
    }

    // Create Colorful QR Image
    private static func createColorfulQRImage(codes: [[Bool]], colorBack: UIColor, colorFront: UIColor, quality: EFQuality) -> UIImage? {
        let scale = EFQRCodeGenerator.qualityList[quality.rawValue] //Quality
        let codeSize = codes.count
        let imageSize = codeSize * scale

        var finalImage: UIImage?
        UIGraphicsBeginImageContext(CGSize(width: imageSize, height: imageSize))
        if let context = UIGraphicsGetCurrentContext() {
            // Back
            context.setFillColor(colorBack.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
            // Point
            context.setFillColor(colorFront.cgColor)
            for indexY in 0 ..< codeSize {
                for indexX in 0 ..< codeSize {
                    if true == codes[indexY][indexX] {
                        context.fill(CGRect(x: indexX * scale, y: indexY * scale, width: scale, height: scale))
                    }
                }
            }

            finalImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()

        return finalImage
    }

    // Create Colorful QR Image
    private static func createFinalQRImage(codes: [[Bool]], colorBack: UIColor, colorFront: UIColor, quality: EFQuality) -> UIImage? {
        let scale = EFQRCodeGenerator.qualityList[quality.rawValue] //Quality
        let codeSize = codes.count
        let imageSize = codeSize * scale

        // Get AlignmentPatternLocations first
        var points = [EFIntPoint]()
        if let locations = EFQRCodeGenerator.getAlignmentPatternLocations(version: EFQRCodeGenerator.getVersion(size: codeSize - 2)) {
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
        UIGraphicsBeginImageContext(CGSize(width: imageSize, height: imageSize))
        if let context = UIGraphicsGetCurrentContext() {
            // Back point
            context.setFillColor(colorBack.cgColor)
            for indexY in 0 ..< codeSize {
                for indexX in 0 ..< codeSize {
                    if false == codes[indexY][indexX] {
                        if EFQRCodeGenerator.isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points) {
                            context.fill(CGRect(x: indexX * scale, y: indexY * scale, width: scale, height: scale))
                        } else {
                            let margin = scale / 3
                            context.fill(
                                CGRect(
                                    x: indexX * scale + margin, y: indexY * scale + margin,
                                    width: scale - 2 * margin, height: scale - 2 * margin
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
                        if EFQRCodeGenerator.isStatic(x: indexX, y: indexY, size: codeSize, APLPoints: points) {
                            context.fill(CGRect(x: indexX * scale, y: indexY * scale, width: scale, height: scale))
                        } else {
                            let margin = scale / 3
                            context.fill(
                                CGRect(
                                    x: indexX * scale + margin, y: indexY * scale + margin,
                                    width: scale - 2 * margin, height: scale - 2 * margin
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

    // Pre
    private static func preWatermarkImage(image: UIImage, colorBack: UIColor, mode: EFWatermarkMode, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            // Back
            context.setFillColor(colorBack.cgColor)
            context.fill(CGRect(origin: CGPoint.zero, size: size))
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
    private static func mixImage(backImage: UIImage, backImageSize: CGSize, frontImage: UIImage?, frontImageSize: CGSize? = nil) -> UIImage? {
        if let tryBackCIImage = EFQRCodeGenerator.convertUIImageToCIImage(inputImage: backImage) {
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

    // Special Points of QRCode
    private static func isStatic(x: Int, y: Int, size: Int, APLPoints: [EFIntPoint]) -> Bool {
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

    private static func getAlignmentPatternLocations(version: Int) -> [Int]? {
        // http://stackoverflow.com/questions/13238704/calculating-the-position-of-qr-code-alignment-patterns
        if version == 1 {
            return nil
        }
        let divs = 2 + version / 7
        let size = EFQRCodeGenerator.getSize(version: version)
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

    private static func getVersion(size: Int) -> Int {
        return (size - 21) / 4 + 1
    }

    private static func getSize(version: Int) -> Int {
        return 17 + 4 * version
    }
}
