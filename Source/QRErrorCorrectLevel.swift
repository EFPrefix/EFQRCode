#if os(iOS) || os(tvOS) || os(macOS)
#else
    /// This has weird rawValue
    enum QRErrorCorrectLevel: Int {
        /// Error resilience level: 7%
        case L = 1
        /// Error resilience level: 15%
        case M = 0
        /// Error resilience level: 25%
        case Q = 3
        /// Error resilience level: 30%
        case H = 2
    }
    
    extension EFInputCorrectionLevel {
        var qrErrorCorrectLevel: QRErrorCorrectLevel {
            switch self {
            case .h: return .H
            case .l: return .L
            case .m: return .M
            case .q: return .Q
            }
        }
    }
#endif
