//
//  InterfaceController.swift
//  watchOS Example Extension
//
//  Created by Apollo Zhu on 12/27/17.
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

import WatchKit
import EFQRCode
import SDWebImage

class InterfaceController: WKInterfaceController {
    @IBOutlet var qrcodeImage: WKInterfaceImage!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        guard let svg = context as? String else {
            return dismiss()
        }
        if let svgURL = saveSvgStringToTemporaryFile(svgString: svg) {
            let bitmapSize = CGSize(width: 512, height: 512)
            qrcodeImage.sd_setImage(with: svgURL, placeholderImage: nil, options: [], context: [.imageThumbnailPixelSize : bitmapSize])
        }
    }
    
    func saveSvgStringToTemporaryFile(svgString: String) -> URL? {
        guard let data = svgString.data(using: .utf8) else {
            return nil
        }
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("svg")
        do {
            try data.write(to: temporaryFileURL, options: [])
            return temporaryFileURL
        } catch {
            print("Save SVG error: \(error)")
            return nil
        }
    }
}
