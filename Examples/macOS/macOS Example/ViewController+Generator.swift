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

enum EFImage {
    case normal(_ image: NSImage)
    case gif(_ data: Data)
    
    var isGIF: Bool {
        switch self {
        case .normal: return false
        case .gif: return true
        }
    }
}

class EFBackColorPicker: NSColorPanel {

}

class EFFrontColorPicker: NSColorPanel {

}

extension ViewController: NSAlertDelegate {

    func addControlGenerator() {
        generatorView.addSubview(generatorViewImage)

        let tryCentredStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        tryCentredStyle?.alignment = .left
        let centredStyle = tryCentredStyle ?? NSMutableParagraphStyle.default

        generatorViewSave.wantsLayer = true
        generatorViewSave.layer?.cornerRadius = 5
        generatorViewSave.bezelStyle = .regularSquare
        generatorViewSave.attributedTitle = NSMutableAttributedString(
            string: "Save", attributes: [
                NSAttributedString.Key.foregroundColor: NSColor.theme,
                NSAttributedString.Key.paragraphStyle: centredStyle
            ]
        )
        generatorViewSave.action = #selector(generatorViewSaveClicked)
        generatorView.addSubview(generatorViewSave)
        generatorViewSave.snp.makeConstraints {
            (make) in
            make.leading.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(45)
            make.width.equalTo(generatorViewImage)
        }

        generatorViewCreate.wantsLayer = true
        generatorViewCreate.layer?.cornerRadius = 5
        generatorViewCreate.bezelStyle = .regularSquare
        generatorViewCreate.attributedTitle = NSMutableAttributedString(
            string: "Create", attributes: [
                NSAttributedString.Key.foregroundColor: NSColor.theme,
                NSAttributedString.Key.paragraphStyle: centredStyle
            ]
        )
        generatorViewCreate.action = #selector(generatorViewCreateClicked)
        generatorView.addSubview(generatorViewCreate)
        generatorViewCreate.snp.makeConstraints {
            (make) in
            make.bottom.equalTo(generatorViewSave.snp.top).offset(-10)
            make.leading.trailing.height.equalTo(generatorViewSave)
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
            make.leading.top.equalTo(10)
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
            make.trailing.equalTo(-10)
            make.leading.equalTo(generatorViewImage.snp.trailing).offset(10)
            make.height.equalTo(100)
        }

        generatorView.addSubview(generatorViewTable)
        generatorViewTable.snp.makeConstraints {
            (make) in
            make.top.equalTo(generatorViewContent.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
            make.leading.trailing.equalTo(generatorViewContent)
        }

        for index in generatorViewOptions.indices {
            let margin = 5

            generatorViewOptions[index].tag = index
            generatorViewOptions[index].wantsLayer = true
            generatorViewOptions[index].layer?.cornerRadius = 5
            generatorViewOptions[index].bezelStyle = .regularSquare
            generatorViewOptions[index].attributedTitle = NSMutableAttributedString(
                string: titleArray[index], attributes: [
                    NSAttributedString.Key.foregroundColor: NSColor.theme,
                    NSAttributedString.Key.paragraphStyle: centredStyle
                ]
            )
            generatorViewOptions[index].action = #selector(generatorViewOptionsClicked(button:))
            generatorViewTable.addSubview(generatorViewOptions[index])
            generatorViewOptions[index].snp.makeConstraints {
                (make) in
                if 1 == index % 2 {
                    make.leading.equalTo(generatorViewOptions[index - 1].snp.trailing).offset(margin)
                    make.trailing.equalTo(0)
                    make.width.equalTo(generatorViewOptions[index - 1])
                } else {
                    make.leading.equalTo(0)
                }

                if index > 1 {
                    make.top.equalTo(generatorViewOptions[index - 2].snp.bottom).offset(margin)
                    make.height.equalTo(generatorViewOptions[index - 2])
                } else {
                    make.top.equalTo(0)
                }

                if generatorViewOptions.count - 1 == index || generatorViewOptions.count - 2 == index {
                    make.bottom.equalTo(0)
                }
            }
        }

        refresh()
    }

    @objc func generatorViewCreateClicked() {
        // Lock user activity
        generatorViewCreate.isEnabled = false
        // Recover user activity
        defer { generatorViewCreate.isEnabled = true }

        let content = generatorViewContent.string

        let generator = EFQRCodeGenerator(content: content, size: size)
        generator.setInputCorrectionLevel(inputCorrectionLevel: inputCorrectionLevel)
        generator.setMode(mode: mode)
        generator.setMagnification(magnification: magnification)
        generator.setColors(backgroundColor: backColor.toCIColor(), foregroundColor: frontColor.toCIColor())
        generator.setIcon(icon: icon?.toCGImage(), size: iconSize)
        generator.setForegroundPointOffset(foregroundPointOffset: foregroundPointOffset)
        generator.setAllowTransparent(allowTransparent: allowTransparent)
        generator.setBinarizationThreshold(binarizationThreshold: binarizationThreshold)
        generator.setPointShape(pointShape: pointShape)

        switch watermark {
        case .gif(let data)?: // GIF
            generator.setWatermark(watermark: nil, mode: watermarkMode)
            
            if let afterData = EFQRCode.generateWithGIF(data: data, generator: generator) {
                generatorViewImage.image = NSImage(data: afterData)
                result = afterData
            } else {
                messageBox("Create QRCode failed!")
            }
        case .normal(let image)?:
            generator.setWatermark(watermark: image.toCGImage(), mode: watermarkMode)
            fallthrough // Other use UIImage
        case nil:
            if let tryCGImage = generator.generate() {
                generatorViewImage.image = NSImage(
                    cgImage: tryCGImage, size: NSSize(width: tryCGImage.width, height: tryCGImage.height)
                )
            } else {
                messageBox("Create QRCode failed!")
            }
        }
    }

    @objc func generatorViewSaveClicked() {
        guard let image = generatorViewImage.image else { return }
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["png", "gif"]
        panel.nameFieldStringValue = watermark?.isGIF == true ? "Untitle.gif" : "Untitle.png"
        panel.message = "Choose the path to save the image"
        panel.allowsOtherFileTypes = true
        panel.isExtensionHidden = true
        panel.canCreateDirectories = true
        panel.begin {
            [weak self] (result) in
            guard let self = self,
                result.rawValue == NSFileHandlingPanelOKButton,
                let url = panel.url
                else { return }
            // [@"onecodego" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            if url.absoluteString.lowercased().hasSuffix(".gif") {
                do {
                    try self.result?.write(to: url)
                    messageBox("GIF image saved.")
                } catch {
                    messageBox("GIF image saved failed!")
                }
            } else if image.pngWrite(to: url, options: .atomic) {
                messageBox("Image saved.")
            }
        }
    }

