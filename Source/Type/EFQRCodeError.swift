//
//  EFQRCodeError.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/3.
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

import QRCodeSwift

/**
 * All possible errors that could occur when working with EFQRCode.
 *
 * This enum defines all the error types that can be thrown by EFQRCode operations,
 * including data encoding errors, image generation errors, and internal implementation errors.
 *
 * ## Error Categories
 *
 * - **Data Errors**: Related to input data encoding and capacity
 * - **Image Generation Errors**: Related to image creation and processing
 * - **Color Space Errors**: Related to color space conversion and creation
 * - **Internal Errors**: Related to internal implementation issues
 *
 * ## Usage
 *
 * ```swift
 * do {
 *     let generator = try EFQRCode.Generator("Hello World")
 *     let image = try generator.toImage(width: 200)
 * } catch EFQRCodeError.dataLengthExceedsCapacityLimit {
 *     print("Data is too large for QR code")
 * } catch EFQRCodeError.text(let text, let encoding) {
 *     print("Cannot encode '\(text)' with \(encoding)")
 * } catch {
 *     print("Other error: \(error)")
 * }
 * ```
 */
public enum EFQRCodeError: Error {
    /**
     * The data to be encoded exceeds the QR code capacity limit.
     *
     * QR codes have a maximum data capacity that depends on the error correction level
     * and the QR code version. This error occurs when the input data is too large
     * to fit within the available capacity.
     */
    case dataLengthExceedsCapacityLimit
    
    /**
     * The text cannot be encoded using the specified encoding.
     *
     * - Parameters:
     *   - text: The text that failed to encode
     *   - encoding: The encoding that was attempted
     */
    case text(String, incompatibleWithEncoding: String.Encoding)
    
    /**
     * Failed to convert between color spaces.
     *
     * This error occurs when the system cannot convert between different color spaces,
     * typically when working with images that have incompatible color spaces.
     */
    case colorSpaceConversionFailure
    
    /**
     * Failed to create a color space.
     *
     * This error occurs when the system cannot create a required color space,
     * typically due to insufficient memory or system resources.
     */
    case colorSpaceCreateFailure
    
    /**
     * Cannot extract color components from CGColor.
     *
     * This error occurs when the CGColor object does not contain the expected
     * color components or the color space is not supported.
     */
    case invalidCGColorComponents
    
    /**
     * Cannot create mutable data buffer.
     *
     * This error occurs when the system cannot allocate memory for a mutable data buffer,
     * typically due to insufficient memory.
     */
    case cannotCreateMutableData
    
    /**
     * Cannot create CGImage destination.
     *
     * This error occurs when the system cannot create a CGImage destination for
     * image writing operations.
     */
    case cannotCreateCGImageDestination
    
    /**
     * Cannot finalize CGImage destination.
     *
     * This error occurs when the system cannot finalize the CGImage destination,
     * typically due to data corruption or insufficient memory.
     */
    case cannotFinalizeCGImageDestination
    
    /**
     * Cannot create CGContext.
     *
     * This error occurs when the system cannot create a Core Graphics context,
     * typically due to insufficient memory or invalid parameters.
     */
    case cannotCreateCGContext
    
    /**
     * Cannot create SVG document.
     *
     * This error occurs when the system cannot create an SVG document,
     * typically due to invalid SVG content or insufficient memory.
     */
    case cannotCreateSVGDocument
    
    /**
     * Cannot create CGImage.
     *
     * This error occurs when the system cannot create a CGImage from the provided data,
     * typically due to invalid image data or insufficient memory.
     */
    case cannotCreateCGImage
    
    /**
     * Cannot create UIImage.
     *
     * This error occurs when the system cannot create a UIImage from the CGImage,
     * typically due to invalid image data or platform-specific issues.
     */
    case cannotCreateUIImage
    
    /**
     * Cannot create image data.
     *
     * This error occurs when the system cannot create image data in the requested format,
     * typically due to unsupported format or insufficient memory.
     */
    case cannotCreateImageData
    
    /**
     * Cannot create animated image (GIF/APNG).
     *
     * This error occurs when the system cannot create an animated image,
     * typically due to invalid frame data or insufficient memory.
     */
    case cannotCreateAnimatedImage
    
    /**
     * Cannot create video file.
     *
     * This error occurs when the system cannot create a video file,
     * typically due to invalid video data or insufficient memory.
     */
    case cannotCreateVideo
    
    /**
     * Internal implementation error.
     *
     * This error indicates an internal implementation issue that should be reported
     * to the developers. It contains additional details about the specific problem.
     *
     * - Parameter error: The specific implementation error details.
     */
    case internalError(ImplmentationError)
    
    /**
     * Internal implementation error types.
     *
     * These errors represent specific internal implementation issues that should
     * be reported to the developers for investigation.
     */
    public enum ImplmentationError {
        /**
         * Failed to determine the size of the data.
         *
         * This error occurs when the system cannot determine the size of the input data,
         * typically due to data corruption or invalid data format.
         */
        case dataLengthIndeterminable
        
        /**
         * Data length exceeds the capacity limit.
         *
         * - Parameters:
         *   - dataLength: The actual length of the data
         *   - capacityLimit: The maximum capacity limit
         */
        case dataLength(Int, exceedsCapacityLimit: Int)
    }
}

extension QRCodeError {
    
    /**
     * Converts a QRCodeError to an EFQRCodeError.
     *
     * This extension provides a mapping from QRCodeSwift errors to EFQRCode errors,
     * ensuring consistent error handling across the library.
     *
     * - Returns: The corresponding EFQRCodeError.
     */
    var efQRCodeError: EFQRCodeError {
        switch self {
        case .dataLengthExceedsCapacityLimit:
            return .dataLengthExceedsCapacityLimit
        case .text(let string, let encoding):
            return EFQRCodeError.text(string, incompatibleWithEncoding: encoding)
        case .internalError(let impError):
            switch impError {
            case .dataLengthIndeterminable:
                return EFQRCodeError.internalError(.dataLengthIndeterminable)
            case .dataLength(let value, let limit):
                return EFQRCodeError.internalError(.dataLength(value, exceedsCapacityLimit: limit))
            }
        }
    }
}
