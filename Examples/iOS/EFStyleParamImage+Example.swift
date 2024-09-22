//
//  EFStyleParamImage+Example.swift
//  iOS Example
//
//  Created by EyreFree on 2024/9/21.
//  Copyright © 2024 EyreFree. All rights reserved.
//

import Foundation
import EFQRCode
import CoreGraphics

extension EFStyleParamImage {
    
    var firstImage: CGImage {
        switch self {
        case .static(let image):
            return image
        case .animated(let images, let imageDelays):
            return images[0]
        }
    }
}
