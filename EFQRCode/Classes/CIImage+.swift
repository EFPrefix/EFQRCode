//
//  CIImage+.swift
//  Pods
//
//  Created by EyreFree on 2017/3/29.
//
//

import Foundation

public struct EFUIntPixel {
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var alpha: UInt8 = 0
}

extension CIImage {

    // Gray
    // https://gist.github.com/darcwader/bd346656db880666007e0dff6a1727fc
    func resize(size: CGSize) -> CIImage? {
        let scale = size.width / self.extent.width
        if let tryFilter = CIFilter(name: "CILanczosScaleTransform") {
            tryFilter.setValue(self, forKey: kCIInputImageKey)
            tryFilter.setValue(NSNumber(value: Double(scale)), forKey: kCIInputScaleKey)
            tryFilter.setValue(1.0, forKey: kCIInputAspectRatioKey)
            return tryFilter.value(forKey: kCIOutputImageKey) as? CIImage
        }
        return nil
    }

    // Convert CIImage To CGImage
    // http://wiki.hawkguide.com/wiki/Swift:_Convert_between_CGImage,_CIImage_and_UIImage
    func toCGImage() -> CGImage? {
        return CIContext(options: nil).createCGImage(self, from: self.extent)
    }

    // Get pixels from CIImage
    func pixels() -> [[EFUIntPixel]]? {
        var pixels: [[EFUIntPixel]]?
        if let tryCGImage = self.toCGImage() {
            if let pixelData = tryCGImage.dataProvider?.data {
                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                pixels = [[EFUIntPixel]]()
                for indexY in 0 ..< tryCGImage.height {
                    pixels?.append([EFUIntPixel]())
                    for indexX in 0 ..< tryCGImage.width {
                        let pixelInfo: Int = ((Int(tryCGImage.width) * Int(indexY)) + Int(indexX)) * 4
                        pixels?[indexY].append(
                            EFUIntPixel(
                                red: data[pixelInfo],
                                green: data[pixelInfo + 1],
                                blue: data[pixelInfo + 2],
                                alpha: data[pixelInfo + 3]
                            )
                        )
                    }
                }
                return pixels
            }
        }
        return nil
    }
}
