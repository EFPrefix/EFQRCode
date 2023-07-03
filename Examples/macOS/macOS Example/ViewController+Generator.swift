//
//  ViewController+Generator.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/11/14.
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
    
    var styleParamImage: EFStyleParamImage? {
        switch self {
        case .normal(let image):
            if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                return EFStyleParamImage.static(image: cgImage)
            }
            return nil
        case .gif(let data):
            if let animatedImage = AnimatedImage(data: data, format: .gif) {
                let frames = animatedImage.frames.compactMap { return $0 }
                let duration = animatedImage.duration
                return .animated(images: frames, duration: duration)
            }
            return nil
        }
    }
}

class EFDataDarkColorPicker: NSColorPanel {

}

class EFDataLightColorPicker: NSColorPanel {

}

class EFPositionColorPicker: NSColorPanel {

}

extension ViewController: NSAlertDelegate {

    func addControlGenerator() {
        generatorView.addSubview(generatorViewImage)
        generatorView.addSubview(generatorWebViewImage)

        let tryCentredStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        tryCentredStyle?.alignment = .left
        let centredStyle = tryCentredStyle ?? .default

        generatorViewSave.wantsLayer = true
        generatorViewSave.layer?.cornerRadius = 5
        generatorViewSave.bezelStyle = .regularSquare
        generatorViewSave.attributedTitle = NSMutableAttributedString(
            string: Localized.save,
            attributes: [
                .foregroundColor: NSColor.theme,
                .paragraphStyle: centredStyle
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
            string: NSLocalizedString("Create", comment: "Button to init generation"),
            attributes: [
                .foregroundColor: NSColor.theme,
                .paragraphStyle: centredStyle
            ]
        )
        generatorViewCreate.action = #selector(generatorViewCreateClicked)
        generatorView.addSubview(generatorViewCreate)
        generatorViewCreate.snp.makeConstraints {
            (make) in
            make.bottom.equalTo(generatorViewSave.snp.top).offset(-10)
            make.leading.trailing.height.equalTo(generatorViewSave)
        }

        generatorViewImage.isHidden = true
        generatorViewImage.wantsLayer = true
        generatorViewImage.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.08).cgColor
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
        
        generatorWebViewImage.wantsLayer = true
        generatorWebViewImage.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.08).cgColor
        generatorWebViewImage.layer?.borderColor = NSColor.theme.cgColor
        generatorWebViewImage.layer?.borderWidth = 1
        generatorWebViewImage.layer?.cornerRadius = 5
        generatorWebViewImage.snp.makeConstraints { make in
            make.leading.top.equalTo(10)
            make.bottom.equalTo(generatorViewCreate.snp.top).offset(-10)
            make.width.equalTo(generatorViewImage.snp.height)
        }

