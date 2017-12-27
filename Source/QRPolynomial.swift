#if os(iOS) || os(tvOS) || os(macOS)
#else
    struct QRPolynomial {
        
        private var numbers: [Int]
        
        init!(_ nums: Int..., shift: Int = 0) {
            self.init(nums, shift: shift)
        }
        
        init?(_ nums: [Int], shift: Int = 0) {
            guard nums.count != 0 else { return nil }
            var offset = 0
            while offset < nums.count && nums[offset] == 0 {
                offset += 1
            }
            self.numbers = [Int](repeating: 0, count: nums.count - offset + shift)
            for i in 0..<nums.count - offset {
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
            for i in 0..<count {
                for j in 0..<e.count {
                    nums[i + j] ^= QRMath.gexp(QRMath.glog(self[i]) + QRMath.glog(e[j]))
                }
            }
            return QRPolynomial(nums)!
        }
        
        func moded(by e: QRPolynomial) -> QRPolynomial {
            if (count - e.count < 0) {
                return self
            }
            let ratio = QRMath.glog(self[0]) - QRMath.glog(e[0])
            var num = [Int](repeating: 0, count: count)
            for i in 0..<count {
                num[i] = self[i]
            }
            for i in 0..<e.count {
                num[i] ^= QRMath.gexp(QRMath.glog(e[i]) + ratio)
            }
            return QRPolynomial(num)!.moded(by: e)
        }
        
        static func errorCorrectPolynomial(ofLength errorCorrectLength: Int) -> QRPolynomial? {
            guard var a = QRPolynomial(1) else { return nil }
            for i in 0..<errorCorrectLength {
                a = a.multiplying(QRPolynomial(1, QRMath.gexp(i))!)
            }
            return a
        }
    }
#endif
