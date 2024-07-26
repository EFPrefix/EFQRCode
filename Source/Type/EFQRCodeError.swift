//
//  EFQRCodeError.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/3.
//  Copyright © 2023 EyreFree. All rights reserved.
//

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