    @objc func generatorViewOptionsClicked(button: NSButton) {
        [chooseInputCorrectionLevel, chooseMode, chooseSize, chooseMagnification,
         chooseBackColor, chooseFrontColor, chooseIcon, chooseIconSize,
         chooseWatermark, chooseWatermarkMode, chooseForegroundPointOffset, chooseAllowTransparent,
         chooseBinarizationThreshold, chooseShape][button.tag]()
    }

    func refresh() {
        let magnificationString = "\(nil == magnification ? "nil" : "\(magnification?.width ?? 0)x\(magnification?.height ?? 0)")"
        let iconSizeString = "\(nil == iconSize ? "nil" : "\(iconSize?.width ?? 0)x\(iconSize?.height ?? 0)")"
        let watermarkModeString = [
            "scaleToFill", "scaleAspectFit", "scaleAspectFill", "center", "top", "bottom",
            "left", "right", "topLeft", "topRight", "bottomLeft", "bottomRight"
            ][watermarkMode.rawValue]
        let detailArray = [
            "\(["L", "M", "Q", "H"][inputCorrectionLevel.rawValue])",
            "\(["none", "grayscale", "binarization"][mode.rawValue])",
            "\(size.width)x\(size.height)",
            magnificationString,
            "", // backgroundColor
            "", // foregroundColor
            "", // icon
            iconSizeString,
            "", // watermark
            watermarkModeString,
            "\(foregroundPointOffset)",
            "\(allowTransparent)",
            "\(binarizationThreshold)",
            "\(["square", "circle", "diamond"][pointShape.rawValue])"
        ]

        for (index, button) in generatorViewOptions.enumerated() {
            if !detailArray[index].isEmpty {
                if nil == button.detailView {
                    let label = NSTextField()
                    label.isBezeled = false
                    label.drawsBackground = false
                    label.isEditable = false
                    label.alignment = .right
                    label.textColor = .gray
                    label.sizeToFit()
                    button.addSubview(label)
                    label.snp.makeConstraints {
                        (make) in
                        make.leading.centerY.equalTo(button)
                        make.trailing.equalTo(-10)
                    }

                    button.detailView = label
                }
                (button.detailView as? NSTextField)?.stringValue = detailArray[index]
            } else {
                if nil == button.detailView {
                    let rightImageView = NSImageView()
                    rightImageView.imageAlignment = .alignCenter
                    rightImageView.imageScaling = .scaleAxesIndependently
                    rightImageView.wantsLayer = true
                    rightImageView.layer?.borderColor = NSColor.theme.cgColor
                    rightImageView.layer?.borderWidth = 0.5
                    button.addSubview(rightImageView)
                    rightImageView.snp.makeConstraints {
                        (make) in
                        make.width.equalTo(rightImageView.snp.height)
                        make.trailing.bottom.equalTo(-5)
                        make.top.equalTo(5)
                    }

                    button.detailView = rightImageView
                }

                let rightImageView = (button.detailView as? NSImageView)
                switch index {
                case 4:
                    rightImageView?.layer?.backgroundColor = backColor.cgColor
                case 5:
                    rightImageView?.layer?.backgroundColor = frontColor.cgColor
                case 6:
                    rightImageView?.image = icon
                case 8:
                    switch watermark {
                    case .gif(let dataGIF)?:
                        rightImageView?.image = NSImage(data: dataGIF)
                    case .normal(let nsImage)?:
                        rightImageView?.image = nsImage
                    case nil:
                        rightImageView?.image = nil
                    }
                default:
                    break
                }
            }
        }
    }

