#if os(iOS) || os(tvOS) || os(macOS)
#else
    enum QRMode: UInt8 { // OptionSet
        case number = 0b0001 // 1 << 0
        case alphaNumber = 0b0010 // 1 << 1
        case _8bitByte = 0b0100 //1 << 2
        case kanji = 0b1000 // 1 << 3
    }
    
    extension QRMode {
        func bitCount(ofType type: Int) -> Int? {
            if 1 <= type && type < 10 {
                switch self {
                case .number: return 10
                case .alphaNumber: return 9
                case ._8bitByte, .kanji: return 8
                }
            } else if type < 27 {
                switch self {
                case .number: return 12
                case .alphaNumber: return 11
                case ._8bitByte: return 16
                case .kanji: return 10
                }
            } else if type < 41 {
                switch self {
                case .number: return 14
                case .alphaNumber: return 13
                case ._8bitByte: return 16
                case .kanji: return 12
                }
            } else {
                return nil
            }
        }
    }
#endif
