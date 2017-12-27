#if os(iOS) || os(tvOS) || os(macOS)
#else
    enum QRMaskPattern: Int {
        case _000, _001, _010, _011, _100, _101, _110, _111
    }
    
    extension QRMaskPattern {
        func getMask(_ i: Int, _ j: Int) -> Bool {
            switch (self) {
            case ._000: return (i + j) % 2 == 0
            case ._001: return i % 2 == 0
            case ._010: return j % 3 == 0
            case ._011: return (i + j) % 3 == 0
            case ._100: return (i / 2 + j / 3) % 2 == 0
            case ._101: return (i * j) % 2 + (i * j) % 3 == 0
            case ._110: return ((i * j) % 2 + (i * j) % 3) % 2 == 0
            case ._111: return ((i * j) % 3 + (i + j) % 2) % 2 == 0
            }
        }
    }
#endif
