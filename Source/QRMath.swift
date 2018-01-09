//
//  QRMath.swift
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
    struct QRMath {

        /// glog
        ///
        /// - Parameter n: n | n >= 1.
        /// - Returns: glog(n), or a fatal error if n < 1.
        static func glog(_ n: Int) -> Int {
            precondition(n > 0, "glog only works with n > 0, not \(n)")
            return QRMath.instance.LOG_TABLE[n]
        }

        static func gexp(_ n: Int) -> Int {
            var n = n
            while n < 0 {
                n += 255
            }
            while (n >= 256) {
                n -= 255
            }
            return QRMath.instance.EXP_TABLE[n]
        }

        private var EXP_TABLE: [Int]
        private var LOG_TABLE: [Int]

        private static let instance = QRMath()
        private init() {
            EXP_TABLE = [Int](repeating: 0, count: 256)
            LOG_TABLE = [Int](repeating: 0, count: 256)
            for i in 0 ..< 8 {
                EXP_TABLE[i] = 1 << i
            }
            for i in 8 ..< 256 {
                EXP_TABLE[i] = EXP_TABLE[i - 4] ^ EXP_TABLE[i - 5] ^ EXP_TABLE[i - 6] ^ EXP_TABLE[i - 8]
            }
            for i in 0 ..< 255 {
                LOG_TABLE[EXP_TABLE[i]] = i
            }
        }
    }
#endif
