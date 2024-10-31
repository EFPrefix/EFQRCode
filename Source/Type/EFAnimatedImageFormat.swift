//
//  EFAnimatedImageFormat.swift
//  EFQRCode
//
//  Created by EyreFree on 2024/9/5.
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
#if canImport(MobileCoreServices)
import MobileCoreServices
#else
import CoreServices
#endif
import UniformTypeIdentifiers

enum EFAnimatedImageFormat: CaseIterable {
    case gif
    case apng
    
    var identifier: CFString {
        switch self {
        case .gif:
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                return UTType.gif.identifier as CFString
            } else {
                return kUTTypeGIF
            }
        case .apng:
            if #available(iOS 14.0,macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                return UTType.png.identifier as CFString
            } else {
                return kUTTypePNG
            }
        }
    }
}
