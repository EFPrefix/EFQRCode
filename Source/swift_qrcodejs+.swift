//
//  swift_qrcodejs+.swift
//  EFQRCode
//
//  Created by EyreFree on 2018/11/7.
//  Copyright © 2018年 EyreFree. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS)

#else
    import Foundation
    import swift_qrcodejs

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
