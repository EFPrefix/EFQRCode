//
//  EFQRCodeX.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/1.
//
//  Copyright (c) 2017-2024 EyreFree <eyrefree@eyrefree.org>
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
import ImageIO
#if canImport(MobileCoreServices)
import MobileCoreServices
#else
import CoreServices
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif
#if canImport(AVFoundation) && !os(watchOS)
import AVFoundation
import CoreVideo
#endif

import QRCodeSwift
import SwiftDraw

public extension EFQRCode {
    
    /**
     * A QR code generator that creates QR codes with various styles and output formats.
     *
     * The `Generator` class is the main entry point for creating QR codes in EFQRCode.
     * It supports multiple initialization methods, various output formats, and custom styling.
     *
     * ## Basic Usage
     *
     * ```swift
     * // Create a generator with text
     * let generator = try EFQRCode.Generator("Hello World")
     * 
     * // Generate an image
     * let image = try generator.toImage(width: 200)
     * 
     * // Generate PNG data
     * let pngData = try generator.toPNGData(width: 200)
     * ```
     *
     * ## Initialization
     *
     * You can initialize a generator with:
     * - String content with encoding
     * - Data content
     * - Existing QRCode object
     *
     * ## Output Formats
     *
     * The generator supports multiple output formats:
     * - **Images**: PNG, JPEG, SVG
     * - **Animated**: GIF, APNG
     * - **Video**: MOV, M4V, MP4
     * - **Document**: PDF
     *
     * ## Styling
     *
     * QR codes can be styled with various styles including:
     * - Basic styles
     * - Bubble styles
     * - 2.5D styles
     * - Image-based styles
     * - Custom icons and watermarks
     *
     * ## Error Handling
     *
     * The generator throws `EFQRCodeError` for various error conditions:
     * - Invalid text encoding
     * - Data too large for QR code capacity
     * - Invalid style configurations
     * - Output format errors
     */
    class Generator {
        /// The underlying QR code object containing the encoded data and structure.
        public let qrcode: QRCode
        
        /// The style implementation that defines how the QR code is rendered.
        public let style: EFQRCodeStyleBase
        
        /// Cache for SVG content to avoid regeneration.
        private var svgContentCache: String?
        
        /**
         * Creates a QR code generator with text content.
         *
         * - Parameters:
         *   - text: The text content to encode in the QR code.
         *   - encoding: The string encoding to use for the text. Defaults to UTF-8.
         *   - errorCorrectLevel: The error correction level for the QR code. Defaults to high (H).
         *   - style: The style to apply to the QR code.
         * - Throws: `EFQRCodeError` if the text cannot be encoded or if the data is too large.
         */
        public convenience init(
            _ text: String,
            encoding: String.Encoding = .utf8,
            errorCorrectLevel: EFCorrectionLevel = .h,
            style: EFQRCodeStyle
        ) throws {
            guard let data = text.data(using: encoding) else {
                throw EFQRCodeError.text(text, incompatibleWithEncoding: encoding)
            }
            try self.init(data, errorCorrectLevel: errorCorrectLevel, style: style)
        }
        
        /**
         * Creates a QR code generator with data content.
         *
         * - Parameters:
         *   - data: The data to encode in the QR code.
         *   - errorCorrectLevel: The error correction level for the QR code. Defaults to high (H).
         *   - style: The style to apply to the QR code.
         * - Throws: `EFQRCodeError` if the data is too large for QR code capacity.
         */
        public init(
            _ data: Data,
            errorCorrectLevel: EFCorrectionLevel = .h,
            style: EFQRCodeStyle
        ) throws {
            do {
                self.qrcode = try QRCode(
                    data,
                    errorCorrectLevel: errorCorrectLevel.qrErrorCorrectLevel,
                    withBorder: false,
                    needTypeTable: true
                )
            } catch {
                throw (error as? QRCodeError)?.efQRCodeError ?? error
            }
            
            self.style = style.implementation
        }
        
        /**
         * Creates a QR code generator with an existing QR code object.
         *
         * - Parameters:
         *   - qrcode: An existing QR code object.
         *   - style: The style to apply to the QR code.
         */
        public convenience init(
            _ qrcode: QRCode,
            style: EFQRCodeStyle
        ) {
            self.init(qrcode, styleImplementation: style.implementation)
        }
        
        /**
         * Creates a QR code generator with an existing QR code object and style implementation.
         *
         * - Parameters:
         *   - qrcode: An existing QR code object.
         *   - styleImplementation: The style implementation to apply to the QR code.
         */
        public init(
            _ qrcode: QRCode,
            styleImplementation: EFQRCodeStyleBase
        ) {
            self.qrcode = qrcode
            self.style = styleImplementation
        }
        
        /**
         * Creates a copy of the generator with a new style.
         *
         * - Parameter style: The new style to apply.
         * - Returns: A new generator instance with the updated style.
         */
        func copyWith(
            style: EFQRCodeStyle
        ) -> Generator {
            return Generator(
                qrcode,
                style: style
            )
        }
        
        /**
         * Indicates whether the QR code contains animated content.
         *
         * This property checks if the SVG content contains animation elements.
         * It's computed lazily and cached for performance.
         */
        public lazy var isAnimated: Bool = {
            if let svgContent = try? toSVG() {
                return svgContent.contains("<animate")
            }
            return false
        }()
        
