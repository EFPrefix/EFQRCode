//
//  EFEdgeInsets.swift
//  EFQRCode
//
//  Created by EyreFree on 2024/9/11.
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
import SwiftDraw

#if canImport(AppKit)
import AppKit
/**
 * Cross-platform edge insets type for EFQRCode.
 *
 * `EFEdgeInsets` is a type alias that provides a unified interface for edge insets
 * across different Apple platforms. It automatically maps to the appropriate
 * platform-specific edge insets type.
 *
 * ## Platform Mapping
 *
 * - **macOS**: Maps to `NSEdgeInsets`
 * - **iOS/tvOS**: Maps to `UIEdgeInsets`
 * - **watchOS**: Maps to `UIEdgeInsets`
 *
 * ## Usage
 *
 * ```swift
 * // Create edge insets for padding
 * let insets = EFEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
 * 
 * // Use with QR code generation
 * let image = try generator.toImage(width: 200, insets: insets)
 * ```
 *
 * ## Properties
 *
 * - `top`: The inset from the top edge
 * - `left`: The inset from the left edge
 * - `bottom`: The inset from the bottom edge
 * - `right`: The inset from the right edge
 */
public typealias EFEdgeInsets = NSEdgeInsets

/**
 * Extension providing zero edge insets for macOS.
 */
public extension EFEdgeInsets {
    /**
     * Edge insets with zero values for all edges.
     *
     * This static property provides a convenient way to create edge insets
     * with no padding on any side.
     */
    static let zero = NSEdgeInsetsZero
}
#elseif canImport(UIKit)
import UIKit
/**
 * Cross-platform edge insets type for EFQRCode.
 *
 * `EFEdgeInsets` is a type alias that provides a unified interface for edge insets
 * across different Apple platforms. It automatically maps to the appropriate
 * platform-specific edge insets type.
 *
 * ## Platform Mapping
 *
 * - **macOS**: Maps to `NSEdgeInsets`
 * - **iOS/tvOS**: Maps to `UIEdgeInsets`
 * - **watchOS**: Maps to `UIEdgeInsets`
 *
 * ## Usage
 *
 * ```swift
 * // Create edge insets for padding
 * let insets = EFEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
 * 
 * // Use with QR code generation
 * let image = try generator.toImage(width: 200, insets: insets)
 * ```
 *
 * ## Properties
 *
 * - `top`: The inset from the top edge
 * - `left`: The inset from the left edge
 * - `bottom`: The inset from the bottom edge
 * - `right`: The inset from the right edge
 */
public typealias EFEdgeInsets = UIEdgeInsets
#elseif canImport(WatchKit)
import WatchKit
/**
 * Cross-platform edge insets type for EFQRCode.
 *
 * `EFEdgeInsets` is a type alias that provides a unified interface for edge insets
 * across different Apple platforms. It automatically maps to the appropriate
 * platform-specific edge insets type.
 *
 * ## Platform Mapping
 *
 * - **macOS**: Maps to `NSEdgeInsets`
 * - **iOS/tvOS**: Maps to `UIEdgeInsets`
 * - **watchOS**: Maps to `UIEdgeInsets`
 *
 * ## Usage
 *
 * ```swift
 * // Create edge insets for padding
 * let insets = EFEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
 * 
 * // Use with QR code generation
 * let image = try generator.toImage(width: 200, insets: insets)
 * ```
 *
 * ## Properties
 *
 * - `top`: The inset from the top edge
 * - `left`: The inset from the left edge
 * - `bottom`: The inset from the bottom edge
 * - `right`: The inset from the right edge
 */
public typealias EFEdgeInsets = UIEdgeInsets
#endif