    @objc func backColorChanged(colorPanel: NSColorPanel) {
        backColor = colorPanel.color
        refresh()
    }

    @objc func frontColorChanged(colorPanel: NSColorPanel) {
        frontColor = colorPanel.color
        refresh()
    }

    // MARK: - param
    func chooseInputCorrectionLevel() {
        choose("inputCorrectionLevel", from: "L", "M", "Q", "H") {
            (self, response) in
            self.inputCorrectionLevel = [
                EFInputCorrectionLevel.l,
                EFInputCorrectionLevel.m,
                EFInputCorrectionLevel.q,
                EFInputCorrectionLevel.h
            ][response.rawValue - 1000]
        }
    }

    func chooseMode() {
        choose("mode", from: "none", "grayscale", "binarization") {
            (self, response) in
            self.mode = [
                EFQRCodeMode.none,
                EFQRCodeMode.grayscale,
                EFQRCodeMode.binarization
            ][response.rawValue - 1000]
        }
    }

    func chooseSize() {
        choose("size", from: "128x128", "256x256", "1024x1024", "2048x2048") {
            (self, response) in
            let size = [128, 256, 1024, 2048][response.rawValue - 1000]
            self.size = EFIntSize(width: size, height: size)
        }
    }
    
    func chooseMagnification() {
        choose("magnification", from: "nil", "3x3", "9x9", "12x12", "30x30") {
            (self, response) in
            let size = [nil, 3, 9, 12, 30][response.rawValue - 1000]
            self.magnification = size.map { EFIntSize(width: $0, height: $0) }
        }
    }

