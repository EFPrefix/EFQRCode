//
//  NSColor+.swift
//  macOS Example
//
//  Created by EyreFree on 2017/4/22.
//  Copyright © 2017年 EyreFree. All rights reserved.
//

import Cocoa

extension NSColor {

    convenience init(value: UInt, alpha: CGFloat = 1.0) {
        self.init(
            calibratedRed: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
