//
//  EFImageMode.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/4/11.
//
//  Copyright (c) 2017-2024 EyreFree <eyrefree@eyrefree.org>
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

/**
 * Image scaling modes for QR code watermark and icon positioning.
 *
 * This enum defines how images (watermarks, icons) are scaled and positioned
 * within QR codes. Each mode provides different behavior for handling aspect ratios
 * and image fitting.
 *
 * ## Scaling Modes
 *
 * - **scaleToFill**: Stretches the image to fill the entire area, potentially distorting it
 * - **scaleAspectFit**: Scales the image to fit within the area while maintaining aspect ratio
 * - **scaleAspectFill**: Scales the image to fill the area while maintaining aspect ratio, potentially cropping
 *
 * ## Usage
 *
 * ```swift
 * let icon = EFStyleParamIcon(
 *     image: .static(myImage),
 *     mode: .scaleAspectFill,  // Use aspect fill mode
 *     alpha: 1.0,
 *     borderColor: .black,
 *     percentage: 0.2
 * )
 * ```
 *
 * ## Visual Comparison
 *
 * | Mode | Behavior | Aspect Ratio | Cropping | Distortion |
 * |------|----------|--------------|----------|------------|
 * | scaleToFill | Stretches to fill | Changed | No | Yes |
 * | scaleAspectFit | Fits within bounds | Maintained | No | No |
 * | scaleAspectFill | Fills bounds | Maintained | Yes | No |
 */
public enum EFImageMode: CaseIterable {
    /// Scales the image to fill the entire area by changing the aspect ratio if necessary.
    case scaleToFill
    /// Scales the image to fit within the area while maintaining the aspect ratio.
    case scaleAspectFit
    /// Scales the image to fill the area while maintaining the aspect ratio.
    case scaleAspectFill
    
    // MARK: - Utilities
    
    /**
     * Calculates the rectangle where the image will be positioned in the canvas.
     *
     * This method determines the exact position and size of the image within the canvas
     * based on the scaling mode and the relative sizes of the image and canvas.
     *
     * - Parameters:
     *   - imageSize: The size of the image to be positioned.
     *   - canvasSize: The size of the canvas where the image will be placed.
     * - Returns: A CGRect defining the area where the image will be positioned.
     */
    public func rectForContent(ofSize imageSize: CGSize,
                               inCanvasOfSize canvasSize: CGSize) -> CGRect {
        let size = canvasSize
        var finalSize: CGSize = size
        var finalOrigin: CGPoint = CGPoint.zero
        let imageSize: CGSize = imageSize
        switch self {
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
    
    /**
     * Processes an image according to the scaling mode and target ratio.
     *
     * This method applies the scaling mode to transform the input image to match
     * the desired canvas ratio, potentially resizing or cropping the image.
     *
     * - Parameters:
     *   - image: The CGImage to be processed.
     *   - canvasRatio: The target aspect ratio for the canvas.
     * - Returns: A processed CGImage that matches the scaling mode and target ratio.
     * - Throws: `EFQRCodeError` if image processing fails.
     */
    public func imageForContent(ofImage image: CGImage, inCanvasOfRatio canvasRatio: CGSize) throws -> CGImage {
        let imageWidth: CGFloat = image.width.cgFloat
        let imageHeight: CGFloat = image.height.cgFloat
        
        if imageWidth / imageHeight == canvasRatio.width / canvasRatio.height { return image }
        
        let widthRatio: CGFloat = imageWidth / canvasRatio.width
        let heightRatio: CGFloat = imageHeight / canvasRatio.height
        switch self {
        case .scaleToFill:
            let newSize: CGSize = {
                if widthRatio > heightRatio {
                    return CGSize(width: imageHeight / canvasRatio.height * canvasRatio.width, height: imageHeight)
                } else {
                    return CGSize(width: imageWidth, height: imageWidth / canvasRatio.width * canvasRatio.height)
                }
            }()
            return try image.resize(to: newSize)
        case .scaleAspectFit:
            let newSize: CGSize = {
                if widthRatio > heightRatio {
                    return CGSize(width: imageWidth, height: imageWidth / canvasRatio.width * canvasRatio.height)
                } else {
                    return CGSize(width: imageHeight / canvasRatio.height * canvasRatio.width, height: imageHeight)
                }
            }()
            return try image.clipAndExpandingTransparencyWith(rect: CGRect(
                x: -(imageWidth.cgFloat - newSize.width) / 2,
                y:  -(imageHeight.cgFloat - newSize.height) / 2,
                width: newSize.width,
                height: newSize.height
            ))
        case .scaleAspectFill:
            let newSize: CGSize = {
                if widthRatio < heightRatio {
                    return CGSize(width: imageWidth, height: imageWidth / canvasRatio.width * canvasRatio.height)
                } else {
                    return CGSize(width: imageHeight / canvasRatio.height * canvasRatio.width, height: imageHeight)
                }
            }()
            return try image.clipAndExpandingTransparencyWith(rect: CGRect(
                x: -(imageWidth.cgFloat - newSize.width) / 2,
                y:  -(imageHeight.cgFloat - newSize.height) / 2,
                width: newSize.width,
                height: newSize.height
            ))
        }
    }
}
