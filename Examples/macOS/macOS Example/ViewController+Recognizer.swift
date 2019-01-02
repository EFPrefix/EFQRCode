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
        
        recognizerViewImage.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.08).cgColor
        recognizerViewImage.layer?.borderColor = NSColor.theme.cgColor
        recognizerViewImage.layer?.borderWidth = 1
        recognizerViewImage.layer?.cornerRadius = 5
        recognizerViewImage.imageAlignment = .alignCenter
        recognizerViewImage.imageScaling = .scaleProportionallyUpOrDown
        recognizerViewImage.image = NSImage(named: "drag")
        recognizerView.addSubview(recognizerViewImage)
        recognizerViewImage.snp.makeConstraints {
            (make) in
            make.leading.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(recognizerViewImage.snp.height)
        }

        let tryCentredStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        tryCentredStyle?.alignment = .center
        let centredStyle = tryCentredStyle ?? .default

        recognizerViewScan.wantsLayer = true
        recognizerViewScan.layer?.cornerRadius = 5
        recognizerViewScan.bezelStyle = .regularSquare
        recognizerViewScan.attributedTitle = NSMutableAttributedString(
            string: "Scan", attributes: [
                NSAttributedString.Key.foregroundColor: NSColor.theme,
                NSAttributedString.Key.paragraphStyle: centredStyle
            ]
        )
        recognizerViewScan.action = #selector(recognizerViewScanClicked)
        recognizerView.addSubview(recognizerViewScan)
        recognizerViewScan.snp.makeConstraints {
            (make) in
            make.leading.equalTo(recognizerViewImage.snp.trailing).offset(10)
            make.bottom.trailing.equalTo(-10)
            make.height.equalTo(48)
        }

        recognizerViewPick.wantsLayer = true
        recognizerViewPick.layer?.cornerRadius = 5
        recognizerViewPick.bezelStyle = .regularSquare
        recognizerViewPick.attributedTitle = NSMutableAttributedString(
            string: "Choose image", attributes: [
                NSAttributedString.Key.foregroundColor: NSColor.theme,
                NSAttributedString.Key.paragraphStyle: centredStyle
            ]
        )
        recognizerViewPick.action = #selector(recognizerViewPickClicked)
        recognizerView.addSubview(recognizerViewPick)
        recognizerViewPick.snp.makeConstraints {
            (make) in
            make.bottom.equalTo(recognizerViewScan.snp.top).offset(-10)
            make.leading.trailing.height.equalTo(recognizerViewScan)
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
            make.trailing.equalTo(-10)
            make.leading.equalTo(recognizerViewImage.snp.trailing).offset(10)
            make.bottom.equalTo(recognizerViewPick.snp.top).offset(-10)
        }
    }

    @objc func recognizerViewPickClicked() {
        selectImageFromDisk {
            [weak self] (image) in
            if case let .normal(nsImage) = image {
                self?.recognizerViewImage.image = nsImage
            }
        }
    }

    @objc func recognizerViewScanClicked() {
        recognizerViewResult.string = ""
        if let image = recognizerViewImage.image?.toCGImage(),
            let result = EFQRCode.recognize(image: image)?.first {
            recognizerViewResult.string = result
        }
    }

    func selectImageFromDisk(process: @escaping (EFImage) -> Void) {
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
            guard self != nil else { return }
            guard result.rawValue == NSFileHandlingPanelOKButton else {
                return panel.close()
            }
            // We aren't allowing multiple selection,
            // but NSOpenPanel still returns an array with a single element.
            guard let imagePath = panel.urls.first else { return }
            if imagePath.absoluteString.lowercased().hasSuffix(".gif"),
                let image = try? Data(contentsOf: imagePath) {
                return process(.gif(image))
            }
            if let image = NSImage(contentsOf: imagePath) {
                process(.normal(image))
            }
        }
    }
}
