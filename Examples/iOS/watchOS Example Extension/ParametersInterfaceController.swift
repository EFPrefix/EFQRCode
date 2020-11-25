//
//  ParametersInterfaceController.swift
//  watchOS Example Extension
//
//  Created by Apollo Zhu on 12/27/17.
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

import WatchKit
import EFQRCode

enum EFImage {
    case normal(_ image: UIImage)
    case gif(_ data: Data)
}

class ParametersInterfaceController: WKInterfaceController {
    override func willActivate() {
        super.willActivate()
        self.contentDisplay?.setText(link)
    }

    private static let lastContent = StorageUserDefaults<NSString>(key: "lastContent")
    private var link = (ParametersInterfaceController.lastContent.value as String?) ?? "https://github.com/EFPrefix/EFQRCode"
    @IBOutlet var contentDisplay: WKInterfaceLabel!
    @IBAction func changeLink() {
        presentTextInputController(withSuggestions: [link], allowedInputMode: .allowEmoji) {
            [weak self] array in
            guard let self = self,
                let link = array?.first(where: { $0 is NSString }) as? String
                else { return }
            self.link = link
            self.contentDisplay?.setText(link)
        }
    }
    
    private var correctionLevel = EFInputCorrectionLevel.h
    @IBAction func changeInputCorrectionLevel(_ value: Float) {
        if let level = EFInputCorrectionLevel(rawValue: Int(value)) {
            correctionLevel = level
        }
    }
    private var selectedMode = EFQRCodeMode.none
    private let mode = [
        "none", "grayscale", "binarization"
    ]
    @IBOutlet var modePicker: WKInterfacePicker? {
        didSet {
            modePicker?.setItems(Localized.Parameters.modeNames.map {
                let item = WKPickerItem()
                item.title = $0
                return item
            })
        }
    }
    @IBAction func pickedMode(_ value: Int) {
        selectedMode = [.none, .grayscale, .binarization(threshold: 0.5)][value]
        if case .binarization = selectedMode {
            binarizationThresholdLabel.setHidden(false)
            binarizationThresholdPicker?.setHidden(false)
        } else {
            binarizationThresholdLabel.setHidden(true)
            binarizationThresholdPicker?.setHidden(true)
        }
    }

    @IBOutlet var binarizationThresholdLabel: WKInterfaceLabel!
    
    private var width = 1024
    @IBOutlet var widthButton: WKInterfaceButton?
    @IBAction func changeWidth() {
        presentNumberInputController(withDefault: width) {
            [weak self] in
            if $0 > 0 {
                self?.width = $0
                self?.widthButton?.setTitle("\($0)")
            }
        }
    }
    private var height = 1024
    @IBOutlet var heightButton: WKInterfaceButton?
    @IBAction func changeHeight() {
        presentNumberInputController(withDefault: height) {
            [weak self] in
            if $0 > 0 {
                self?.height = $0
                self?.heightButton?.setTitle("\($0)")
            }
        }
    }
    
    private var magnificationWidth = 9
    @IBOutlet var magnificationWidthButton: WKInterfaceButton?
    @IBAction func changeMagnificationWidth() {
        presentNumberInputController(withDefault: magnificationWidth) {
            [weak self] in
            if $0 > 0 {
                self?.magnificationWidth = $0
                self?.magnificationWidthButton?.setTitle("\($0)")
            }
        }
    }
    private var magnificationHeight = 9
    @IBOutlet var magnificationHeightButton: WKInterfaceButton?
    @IBAction func changeMagnificationHeight() {
        presentNumberInputController(withDefault: magnificationHeight) {
            [weak self] in
            if $0 > 0 {
                self?.magnificationHeight = $0
                self?.magnificationHeightButton?.setTitle("\($0)")
            }
        }
    }
    
    var backgroundColor: UIColor = .white
    @IBOutlet var backgroundColorPicker: WKInterfacePicker? {
        didSet {
            backgroundColorPicker?.setItems(Localized.Parameters.colors.map {
                let item = WKPickerItem()
                item.title = $0.name
                return item
            })
            backgroundColorPicker?.setSelectedItemIndex(1)
        }
    }
    @IBAction func pickedBackgroundColor(_ value: Int) {
        backgroundColor = Localized.Parameters.colors[value].color
    }
    
    var foregroundColor: UIColor = .black
    @IBOutlet var foregroundColorPicker: WKInterfacePicker? {
        didSet {
            foregroundColorPicker?.setItems(Localized.Parameters.colors.map {
                let item = WKPickerItem()
                item.title = $0.name
                return item
            })
        }
    }
    @IBAction func pickedForegroundColor(_ value: Int) {
        foregroundColor = Localized.Parameters.colors[value].color
    }
    
    var icon: UIImage? = nil
    @IBOutlet var iconPicker: WKInterfacePicker? {
        didSet {
            iconPicker?.setItems(([Localized.none] + Localized.Parameters.iconNames).map {
                let item = WKPickerItem()
                item.title = $0
                return item
            })
        }
    }
    @IBAction func pickedIcon(_ value: Int) {
        icon = [nil, "EyreFree", "GitHub", "Pikachu", "Swift"][value]
            .flatMap(UIImage.init(named:))
    }
    
