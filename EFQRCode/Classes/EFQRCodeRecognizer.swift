//
//  EFQRCodeRecognizer.swift
//  Pods
//
//  Created by EyreFree on 2017/3/28.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
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
import UIKit

public class EFQRCodeRecognizer {

    public var image: UIImage? {
        didSet {
            contentArray = nil
        }
    }
    var contents: [String]? {
        get {
            if nil == contentArray {
                contentArray = getQRString()
            }
            return contentArray
        }
    }

    private var contentArray: [String]?

    public init(image: UIImage) {
        self.image = image
    }

    // Get QRCodes from image
    private func getQRString() -> [String]? {

        guard let finalImage = self.image else {
            return nil
        }
        let result = scanFrom(image: finalImage, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        if (result?.count ?? 0) <= 0 {
            return scanFrom(
                image: finalImage.greyScale(), options: [CIDetectorAccuracy : CIDetectorAccuracyLow]
            )
        }
        return result
    }

    private func scanFrom(image: UIImage?, options: [String : Any]? = nil) -> [String]? {
        if let tryCGImage = image?.cgImage {
            var result = [String]()
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
            if let features = detector?.features(in: CIImage(cgImage: tryCGImage)) {
                for feature in features {
                    if let tryString = (feature as? CIQRCodeFeature)?.messageString {
                        result.append(tryString)
                    }
                }
            }
            return result
        }
        return nil
    }
}
