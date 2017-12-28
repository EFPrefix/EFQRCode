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

class EFImage {
    var isGIF: Bool = false
    var data: Any?

    init() {

    }

    init?(_ image: NSImage?) {
        if let image = image {
            self.data = image
            self.isGIF = false
        } else {
            return nil
        }
    }

    init?(_ data: Data?) {
        if let data = data {
            self.data = data
            self.isGIF = true
        } else {
            return nil
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

        generatorView.addSubview(generatorViewTable)
        generatorViewTable.snp.makeConstraints {
            (make) in
            make.top.equalTo(generatorViewContent.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
            make.left.right.equalTo(generatorViewContent)
        }

        for index in 0 ..< generatorViewOptions.count {
            let margin = 5

            generatorViewOptions[index].tag = index
            generatorViewOptions[index].wantsLayer = true
            generatorViewOptions[index].layer?.cornerRadius = 5
            generatorViewOptions[index].bezelStyle = .regularSquare
            generatorViewOptions[index].attributedTitle = NSMutableAttributedString(
                string: titleArray[index], attributes: [
                    NSAttributedStringKey.foregroundColor: NSColor.theme,
                    NSAttributedStringKey.paragraphStyle: centredStyle
                ]
            )
            generatorViewOptions[index].action = #selector(generatorViewOptionsClicked(button:))
            generatorViewTable.addSubview(generatorViewOptions[index])
            generatorViewOptions[index].snp.makeConstraints {
                (make) in
                if 1 == index % 2 {
                    make.left.equalTo(generatorViewOptions[index - 1].snp.right).offset(margin)
                    make.right.equalTo(0)
                    make.width.equalTo(generatorViewOptions[index - 1])
                } else {
                    make.left.equalTo(0)
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

        if watermark?.isGIF == true, let data = watermark?.data as? Data {
            // GIF
            generator.setWatermark(watermark: nil, mode: watermarkMode)

            if let afterData = EFQRCode.generateWithGIF(data: data, generator: generator) {
                generatorViewImage.image = NSImage(data: afterData)
                self.result = afterData
            } else {
                messageBox("Create QRCode failed!")
            }
        } else {
            // Other use UIImage
            generator.setWatermark(watermark: (watermark?.data as? NSImage)?.toCGImage(), mode: watermarkMode)

            if let tryCGImage = generator.generate() {
                generatorViewImage.image = NSImage(
                    cgImage: tryCGImage, size: NSSize(width: tryCGImage.width, height: tryCGImage.height)
                )
            } else {
                messageBox("Create QRCode failed!")
            }
        }

        // Recove user activity
        generatorViewCreate.isEnabled = true
    }

    @objc func generatorViewSaveClicked() {
        if let image = generatorViewImage.image {
            let panel = NSSavePanel()
            panel.allowedFileTypes = ["png", "gif"]
            panel.nameFieldStringValue = self.watermark?.isGIF == true ? "Untitle.gif" : "Untitle.png"
            panel.message = "Choose the path to save the image"
            panel.allowsOtherFileTypes = true
            panel.isExtensionHidden = true
            panel.canCreateDirectories = true
            panel.begin {
                [weak self] (result) in
                if let strongSelf = self {
                    if result.rawValue == NSFileHandlingPanelOKButton {
                        // [@"onecodego" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
                        if let url = panel.url {
                            if url.absoluteString.lowercased().hasSuffix(".gif") {
                                do {
                                    try strongSelf.result?.write(to: url)
                                } catch {
                                    messageBox("GIF image saved failed!")
                                    return
                                }
                                messageBox("GIF image saved.")
                            } else if image.pngWrite(to: url, options: .atomic) {
                                messageBox("Image saved.")
                            }
                        }
                    }
                }
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
            "\(["square", "circle"][pointShape.rawValue])"
        ]

        for (index, button) in self.generatorViewOptions.enumerated() {
            if "" != detailArray[index] {
                if nil == button.detailView {
                    let label = NSTextField()
                    label.isBezeled = false
                    label.drawsBackground = false
                    label.isEditable = false
                    label.alignment = .right
                    label.textColor = NSColor.gray
                    label.sizeToFit()
                    button.addSubview(label)
                    label.snp.makeConstraints {
                        (make) in
                        make.left.centerY.equalTo(button)
                        make.right.equalTo(-10)
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
                        make.right.bottom.equalTo(-5)
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
                    if watermark?.isGIF == true {
                        if let dataGIF = watermark?.data as? Data {
                            rightImageView?.image = NSImage(data: dataGIF)
                        }
                    } else {
                        rightImageView?.image = watermark?.data as? NSImage
                    }
                default:
                    break
                }
            }
        }
    }

    @objc func backColorChanged(colorPanel: NSColorPanel) {
        self.backColor = colorPanel.color
        self.refresh()
    }

    @objc func frontColorChanged(colorPanel: NSColorPanel) {
        self.frontColor = colorPanel.color
        self.refresh()
    }

    // MARK:- param
    func chooseInputCorrectionLevel() {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = "inputCorrectionLevel"
            alert.addButton(withTitle: "L")
            alert.addButton(withTitle: "M")
            alert.addButton(withTitle: "Q")
            alert.addButton(withTitle: "H")
            alert.delegate = self
            alert.beginSheetModal(for: window) {
                [weak self] (response) in
                if let strongSelf = self {
                    strongSelf.inputCorrectionLevel = [
                        EFInputCorrectionLevel.l,
                        EFInputCorrectionLevel.m,
                        EFInputCorrectionLevel.q,
                        EFInputCorrectionLevel.h
                        ][response.rawValue - 1000]
                    strongSelf.refresh()
                }
            }
        }
    }

    func chooseMode() {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = "mode"
            alert.addButton(withTitle: "none")
            alert.addButton(withTitle: "grayscale")
            alert.addButton(withTitle: "binarization")
            alert.delegate = self
            alert.beginSheetModal(for: window) {
                [weak self] (response) in
                if let strongSelf = self {
                    strongSelf.mode = [
                        EFQRCodeMode.none,
                        EFQRCodeMode.grayscale,
                        EFQRCodeMode.binarization
                        ][response.rawValue - 1000]
                    strongSelf.refresh()
                }
            }
        }
    }

    func chooseSize() {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = "size"
            alert.addButton(withTitle: "128x128")
            alert.addButton(withTitle: "256x256")
            alert.addButton(withTitle: "1024x1024")
            alert.addButton(withTitle: "2048x2048")
            alert.delegate = self
            alert.beginSheetModal(for: window) {
                [weak self] (response) in
                if let strongSelf = self {
                    let size = [128, 256, 1024, 2048][response.rawValue - 1000]
                    strongSelf.size = EFIntSize(width: size, height: size)
                    strongSelf.refresh()
                }
            }
        }
    }

    func chooseMagnification() {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = "magnification"
            alert.addButton(withTitle: "nil")
            alert.addButton(withTitle: "3x3")
            alert.addButton(withTitle: "9x9")
            alert.addButton(withTitle: "12x12")
            alert.addButton(withTitle: "30x30")
            alert.delegate = self
            alert.beginSheetModal(for: window) {
                [weak self] (response) in
                if let strongSelf = self {
                    let size = [nil, 3, 9, 12, 30][response.rawValue - 1000]
                    strongSelf.magnification = size == nil ? nil : EFIntSize(width: size!, height: size!)
                    strongSelf.refresh()
                }
            }
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
        selectImageFromDisk(finish: {
            [weak self] (image) in
            if let strongSelf = self {
                strongSelf.icon = image
                strongSelf.refresh()
            }
        })
    }

    func chooseIconSize() {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = "iconSize"
            alert.addButton(withTitle: "nil")
            alert.addButton(withTitle: "32x32")
            alert.addButton(withTitle: "64x64")
            alert.addButton(withTitle: "128x128")
            alert.delegate = self
            alert.beginSheetModal(for: window) {
                [weak self] (response) in
                if let strongSelf = self {
                    let size = [nil, 32, 64, 128][response.rawValue - 1000]
                    strongSelf.iconSize = size == nil ? nil : EFIntSize(width: size!, height: size!)
                    strongSelf.refresh()
                }
            }
        }
    }

    func chooseWatermark() {
        selectImageFromDisk(finish: {
            [weak self] (image) in
            if let strongSelf = self {
                strongSelf.watermark = EFImage(image)
                strongSelf.refresh()
            }
        }) {
            [weak self] (imageGIF) in
            if let strongSelf = self {
                strongSelf.watermark = EFImage(imageGIF)
                strongSelf.refresh()
            }
        }
    }

    func chooseWatermarkMode() {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = "watermarkMode"
            alert.addButton(withTitle: "scaleToFill")
            alert.addButton(withTitle: "scaleAspectFit")
            alert.addButton(withTitle: "scaleAspectFill")
            alert.addButton(withTitle: "center")
            alert.addButton(withTitle: "top")
            alert.addButton(withTitle: "bottom")
            alert.addButton(withTitle: "left")
            alert.addButton(withTitle: "right")
            alert.addButton(withTitle: "topLeft")
            alert.addButton(withTitle: "topRight")
            alert.addButton(withTitle: "bottomLeft")
            alert.addButton(withTitle: "bottomRight")
            alert.delegate = self
            alert.beginSheetModal(for: window) {
                [weak self] (response) in
                if let strongSelf = self {
                    strongSelf.watermarkMode = [
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
                    strongSelf.refresh()
                }
            }
        }
    }

    func chooseForegroundPointOffset() {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = "foregroundPointOffset"
            alert.addButton(withTitle: "nil")
            alert.addButton(withTitle: "-0.5")
            alert.addButton(withTitle: "-0.25")
            alert.addButton(withTitle: "0")
            alert.addButton(withTitle: "0.25")
            alert.addButton(withTitle: "0.5")
            alert.delegate = self
            alert.beginSheetModal(for: window) {
                [weak self] (response) in
                if let strongSelf = self {
                    strongSelf.foregroundPointOffset = [nil, CGFloat(-0.5), -0.25, 0, 0.25, 0.5][response.rawValue - 1000] ?? 0
                    strongSelf.refresh()
                }
            }
        }
    }

    func chooseAllowTransparent() {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = "allowTransparent"
            alert.addButton(withTitle: "true")
            alert.addButton(withTitle: "false")
            alert.delegate = self
            alert.beginSheetModal(for: window) {
                [weak self] (response) in
                if let strongSelf = self {
                    strongSelf.allowTransparent = [true, false][response.rawValue - 1000]
                    strongSelf.refresh()
                }
            }
        }
    }

    func chooseBinarizationThreshold() {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = "binarizationThreshold"
            alert.addButton(withTitle: "0")
            alert.addButton(withTitle: "0.1")
            alert.addButton(withTitle: "0.2")
            alert.addButton(withTitle: "0.3")
            alert.addButton(withTitle: "0.4")
            alert.addButton(withTitle: "0.5")
            alert.addButton(withTitle: "0.6")
            alert.addButton(withTitle: "0.7")
            alert.addButton(withTitle: "0.8")
            alert.addButton(withTitle: "0.9")
            alert.addButton(withTitle: "1")
            alert.delegate = self
            alert.beginSheetModal(for: window) {
                [weak self] (response) in
                if let strongSelf = self {
                    strongSelf.binarizationThreshold = CGFloat(
                        [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1][response.rawValue - 1000]
                    )
                    strongSelf.refresh()
                }
            }
        }
    }

    func chooseShape() {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = "shape"
            alert.addButton(withTitle: "square")
            alert.addButton(withTitle: "circle")
            alert.delegate = self
            alert.beginSheetModal(for: window) {
                [weak self] (response) in
                if let strongSelf = self {
                    strongSelf.pointShape = [EFPointShape.square, EFPointShape.circle][response.rawValue - 1000]
                    strongSelf.refresh()
                }
            }
        }
    }
}