        /**
         * Generates SVG content for the QR code.
         *
         * - Returns: The SVG string representation of the QR code.
         * - Throws: `EFQRCodeError` if SVG generation fails.
         */
        public func toSVG() throws -> String {
            if let svgContent = svgContentCache {
                return svgContent
            }
            let svgString = try self.style.generateSVG(qrcode: qrcode)
            self.svgContentCache = svgString
            return svgString
        }
        
#if canImport(UIKit)
        /**
         * Generates a UIImage with the specified width.
         *
         * - Parameters:
         *   - width: The desired width of the image in points.
         *   - insets: Edge insets to apply to the image. Defaults to zero.
         * - Returns: A UIImage representation of the QR code.
         * - Throws: `EFQRCodeError` if image generation fails.
         */
        public func toImage(width: CGFloat, insets: UIEdgeInsets = .zero) throws -> UIImage {
            let imageSize: CGSize = calculateSize(width: width)
            return try toImage(size: imageSize, insets: insets)
        }
        
        /**
         * Generates a UIImage with the specified height.
         *
         * - Parameters:
         *   - height: The desired height of the image in points.
         *   - insets: Edge insets to apply to the image. Defaults to zero.
         * - Returns: A UIImage representation of the QR code.
         * - Throws: `EFQRCodeError` if image generation fails.
         */
        public func toImage(height: CGFloat, insets: UIEdgeInsets = .zero) throws -> UIImage {
            let imageSize: CGSize = calculateSize(height: height)
            return try toImage(size: imageSize, insets: insets)
        }
        
        /**
         * Generates a UIImage with the specified size.
         *
         * - Parameters:
         *   - size: The desired size of the image in points.
         *   - insets: Edge insets to apply to the image. Defaults to zero.
         * - Returns: A UIImage representation of the QR code.
         * - Throws: `EFQRCodeError` if image generation fails.
         */
        private func toImage(size: CGSize, insets: UIEdgeInsets = .zero) throws -> UIImage {
            let newSvgContent: String = try checkIfNeedResize(size: size)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)?.expanded(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
            guard let image = svg?.rasterize(size: size, scale: 1) else {
                throw EFQRCodeError.cannotCreateUIImage
            }
            
            return image
        }
#endif
        
#if canImport(AppKit)
        /**
         * Generates an NSImage with the specified width.
         *
         * - Parameters:
         *   - width: The desired width of the image in points.
         *   - insets: Edge insets to apply to the image. Defaults to zero.
         * - Returns: An NSImage representation of the QR code.
         * - Throws: `EFQRCodeError` if image generation fails.
         */
        public func toImage(width: CGFloat, insets: NSEdgeInsets = .zero) throws -> NSImage {
            let imageSize: CGSize = calculateSize(width: width)
            return try toImage(size: imageSize, insets: insets)
        }
        
        /**
         * Generates an NSImage with the specified height.
         *
         * - Parameters:
         *   - height: The desired height of the image in points.
         *   - insets: Edge insets to apply to the image. Defaults to zero.
         * - Returns: An NSImage representation of the QR code.
         * - Throws: `EFQRCodeError` if image generation fails.
         */
        public func toImage(height: CGFloat, insets: NSEdgeInsets = .zero) throws -> NSImage {
            let imageSize: CGSize = calculateSize(height: height)
            return try toImage(size: imageSize, insets: insets)
        }
        
        /**
         * Generates an NSImage with the specified size.
         *
         * - Parameters:
         *   - size: The desired size of the image in points.
         *   - insets: Edge insets to apply to the image. Defaults to zero.
         * - Returns: An NSImage representation of the QR code.
         * - Throws: `EFQRCodeError` if image generation fails.
         */
        private func toImage(size: CGSize, insets: NSEdgeInsets = .zero) throws -> NSImage {
            let newSvgContent: String = try checkIfNeedResize(size: size)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)?.expanded(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
            guard let image = svg?.rasterize(with: size, scale: 1) else {
                throw EFQRCodeError.cannotCreateUIImage
            }
            
            return image
        }
#endif
        
        // MARK:- Video
#if canImport(AVFoundation) && !os(watchOS)
        /**
         * Generates MOV video data with the specified width.
         *
         * - Parameters:
         *   - width: The desired width of the video in points.
         *   - insets: Edge insets to apply to the video. Defaults to zero.
         * - Returns: MOV video data containing the animated QR code.
         * - Throws: `EFQRCodeError` if video generation fails.
         */
        public func toMovData(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toVideoData(format: .mov, size: imageSize, insets: insets)
        }
        
        /**
         * Generates M4V video data with the specified width.
         *
         * - Parameters:
         *   - width: The desired width of the video in points.
         *   - insets: Edge insets to apply to the video. Defaults to zero.
         * - Returns: M4V video data containing the animated QR code.
         * - Throws: `EFQRCodeError` if video generation fails.
         */
        public func toM4vData(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toVideoData(format: .m4v, size: imageSize, insets: insets)
        }
        
        /**
         * Generates MP4 video data with the specified width.
         *
         * - Parameters:
         *   - width: The desired width of the video in points.
         *   - insets: Edge insets to apply to the video. Defaults to zero.
         * - Returns: MP4 video data containing the animated QR code.
         * - Throws: `EFQRCodeError` if video generation fails.
         */
        public func toMp4Data(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toVideoData(format: .mp4, size: imageSize, insets: insets)
        }
#endif
        
        // MARK:- GIF
        /**
         * Generates GIF data with the specified width.
         *
         * - Parameters:
         *   - width: The desired width of the GIF in points.
         *   - insets: Edge insets to apply to the GIF. Defaults to zero.
         * - Returns: GIF data containing the animated QR code.
         * - Throws: `EFQRCodeError` if GIF generation fails.
         */
        public func toGIFData(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toGIFData(size: imageSize, insets: insets)
        }
        
