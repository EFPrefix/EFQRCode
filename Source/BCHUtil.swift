//
//  BCHUtil.swift
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
    struct BCHUtil {
        private static let g15 = 0b10100110111
        private static let g18 = 0b1111100100101
        private static let g15Mask = 0b101010000010010
        private static let g15BCHDigit = bchDigit(of: g15)
        private static let g18BCHDigit = bchDigit(of: g18)

        static func bchTypeInfo(of data: Int) -> Int {
            var d = data << 10
            while bchDigit(of: d) - g15BCHDigit >= 0 {
                d ^= (g15 << (bchDigit(of: d) - g15BCHDigit))
            }
            return ((data << 10) | d) ^ g15Mask
        }

        static func bchTypeNumber(of data: Int) -> Int {
            var d = data << 12
            while bchDigit(of: d) - g18BCHDigit >= 0 {
                d ^= (g18 << (bchDigit(of: d) - g18BCHDigit))
            }
            return (data << 12) | d
        }

        private static func bchDigit(of data: Int) -> Int {
            var digit = 0
            var data = UInt(data)
            while (data != 0) {
                digit += 1
                data >>= 1
            }
            return digit
        }
    }
#endif
