//
//  QRRSBlock.swift
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
    // OptionSet
    enum QRMode: UInt {
        case number = 0b0001        // 1 << 0
        case alphaNumber = 0b0010   // 1 << 1
        case bitByte8 = 0b0100      // 1 << 2
        case kanji = 0b1000         // 1 << 3
    }

    extension QRMode {
        func bitCount(ofType type: Int) -> Int? {
            if 1 <= type && type < 10 {
                switch self {
                case .number:
                    return 10
                case .alphaNumber:
                    return 9
                case .bitByte8, .kanji:
                    return 8
                }
            } else if type < 27 {
                switch self {
                case .number:
                    return 12
                case .alphaNumber:
                    return 11
                case .bitByte8:
                    return 16
                case .kanji:
                    return 10
                }
            } else if type < 41 {
                switch self {
                case .number:
                    return 14
                case .alphaNumber:
                    return 13
                case .bitByte8:
                    return 16
                case .kanji:
                    return 12
                }
            } else {
                return nil
            }
        }
    }
#endif
