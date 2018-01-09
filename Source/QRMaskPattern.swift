//
//  QRMaskPattern.swift
//  EFQRCode
//
//  Created by Apollo Zhu on 12/27/17.
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

#if os(iOS) || os(tvOS) || os(macOS)
    
#else
    enum QRMaskPattern: Int {
        case _000, _001, _010, _011, _100, _101, _110, _111
    }
    
    extension QRMaskPattern {
        func getMask(_ i: Int, _ j: Int) -> Bool {
            switch (self) {
            case ._000:
                return (i + j) % 2 == 0
            case ._001:
                return i % 2 == 0
            case ._010:
                return j % 3 == 0
            case ._011:
                return (i + j) % 3 == 0
            case ._100:
                return (i / 2 + j / 3) % 2 == 0
            case ._101:
                return (i * j) % 2 + (i * j) % 3 == 0
            case ._110:
                return ((i * j) % 2 + (i * j) % 3) % 2 == 0
            case ._111:
                return ((i * j) % 3 + (i + j) % 2) % 2 == 0
            }
        }
    }
#endif