        /**
         * Generates GIF data with the specified height.
         *
         * - Parameters:
         *   - height: The desired height of the GIF in points.
         *   - insets: Edge insets to apply to the GIF. Defaults to zero.
         * - Returns: GIF data containing the animated QR code.
         * - Throws: `EFQRCodeError` if GIF generation fails.
         */
        public func toGIFData(height: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(height: height)
            return try toGIFData(size: imageSize, insets: insets)
        }
        
        /**
         * Generates GIF data with the specified size.
         *
         * - Parameters:
         *   - size: The desired size of the GIF in points.
         *   - insets: Edge insets to apply to the GIF. Defaults to zero.
         * - Returns: GIF data containing the animated QR code.
         * - Throws: `EFQRCodeError` if GIF generation fails.
         */
        private func toGIFData(size: CGSize, insets: EFEdgeInsets = .zero) throws -> Data {
            return try toAnimatedImage(format: EFAnimatedImageFormat.gif, size: size, insets: insets)
        }
        
        // MARK:- APNG
        /**
         * Generates APNG data with the specified width.
         *
         * - Parameters:
         *   - width: The desired width of the APNG in points.
         *   - insets: Edge insets to apply to the APNG. Defaults to zero.
         * - Returns: APNG data containing the animated QR code.
         * - Throws: `EFQRCodeError` if APNG generation fails.
         */
        public func toAPNGData(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toAPNGData(size: imageSize, insets: insets)
        }
        
        /**
         * Generates APNG data with the specified height.
         *
         * - Parameters:
         *   - height: The desired height of the APNG in points.
         *   - insets: Edge insets to apply to the APNG. Defaults to zero.
         * - Returns: APNG data containing the animated QR code.
         * - Throws: `EFQRCodeError` if APNG generation fails.
         */
        public func toAPNGData(height: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(height: height)
            return try toAPNGData(size: imageSize, insets: insets)
        }
        
        /**
         * Generates APNG data with the specified size.
         *
         * - Parameters:
         *   - size: The desired size of the APNG in points.
         *   - insets: Edge insets to apply to the APNG. Defaults to zero.
         * - Returns: APNG data containing the animated QR code.
         * - Throws: `EFQRCodeError` if APNG generation fails.
         */
        private func toAPNGData(size: CGSize, insets: EFEdgeInsets = .zero) throws -> Data {
            return try toAnimatedImage(format: EFAnimatedImageFormat.apng, size: size, insets: insets)
        }
        
        // MARK:- JPEG
        /**
         * Generates JPEG data with the specified width.
         *
         * - Parameters:
         *   - width: The desired width of the JPEG in points.
         *   - compressionQuality: The compression quality (0.0 to 1.0). Defaults to 1.0.
         *   - insets: Edge insets to apply to the JPEG. Defaults to zero.
         * - Returns: JPEG data containing the QR code.
         * - Throws: `EFQRCodeError` if JPEG generation fails.
         */
        public func toJPEGData(width: CGFloat, compressionQuality: CGFloat = 1, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toJPEGData(size: imageSize, compressionQuality: compressionQuality, insets: insets)
        }
        
        /**
         * Generates JPEG data with the specified height.
         *
         * - Parameters:
         *   - height: The desired height of the JPEG in points.
         *   - compressionQuality: The compression quality (0.0 to 1.0). Defaults to 1.0.
         *   - insets: Edge insets to apply to the JPEG. Defaults to zero.
         * - Returns: JPEG data containing the QR code.
         * - Throws: `EFQRCodeError` if JPEG generation fails.
         */
        public func toJPEGData(height: CGFloat, compressionQuality: CGFloat = 1, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(height: height)
            return try toJPEGData(size: imageSize, compressionQuality: compressionQuality, insets: insets)
        }
        
