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

    // Replace color with another one
    // https://github.com/dstarsboy/TMReplaceColorHue/blob/master/TMReplaceColorHue/ViewController.swift
    func replace(colorOld: EFUIntPixel, colorNew: EFUIntPixel) -> CIImage? {
        let cubeSize = 64
        let cubeData = { () -> [Float] in
            let selectColor = (Float(colorOld.red) / 255.0, Float(colorOld.green) / 255.0, Float(colorOld.blue) / 255.0, Float(colorOld.alpha) / 255.0)
            let raplaceColor = (Float(colorNew.red) / 255.0, Float(colorNew.green) / 255.0, Float(colorNew.blue) / 255.0, Float(colorNew.alpha) / 255.0)

            var data = [Float](repeating: 0, count: cubeSize * cubeSize * cubeSize * 4)
            var tempRGB: [Float] = [0, 0, 0]
            var newRGB: (r : Float, g : Float, b : Float, a: Float)
            var offset = 0
            for z in 0 ..< cubeSize {
                tempRGB[2] = Float(z) / Float(cubeSize) // blue value
                for y in 0 ..< cubeSize {
                    tempRGB[1] = Float(y) / Float(cubeSize) // green value
                    for x in 0 ..< cubeSize {
                        tempRGB[0] = Float(x) / Float(cubeSize) // red value
                        // Select colorOld
                        if tempRGB[0] == selectColor.0 && tempRGB[1] == selectColor.1 && tempRGB[2] == selectColor.2 {
                            newRGB = (raplaceColor.0, raplaceColor.1, raplaceColor.2, raplaceColor.3)
                        } else {
                            newRGB = (tempRGB[0], tempRGB[1], tempRGB[2], 1)
                        }
                        data[offset] = newRGB.r
                        data[offset + 1] = newRGB.g
                        data[offset + 2] = newRGB.b
                        data[offset + 3] = 1.0
                        offset += 4
                    }
                }
            }
            return data
        }()

        let data = cubeData.withUnsafeBufferPointer { Data(buffer: $0) } as NSData
        let colorCube = CIFilter(name: "CIColorCube")!
        colorCube.setValue(cubeSize, forKey: "inputCubeDimension")
        colorCube.setValue(data, forKey: "inputCubeData")
        colorCube.setValue(self, forKey: kCIInputImageKey)
        return colorCube.outputImage
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
