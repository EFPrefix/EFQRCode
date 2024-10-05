//
//  EFPointPatternType.swift
//  EFQRCode
//
//  Created by Henry on 05/10/2024.
//  Copyright © 2024 EyreFree. All rights reserved.
//

import Foundation

@objc public enum EFPointPatternType: Int {
    case none = 0

    // Empty border
    case border

    // Timing pattern
    case timing

    // Alignment pattern
    case alignment

    // Finder pattern markers
    case finderTopLeftInner
    case finderTopLeftOuter

    case finderTopRightInner
    case finderTopRightOuter

    case finderBottomLeftInner
    case finderBottomLeftOuter
}