        /**
         * Generates JPEG data with the specified size.
         *
         * - Parameters:
         *   - size: The desired size of the JPEG in points.
         *   - compressionQuality: The compression quality (0.0 to 1.0). Defaults to 1.0.
         *   - insets: Edge insets to apply to the JPEG. Defaults to zero.
         * - Returns: JPEG data containing the QR code.
         * - Throws: `EFQRCodeError` if JPEG generation fails.
         */
        private func toJPEGData(size: CGSize, compressionQuality: CGFloat = 1, insets: EFEdgeInsets = .zero) throws -> Data {
            let newSvgContent: String = try checkIfNeedResize(size: size)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            let svg = SVG(data: svgData)?.sized(size).expanded(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
            guard let data = try svg?.jpegData(scale: 1, compressionQuality: compressionQuality) else {
                throw EFQRCodeError.cannotCreateImageData
            }
            return data
        }
        
        // MARK:- PNG
        /**
         * Generates PNG data with the specified width.
         *
         * - Parameters:
         *   - width: The desired width of the PNG in points.
         *   - insets: Edge insets to apply to the PNG. Defaults to zero.
         * - Returns: PNG data containing the QR code.
         * - Throws: `EFQRCodeError` if PNG generation fails.
         */
        public func toPNGData(width: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toPNGData(size: imageSize, insets: insets)
        }
        
        /**
         * Generates PNG data with the specified height.
         *
         * - Parameters:
         *   - height: The desired height of the PNG in points.
         *   - insets: Edge insets to apply to the PNG. Defaults to zero.
         * - Returns: PNG data containing the QR code.
         * - Throws: `EFQRCodeError` if PNG generation fails.
         */
        public func toPNGData(height: CGFloat, insets: EFEdgeInsets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(height: height)
            return try toPNGData(size: imageSize, insets: insets)
        }
        
        /**
         * Generates PNG data with the specified size.
         *
         * - Parameters:
         *   - size: The desired size of the PNG in points.
         *   - insets: Edge insets to apply to the PNG. Defaults to zero.
         * - Returns: PNG data containing the QR code.
         * - Throws: `EFQRCodeError` if PNG generation fails.
         */
        private func toPNGData(size: CGSize, insets: EFEdgeInsets = .zero) throws -> Data {
            let newSvgContent: String = try checkIfNeedResize(size: size)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            let svg = SVG(data: svgData)?.sized(size).expanded(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
            guard let data = try svg?.pngData(scale: 1) else {
                throw EFQRCodeError.cannotCreateImageData
            }
            return data
        }

        // MARK:- PDF
        /**
         * Generates PDF data with the specified width.
         *
         * - Parameters:
         *   - width: The desired width of the PDF in points.
         *   - insets: Edge insets to apply to the PDF. Defaults to zero.
         * - Returns: PDF data containing the QR code.
         * - Throws: `EFQRCodeError` if PDF generation fails.
         */
        public func toPDFData(width: CGFloat, insets: SVG.Insets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(width: width)
            return try toPDFData(size: imageSize, insets: insets)
        }
        
        /**
         * Generates PDF data with the specified height.
         *
         * - Parameters:
         *   - height: The desired height of the PDF in points.
         *   - insets: Edge insets to apply to the PDF. Defaults to zero.
         * - Returns: PDF data containing the QR code.
         * - Throws: `EFQRCodeError` if PDF generation fails.
         */
        public func toPDFData(height: CGFloat, insets: SVG.Insets = .zero) throws -> Data {
            let imageSize: CGSize = calculateSize(height: height)
            return try toPDFData(size: imageSize, insets: insets)
        }
        
        /**
         * Generates PDF data with the specified size.
         *
         * - Parameters:
         *   - size: The desired size of the PDF in points.
         *   - insets: Edge insets to apply to the PDF. Defaults to zero.
         * - Returns: PDF data containing the QR code.
         * - Throws: `EFQRCodeError` if PDF generation fails.
         */
        private func toPDFData(size: CGSize, insets: SVG.Insets = .zero) throws -> Data {
            let newSvgContent: String = try checkIfNeedResize(size: size)
            guard let svgData = newSvgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(newSvgContent, incompatibleWithEncoding: .utf8)
            }
            let svg = SVG(data: svgData)?.sized(size).expanded(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
            guard let data = try svg?.pdfData() else {
                throw EFQRCodeError.cannotCreateImageData
            }
            return data
        }
    }
}

/**
 * Private extension for EFQRCode.Generator providing internal implementation methods.
 *
 * This extension contains private helper methods used internally by the Generator
 * class for image processing, size calculations, animation handling, and video generation.
 *
 * ## Internal Methods
 *
 * - **Size Calculations**: Methods for calculating image dimensions
 * - **Image Processing**: Methods for resizing and processing images
 * - **Animation Handling**: Methods for creating animated images and videos
 * - **Mathematical Utilities**: Helper methods for GCD, LCM, and rational approximations
 */
extension EFQRCode.Generator {
    /**
     * Calculates the size of the QR code image based on the specified width.
     *
     * This method maintains the aspect ratio of the QR code while scaling to the
     * specified width.
     *
     * - Parameter width: The target width for the image.
     * - Returns: A CGSize with the calculated dimensions.
     */
    private func calculateSize(width: CGFloat) -> CGSize {
        let viewBox: CGRect = self.style.viewBox(qrcode: self.qrcode)
        let imageHeight: CGFloat = width / viewBox.width * viewBox.height
        return CGSize(width: width, height: imageHeight)
    }
    
    /**
     * Calculates the size of the QR code image based on the specified height.
     *
     * This method maintains the aspect ratio of the QR code while scaling to the
     * specified height.
     *
     * - Parameter height: The target height for the image.
     * - Returns: A CGSize with the calculated dimensions.
     */
    private func calculateSize(height: CGFloat) -> CGSize {
        let viewBox: CGRect = self.style.viewBox(qrcode: self.qrcode)
        let imageWidth: CGFloat = height / viewBox.height * viewBox.width
        return CGSize(width: imageWidth, height: height)
    }
    
