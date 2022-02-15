//
//  EFPointStyle.swift
//  EFQRCode
//
//  Created by Apollo Zhu on 2021/11/20.
//
//  Copyright (c) 2017-2021 EyreFree <eyrefree@eyrefree.org>
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

/// Collection of foreground point renderer capabilities.
@objc public protocol EFPointStyle {
    /// Fills a code point satisfying this style.
    /// - Parameters:
    ///   - context: the context to draw in.
    ///   - rect: the boundaries of the point to draw.
    ///   - isStatic: true if it is recommended to use a square instead of current style.
    func fillRect(context: CGContext, rect: CGRect, isStatic: Bool)
}

/// Drawing classical look and feel QR code foreground points 🔳.
@objc public class EFSquarePointStyle: NSObject, EFPointStyle {
    public func fillRect(context: CGContext, rect: CGRect, isStatic: Bool) {
        context.fill(rect)
    }
}

/// Drawing rounded foreground points 🔘.
@objc public class EFCirclePointStyle: NSObject, EFPointStyle {
    public func fillRect(context: CGContext, rect: CGRect, isStatic: Bool) {
        if isStatic {
            context.fill(rect)
        } else {
            context.fillEllipse(in: rect)
        }
    }
}

/// Drawing Sparkling foreground points ✨.
@objc public class EFDiamondPointStyle: NSObject, EFPointStyle {
    public func fillRect(context: CGContext, rect: CGRect, isStatic: Bool) {
        if isStatic {
            context.fill(rect)
        } else {
            fillDiamond(context: context, rect: rect)
        }
    }

    private func fillDiamond(context: CGContext, rect: CGRect) {
        // shrink rect edge
        let drawingRect = rect.insetBy(dx: -2, dy: -2)

        // create path
        let path = CGMutablePath()
        // Bezier Control Point
        let controlPoint = CGPoint(x: drawingRect.midX , y: drawingRect.midY)
        // Bezier Start Point
        let startPoint = CGPoint(x: drawingRect.minX, y: drawingRect.midY)
        // the other point of diamond
        let otherPoints = [CGPoint(x: drawingRect.midX, y: drawingRect.maxY),
                           CGPoint(x: drawingRect.maxX, y: drawingRect.midY),
                           CGPoint(x: drawingRect.midX, y: drawingRect.minY)]

        path.move(to: startPoint)
        for point in otherPoints {
            path.addQuadCurve(to: point, control: controlPoint)
        }
        path.addQuadCurve(to: startPoint, control: controlPoint)
        context.addPath(path)
        context.fillPath()
    }
}

public extension EFPointStyle where Self == EFSquarePointStyle {
    /// Classical QR code look and feel 🔳.
    static var square: Self { .init() }
}

public extension EFPointStyle where Self == EFCirclePointStyle {
    /// More well rounded 🔘.
    static var circle: Self { .init() }
}

public extension EFPointStyle where Self == EFDiamondPointStyle {
    /// Sparkling ✨.
    static var diamond: Self { .init() }
}
