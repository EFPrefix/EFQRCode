#if os(iOS) || os(tvOS) || os(macOS)
#else
    struct BCHUtil {
        private static let g15     =     0b10100110111
        private static let g18     =   0b1111100100101
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
