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

class EFImage {
    private(set) var isGIF: Bool = false
    private(set) var data: Any?

    init() {

    }
    
    init?(_ image: UIImage?) {
        guard let data = image else {
            return nil
        }
        self.data = data
    }
    
    init?(_ data: Data?) {
        guard let data = data else {
            return nil
        }
        self.data = data
        self.isGIF = true
    }
}

class ParametersInterfaceController: WKInterfaceController {
    private var link = "https://github.com/EyreFree/EFQRCode"
    @IBOutlet var contentDisplay: WKInterfaceLabel!
    @IBAction func changeLink() {
        presentTextInputController(withSuggestions: [link], allowedInputMode: .plain) {
            [weak self] array in
            guard let inputs = array else {
                return
            }
            for input in inputs {
                if let str = input as? String {
                    self?.link = str
                    self?.contentDisplay?.setText(str)
                }
            }
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
            modePicker?.setItems(mode.map {
                let item = WKPickerItem()
                item.title = $0
                return item
            })
        }
    }
    @IBAction func pickedMode(_ value: Int) {
        selectedMode = EFQRCodeMode(rawValue: value) ?? selectedMode
    }
    
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
    
    let colorNames = [
        "Black", "White", "Gray", "Red", "Blue", "LPD", "Miku", "Wille",
        "Hearth Stone", "Pikachu Red", "3 Red", "Cee", "toto"
    ]
    let colors: [UIColor] = [
        .black, .white, .gray, .red, .blue, UIColor(
            red: 0 / 255.0, green: 139.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0
        ), UIColor(
            red: 57.0 / 255.0, green: 197.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0
        ), UIColor(
            red: 208.0 / 255.0, green: 34.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0
        ), UIColor(
            red: 125.0 / 255.0, green: 112.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0
        ), UIColor(
            red: 233.0 / 255.0, green: 77.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0
        ), UIColor(
            red: 132.0 / 255.0, green: 37.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0
        ), UIColor(
            red: 42.0 / 255.0, green: 42.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0
        ), UIColor(
            red: 41.0 / 255.0, green: 44.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0
        )
    ]
    
    var backgroundColor: UIColor = .white
    @IBOutlet var backgroundColorPicker: WKInterfacePicker? {
        didSet {
            backgroundColorPicker?.setItems(colorNames.map {
                let item = WKPickerItem()
                item.title = $0
                return item
            })
            backgroundColorPicker?.setSelectedItemIndex(1)
        }
    }
    @IBAction func pickedBackgroundColor(_ value: Int) {
        backgroundColor = colors[value]
    }
    
    var foregroundColor: UIColor = .black
    @IBOutlet var foregroundColorPicker: WKInterfacePicker? {
        didSet {
            foregroundColorPicker?.setItems(colorNames.map {
                let item = WKPickerItem()
                item.title = $0
                return item
            })
        }
    }
    @IBAction func pickedForegroundColor(_ value: Int) {
        foregroundColor = colors[value]
    }
    
    var icon: UIImage? = nil
    let icons = [nil, "EyreFree", "GitHub", "LPD", "Pikachu", "Swift"]
    @IBOutlet var iconPicker: WKInterfacePicker? {
        didSet {
            iconPicker?.setItems(icons.map {
                let item = WKPickerItem()
                item.title = $0 ?? "nil"
                return item
            })
        }
    }
    @IBAction func pickedIcon(_ value: Int) {
        if let name = icons[value] {
            icon = UIImage(named: name)
        } else {
            icon = nil
        }
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
    let watermarks = [nil, "Beethoven", "Jobs", "Miku", "Wille", "WWF"]
    @IBOutlet var watermarkPicker: WKInterfacePicker? {
        didSet {
            watermarkPicker?.setItems(watermarks.map {
                let item = WKPickerItem()
                item.title = $0 ?? "nil"
                return item
            })
        }
    }
    @IBAction func pickedWatermark(_ value: Int) {
        if let name = watermarks[value] {
            watermark = EFImage(UIImage(named: name))
        } else {
            watermark = nil
        }
    }
    
    private var watermarkMode = EFWatermarkMode.scaleAspectFill
    let watermarkModeString = [
        "scaleToFill", "scaleAspectFit", "scaleAspectFill", "center", "top", "bottom",
        "left", "right", "topLeft", "topRight", "bottomLeft", "bottomRight"
    ]
    @IBOutlet var watermarkModePicker: WKInterfacePicker? {
        didSet {
            guard let picker = watermarkModePicker else {
                return
            }
            picker.setItems(watermarkModeString.map {
                let item = WKPickerItem()
                item.title = "\($0)"
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
                item.title = "\($0)"
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
    private let binarizationThresholds: [CGFloat] = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0]
    @IBOutlet var binarizationThresholdPicker: WKInterfacePicker? {
        didSet {
            guard let picker = binarizationThresholdPicker else {
                return
            }
            picker.setItems(binarizationThresholds.map {
                let item = WKPickerItem()
                item.title = "\($0)"
                return item
            })
            picker.setSelectedItemIndex(5)
        }
    }
    @IBAction func pickedBinarizationThreshold(_ value: Int) {
        binarizationThreshold = binarizationThresholds[value]
    }
    
    private var isCircular = false
    @IBAction func prefersCircular(_ value: Bool) {
        isCircular = value
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        let generator = EFQRCodeGenerator(content: link, size: EFIntSize(width: width, height: height))
        generator.setInputCorrectionLevel(inputCorrectionLevel: correctionLevel)
        generator.setMode(mode: selectedMode)
        generator.setMagnification(magnification: EFIntSize(width: magnificationWidth, height: magnificationHeight))
        generator.setColors(backgroundColor: backgroundColor.toCGColor(), foregroundColor: foregroundColor.toCGColor())
        generator.setIcon(icon: icon?.toCGImage(), size: EFIntSize(width: iconWidth, height: iconHeight))
        generator.setForegroundPointOffset(foregroundPointOffset: foregroundPointOffset)
        generator.setAllowTransparent(allowTransparent: allowsTransparent)
        generator.setBinarizationThreshold(binarizationThreshold: binarizationThreshold)
        generator.setPointShape(pointShape: isCircular ? .circle : .square)
        
        if watermark?.isGIF == true, let data = watermark?.data as? Data {
            // GIF
            // TODO: Confirm if possible to even have this case on watchOS
            generator.setWatermark(watermark: nil, mode: watermarkMode)
            return EFImage(EFQRCode.generateWithGIF(data: data, generator: generator))
        } else {
            // Other use UIImage
            generator.setWatermark(watermark: (watermark?.data as? UIImage)?.toCGImage(), mode: watermarkMode)
            
            if let tryCGImage = generator.generate() {
                return  EFImage(UIImage(cgImage: tryCGImage))
            }
        }
        return nil
    }
}
