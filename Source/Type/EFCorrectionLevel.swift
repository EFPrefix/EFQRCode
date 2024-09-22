//
//  EFCorrectionLevel.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/6.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics

import QRCodeSwift

/// Levels of tolerance.
public enum EFCorrectionLevel: Int, CaseIterable, CustomStringConvertible {
    /// L 7%.
    case l
    /// M 15%.
    case m
    /// Q 25%.
    case q
    /// H 30%.
    case h
    
    public var description: String {
        switch self {
        case .l:
            return "l"
        case .m:
            return "m"
        case .q:
            return "q"
        case .h:
            return "h"
        }
    }
}

extension EFCorrectionLevel {
    
    /// Representation of `self` in QRCodeSwift.
    var qrErrorCorrectLevel: QRErrorCorrectLevel {
        switch self {
        case .h: return .H
        case .l: return .L
        case .m: return .M
        case .q: return .Q
        }
    }
}