    /**
     * Checks if image resizing is needed and returns the appropriate SVG content.
     *
     * This method determines if the icon or watermark images need to be resized
     * based on the target size and percentage constraints. If resizing is needed,
     * it creates a new SVG with the resized images.
     *
     * - Parameter size: The target size for the QR code image.
     * - Returns: SVG content string with appropriate image sizing.
     * - Throws: `EFQRCodeError` if image processing fails.
     */
    private func checkIfNeedResize(size: CGSize) throws -> String {
        func judgeImage(containerSize: CGSize, percentage: CGFloat, targetImage: CGImage, needRecreate: Bool) throws -> EFStyleParamImage? {
            let canvasSize: CGSize = CGSize(width: containerSize.width * percentage, height: containerSize.height * percentage)
            let imageSize: CGSize = CGSize(width: targetImage.width.cgFloat, height: targetImage.height.cgFloat)
            if imageSize.width > canvasSize.width || imageSize.height > canvasSize.height {
                let newImageSize = EFImageMode.scaleAspectFill.rectForContent(ofSize: imageSize, inCanvasOfSize: canvasSize)
                let resizedImage = try targetImage.resize(to: newImageSize.size)
                return EFStyleParamImage.static(image: resizedImage)
            }
            if needRecreate {
                return EFStyleParamImage.static(image: targetImage)
            }
            return nil
        }
        
        var (iconImage, watermarkImage) = style.getParamImages()
        var needRecreateIcon: Bool = false
        var needRecreateWatermark: Bool = false
        
        if let tryIcon = iconImage, let tryIconImage: CGImage = {
            switch tryIcon {
            case .static(let image):
                return image
            case .animated(let images, _):
                if let firstFrame = images.first {
                    needRecreateIcon = true
                    return firstFrame
                }
                return nil
            }
        }(), let resizedImage = try judgeImage(containerSize: size, percentage: 0.33, targetImage: tryIconImage, needRecreate: needRecreateIcon) {
            iconImage = resizedImage
            needRecreateIcon = true
        }
        if let tryWatermark = watermarkImage, let tryWatermarkImage: CGImage = {
            switch tryWatermark {
            case .static(let image):
                return image
            case .animated(let images, _):
                if let firstFrame = images.first {
                    needRecreateWatermark = true
                    return firstFrame
                }
                return nil
            }
        }(), let resizedImage = try judgeImage(containerSize: size, percentage: 1, targetImage: tryWatermarkImage, needRecreate: needRecreateWatermark) {
            watermarkImage = resizedImage
            needRecreateWatermark = true
        }
        
        let newSvgContent: String = try {
            if needRecreateIcon || needRecreateWatermark {
                return try style.copyWith(iconImage: iconImage, watermarkImage: watermarkImage).generateSVG(qrcode: qrcode)
            } else {
                return try toSVG()
            }
        }()
        return newSvgContent
    }
    
    /**
     * Generates animated frames for the QR code.
     *
     * This method creates an array of CGImages and their corresponding durations
     * for animated QR codes. If the QR code is not animated, it returns a single
     * frame with duration 1.
     *
     * - Parameters:
     *   - size: The target size for the frames.
     *   - insets: Edge insets for the image. Defaults to zero.
     * - Returns: A tuple containing arrays of CGImages and their durations.
     * - Throws: `EFQRCodeError` if frame generation fails.
     */
    private func getAnimatedFrames(size: CGSize, insets: EFEdgeInsets = .zero) throws -> ([CGImage], [CGFloat]) {
        return try {
            if self.isAnimated {
                let (iconImage, watermarkImage) = self.style.getParamImages()
                return try self.reconcileQRImages(image1: iconImage, image2: watermarkImage, style: self.style, size: size)
            } else {
                if let cgImage = try self.toImage(size: size, insets: insets).cgImage() {
                    return ([cgImage], [1])
                }
            }
            return ([], [])
        }()
    }
    
    /**
     * Creates an animated image in the specified format.
     *
     * This method generates an animated image (GIF or APNG) from the QR code
     * with the specified size and format.
     *
     * - Parameters:
     *   - format: The animated image format (GIF or APNG).
     *   - size: The target size for the animated image.
     *   - insets: Edge insets for the image. Defaults to zero.
     * - Returns: Data containing the animated image.
     * - Throws: `EFQRCodeError` if animated image creation fails.
     */
    private func toAnimatedImage(format: EFAnimatedImageFormat, size: CGSize, insets: EFEdgeInsets = .zero) throws -> Data {
        let (images, durations): ([CGImage], [CGFloat]) = try getAnimatedFrames(size: size, insets: insets)
        let animatedImageData = try self.createAnimatedImageDataWith(format: format, frames: images, frameDelays: durations)
        return animatedImageData
    }
    
