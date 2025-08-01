//
//  EFCorrectionLevel.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/6.
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

import QRCodeSwift

/**
 * QR code error correction levels.
 *
 * Error correction allows QR codes to be read even if they are partially damaged
 * or obscured. Higher correction levels provide better error recovery but reduce
 * the data capacity of the QR code.
 *
 * ## Error Correction Levels
 *
 * The error correction level determines how much of the QR code can be damaged
 * or obscured while still allowing successful decoding. Each level provides
 * different trade-offs between data capacity and error recovery capability.
 *
 * ## Usage
 *
 * ```swift
 * // Create a QR code with high error correction
 * let generator = try EFQRCode.Generator(
 *     "Hello World",
 *     errorCorrectLevel: .h,
 *     style: .basic()
 * )
 * ```
 *
 * ## Correction Capabilities
 *
 * - **L (Low)**: 7% of the QR code can be damaged and still be readable
 * - **M (Medium)**: 15% of the QR code can be damaged and still be readable
 * - **Q (Quartile)**: 25% of the QR code can be damaged and still be readable
 * - **H (High)**: 30% of the QR code can be damaged and still be readable
 *
 * ## Data Capacity Trade-offs
 *
 * Higher error correction levels provide better error recovery but reduce the
 * amount of data that can be stored in the QR code. Choose the level based on:
 *
 * - **L**: Use when QR codes will be displayed in high quality and clean environments
 * - **M**: Good balance for most general use cases
 * - **Q**: Use when QR codes might be slightly damaged or in challenging environments
 * - **H**: Use when QR codes might be significantly damaged or in very challenging environments
 */
public enum EFCorrectionLevel: CaseIterable {
    /// Low error correction level (7%).
    case l
    /// Medium error correction level (15%).
    case m
    /// Quartile error correction level (25%).
    case q
    /// High error correction level (30%).
    case h
}

extension EFCorrectionLevel {
    /**
     * Converts EFQRCode error correction level to QRCodeSwift error correction level.
     *
     * This extension provides a mapping from EFQRCode error correction levels
     * to the underlying QRCodeSwift library's error correction levels.
     *
     * - Returns: The corresponding QRErrorCorrectLevel for QRCodeSwift.
     */
    var qrErrorCorrectLevel: QRErrorCorrectLevel {
        switch self {
        case .h: return .H
        case .l: return .L
        case .m: return .M
        case .q: return .Q
        }
    }
}
