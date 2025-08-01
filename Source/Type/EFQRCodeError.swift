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
    /// The data to be encoded exceeds the QR code capacity limit.
    case dataLengthExceedsCapacityLimit
    /// The text cannot be encoded using the specified encoding.
    case text(String, incompatibleWithEncoding: String.Encoding)
    /// Failed to convert between color spaces.
    case colorSpaceConversionFailure
    /// Failed to create a color space.
    case colorSpaceCreateFailure
    /// Cannot extract color components from CGColor.
    case invalidCGColorComponents
    /// Cannot create mutable data buffer.
    case cannotCreateMutableData
    /// Cannot create CGImage destination.
    case cannotCreateCGImageDestination
    /// Cannot finalize CGImage destination.
    case cannotFinalizeCGImageDestination
    /// Cannot create CGContext.
    case cannotCreateCGContext
    /// Cannot create SVG document.
    case cannotCreateSVGDocument
    /// Cannot create CGImage.
    case cannotCreateCGImage
    /// Cannot create UIImage.
    case cannotCreateUIImage
    /// Cannot create image data.
    case cannotCreateImageData
    /// Cannot create animated image (GIF/APNG).
    case cannotCreateAnimatedImage
    /// Cannot create video file.
    case cannotCreateVideo
    /// Internal implementation error.
    case internalError(ImplmentationError)
    
    /// Internal implementation error types.
    public enum ImplmentationError {
        /// Failed to determine the size of the data.
        case dataLengthIndeterminable
        /// Data length exceeds the capacity limit.
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
