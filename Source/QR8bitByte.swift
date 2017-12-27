#if os(iOS) || os(tvOS) || os(macOS)
#else
    import Foundation
    
    struct QR8bitByte {
        let mode: QRMode = ._8bitByte
        let data: String
        let parsedData: Data
        
        init?(_ data: String) {
            self.data = data
            guard let parsed = data.data(using: .utf8)
                else { return nil }
            self.parsedData = parsed
        }
        
        var count: Int {
            return parsedData.count
        }
        
        func write(to buffer: inout QRBitBuffer) {
            let l: Int = parsedData.count
            for i in 0..<l {
                buffer.put(parsedData[i], length: 8)
            }
        }
    }
#endif
