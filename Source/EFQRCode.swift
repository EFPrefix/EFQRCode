//
//  EFQRCode.swift
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

import CoreImage

public class EFQRCode {

    // MARK:- Recognizer
    public static func recognize(image: CGImage) -> [String]? {
        return EFQRCodeRecognizer(image: image).contents
    }

    // MARK:- Generator
    public static func generate(
        content: String,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        size: EFIntSize = EFIntSize(width: 256, height: 256),
        magnification: EFIntSize? = nil,
        backgroundColor: CIColor = CIColor.EFWhite(),
        foregroundColor: CIColor = CIColor.EFBlack(),
        icon: EFIcon? = nil,
        watermark: EFWatermark? = nil,
        extra: EFExtra? = nil
        ) -> CGImage? {

        let generator = EFQRCodeGenerator(
            content: content,
            inputCorrectionLevel: inputCorrectionLevel,
            size: size,
            magnification: magnification,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor
        )
        if let tryIcon = icon {
            generator.setIcon(icon: tryIcon)
        }
        if let tryWatermark = watermark {
            generator.setWatermark(watermark: tryWatermark)
        }
        if let tryExtra = extra {
            generator.setExtra(extra: tryExtra)
        }
        return generator.image
    }
}