    func chooseBackColor() {
        EFBackColorPicker.shared.setAction(#selector(backColorChanged(colorPanel:)))
        EFBackColorPicker.shared.setTarget(self)
        EFBackColorPicker.shared.makeKeyAndOrderFront(self)
    }

    func chooseFrontColor() {
        EFFrontColorPicker.shared.setAction(#selector(frontColorChanged(colorPanel:)))
        EFFrontColorPicker.shared.setTarget(self)
        EFFrontColorPicker.shared.makeKeyAndOrderFront(self)
    }

    func chooseIcon() {
        selectImageFromDisk {
            [weak self] (image) in
            guard let self = self,
                case let .normal(nsImage) = image
                else { return }
            self.icon = nsImage
            self.refresh()
        }
    }
    
    func chooseIconSize() {
        choose("iconSize", from: "nil", "32x32", "64x64", "128x128") {
            (self, response) in
            let size = [nil, 32, 64, 128][response.rawValue - 1000]
            self.iconSize = size.map { EFIntSize(width: $0, height: $0) }
        }
    }

    func chooseWatermark() {
        selectImageFromDisk {
            [weak self] (image) in
            guard let self = self else { return }
            self.watermark = image
            self.refresh()
        }
    }

    func chooseWatermarkMode() {
        choose("watermarkMode",
               from: "scaleToFill", "scaleAspectFit", "scaleAspectFill",
               "center", "top", "bottom", "left", "right",
               "topLeft", "topRight", "bottomLeft", "bottomRight"
        ) { (self, response) in
            self.watermarkMode = [
                EFWatermarkMode.scaleToFill,
                EFWatermarkMode.scaleAspectFit,
                EFWatermarkMode.scaleAspectFill,
                EFWatermarkMode.center,
                EFWatermarkMode.top,
                EFWatermarkMode.bottom,
                EFWatermarkMode.left,
                EFWatermarkMode.right,
                EFWatermarkMode.topLeft,
                EFWatermarkMode.topRight,
                EFWatermarkMode.bottomLeft,
                EFWatermarkMode.bottomRight
            ][response.rawValue - 1000]
        }
    }
    
    func chooseForegroundPointOffset() {
        choose("foregroundPointOffset",
               from: "nil", "-0.5", "-0.25", "0", "0.25", "0.5"
        ) { (self, response) in
            self.foregroundPointOffset = [nil, CGFloat(-0.5), -0.25, 0, 0.25, 0.5][response.rawValue - 1000] ?? 0
        }
    }

    func chooseAllowTransparent() {
        choose("allowTransparent", from: "true", "false") {
            (self, response) in
            self.allowTransparent = [true, false][response.rawValue - 1000]
        }
    }

    func chooseBinarizationThreshold() {
        choose("binarizationThreshold",
               from: "0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1"
        ) { (self, response) in
            self.binarizationThreshold = CGFloat(
                [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1][response.rawValue - 1000]
            )
        }
    }
    
    func chooseShape() {
        choose("shape", from: "square", "circle", "diamond") {
            (self, response) in
            self.pointShape = [EFPointShape.square, EFPointShape.circle, EFPointShape.diamond][response.rawValue - 1000]
        }
    }
    
    private func choose(
        _ configuration: String,
        from options: String...,
        processBeforeRefresh: @escaping (ViewController, NSApplication.ModalResponse) -> Void
    ) {
        guard let window = view.window else { return }
        let alert = NSAlert()
        alert.messageText = configuration
        for option in options {
            alert.addButton(withTitle: option)
        }
        alert.delegate = self
        alert.beginSheetModal(for: window) {
            [weak self] (response) in
            guard let self = self else { return }
            processBeforeRefresh(self, response)
            self.refresh()
        }
    }
}
