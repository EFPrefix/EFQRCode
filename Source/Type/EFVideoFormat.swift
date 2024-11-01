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

#if canImport(AVFoundation)
import Foundation
import AVFoundation
import CoreVideo

public enum EFVideoFormat {
    case mov
    case mp4
    case m4v
    
    var fileType: AVFileType {
        switch self {
        case .mov: return .mov
        case .mp4: return .mp4
        case .m4v: return .m4v
        }
    }
    
    var fileExtension: String {
        switch self {
        case .mov: return "mov"
        case .mp4: return "mp4"
        case .m4v: return "m4v"
        }
    }
    
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