    /**
     * Reconciles multiple images for animated QR code generation.
     *
     * This method processes icon and watermark images to create synchronized
     * animated frames. It uses parallel processing for performance.
     *
     * - Parameters:
     *   - image1: The first image (typically icon).
     *   - image2: The second image (typically watermark).
     *   - style: The QR code style to apply.
     *   - size: The target size for the frames.
     * - Returns: A tuple containing arrays of CGImages and their durations.
     * - Throws: `EFQRCodeError` if frame generation fails.
     */
    private func reconcileQRImages(image1: EFStyleParamImage?, image2: EFStyleParamImage?, style: EFQRCodeStyleBase, size: CGSize) throws -> ([CGImage], [CGFloat]) {
        let (iconFrames, watermarkFrames, delays) = self.reconcileFrameImages(image1: image1, image2: image2)
        var qrFrames = [CGImage?](repeating: nil, count: delays.count)
        
        let processorCount: Int = ProcessInfo.processInfo.activeProcessorCount
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = max(2, processorCount - 1)
        var encounteredError: Error?
        let errorLock = NSLock()
        
        for index in 0..<delays.count {
            queue.addOperation {
                autoreleasepool {
                    do {
                        let iconImage: EFStyleParamImage? = iconFrames.isEmpty ? nil : EFStyleParamImage.static(image: iconFrames[index])
                        let watermarkImage: EFStyleParamImage? = watermarkFrames.isEmpty ? nil : EFStyleParamImage.static(image: watermarkFrames[index])
                        let frameStyle: EFQRCodeStyleBase = style.copyWith(iconImage: iconImage, watermarkImage: watermarkImage)
                        let tempGenerator: EFQRCode.Generator = EFQRCode.Generator(self.qrcode, styleImplementation: frameStyle)
                        let qrFrame = try tempGenerator.toImage(size: size)
                        guard let qrFrameCGImage = qrFrame.cgImage() else {
                            throw EFQRCodeError.cannotCreateCGImage
                        }
                        qrFrames[index] = qrFrameCGImage
                    } catch {
                        errorLock.lock()
                        if encounteredError == nil {
                            encounteredError = error
                            queue.cancelAllOperations()
                        }
                        errorLock.unlock()
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        if let error = encounteredError {
            throw error
        }
        
        let finalQRFrames = qrFrames.compactMap { $0 }
        return (finalQRFrames, delays)
    }
    
    /**
     * Reconciles frame images for synchronized animation.
     *
     * This method synchronizes two animated images by finding the least common
     * multiple of their durations and creating synchronized frame sequences.
     *
     * - Parameters:
     *   - image1: The first animated image.
     *   - image2: The second animated image.
     * - Returns: A tuple containing synchronized frame arrays and delays.
     */
    private func reconcileFrameImages(image1: EFStyleParamImage?, image2: EFStyleParamImage?) -> ([CGImage], [CGImage], [CGFloat]) {
        if let image1 = image1 {
            if let image2 = image2 {
                let (frames1, delays1) = self.frameImages(image: image1)
                let (frames2, delays2) = self.frameImages(image: image2)
                
                if frames1.count == 1 {
                    let resultImages1 = [CGImage](repeating: frames1[0], count: frames2.count)
                    return (resultImages1, frames2, delays2)
                } else if frames2.count == 1 {
                    let resultImages2 = [CGImage](repeating: frames2[0], count: frames1.count)
                    return (frames1, resultImages2, delays1)
                } else {
                    let duration1: CGFloat = delays1.reduce(0, +)
                    let duration2: CGFloat = delays2.reduce(0, +)
                    let duration: CGFloat = lcm(duration1, duration2)
                    let repeatCount1: Int = lround(duration / duration1)
                    let repeatCount2: Int = lround(duration / duration2)
                    
                    var resultImages1: [CGImage] = [], resultImages2: [CGImage] = [], resultDelays: [CGFloat] = []
                    let imagesCount1: Int = frames1.count
                    let imagesCount2: Int = frames2.count
                    let maxIndex1: Int = repeatCount1 * imagesCount1 - 1
                    let maxIndex2: Int = repeatCount2 * imagesCount2 - 1
                    var index1: Int = 0, index2: Int = 0
                    var remainDelay: CGFloat = 0
                    var remainIs1: Bool = true
                    var durationLeft: CGFloat = duration
                    
                    repeat {
                        let arrayIndex1: Int = index1 % imagesCount1
                        let arrayIndex2: Int = index2 % imagesCount2
                        let frame1: CGImage = frames1[arrayIndex1]
                        let frame2: CGImage = frames2[arrayIndex2]
                        let delay1: CGFloat = delays1[arrayIndex1]
                        let delay2: CGFloat = delays2[arrayIndex2]
                        var currentDelay: CGFloat = delay1
                        
                        if remainDelay == 0 {
                            if delay1 < delay2 {
                                index1 += 1
                                remainDelay = delay2 - delay1
                                remainIs1 = false
                                currentDelay = delay1
                            } else if delay1 > delay2 {
                                index2 += 1
                                remainDelay = delay1 - delay2
                                remainIs1 = true
                                currentDelay = delay2
                            } else {
                                index1 += 1
                                index2 += 1
                                remainDelay = 0
                                remainIs1 = true
                                currentDelay = delay1
                            }
                        } else {
                            if remainIs1 {
                                if remainDelay < delay2 {
                                    index1 += 1
                                    remainDelay = delay2 - remainDelay
                                    remainIs1 = false
                                    currentDelay = remainDelay
                                } else if remainDelay > delay2 {
                                    index2 += 1
                                    remainDelay = remainDelay - delay2
                                    remainIs1 = true
                                    currentDelay = delay2
                                } else {
                                    index1 += 1
                                    index2 += 1
                                    remainDelay = 0
                                    remainIs1 = true
                                    currentDelay = delay1
                                }
                            } else {
                                if delay1 < remainDelay {
                                    index1 += 1
                                    remainDelay = remainDelay - delay1
                                    remainIs1 = false
                                    currentDelay = delay1
                                } else if delay1 > remainDelay {
                                    index2 += 1
                                    remainDelay = delay1 - remainDelay
                                    remainIs1 = true
                                    currentDelay = remainDelay
                                } else {
                                    index1 += 1
                                    index2 += 1
                                    remainDelay = 0
                                    remainIs1 = true
                                    currentDelay = delay1
                                }
                            }
                        }
                        
                        resultImages1.append(frame1)
                        resultImages2.append(frame2)
                        
                        let tryDurationLeft: CGFloat = durationLeft - currentDelay
                        if tryDurationLeft <= 0.001 {
                            resultDelays.append(durationLeft)
                        } else {
                            resultDelays.append(currentDelay)
                        }
                        durationLeft = tryDurationLeft
                        
                        if durationLeft <= 0.001 || index1 > maxIndex1 || index2 > maxIndex2 {
                            break
                        }
                    } while (true)
                    
                    return (resultImages1, resultImages2, resultDelays)
                }
            } else {
                let (frames, delays) = frameImages(image: image1)
                return (frames, [], delays)
            }
        } else {
            if let image2 = image2 {
                let (frames, delays) = frameImages(image: image2)
                return ([], frames, delays)
            }
        }
        return ([], [], [])
    }
    
    /**
     * Extracts frame images and delays from an EFStyleParamImage.
     *
     * This method converts an EFStyleParamImage to arrays of CGImages and delays.
     * For static images, it returns a single frame with duration 1.
     *
     * - Parameter image: The image to extract frames from.
     * - Returns: A tuple containing arrays of CGImages and their durations.
     */
    private func frameImages(image: EFStyleParamImage) -> ([CGImage], [CGFloat]) {
        switch image {
        case .static(let image):
            return ([image], [1])
        case .animated(let images, let imageDelays):
            return (images, imageDelays)
        }
    }
    
    /**
     * Calculates the greatest common divisor of two integers.
     *
     * This method uses the Euclidean algorithm to find the GCD.
     *
     * - Parameters:
     *   - a: The first integer.
     *   - b: The second integer.
     * - Returns: The greatest common divisor of a and b.
     */
    private func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a, b = b
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return abs(a)
    }
    
    /**
     * Calculates the least common multiple of two integers.
     *
     * This method uses the GCD to calculate the LCM.
     *
     * - Parameters:
     *   - a: The first integer.
     *   - b: The second integer.
     * - Returns: The least common multiple of a and b.
     */
    private func lcm(_ a: Int, _ b: Int) -> Int {
        return (a / gcd(a, b)) * b
    }
    
    /**
     * Calculates a rational approximation of a floating-point number.
     *
     * This method uses continued fraction expansion to find a rational
     * approximation of the given number.
     *
     * - Parameters:
     *   - x: The floating-point number to approximate.
     *   - eps: The precision for the approximation. Defaults to 1.0E-6.
     * - Returns: A tuple containing the numerator and denominator.
     */
    private func rationalApproximation(of x: Double, withPrecision eps: Double = 1.0E-6) -> (Int, Int) {
        var x = x
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0 / (x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    
    /**
     * Calculates the least common multiple of two CGFloat values.
     *
     * This method uses rational approximation to handle floating-point
     * precision issues when calculating LCM.
     *
     * - Parameters:
     *   - a: The first CGFloat value.
     *   - b: The second CGFloat value.
     *   - precision: The precision for rational approximation. Defaults to 1.
     * - Returns: The least common multiple of a and b.
     */
    private func lcm(_ a: CGFloat, _ b: CGFloat, precision: Int = 1) -> CGFloat {
        let precision = 1.0 / pow(10, Double(precision))
        let (num1, den1) = rationalApproximation(of: Double(a), withPrecision: precision)
        let (num2, den2) = rationalApproximation(of: Double(b), withPrecision: precision)
        let lcmDen = lcm(den1, den2)
        let lcmNum = lcm(num1 * (lcmDen / den1), num2 * (lcmDen / den2))
        return CGFloat(lcmNum) / CGFloat(lcmDen)
    }
    
    /**
     * Creates animated image data with the specified format and frames.
     *
     * This method creates animated image data (GIF or APNG) from an array
     * of frames and their corresponding delays.
     *
     * - Parameters:
     *   - format: The animated image format (GIF or APNG).
     *   - frames: Array of CGImages representing the animation frames.
     *   - frameDelays: Array of delays for each frame.
     * - Returns: Data containing the animated image.
     * - Throws: `EFQRCodeError` if animated image creation fails.
     */
    private func createAnimatedImageDataWith(format: EFAnimatedImageFormat, frames: [CGImage], frameDelays: [CGFloat]) throws -> Data {
        if frames.isEmpty || frames.count != frameDelays.count {
            throw EFQRCodeError.cannotCreateAnimatedImage
        }
        let (framePropertiesArray, fileProperties): ([CFDictionary], CFDictionary) = {
            switch format {
            case .gif:
                return (
                    frameDelays.map { delay in
                        [kCGImagePropertyGIFDictionary as String: [
                            kCGImagePropertyGIFDelayTime as String: delay,
                            kCGImagePropertyGIFUnclampedDelayTime as String: delay
                        ]]
                    } as [CFDictionary],
                    [
                        kCGImagePropertyGIFDictionary as String: [
                            kCGImagePropertyGIFLoopCount as String: 0
                        ]
                    ] as CFDictionary
                )
            case .apng:
                return (
                    frameDelays.map { delay in
                        [kCGImagePropertyPNGDictionary as String: [
                            kCGImagePropertyAPNGDelayTime as String: delay,
                            kCGImagePropertyAPNGUnclampedDelayTime as String: delay
                        ]]
                    } as [CFDictionary],
                    [
                        kCGImagePropertyPNGDictionary as String: [
                            kCGImagePropertyAPNGLoopCount as String: 0
                        ]
                    ] as CFDictionary
                )
            }
        }()
        return try self.createAnimatedImageDataWith(
            format: format,
            frames: frames,
            framePropertiesArray: framePropertiesArray,
            fileProperties: fileProperties
        )
    }
    
    /**
     * Creates animated image data with custom frame and file properties.
     *
     * This method creates animated image data with custom properties for
     * frame delays and file metadata.
     *
     * - Parameters:
     *   - format: The animated image format (GIF or APNG).
     *   - frames: Array of CGImages representing the animation frames.
     *   - framePropertiesArray: Array of frame properties dictionaries.
     *   - fileProperties: File properties dictionary.
     * - Returns: Data containing the animated image.
     * - Throws: `EFQRCodeError` if animated image creation fails.
     */
    private func createAnimatedImageDataWith(format: EFAnimatedImageFormat, frames: [CGImage], framePropertiesArray: [CFDictionary], fileProperties: CFDictionary) throws -> Data {
        guard let mutableData = CFDataCreateMutable(nil, 0) else {
            throw EFQRCodeError.cannotCreateMutableData
        }
        guard let destination = CGImageDestinationCreateWithData(mutableData, format.identifier, frames.count, nil) else {
            throw EFQRCodeError.cannotCreateCGImageDestination
        }
        CGImageDestinationSetProperties(destination, fileProperties)
        for (index, image) in frames.enumerated() {
            CGImageDestinationAddImage(destination, image, framePropertiesArray[index])
        }
        guard CGImageDestinationFinalize(destination) else {
            throw EFQRCodeError.cannotFinalizeCGImageDestination
        }
        return mutableData as Data
    }
    
#if canImport(AVFoundation) && !os(watchOS)
    /**
     * Creates video data in the specified format.
     *
     * This method generates video data (MOV, MP4, or M4V) from the QR code
     * animation frames.
     *
     * - Parameters:
     *   - format: The video format (MOV, MP4, or M4V).
     *   - size: The target size for the video.
     *   - insets: Edge insets for the video. Defaults to zero.
     * - Returns: Data containing the video file.
     * - Throws: `EFQRCodeError` if video creation fails.
     */
    private func toVideoData(format: EFVideoFormat, size: CGSize, insets: EFEdgeInsets = .zero) throws -> Data {
        let (images, durations): ([CGImage], [CGFloat]) = try getAnimatedFrames(size: size, insets: insets)
        let animatedImageData = try self.createVideoDataWith(format: format, frames: images, frameDelays: durations)
        return animatedImageData
    }
    
    /**
     * Creates video data with the specified format and frames.
     *
     * This method creates video data using AVFoundation with the specified
     * frames and their corresponding delays.
     *
     * - Parameters:
     *   - format: The video format (MOV, MP4, or M4V).
     *   - frames: Array of CGImages representing the video frames.
     *   - frameDelays: Array of delays for each frame.
     * - Returns: Data containing the video file.
     * - Throws: `EFQRCodeError` if video creation fails.
     */
    private func createVideoDataWith(format: EFVideoFormat, frames: [CGImage], frameDelays: [CGFloat]) throws -> Data {
        if frames.isEmpty || frames.count != frameDelays.count {
            throw EFQRCodeError.cannotCreateVideo
        }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + "." + format.fileExtension)
        
        let width = frames[0].width
        let height = frames[0].height
        let fps: Float = 30.0
        let frameDuration = 1.0 / Double(fps)
        
        guard let assetWriter = try? AVAssetWriter(outputURL: outputURL, fileType: format.fileType) else {
            throw EFQRCodeError.cannotCreateVideo
        }
        
        let videoSettings = format.videoSettings.merging([
            AVVideoWidthKey: width,
            AVVideoHeightKey: height
        ]) { (_, new) in new }
        
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        writerInput.expectsMediaDataInRealTime = false
        
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: writerInput,
            sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
                kCVPixelBufferWidthKey as String: width,
                kCVPixelBufferHeightKey as String: height
            ]
        )
        
        assetWriter.add(writerInput)
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: .zero)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let attributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
            kCVPixelBufferIOSurfacePropertiesKey as String: [:]
        ]
        
        var pixelBufferPool: CVPixelBufferPool?
        CVPixelBufferPoolCreate(kCFAllocatorDefault, nil, attributes as CFDictionary, &pixelBufferPool)
        
        guard let pool = pixelBufferPool else {
            throw EFQRCodeError.cannotCreateVideo
        }
        
        let frameQueue = DispatchQueue(label: "com.ef.qrcode.frameQueue")
        writerInput.requestMediaDataWhenReady(on: frameQueue) {
            var accumulatedTime: Double = 0.0
            
            for (frameIndex, (frame, originalDelay)) in zip(frames, frameDelays).enumerated() {
                let targetTime = accumulatedTime + Double(originalDelay)
                
                while accumulatedTime < targetTime {
                    var pixelBuffer: CVPixelBuffer?
                    CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &pixelBuffer)
                    
                    guard let buffer = pixelBuffer else { return }
                    
                    CVPixelBufferLockBaseAddress(buffer, [])
                    let pixelData = CVPixelBufferGetBaseAddress(buffer)
                    let colorSpace = CGColorSpaceCreateDeviceRGB()
                    
                    guard let context = CGContext(
                        data: pixelData,
                        width: width,
                        height: height,
                        bitsPerComponent: 8,
                        bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                        space: colorSpace,
                        bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
                    ) else {
                        CVPixelBufferUnlockBaseAddress(buffer, [])
                        return
                    }
                    
                    context.clear(CGRect(x: 0, y: 0, width: width, height: height))
                    context.draw(frame, in: CGRect(x: 0, y: 0, width: width, height: height))
                    CVPixelBufferUnlockBaseAddress(buffer, [])
                    
                    let remainingTime = targetTime - accumulatedTime
                    if remainingTime < frameDuration * 0.5 && frameIndex < frames.count - 1 {
                        break
                    }
                    
                    let presentationTime = CMTime(
                        seconds: accumulatedTime,
                        preferredTimescale: CMTimeScale(fps * 10)
                    )
                    
                    while !writerInput.isReadyForMoreMediaData {
                        Thread.sleep(forTimeInterval: 0.1)
                    }
                    
                    adaptor.append(buffer, withPresentationTime: presentationTime)
                    accumulatedTime += frameDuration
                }
            }
            
            writerInput.markAsFinished()
            assetWriter.finishWriting {
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        
        if assetWriter.status == .failed {
            throw assetWriter.error ?? EFQRCodeError.cannotCreateVideo
        }
        
        let videoData = try Data(contentsOf: outputURL)
        try? FileManager.default.removeItem(at: outputURL)
        return videoData
    }
#endif
}
