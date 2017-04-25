//
//  EFDefine.swift
//  Pods
//
//  Created by EyreFree on 2017/4/11.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import CoreGraphics

public struct EFUIntPixel {
    public var red: UInt8 = 0
    public var green: UInt8 = 0
    public var blue: UInt8 = 0
    public var alpha: UInt8 = 0
}

public class EFIntSize {
    public private(set) var width: Int = 0
    public private(set) var height: Int = 0

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    public func toCGSize() -> CGSize {
        return CGSize(width: self.width, height: self.height)
    }

    public func widthCGFloat() -> CGFloat {
        return CGFloat(width)
    }

    public func heightCGFloat() -> CGFloat {
        return CGFloat(height)
    }
}

// EFInputCorrectionLevel
public enum EFInputCorrectionLevel: Int {
    case l = 0;     // L 7%
    case m = 1;     // M 15%
    case q = 2;     // Q 25%
    case h = 3;     // H 30%
}

// Like UIViewContentMode
public enum EFWatermarkMode: Int {
    case scaleToFill        = 0;
    case scaleAspectFit     = 1;
    case scaleAspectFill    = 2;
    case center             = 3;
    case top                = 4;
    case bottom             = 5;
    case left               = 6;
    case right              = 7;
    case topLeft            = 8;
    case topRight           = 9;
    case bottomLeft         = 10;
    case bottomRight        = 11;
}

struct EFIntPoint {
    public var x: Int = 0
    public var y: Int = 0

    public func toCGPoint() -> CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }
}

public struct EFIcon {
    public var image: CGImage?
    public var size: EFIntSize?
    public var isColorful: Bool = true

    public init(image: CGImage?, size: EFIntSize? = nil, isColorful: Bool = true) {
        self.image = image
        self.size = size
        self.isColorful = isColorful
    }
}

public struct EFWatermark {
    public var image: CGImage?
    public var mode: EFWatermarkMode = .scaleToFill
    public var isColorful: Bool = true

    public init(image: CGImage?, mode: EFWatermarkMode = .scaleToFill, isColorful: Bool = true) {
        self.image = image
        self.mode = mode
        self.isColorful = isColorful
    }
}

public struct EFExtra {
    public var foregroundPointOffset: CGFloat = 0
    public var allowTransparent: Bool = true

    public init(foregroundPointOffset: CGFloat = 0, allowTransparent: Bool = true) {
        self.foregroundPointOffset = foregroundPointOffset
        self.allowTransparent = allowTransparent
    }
}