    private var iconWidth = 128
    @IBOutlet var iconWidthButton: WKInterfaceButton?
    @IBAction func changeIconWidth() {
        presentNumberInputController(withDefault: iconWidth) {
            [weak self] in
            if $0 > 0 {
                self?.iconWidth = $0
                self?.iconWidthButton?.setTitle("\($0)")
            }
        }
    }
    private var iconHeight = 128
    @IBOutlet var iconHeightButton: WKInterfaceButton?
    @IBAction func changeIconHeight() {
        presentNumberInputController(withDefault: iconHeight) {
            [weak self] in
            if $0 > 0 {
                self?.iconHeight = $0
                self?.iconHeightButton?.setTitle("\($0)")
            }
        }
    }
    
    var watermark: EFImage? = nil
    @IBOutlet var watermarkPicker: WKInterfacePicker? {
        didSet {
            watermarkPicker?.setItems(([Localized.none] + Localized.Parameters.watermarkNames).map {
                let item = WKPickerItem()
                item.title = $0
                return item
            })
        }
    }
    @IBAction func pickedWatermark(_ value: Int) {
        watermark = [nil, "Beethoven", "Jobs", "Miku", "Wille", "WWF"][value]
            .flatMap(UIImage.init(named:))
            .map { .normal($0) }
    }
    
    private var watermarkMode = EFWatermarkMode.scaleAspectFill
    @IBOutlet var watermarkModePicker: WKInterfacePicker? {
        didSet {
            guard let picker = watermarkModePicker else {
                return
            }
            picker.setItems(Localized.Parameters.watermarkModeNames.map {
                let item = WKPickerItem()
                item.title = $0
                return item
            })
            picker.setSelectedItemIndex(2)
        }
    }
    @IBAction func pickedWatermarkMode(_ value: Int) {
        watermarkMode = EFWatermarkMode(rawValue: value) ?? watermarkMode
    }
    
    var foregroundPointOffset: CGFloat = 0
    let foregroundPointOffsets: [CGFloat] = [-0.5, -0.25, 0, 0.25, 0.5]
    @IBOutlet var foregroundPointOffsetPicker: WKInterfacePicker? {
        didSet {
            guard let picker = foregroundPointOffsetPicker else {
                return
            }
            picker.setItems(foregroundPointOffsets.map {
                let item = WKPickerItem()
                item.title = Localized.number($0)
                return item
            })
            picker.setSelectedItemIndex(2)
        }
    }
    @IBAction func pickedForegroundPointOffset(_ value: Int) {
        foregroundPointOffset = foregroundPointOffsets[value]
    }
    
    private var allowsTransparent = false
    @IBAction func allowTransparent(_ value: Bool) {
        allowsTransparent = value
    }
    
    private var binarizationThreshold: CGFloat = 0.5
    private let binarizationThresholds: [CGFloat] = [
        0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0
    ]
    @IBOutlet var binarizationThresholdPicker: WKInterfacePicker? {
        didSet {
            guard let picker = binarizationThresholdPicker else {
                return
            }
            picker.setItems(binarizationThresholds.map {
                let item = WKPickerItem()
                item.title = Localized.number($0)
                return item
            })
            picker.setSelectedItemIndex(5)
        }
    }
    @IBAction func pickedBinarizationThreshold(_ value: Int) {
        binarizationThreshold = binarizationThresholds[value]
    }
    
    private var pointShape = EFPointShape.square
    @IBOutlet var pointShapePicker: WKInterfacePicker! {
        didSet {
            guard let picker = pointShapePicker else {
                return
            }
            picker.setItems(Localized.Parameters.shapeNames.map {
                let item = WKPickerItem()
                item.title = $0
                return item
            })
        }
    }
    @IBAction func pickedPointShape(_ value: Int) {
        pointShape = EFPointShape(rawValue: value) ?? pointShape
    }

    private var ignoreTiming = false
    @IBAction func ignoreTiming(_ value: Bool) {
        ignoreTiming = value
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        ParametersInterfaceController.lastContent.value = link as NSString

        let generator = EFQRCodeGenerator(content: link, size: EFIntSize(width: width, height: height))
        generator.setInputCorrectionLevel(inputCorrectionLevel: correctionLevel)
        switch selectedMode {
        case .binarization:
            generator.setMode(mode: .binarization(threshold: binarizationThreshold))
        default:
            generator.setMode(mode: selectedMode)
        }
        generator.setMagnification(magnification: EFIntSize(width: magnificationWidth, height: magnificationHeight))
        generator.setColors(backgroundColor: backgroundColor.ef.cgColor, foregroundColor: foregroundColor.ef.cgColor)
        generator.setIcon(icon: icon?.ef.cgImage, size: EFIntSize(width: iconWidth, height: iconHeight))
        generator.setForegroundPointOffset(foregroundPointOffset: foregroundPointOffset)
        generator.setAllowTransparent(allowTransparent: allowsTransparent)
        generator.setPointShape(pointShape: pointShape)
        generator.setIgnoreTiming(ignoreTiming: ignoreTiming)
        
        switch watermark {
        case .gif(let data)?: // GIF
            // TODO: Confirm if possible to even have this case on watchOS
            generator.setWatermark(watermark: nil, mode: watermarkMode)
            if let afterData = EFQRCode.generateWithGIF(data: data, generator: generator) {
                return EFImage.gif(afterData)
            }
        case .normal(let uiImage)?:
            generator.setWatermark(watermark: uiImage.ef.cgImage, mode: watermarkMode)
            fallthrough // Other use UIImage
        case nil:
            if let tryCGImage = generator.generate() {
                return EFImage.normal(UIImage(cgImage: tryCGImage))
            }
        }
        return nil
    }
}
