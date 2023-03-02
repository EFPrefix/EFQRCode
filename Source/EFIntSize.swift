//
//  EFIntSize.swift
//  EFQRCode
//
//  Created by EyreFree on 2018/11/14.
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

import CoreGraphics
import Foundation

/// A structure that contains width and height values.
///
/// - Note: This is like `CGSize`, but with `Int` instead of `CGFloat`.
@objcMembers
public final class EFIntSize: NSObject {
    /// A width value.
    public let width: Int
    /// A height value.
    public let height: Int

    /// Creates a size with dimensions specified as integer values.
    /// - Parameters:
    ///   - width: The width value.
    ///   - height: The height value.
    /// - Note: Creates a size with zero width and height if no argument is specified.
    public init(width: Int = 0, height: Int = 0) {
        self.width = width
        self.height = height
    }

    /// Converts `CGSize` to `EFIntSize`.
    /// - Parameter size: the `CGSize` to convert.
    /// - Note: `width` and `height` will be truncated to `Int`.
    public convenience init(size: CGSize) {
        self.init(width: Int(size.width),
                  height: Int(size.height))
    }

    /// Representation as `CGSize`.
    public var cgSize: CGSize {
        return CGSize(width: width, height: height)
    }
}
