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
    struct QRPolynomial {
        
        private var numbers: [Int]
        
        init!(_ nums: Int..., shift: Int = 0) {
            self.init(nums, shift: shift)
        }
        
        init?(_ nums: [Int], shift: Int = 0) {
            guard nums.count != 0 else {
                return nil
            }
            var offset = 0
            while offset < nums.count && nums[offset] == 0 {
                offset += 1
            }
            self.numbers = [Int](repeating: 0, count: nums.count - offset + shift)
            for i in 0 ..< nums.count - offset {
                self.numbers[i] = nums[i + offset]
            }
        }
        
        func get(index: Int) -> Int {
            return numbers[index]
        }

        subscript(index: Int) -> Int {
            return get(index: index)
        }
        
        var count: Int {
            return numbers.count
        }
        
        func multiplying(_ e: QRPolynomial) -> QRPolynomial {
            var nums = [Int](repeating: 0, count: count + e.count - 1)
            for i in 0 ..< count {
                for j in 0 ..< e.count {
                    nums[i + j] ^= QRMath.gexp(QRMath.glog(self[i]) + QRMath.glog(e[j]))
                }
            }
            return QRPolynomial(nums)!
        }

        func moded(by e: QRPolynomial) -> QRPolynomial {
            if count - e.count < 0 {
                return self
            }
            let ratio = QRMath.glog(self[0]) - QRMath.glog(e[0])
            var num = [Int](repeating: 0, count: count)
            for i in 0 ..< count {
                num[i] = self[i]
            }
            for i in 0 ..< e.count {
                num[i] ^= QRMath.gexp(QRMath.glog(e[i]) + ratio)
            }
            return QRPolynomial(num)!.moded(by: e)
        }

        static func errorCorrectPolynomial(ofLength errorCorrectLength: Int) -> QRPolynomial? {
            guard var a = QRPolynomial(1) else { return nil }
            for i in 0 ..< errorCorrectLength {
                a = a.multiplying(QRPolynomial(1, QRMath.gexp(i))!)
            }
            return a
        }
    }
#endif
