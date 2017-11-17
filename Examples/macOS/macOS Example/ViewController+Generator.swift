//
//  ViewController+Generator.swift
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

    func addControlGenerator() {
        generatorView.addSubview(generatorViewImage)

        let tryCentredStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        tryCentredStyle?.alignment = .center
        let centredStyle = tryCentredStyle ?? NSMutableParagraphStyle.default

        generatorViewSave.wantsLayer = true
        generatorViewSave.layer?.cornerRadius = 5
        generatorViewSave.bezelStyle = .regularSquare
        generatorViewSave.attributedTitle = NSMutableAttributedString(
            string: "Save", attributes: [
                NSAttributedStringKey.foregroundColor: NSColor.theme,
                NSAttributedStringKey.paragraphStyle: centredStyle
            ]
        )
        generatorViewSave.action = #selector(generatorViewSaveClicked)
        generatorView.addSubview(generatorViewSave)
        generatorViewSave.snp.makeConstraints {
            (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(45)
            make.width.equalTo(generatorViewImage)
        }

        generatorViewCreate.wantsLayer = true
        generatorViewCreate.layer?.cornerRadius = 5
        generatorViewCreate.bezelStyle = .regularSquare
        generatorViewCreate.attributedTitle = NSMutableAttributedString(
            string: "Create", attributes: [
                NSAttributedStringKey.foregroundColor: NSColor.theme,
                NSAttributedStringKey.paragraphStyle: centredStyle
            ]
        )
        generatorViewCreate.action = #selector(generatorViewCreateClicked)
        generatorView.addSubview(generatorViewCreate)
        generatorViewCreate.snp.makeConstraints {
            (make) in
            make.bottom.equalTo(generatorViewSave.snp.top).offset(-10)
            make.left.right.height.equalTo(generatorViewSave)
        }

        generatorViewImage.wantsLayer = true
        generatorViewImage.layer?.backgroundColor = NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        generatorViewImage.layer?.borderColor = NSColor.theme.cgColor
        generatorViewImage.layer?.borderWidth = 1
        generatorViewImage.layer?.cornerRadius = 5
        generatorViewImage.imageAlignment = .alignCenter
        generatorViewImage.imageScaling = .scaleProportionallyUpOrDown
        generatorViewImage.snp.makeConstraints {
            (make) in
            make.left.top.equalTo(10)
            make.bottom.equalTo(generatorViewCreate.snp.top).offset(-10)
            make.width.equalTo(generatorViewImage.snp.height)
        }

        generatorViewContent.wantsLayer = true
        generatorViewContent.layer?.backgroundColor = NSColor(
            calibratedRed: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 0.08
            ).cgColor
        generatorViewContent.layer?.borderColor = NSColor.theme.cgColor
        generatorViewContent.layer?.borderWidth = 1
        generatorViewContent.layer?.cornerRadius = 5
        generatorView.addSubview(generatorViewContent)
        generatorViewContent.snp.makeConstraints {
            (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.left.equalTo(generatorViewImage.snp.right).offset(10)
            make.height.equalTo(100)
        }

        generatorViewTable.wantsLayer = true
        generatorViewTable.layer?.borderColor = NSColor.theme.cgColor
        generatorViewTable.layer?.borderWidth = 1
        generatorViewTable.layer?.cornerRadius = 5
        generatorView.addSubview(generatorViewTable)
        generatorViewTable.snp.makeConstraints {
            (make) in
            make.top.equalTo(generatorViewContent.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
            make.left.right.equalTo(generatorViewContent)
        }
    }

    @objc func generatorViewCreateClicked() {
        let content = generatorViewContent.string
        if let cgImage = EFQRCode.generate(content: content) {
            generatorViewImage.image = NSImage(
                cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height)
            )
        }
    }

    @objc func generatorViewSaveClicked() {
        if let image = generatorViewImage.image {
            let panel = NSSavePanel()
            panel.nameFieldStringValue = "Untitle.png"
            panel.message = "Choose the path to save the image"
            panel.allowsOtherFileTypes = true
            panel.allowedFileTypes = ["png"]
            panel.isExtensionHidden = true
            panel.canCreateDirectories = true
            panel.begin {
                [weak self] (result) in
                if let strongSelf = self {
                    if result.rawValue == NSFileHandlingPanelOKButton {
                        // [@"onecodego" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
                        if let url = panel.url {
                            if image.pngWrite(to: url, options: .atomic) {
                                print("Image saved")
                            }
                        }
                    }
                }
            }
        }
    }
}
