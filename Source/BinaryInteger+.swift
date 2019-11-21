//
//  BinaryInteger+.swift
//  EFQRCode
//
//  Created by EyreFree on 2019/11/20.
//
//  Copyright © 2019 EyreFree. All rights reserved.
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
import CoreGraphics

extension BinaryInteger {

    var bool: Bool {
        return 0 != self
    }

    var cgFloat: CGFloat {
        return CGFloat(self)
    }

    var double: Double {
        return Double(self)
    }

    var float: Float {
        return Float(self)
    }

    var int: Int {
        return Int(self)
    }

    var int8: Int8 {
        return Int8(self)
    }

    var int16: Int16 {
        return Int16(self)
    }

    var int32: Int32 {
        return Int32(self)
    }

    var int64: Int64 {
        return Int64(self)
    }

    var uInt: UInt {
        return UInt(self)
    }

    var uInt8: UInt8 {
        return UInt8(self)
    }

    var uInt16: UInt16 {
        return UInt16(self)
    }

    var uInt32: UInt32 {
        return UInt32(self)
    }

    var uInt64: UInt64 {
        return UInt64(self)
    }
}