        generatorViewContent.wantsLayer = true
        generatorViewContent.layer?.backgroundColor = NSColor.theme.withAlphaComponent(0.08).cgColor
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
                string: titleArray[index],
                attributes: [
                    .foregroundColor: NSColor.theme,
                    .paragraphStyle: centredStyle
                ]
            )
            generatorViewOptions[index].action = #selector(generatorViewOptionsClicked(button:))
            generatorViewTable.addSubview(generatorViewOptions[index])
            generatorViewOptions[index].snp.makeConstraints {
                (make) in

                if index > 0 {
                    make.width.equalTo(generatorViewOptions[index-1])
                }
                
                if index.isMultiple(of: 2) {
                    make.leading.equalTo(0)
                } else {
                    make.leading.equalTo(generatorViewOptions[index - 1].snp.trailing).offset(margin)
                    make.trailing.equalTo(0)
                }

                if index > 1 {
                    make.top.equalTo(generatorViewOptions[index - 2].snp.bottom).offset(margin)
                    make.height.equalTo(generatorViewOptions[index - 2])
                } else {
                    make.top.equalTo(0)
                }

                if generatorViewOptions.count - 1 == index {
                    make.bottom.equalTo(0)
                } else if generatorViewOptions.count - 2 == index {
                    if generatorViewOptions.count.isMultiple(of: 2) {
                        make.bottom.equalTo(0)
                    } else {
                        make.bottom.equalTo(generatorViewOptions[index-1])
                    }
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
        lastContent.value = content as NSString

        let paramIcon: EFStyleParamIcon? = {
            if let icon = self.icon {
                return EFStyleParamIcon(image: icon, percentage: iconScale, alpha: iconAlpha)
            }
            return nil
        }()
        
        let paramWatermark: EFStyleImageParamsImage? = {
            if let image = self.image {
                return EFStyleImageParamsImage(image: image, alpha: imageAlpha)
            }
            return nil
        }()
        
        do {
            let generator = try EFQRCode.Generator(
                content,
                encoding: .utf8,
                errorCorrectLevel: inputCorrectionLevel,
                style: EFQRCodeStyle.image(
                    params: EFStyleImageParams(
                        icon: paramIcon,
                        alignStyle: alignStyle,
                        timingStyle: timingStyle,
                        position: EFStyleImageParamsPosition(
                            style: positionStyle,
                            color: positionColor.cgColor
                        ),
                        data: EFStyleImageParamsData(
                            style: dataStyle,
                            scale: dataThickness,
                            alpha: dataAlpha,
                            colorDark: dataDarkColor.cgColor,
                            colorLight: dataLightColor.cgColor
                        ),
                        image: paramWatermark
                    )
                )
            )
            let svg = try generator.generateSVG()
            self.generatorSVG = svg
            generatorWebViewImage.loadHTMLString(svg, baseURL: nil)
        } catch {
            messageBox(Localized.createQRCodeFailed)
        }
    }

    @objc func generatorViewSaveClicked() {
        guard let svgString = self.generatorSVG else { return }
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["svg"]
        let defaultFileName = NSLocalizedString("Untitled", comment: "Default file name")
        let fileExtension = "svg"
        panel.nameFieldStringValue = "\(defaultFileName).\(fileExtension)"
        panel.message = NSLocalizedString(
            "Choose the location to save the image",
            comment: "File saver prompt title"
        )
        panel.allowsOtherFileTypes = true
        panel.isExtensionHidden = true
        panel.canCreateDirectories = true
        panel.begin {
            [weak self] (result) in
            guard let self = self,
                result.rawValue == NSApplication.ModalResponse.OK.rawValue,
                let url = panel.url
                else { return }
            // [@"onecodego" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            do {
                try svgString.data(using: .utf8)?.write(to: url)
                messageBox(NSLocalizedString(
                    "SVG image saved",
                    comment: "Successfully export QR code image"
                ))
            } catch {
                messageBox(NSLocalizedString(
                    "Failed to save SVG image",
                    comment: "Failed to export QR code image"
                ))
            }
        }
    }

    @objc func generatorViewOptionsClicked(button: NSButton) {
        var state: Bool? {
            switch button.state {
            case .on where button.title.isEmpty:
                return true
            case .off where button.title.isEmpty:
                return false
            default:
                return nil
            }
        }
        [
            chooseInputCorrectionLevel,
            chooseWatermark,
            chooseWatermarkAlpha,
            chooseDataStyle,
            chooseDataDarkColor,
            chooseDataLightColor,
            chooseDataAlpha,
            chooseDataThickness,
            choosePositionStyle,
            choosePositionColor,
            chooseAlignStyle,
            chooseTimingStyle,
            chooseIcon,
            chooseIconScale,
            chooseIconAlpha,
        ][button.tag]()
    }

    func refresh() {
        let detailArray: [Any?] = [
            "\(inputCorrectionLevel)",
            nil, // watermark
            "\(imageAlpha)",
            "\(dataStyle)",
            nil, // dataDarkColor
            nil, // dataLightColor
            "\(dataAlpha)",
            "\(dataThickness)",
            "\(positionStyle)",
            nil, // positionColor
            "\(alignStyle)",
            "\(timingStyle)",
            nil, // icon
            "\(iconScale)",
            "\(iconAlpha)"
        ]

        for (index, button) in generatorViewOptions.enumerated() {
            func makeTextField() {
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
            }
            func makeCheckbox() {
                if nil == button.detailView {
                    if #available(macOS 10.12, *) {
                        let toggle = NSButton(checkboxWithTitle: "", target: self, action: #selector(generatorViewOptionsClicked))
                        toggle.allowsMixedState = false
                        button.addSubview(toggle)
                        toggle.snp.makeConstraints {
                            (make) in
                            make.centerY.equalTo(button)
                            make.trailing.equalTo(-10)
                        }
                        toggle.tag = index
                        button.detailView = toggle
                    } else {
                        makeTextField()
                    }
                }
            }
            switch detailArray[index] {
            case let detail as Bool:
                makeCheckbox()
                (button.detailView as? NSButton)?.state = detail ? .on : .off
                (button.detailView as? NSTextField)?.stringValue = detail ? Localized.yes : Localized.no
            case let detail as String:
                makeTextField()
                (button.detailView as? NSTextField)?.stringValue = detail
            case nil:
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
                    rightImageView?.layer?.backgroundColor = dataDarkColor.cgColor
                case 5:
                    rightImageView?.layer?.backgroundColor = dataLightColor.cgColor
                case 9:
                    rightImageView?.layer?.backgroundColor = positionColor.cgColor
                case 12:
                    switch efImageIcon {
                    case .gif(let dataGIF)?:
                        rightImageView?.image = NSImage(data: dataGIF)
                    case .normal(let nsImage)?:
                        rightImageView?.image = nsImage
                    case nil:
                        rightImageView?.image = nil
                    }
                case 1:
                    switch efImageWatermark {
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
            default:
                break
            }
        }
    }

    @objc func dataDarkColorChanged(colorPanel: NSColorPanel) {
        dataDarkColor = colorPanel.color
        refresh()
    }

    @objc func dataLightColorChanged(colorPanel: NSColorPanel) {
        dataLightColor = colorPanel.color
        refresh()
    }
    
    @objc func positionColorChanged(colorPanel: NSColorPanel) {
        positionColor = colorPanel.color
        refresh()
    }

    // MARK: - param
    func chooseInputCorrectionLevel() {
        chooseFromEnum(title: Localized.Title.inputCorrectionLevel, type: EFCorrectionLevel.self) { [weak self] result in
            guard let self = self else { return }
            
            self.inputCorrectionLevel = result
            self.refresh()
        }
    }

    func chooseDataDarkColor() {
        EFDataDarkColorPicker.shared.setAction(#selector(dataDarkColorChanged(colorPanel:)))
        EFDataDarkColorPicker.shared.setTarget(self)
        EFDataDarkColorPicker.shared.makeKeyAndOrderFront(self)
    }

    func chooseDataLightColor() {
        EFDataLightColorPicker.shared.setAction(#selector(dataLightColorChanged(colorPanel:)))
        EFDataLightColorPicker.shared.setTarget(self)
        EFDataLightColorPicker.shared.makeKeyAndOrderFront(self)
    }
    
    func choosePositionColor() {
        EFPositionColorPicker.shared.setAction(#selector(positionColorChanged(colorPanel:)))
        EFPositionColorPicker.shared.setTarget(self)
        EFPositionColorPicker.shared.makeKeyAndOrderFront(self)
    }

    func chooseIcon() {
        selectImageFromDisk {
            [weak self] (image) in
            guard let self = self else { return }
            self.efImageIcon = image
            self.icon = image?.styleParamImage
            self.refresh()
        }
    }

    func chooseWatermark() {
        selectImageFromDisk {
            [weak self] (image) in
            guard let self = self else { return }
            self.efImageWatermark = image
            self.image = image?.styleParamImage
            self.refresh()
        }
    }

    func chooseDataThickness() {
        chooseFromList(title: Localized.Title.dataThickness, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.dataThickness = result
            self.refresh()
        }
    }
    
    func choosePositionStyle() {
        chooseFromEnum(title: Localized.Title.positionStyle, type: EFStyleImageParamsPositionStyle.self) { [weak self] result in
            guard let self = self else { return }
            
            self.positionStyle = result
            self.refresh()
        }
    }
    
    func chooseWatermarkAlpha() {
        chooseFromList(title: Localized.Title.watermarkAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.imageAlpha = result
            self.refresh()
        }
    }
    
    func chooseDataStyle() {
        chooseFromEnum(title: Localized.Title.dataStyle, type: EFStyleImageParamsDataStyle.self) { [weak self] result in
            guard let self = self else { return }
            
            self.dataStyle = result
            self.refresh()
        }
    }
    
    func chooseAlignStyle() {
        chooseFromEnum(title: Localized.Title.alignStyle, type: EFStyleParamAlignStyle.self) { [weak self] result in
            guard let self = self else { return }
            
            self.alignStyle = result
            self.refresh()
        }
    }
    
    func chooseTimingStyle() {
        chooseFromEnum(title: Localized.Title.timingStyle, type: EFStyleParamTimingStyle.self) { [weak self] result in
            guard let self = self else { return }
            
            self.timingStyle = result
            self.refresh()
        }
    }
    
    func chooseDataAlpha() {
        chooseFromList(title: Localized.Title.dataAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.dataAlpha = result
            self.refresh()
        }
    }
    
    func chooseIconScale() {
        chooseFromList(title: Localized.Title.iconScale, items: [0, 0.11, 0.22, 0.33]) { [weak self] result in
            guard let self = self else { return }
            
            self.iconScale = result
            self.refresh()
        }
    }
    
    func chooseIconAlpha() {
        chooseFromList(title: Localized.Title.iconAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.iconAlpha = result
            self.refresh()
        }
    }
    
    private func choose(
        _ configuration: String,
        from options: [String],
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
    
    func chooseFromEnum<T: CaseIterable>(title: String, type: T.Type, completion: ((T) -> Void)?) {
        guard let window = view.window else { return }
        let alert = NSAlert()
        alert.messageText = title
        let allCases = Array(type.allCases)
        let names: [String] = allCases.map{ "\($0)" }
        for modeName in names {
            alert.addButton(withTitle: modeName)
        }
        alert.delegate = self
        alert.beginSheetModal(for: window) {
            [weak self] (response) in
            guard let self = self else { return }
            completion?(allCases[response.rawValue - 1000])
            self.refresh()
        }
    }
    
    func chooseFromList<T>(title: String, items: [T], completion: ((T) -> Void)?) {
        guard let window = view.window else { return }
        let alert = NSAlert()
        alert.messageText = title
        let names: [String] = items.map{ "\($0)" }
        for modeName in names {
            alert.addButton(withTitle: modeName)
        }
        alert.delegate = self
        alert.beginSheetModal(for: window) {
            [weak self] (response) in
            guard let self = self else { return }
            completion?(items[response.rawValue - 1000])
            self.refresh()
        }
    }
}
