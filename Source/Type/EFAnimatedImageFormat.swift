//
//  EFAnimatedImageFormat.swift
//  EFQRCode
//
//  Created by EyreFree on 2024/9/5.
//  Copyright © 2024 EyreFree. All rights reserved.
//

import Foundation
#if canImport(MobileCoreServices)
import MobileCoreServices
#else
import CoreServices
#endif
import UniformTypeIdentifiers

public enum EFAnimatedImageFormat: Int {
    case gif
    case apng
    
    var identifier: CFString {
        switch self {
        case .gif:
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                return UTType.gif.identifier as CFString
            } else {
                return kUTTypeGIF
            }
        case .apng:
            if #available(iOS 14.0,macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                return UTType.png.identifier as CFString
            } else {
                return kUTTypePNG
            }
        }
    }
}
