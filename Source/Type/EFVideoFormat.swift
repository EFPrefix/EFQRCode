//
//  EFVideoFormat.swift
//  EFQRCode
//
//  Created by EyreFree on 2024/11/2.
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

#if canImport(AVFoundation) && !os(watchOS)
import Foundation
import AVFoundation
import CoreVideo

/**
 * Supported video formats for QR code animation export.
 *
 * This enum defines the video formats that can be used to export animated QR codes
 * as video files. Each format has different characteristics in terms of compatibility,
 * file size, and quality.
 *
 * ## Supported Formats
 *
 * - **MOV**: Apple's native format, best compatibility with Apple ecosystem
 * - **MP4**: Widely supported format, good for cross-platform use
 * - **M4V**: Apple's container format, optimized for iTunes and Apple devices
 *
 * ## Usage
 *
 * ```swift
 * let generator = try EFQRCode.Generator("Hello World")
 * 
 * // Export as MOV video
 * let movData = try generator.toMovData(width: 200)
 * 
 * // Export as MP4 video
 * let mp4Data = try generator.toMp4Data(width: 200)
 * 
 * // Export as M4V video
 * let m4vData = try generator.toM4vData(width: 200)
 * ```
 *
 * ## Format Comparison
 *
 * | Format | Apple Ecosystem | Cross-Platform | File Size | Quality |
 * |--------|-----------------|-----------------|-----------|---------|
 * | MOV    | Excellent       | Good            | Medium    | High    |
 * | MP4    | Good            | Excellent       | Small     | High    |
 * | M4V    | Excellent       | Limited         | Medium    | High    |
 *
 * ## Requirements
 *
 * - AVFoundation framework must be available
 * - Not available on watchOS
 */
public enum EFVideoFormat {
    /// QuickTime Movie format (MOV).
    case mov
    /// MPEG-4 format (MP4).
    case mp4
    /// Apple's M4V container format.
    case m4v
    /**
     * The AVFoundation file type for the video format.
     *
     * This property provides the appropriate AVFileType for use with AVFoundation
     * video writing operations.
     *
     * - Returns: The AVFileType corresponding to the video format.
     */
    var fileType: AVFileType {
        switch self {
        case .mov: return .mov
        case .mp4: return .mp4
        case .m4v: return .m4v
        }
    }
    /**
     * The file extension for the video format.
     *
     * This property provides the standard file extension for the video format,
     * useful for saving files with the correct extension.
     *
     * - Returns: The file extension string (e.g., "mov", "mp4", "m4v").
     */
    public var fileExtension: String {
        switch self {
        case .mov: return "mov"
        case .mp4: return "mp4"
        case .m4v: return "m4v"
        }
    }
    /**
     * Video compression settings for the format.
     *
     * This property provides optimized video compression settings for each format,
     * including codec type and compression properties.
     *
     * - Returns: A dictionary containing video compression settings.
     */
    var videoSettings: [String: Any] {
        var settings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
        ]
        
        switch self {
        case .mov:
            break
        case .mp4, .m4v:
            settings[AVVideoCompressionPropertiesKey] = [
                AVVideoAverageBitRateKey: 2000000,
                AVVideoMaxKeyFrameIntervalKey: 30,
                AVVideoAllowFrameReorderingKey: false
            ]
        }
        
        return settings
    }
}
#endif
