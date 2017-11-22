//
//  ViewController+Recognizer.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/11/14.
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

import Cocoa
import EFQRCode

extension ViewController {

    func addControlRecognizer() {
        recognizerViewImage.focusRingType = .none
        recognizerViewImage.wantsLayer = true
        recognizerViewImage.layer?.backgroundColor = NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        recognizerViewImage.layer?.borderColor = NSColor.theme.cgColor
        recognizerViewImage.layer?.borderWidth = 1
        recognizerViewImage.layer?.cornerRadius = 5
        recognizerViewImage.imageAlignment = .alignCenter
        recognizerViewImage.imageScaling = .scaleProportionallyUpOrDown
        recognizerViewImage.image = NSImage(named: NSImage.Name("drag"))
        recognizerView.addSubview(recognizerViewImage)
        recognizerViewImage.snp.makeConstraints {
            (make) in
            make.left.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(recognizerViewImage.snp.height)
        }

        let tryCentredStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        tryCentredStyle?.alignment = .center
        let centredStyle = tryCentredStyle ?? NSMutableParagraphStyle.default

        recognizerViewScan.wantsLayer = true
        recognizerViewScan.layer?.cornerRadius = 5
        recognizerViewScan.bezelStyle = .regularSquare
        recognizerViewScan.attributedTitle = NSMutableAttributedString(
            string: "Scan", attributes: [
                NSAttributedStringKey.foregroundColor: NSColor.theme,
                NSAttributedStringKey.paragraphStyle: centredStyle
            ]
        )
        recognizerViewScan.action = #selector(recognizerViewScanClicked)
        recognizerView.addSubview(recognizerViewScan)
        recognizerViewScan.snp.makeConstraints {
            (make) in
            make.left.equalTo(recognizerViewImage.snp.right).offset(10)
            make.bottom.right.equalTo(-10)
            make.height.equalTo(48)
        }

        recognizerViewPick.wantsLayer = true
        recognizerViewPick.layer?.cornerRadius = 5
        recognizerViewPick.bezelStyle = .regularSquare
        recognizerViewPick.attributedTitle = NSMutableAttributedString(
            string: "Choose image", attributes: [
                NSAttributedStringKey.foregroundColor: NSColor.theme,
                NSAttributedStringKey.paragraphStyle: centredStyle
            ]
        )
        recognizerViewPick.action = #selector(recognizerViewPickClicked)
        recognizerView.addSubview(recognizerViewPick)
        recognizerViewPick.snp.makeConstraints {
            (make) in
            make.bottom.equalTo(recognizerViewScan.snp.top).offset(-10)
            make.left.right.height.equalTo(recognizerViewScan)
        }

        recognizerViewResult.isEditable = false
        recognizerViewResult.wantsLayer = true
        recognizerViewResult.layer?.backgroundColor = NSColor(
            calibratedRed: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 0.08
            ).cgColor
        recognizerViewResult.layer?.borderColor = NSColor.theme.cgColor
        recognizerViewResult.layer?.borderWidth = 1
        recognizerViewResult.layer?.cornerRadius = 5
        recognizerView.addSubview(recognizerViewResult)
        recognizerViewResult.snp.makeConstraints {
            (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.left.equalTo(recognizerViewImage.snp.right).offset(10)
            make.bottom.equalTo(recognizerViewPick.snp.top).offset(-10)
        }
    }

    @objc func recognizerViewPickClicked() {
        selectImageFromDisk(finish: {
            [weak self] (image) in
            if let strongSelf = self {
                strongSelf.recognizerViewImage.image = image
            }
        })
    }

    @objc func recognizerViewScanClicked() {
        recognizerViewResult.string = ""
        if let image = recognizerViewImage.image?.toCGImage() {
            if let resultArray = EFQRCode.recognize(image: image), resultArray.count > 0 {
                recognizerViewResult.string = resultArray[0]
            }
        }
    }

    func selectImageFromDisk(finish: ((NSImage) -> Void)?, finishGIF: ((Data) -> Void)? = nil) {
        // https://gist.github.com/jlindsey/499215
        let panel = NSOpenPanel()
        panel.allowedFileTypes = NSImage.imageTypes
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.resolvesAliases = true
        if let url = URL(string: NSHomeDirectory()) {
            panel.directoryURL = url
        }

        panel.begin {
            [weak self] (result) in
            if let _ = self {
                if result.rawValue == NSFileHandlingPanelOKButton {
                    // We aren't allowing multiple selection, but NSOpenPanel still returns
                    // an array with a single element.
                    if let imagePath = panel.urls.first {

                        if imagePath.absoluteString.lowercased().hasSuffix(".gif") && nil != finishGIF {
                            if let image = try? Data(contentsOf: imagePath) {
                                finishGIF?(image)
                            }
                        } else {
                            if let image = NSImage(contentsOf: imagePath) {
                                finish?(image)
                            }
                        }
                    }
                } else {
                    panel.close()
                }
            }
        }
    }
}
