//
//  EFDefine.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/4/11.
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

/// Options to specify how watermark position and size for QR code.
@objc public enum EFWatermarkMode: Int {
    /// The option to scale the watermark to fit the size of QR code by changing the aspect ratio of the watermark if necessary.
    case scaleToFill        = 0
    /// The option to scale the watermark to fit the size of the QR code by maintaining the aspect ratio. Any remaining area of the QR code uses the background color.
    case scaleAspectFit     = 1
    /// The option to scale the watermark to fill the size of the QR code. Some portion of the watermark may be clipped to fill the QR code.
    case scaleAspectFill    = 2
    /// The option to center the watermark in the QR code, keeping the proportions the same.
    case center             = 3
    /// The option to center the watermark aligned at the top in the QR code.
    case top                = 4
    /// The option to center the watermark aligned at the bottom in the QR code.
    case bottom             = 5
    /// The option to align the watermark on the left of the QR code.
    case left               = 6
    /// The option to align the watermark on the right of the QR code.
    case right              = 7
    /// The option to align the watermark in the top-left corner of the QR code.
    case topLeft            = 8
    /// The option to align the watermark in the top-right corner of the QR code.
    case topRight           = 9
    /// The option to align the watermark in the bottom-left corner of the QR code.
    case bottomLeft         = 10
    /// The option to align the watermark in the bottom-right corner of the QR code.
    case bottomRight        = 11

    // MARK: - Utilities

    /// Calculates and returns the area in canvas where the image is going to be in this mode.
    /// - Parameters:
    ///   - imageSize: size of the watermark image to place in the canvas.
    ///   - canvasSize: size of the canvas to place the image in.
    /// - Returns: the area where the image is going to be according to the watermark mode.
    public func rectForWatermark(ofSize imageSize: CGSize,
                                 inCanvasOfSize canvasSize: CGSize) -> CGRect {
        let size = canvasSize
        var finalSize: CGSize = size
        var finalOrigin: CGPoint = CGPoint.zero
        let imageSize: CGSize = imageSize
        switch self {
        case .bottom:
            finalSize = imageSize
            finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0, y: 0)
        case .bottomLeft:
            finalSize = imageSize
            finalOrigin = .zero
        case .bottomRight:
            finalSize = imageSize
            finalOrigin = CGPoint(x: size.width - imageSize.width, y: 0)
        case .center:
            finalSize = imageSize
            finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0,
                                  y: (size.height - imageSize.height) / 2.0)
        case .left:
            finalSize = imageSize
            finalOrigin = CGPoint(x: 0, y: (size.height - imageSize.height) / 2.0)
        case .right:
            finalSize = imageSize
            finalOrigin = CGPoint(x: size.width - imageSize.width,
                                  y: (size.height - imageSize.height) / 2.0)
        case .top:
            finalSize = imageSize
            finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0,
                                  y: size.height - imageSize.height)
        case .topLeft:
            finalSize = imageSize
            finalOrigin = CGPoint(x: 0, y: size.height - imageSize.height)
        case .topRight:
            finalSize = imageSize
            finalOrigin = CGPoint(x: size.width - imageSize.width,
                                  y: size.height - imageSize.height)
        case .scaleAspectFill:
            let scale = max(size.width / imageSize.width,
                            size.height / imageSize.height)
            finalSize = CGSize(width: imageSize.width * scale,
                               height: imageSize.height * scale)
            finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0,
                                  y: (size.height - finalSize.height) / 2.0)
        case .scaleAspectFit:
            let scale = max(imageSize.width / size.width,
                            imageSize.height / size.height)
            finalSize = CGSize(width: imageSize.width / scale,
                               height: imageSize.height / scale)
            finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0,
                                  y: (size.height - finalSize.height) / 2.0)
        case .scaleToFill:
            break
        }
        return CGRect(origin: finalOrigin, size: finalSize)
    }
}
