//
//  EFInputCorrectionLevel.swift
//  EFQRCode
//
//  Created by EyreFree on 2018/11/14.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
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

import CoreGraphics

#if os(iOS) || os(tvOS) || os(macOS)
import CoreImage
#else
import swift_qrcodejs
#endif

// EFInputCorrectionLevel
@objc public enum EFInputCorrectionLevel: Int {
    case l = 0     // L 7%
    case m = 1     // M 15%
    case q = 2     // Q 25%
    case h = 3     // H 30%

    #if os(iOS) || os(tvOS) || os(macOS)

    #else
    var qrErrorCorrectLevel: QRErrorCorrectLevel {
        switch self {
        case .h: return .H
        case .l: return .L
        case .m: return .M
        case .q: return .Q
        }
    }
    #endif
}
