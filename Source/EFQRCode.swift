//
//  EFQRCode.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/11.
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

/**
 * EFQRCode - A lightweight QR code generator and recognizer for iOS, macOS, tvOS and watchOS.
 *
 * EFQRCode is a powerful and flexible QR code library that supports:
 * - QR code generation with various styles and customizations
 * - QR code recognition from images
 * - Multiple output formats (PNG, JPEG, GIF, APNG, PDF, SVG, Video)
 * - Animated QR codes
 * - Custom styling with icons and watermarks
 * - Error correction levels
 * - Cross-platform support (iOS, macOS, tvOS, watchOS)
 *
 * ## Basic Usage
 *
 * ```swift
 * // Generate a basic QR code
 * let generator = try EFQRCode.Generator("Hello World")
 * let image = try generator.toImage(width: 200)
 * ```
 *
 * ## Features
 *
 * - **Multiple Styles**: Basic, Bubble, 2.5D, Image, Line, Random Rectangle, and more
 * - **Custom Icons**: Add custom icons to QR codes
 * - **Watermarks**: Overlay watermarks on QR codes
 * - **Animated QR Codes**: Create animated QR codes with GIF and APNG support
 * - **Video Export**: Export QR codes as video files (MOV, M4V, MP4)
 * - **High Performance**: Optimized for performance with caching and efficient algorithms
 * - **Cross Platform**: Works on iOS, macOS, tvOS, and watchOS
 *
 * ## Requirements
 *
 * - iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+ / visionOS 1.0+
 * - Swift 5.0+
 * - Xcode 13.0+
 */
public class EFQRCode {
    
}
