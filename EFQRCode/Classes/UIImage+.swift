//
//  UIImage+.swift
//  Pods
//
//  Created by EyreFree on 2017/3/29.
//
//

import Foundation

extension UIImage {

    // Grey
    // http://stackoverflow.com/questions/40178846/convert-uiimage-to-grayscale-keeping-image-quality
    func greyScale() -> UIImage? {
        let context = CIContext(options: nil)
        if let currentFilter = CIFilter(name: "CIPhotoEffectNoir") {
            currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    return processedImage
                }
            }
        }
        return nil
    }

    // Convert UIImage to CIImage
    // http://wiki.hawkguide.com/wiki/Swift:_Convert_between_CGImage,_CIImage_and_UIImage
    func toCIImage() -> CIImage? {
        return CIImage(image: self)
    }
}
