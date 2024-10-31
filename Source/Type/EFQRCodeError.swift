//
//  EFQRCodeError.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/3.
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

import QRCodeSwift

/// All possible errors that could occur when constructing `EFQRCode`.
public enum EFQRCodeError: Error {
    /// The thing you want to save is too large for `QRCode`.
    case dataLengthExceedsCapacityLimit
    /// Can not encode the given string using the specified encoding.
    case text(String, incompatibleWithEncoding: String.Encoding)
    
    /// Color space conversion failure
    case colorSpaceConversionFailure
    /// colorSpaceCreateFailure
    case colorSpaceCreateFailure
    /// Can not get components from CGColor
    case invalidCGColorComponents
    /// Can not create mutableData
    case cannotCreateMutableData
    /// Can not create CGImage destination
    case cannotCreateCGImageDestination
    /// Can not finalize CGImage destination
    case cannotFinalizeCGImageDestination
    /// Can not create CGContext
    case cannotCreateCGContext
    /// Can not create CGContext
    case cannotCreateSVGDocument
    /// Can not create CGImage
    case cannotCreateCGImage
    /// Can not create UIImage
    case cannotCreateUIImage
    /// Can not create image data
    case cannotCreateImageData
    /// Can not create GIF
    case cannotCreateAnimatedImage
    /// Can not create video
    case cannotCreateVideo
    /// Fill a new issue on GitHub, or submit a pull request.
    case internalError(ImplmentationError)
    
    /// Should probably contact developer is you ever see any of these.
    public enum ImplmentationError {
        /// fail to determine how large is the data.
        case dataLengthIndeterminable
        /// fail to find appropriate container for your data.
        case dataLength(Int, exceedsCapacityLimit: Int)
    }
}

extension QRCodeError {
    
    var efQRCodeError: EFQRCodeError {
        switch self {
        case .dataLengthExceedsCapacityLimit:
            return .dataLengthExceedsCapacityLimit
        case .text(let string, let encoding):
            return EFQRCodeError.text(string, incompatibleWithEncoding: encoding)
        case .internalError(let impError):
            switch impError {
            case .dataLengthIndeterminable:
                return EFQRCodeError.internalError(.dataLengthIndeterminable)
            case .dataLength(let value, let limit):
                return EFQRCodeError.internalError(.dataLength(value, exceedsCapacityLimit: limit))
            }
        }
    }
}
