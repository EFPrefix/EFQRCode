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
                let frameDelays = animatedImage.frameDelays.map({ $0.cgFloat })
                return .animated(images: frames, imageDelays: frameDelays)
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
                return EFStyleParamIcon(
                    image: icon,
                    mode: .scaleAspectFill,
                    alpha: iconAlpha,
                    borderColor: CGColor.white,
                    percentage: iconScale
                )
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
                        align: EFStyleImageParamsAlign(style: alignStyle),
                        timing: EFStyleImageParamsTiming(style: timingStyle),
                        position: EFStyleImageParamsPosition(
                            style: positionStyle,
                            colorDark: positionColor.cgColor
                        ),
                        data: EFStyleImageParamsData(
                            style: dataStyle,
                            scale: dataThickness,
                            colorDark: dataDarkColor.cgColor,
                            colorLight: dataLightColor.cgColor
                        ),
                        image: paramWatermark
                    )
                )
            )
            let svg = try generator.toSVG()
            self.generatorSVG = svg
            generatorWebViewImage.loadHTMLString(svg, baseURL: nil)
            
            Anchor.generator = generator
        } catch {
            messageBox(Localized.createQRCodeFailed)
        }
    }

    // 添加所有支持的格式选项
    static let formats = [
        "SVG": "svg",
        "PDF": "pdf",
        "PNG": "png",
        "JPEG": "jpg",
        "APNG": "apng",
        "GIF": "gif",
        "MOV": "mov",
        "MP4": "mp4",
        "M4V": "m4v"
    ]
    // 用于存储当前选择的格式
    struct Anchor {
        static var selectedFormat: String = "svg"
        static weak var currentAlert: NSAlert?
        static var generator: EFQRCode.Generator?
    }
    @objc func generatorViewSaveClicked() {
        // 创建文件类型选择菜单
        let formatMenu = NSMenu()
        
        // 为每种格式创建菜单项
        for (title, ext) in ViewController.formats {
            let item = NSMenuItem(title: title, action: #selector(formatSelected(_:)), keyEquivalent: "")
            item.representedObject = ext
            item.target = self
            formatMenu.addItem(item)
        }
        
        // 创建菜单按钮
        let formatButton = NSButton(title: "SVG", target: self, action: #selector(showFormatMenu(_:)))
        formatButton.menu = formatMenu
        formatButton.bezelStyle = .rounded
        formatButton.tag = 100 // 用于标识这个按钮
        
        // 创建保存对话框
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Save Image As", comment: "Save dialog title")
        alert.informativeText = NSLocalizedString("Choose format and location:", comment: "Format selection prompt")
        alert.alertStyle = .informational
        Anchor.currentAlert = alert
        
        // 添加取消和保存按钮
        alert.addButton(withTitle: NSLocalizedString("Cancel", comment: "Cancel button"))
        
        _ = alert.addButton(withTitle: NSLocalizedString("Save", comment: "Save button"))
        // 添加格式选择器作为附件视图
        alert.accessoryView = formatButton
        
        // 显示对话框并处理结果
        alert.beginSheetModal(for: self.view.window!) { [weak self] (response) in
            guard let self = self else { return }
            
            // 用户点击了保存按钮
            if response == .alertSecondButtonReturn {
                let format = Anchor.selectedFormat
                self.saveFile(withType: format)
            }
        }
    }
    
    @objc func showFormatMenu(_ sender: NSButton) {
        if let menu = sender.menu {
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: sender.bounds.height), in: sender)
        }
    }
    
    // 定义格式选择的处理函数
    @objc func formatSelected(_ sender: NSMenuItem) {
        if let formatButton = Anchor.currentAlert?.accessoryView as? NSButton {
            formatButton.title = sender.title
            Anchor.selectedFormat = sender.representedObject as? String ?? "svg"
        }
    }

    private func saveAsSVG(to url: URL) {
        guard let svgString = self.generatorSVG else {
            showErrorMessage()
            return
        }
        
        do {
            try svgString.data(using: .utf8)?.write(to: url)
            showSuccessMessage()
        } catch {
            showErrorMessage()
        }
    }
    
    private func saveAsPDF(to url: URL) {
        do {
            try Anchor.generator?.toPDFData(width: 1024).write(to: url)
            showSuccessMessage()
        } catch {
            showErrorMessage()
        }
    }
    
    private func saveAsPNG(to url: URL) {
        do {
            try Anchor.generator?.toPNGData(width: 1024).write(to: url)
            showSuccessMessage()
        } catch {
            showErrorMessage()
        }
    }
    
    private func saveAsJPEG(to url: URL) {
        do {
            try Anchor.generator?.toJPEGData(width: 1024, compressionQuality: 0.8).write(to: url)
            showSuccessMessage()
        } catch {
            showErrorMessage()
        }
    }
    
    private func saveAsAPNG(to url: URL) {
        do {
            try Anchor.generator?.toAPNGData(width: 1024).write(to: url)
            showSuccessMessage()
        } catch {
            showErrorMessage()
        }
    }
    
    private func saveAsGIF(to url: URL) {
        do {
            try Anchor.generator?.toGIFData(width: 1024).write(to: url)
            showSuccessMessage()
        } catch {
            showErrorMessage()
        }
    }
    
    private func saveAsMOV(to url: URL) {
        do {
            try Anchor.generator?.toMovData(width: 1024).write(to: url)
            showSuccessMessage()
        } catch {
            showErrorMessage()
        }
    }
    
    private func saveAsMP4(to url: URL) {
        do {
            try Anchor.generator?.toMp4Data(width: 1024).write(to: url)
            showSuccessMessage()
        } catch {
            showErrorMessage()
        }
    }
    
    private func saveAsM4V(to url: URL) {
        do {
            try Anchor.generator?.toM4vData(width: 1024).write(to: url)
            showSuccessMessage()
        } catch {
            showErrorMessage()
        }
    }

    // 保存文件的方法
    private func saveFile(withType fileType: String) {
        let panel = NSSavePanel()
        panel.allowedFileTypes = [fileType]
        panel.nameFieldStringValue = "Untitled.\(fileType)"
        panel.message = NSLocalizedString("Choose the location to save the image", comment: "File saver prompt title")
        panel.allowsOtherFileTypes = false
        panel.isExtensionHidden = false
        panel.canCreateDirectories = true
        
        panel.begin { [weak self] (result) in
            guard let self = self,
                  result == .OK,
                  let url = panel.url else { return }
            
            // 根据文件类型调用对应的保存方法
            switch fileType {
            case "svg":
                self.saveAsSVG(to: url)
            case "pdf":
                self.saveAsPDF(to: url)
            case "png":
                self.saveAsPNG(to: url)
            case "jpg":
                self.saveAsJPEG(to: url)
            case "apng":
                self.saveAsAPNG(to: url)
            case "gif":
                self.saveAsGIF(to: url)
            case "mov":
                self.saveAsMOV(to: url)
            case "mp4":
                self.saveAsMP4(to: url)
            case "m4v":
                self.saveAsM4V(to: url)
            default:
                self.showErrorMessage("Unsupported format: \(fileType)")
            }
        }
    }

    private func showSuccessMessage() {
        messageBox(NSLocalizedString("File saved successfully", comment: "Successfully save file"))
    }

    private func showErrorMessage(_ msg: String? = nil) {
        messageBox(NSLocalizedString(msg ?? "Failed to save file", comment: "Failed to save file"))
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
        chooseFromEnum(title: Localized.Title.positionStyle, type: EFStyleParamsPositionStyle.self) { [weak self] result in
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
        chooseFromEnum(title: Localized.Title.dataStyle, type: EFStyleParamsDataStyle.self) { [weak self] result in
            guard let self = self else { return }
            
            self.dataStyle = result
            self.refresh()
        }
    }
    
    func chooseAlignStyle() {
        chooseFromEnum(title: Localized.Title.alignStyle, type: EFStyleImageParamAlignStyle.self) { [weak self] result in
            guard let self = self else { return }
            
            self.alignStyle = result
            self.refresh()
        }
    }
    
    func chooseTimingStyle() {
        chooseFromEnum(title: Localized.Title.timingStyle, type: EFStyleImageParamTimingStyle.self) { [weak self] result in
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
