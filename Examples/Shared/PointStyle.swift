//
//  PointStyle.swift
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

import EFQRCode
import CoreGraphics

class StarPointStyle: EFPointStyle {
    func fillRect(context: CGContext, rect: CGRect, isStatic: Bool) {
        let path = CGMutablePath()
        var points: [CGPoint] = []
        let radius = Float(rect.width / 2)
        let angel = Double.pi * 2 / 5
        for i in 1...5 {
            let x = Float(rect.width / 2) - sinf(Float(i) * Float(angel)) * radius + Float(rect.origin.x)
            let y = Float(rect.height / 2) - cosf(Float(i) * Float(angel)) * radius + Float(rect.origin.y)
            points.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
        }
        path.move(to: points.first!)
        for i in 1...5 {
            let index = (2 * i) % 5
            path.addLine(to: points[index])
        }
        context.addPath(path)
        context.fillPath()
    }
}

enum PointStyle: Int, CaseIterable {
    case square
    case circle
    case diamond
    case star

    var efPointStyle: EFPointStyle {
        switch self {
        case .square: return EFSquarePointStyle.square
        case .circle: return EFCirclePointStyle.circle
        case .diamond: return EFDiamondPointStyle.diamond
        case .star: return StarPointStyle()
        }
    }
}
