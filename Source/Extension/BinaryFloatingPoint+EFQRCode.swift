//
//  BinaryFloatingPoint+.swift
//  EFQRCode
//
//  Created by EyreFree on 2019/11/20.
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

/**
 * Extensions for BinaryFloatingPoint to support type conversion in QR code processing.
 *
 * This extension provides convenient type conversion methods for floating-point numbers
 * that are used throughout the EFQRCode library for coordinate calculations, size conversions,
 * and other numerical operations.
 *
 * ## Features
 *
 * - Boolean conversion for conditional logic
 * - CGFloat conversion for Core Graphics operations
 * - Numeric type conversions for various precision requirements
 * - Integer type conversions for different bit widths
 * - Unsigned integer conversions for positive-only values
 *
 * ## Usage
 *
 * ```swift
 * let value: Double = 3.14
 * 
 * // Convert to different types
 * let cgFloat = value.cgFloat      // CGFloat
 * let int = value.int              // Int
 * let bool = value.bool            // Bool (true if non-zero)
 * let uInt32 = value.uInt32        // UInt32
 * ```
 *
 * ## Supported Types
 *
 * The extension provides conversions to:
 * - **Boolean**: `bool` - true if non-zero, false if zero
 * - **Floating Point**: `cgFloat`, `double`, `float`
 * - **Signed Integers**: `int`, `int8`, `int16`, `int32`, `int64`
 * - **Unsigned Integers**: `uInt`, `uInt8`, `uInt16`, `uInt32`, `uInt64`
 */
extension BinaryFloatingPoint {

    /**
     * Converts the floating-point value to a boolean.
     *
     * Returns true if the value is non-zero, false if the value is zero.
     *
     * - Returns: true if the value is non-zero, false otherwise.
     */
    var bool: Bool {
        return 0 != self
    }

    /**
     * Converts the floating-point value to CGFloat.
     *
     * This is commonly used for Core Graphics operations that require CGFloat.
     *
     * - Returns: A CGFloat representation of the value.
     */
    var cgFloat: CGFloat {
        return CGFloat(self)
    }

    /**
     * Converts the floating-point value to Double.
     *
     * - Returns: A Double representation of the value.
     */
    var double: Double {
        return Double(self)
    }

    /**
     * Converts the floating-point value to Float.
     *
     * - Returns: A Float representation of the value.
     */
    var float: Float {
        return Float(self)
    }

    /**
     * Converts the floating-point value to Int.
     *
     * The value is truncated to the nearest integer.
     *
     * - Returns: An Int representation of the value.
     */
    var int: Int {
        return Int(self)
    }

    /**
     * Converts the floating-point value to Int8.
     *
     * The value is truncated to the nearest integer and clamped to Int8 range.
     *
     * - Returns: An Int8 representation of the value.
     */
    var int8: Int8 {
        return Int8(self)
    }

    /**
     * Converts the floating-point value to Int16.
     *
     * The value is truncated to the nearest integer and clamped to Int16 range.
     *
     * - Returns: An Int16 representation of the value.
     */
    var int16: Int16 {
        return Int16(self)
    }

    /**
     * Converts the floating-point value to Int32.
     *
     * The value is truncated to the nearest integer and clamped to Int32 range.
     *
     * - Returns: An Int32 representation of the value.
     */
    var int32: Int32 {
        return Int32(self)
    }

    /**
     * Converts the floating-point value to Int64.
     *
     * The value is truncated to the nearest integer and clamped to Int64 range.
     *
     * - Returns: An Int64 representation of the value.
     */
    var int64: Int64 {
        return Int64(self)
    }

    /**
     * Converts the floating-point value to UInt.
     *
     * The value is truncated to the nearest integer and clamped to UInt range.
     *
     * - Returns: A UInt representation of the value.
     */
    var uInt: UInt {
        return UInt(self)
    }

    /**
     * Converts the floating-point value to UInt8.
     *
     * The value is truncated to the nearest integer and clamped to UInt8 range.
     *
     * - Returns: A UInt8 representation of the value.
     */
    var uInt8: UInt8 {
        return UInt8(self)
    }

    /**
     * Converts the floating-point value to UInt16.
     *
     * The value is truncated to the nearest integer and clamped to UInt16 range.
     *
     * - Returns: A UInt16 representation of the value.
     */
    var uInt16: UInt16 {
        return UInt16(self)
    }

    /**
     * Converts the floating-point value to UInt32.
     *
     * The value is truncated to the nearest integer and clamped to UInt32 range.
     *
     * - Returns: A UInt32 representation of the value.
     */
    var uInt32: UInt32 {
        return UInt32(self)
    }

    /**
     * Converts the floating-point value to UInt64.
     *
     * The value is truncated to the nearest integer and clamped to UInt64 range.
     *
     * - Returns: A UInt64 representation of the value.
     */
    var uInt64: UInt64 {
        return UInt64(self)
    }
}
