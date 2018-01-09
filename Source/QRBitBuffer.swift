//
//  QRBitBuffer.swift
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
    struct QRBitBuffer {
        var buffer = [UInt]()
        private(set) var bitCount = 0
        
        func get(index: Int) -> Bool {
            let bufIndex = index / 8
            return ((buffer[bufIndex] >> (7 - index % 8)) & 1) == 1
        }
        
        subscript(index: Int) -> Bool {
            return get(index: index)
        }
        
        mutating func put(_ num: UInt, length: Int) {
            for i in 0 ..< length {
                put(((num >> (length - i - 1)) & 1) == 1)
            }
        }
        
        mutating func put(_ bit: Bool) {
            let bufIndex = bitCount / 8
            if buffer.count <= bufIndex {
                buffer.append(0)
            }
            if bit {
                buffer[bufIndex] |= (UInt(0x80) >> (bitCount % 8))
            }
            bitCount += 1
        }
    }
#endif
