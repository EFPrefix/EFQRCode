//
//  GeneratorController.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/1/25.
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

import UIKit
import Photos
import EFQRCode
import MobileCoreServices

class EFImage {
    var isGIF: Bool = false
    var data: Any?

    init() {

    }

    init?(_ image: UIImage?) {
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

class GeneratorController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    #if os(iOS)
    var imagePicker: UIImagePickerController?
    #endif

    var textView: UITextView!
    var tableView: UITableView!
    var createButton: UIButton!

    var titleCurrent: String = ""

    // Param
    var inputCorrectionLevel = EFInputCorrectionLevel.h
    var size: EFIntSize = EFIntSize(width: 1024, height: 1024)
    var magnification: EFIntSize? = EFIntSize(width: 9, height: 9)
    var backColor = UIColor.white
    var frontColor = UIColor.black
    var icon: UIImage? = nil
    var iconSize: EFIntSize? = nil
    var watermarkMode = EFWatermarkMode.scaleAspectFill
    var mode: EFQRCodeMode = .none
    var binarizationThreshold: CGFloat = 0.5
    var pointShape: EFPointShape = .square
    var watermark: EFImage? = nil

    // MARK:- Not commonly used
    var foregroundPointOffset: CGFloat = 0
    var allowTransparent: Bool = true

    // Test data
    struct colorData {
        var color: UIColor
        var name: String
    }
    var colorList = [colorData]()
}

extension GeneratorController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Create"
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)

        setupViews()
    }

    func setupViews() {
        let buttonHeight: CGFloat = 46

        // Add test data
        let colorNameArray = [
            "Black", "White", "Gray", "Red", "Blue", "LPD", "Miku", "Wille",
            "Hearth Stone", "Pikachu Red", "3 Red", "Cee", "toto"
        ]
        let colorArray = [
            UIColor.black, UIColor.white, UIColor.gray, UIColor.red, UIColor.blue, UIColor(
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
        for (index, colorName) in colorNameArray.enumerated() {
            colorList.append(GeneratorController.colorData(color: colorArray[index], name: colorName))
        }

        // Content
        textView = UITextView()
        textView.text = "https://github.com/EyreFree/EFQRCode"
        textView.tintColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.32)
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.delegate = self
        textView.returnKeyType = .done
        self.view.addSubview(textView)
        textView.snp.makeConstraints {
            (make) in
            make.left.equalTo(10)
            make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 15)
            make.width.equalTo(self.view).offset(-20)
            make.height.equalTo(self.view).dividedBy(3.0)
        }

        // tableView
        tableView = UITableView()
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        #if os(iOS)
            tableView.separatorColor = UIColor.white
        #endif
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            (make) in
            make.left.equalTo(0)
            make.top.equalTo(textView.snp.bottom)
            make.width.equalTo(self.view)
        }

        createButton = UIButton(type: .system)
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(
            UIColor(red: 246.0 / 255.0, green: 137.0 / 255.0, blue: 222.0 / 255.0, alpha: 1), for: .normal
        )
        createButton.layer.borderColor = UIColor.white.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.cornerRadius = 5
        createButton.layer.masksToBounds = true
        #if os(iOS)
            createButton.addTarget(self, action: #selector(GeneratorController.createCode), for: .touchDown)
        #else
            createButton.addTarget(self, action: #selector(GeneratorController.createCode), for: .primaryActionTriggered)
        #endif
        self.view.addSubview(createButton)
        createButton.snp.makeConstraints {
            (make) in
            make.left.equalTo(10)
            make.top.equalTo(tableView.snp.bottom)
            make.width.equalTo(self.view).offset(-20)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(-10)
        }
    }

    func refresh() {
        tableView.reloadData()
    }

    @objc func createCode() {
        // Lock user activity
        createButton.isEnabled = false

        var content = ""
        if !(nil == textView.text || textView.text == "") {
            content = textView.text
        }

        let generator = EFQRCodeGenerator(content: content, size: size)
        generator.setInputCorrectionLevel(inputCorrectionLevel: inputCorrectionLevel)
        generator.setMode(mode: mode)
        generator.setMagnification(magnification: magnification)
        generator.setColors(backgroundColor: CIColor(color: backColor), foregroundColor: CIColor(color: frontColor))
        generator.setIcon(icon: UIImage2CGimage(icon), size: iconSize)
        generator.setForegroundPointOffset(foregroundPointOffset: foregroundPointOffset)
        generator.setAllowTransparent(allowTransparent: allowTransparent)
        generator.setBinarizationThreshold(binarizationThreshold: binarizationThreshold)
        generator.setPointShape(pointShape: pointShape)

        if watermark?.isGIF == true, let data = watermark?.data as? Data {
            // GIF
            generator.setWatermark(watermark: nil, mode: watermarkMode)

            if let afterData = EFQRCode.generateWithGIF(data: data, generator: generator) {
                self.present(ShowController(image: EFImage(afterData)), animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Warning", message: "Create QRCode failed!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            // Other use UIImage
            generator.setWatermark(watermark: UIImage2CGimage(watermark?.data as? UIImage), mode: watermarkMode)

            if let tryCGImage = generator.generate() {
                let tryImage = UIImage(cgImage: tryCGImage)
                self.present(ShowController(image: EFImage(tryImage)), animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Warning", message: "Create QRCode failed!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

        // Recove user activity
        createButton.isEnabled = true
    }

    // UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //键盘提交
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func chooseInputCorrectionLevel() {
        let alert = UIAlertController(
            title: "InputCorrectionLevel",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        for (index, level) in ["l", "m", "q", "h"].enumerated() {
            alert.addAction(
                UIAlertAction(title: level, style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.inputCorrectionLevel = EFInputCorrectionLevel(rawValue: index)!
                        strongSelf.refresh()
                    }
                })
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseSize() {
        let alert = UIAlertController(
            title: "Size", message: nil, preferredStyle: .alert
        )
        alert.addTextField {
            [weak self] (textField) in
            if let strongSelf = self {
                textField.placeholder = "Width"
                textField.text = "\(strongSelf.size.width)"
            }
        }
        alert.addTextField {
            [weak self] (textField) in
            if let strongSelf = self {
                textField.placeholder = "Height"
                textField.text = "\(strongSelf.size.height)"
            }
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
            if let strongSelf = self {
                if let widthString = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                    let heightString = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if let width = Int(widthString), let height = Int(heightString), 0 < width, 0 < height {
                        strongSelf.size = EFIntSize(width: width, height: height)
                        strongSelf.refresh()
                        return
                    }
                }
                let alert = UIAlertController(title: "Warning", message: "Illegal input size!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }

    func chooseMagnification() {
        func customInput() {
            let alert = UIAlertController(
                title: "Magnification", message: nil, preferredStyle: .alert
            )
            alert.addTextField {
                [weak self] (textField) in
                if let strongSelf = self {
                    textField.placeholder = "Width"
                    textField.text = strongSelf.magnification == nil ? "" : "\(strongSelf.magnification?.width ?? 0)"
                }
            }
            alert.addTextField {
                [weak self] (textField) in
                if let strongSelf = self {
                    textField.placeholder = "Height"
                    textField.text = strongSelf.magnification == nil ? "" : "\(strongSelf.magnification?.height ?? 0)"
                }
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
                if let strongSelf = self {
                    if let widthString = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                        let heightString = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                        if let width = Int(widthString), let height = Int(heightString), 0 < width, 0 < height {
                            strongSelf.magnification = EFIntSize(width: width, height: height)
                            strongSelf.refresh()
                            return
                        }
                    }
                    let alert = UIAlertController(
                        title: "Warning", message: "Illegal input magnification!", preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }

        let alert = UIAlertController(
            title: "Magnification",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        alert.addAction(
            UIAlertAction(title: "nil", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.magnification = nil
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "\(9)x\(9)", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.magnification = EFIntSize(width: 9, height: 9)
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "custom", style: .default, handler: {
                [weak self] (action) -> Void in
                if let _ = self {
                    customInput()
                }
            })
        )
        popActionSheet(alert: alert)
    }

    func chooseBackColor() {
        let alert = UIAlertController(
            title: "BackColor",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        #if os(iOS)
            alert.addAction(
                UIAlertAction(title: "Custom", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.customColor(0)
                    }
                })
            )
        #endif
        for color in colorList {
            alert.addAction(
                UIAlertAction(title: color.name, style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.backColor = color.color
                        strongSelf.refresh()
                    }
                })
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseFrontColor() {
        let alert = UIAlertController(
            title: "FrontColor",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        #if os(iOS)
            alert.addAction(
                UIAlertAction(title: "Custom", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.customColor(1)
                    }
                })
            )
        #endif
        if let tryWaterMark = watermark?.data as? UIImage {
            alert.addAction(
                UIAlertAction(title: "Average of watermark", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.frontColor = tryWaterMark.avarageColor() ?? UIColor.black
                        strongSelf.refresh()
                    }
                })
            )
            alert.addAction(
                UIAlertAction(title: "Average of watermark (Dacker)", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        var xxxColor = tryWaterMark.avarageColor() ?? UIColor.black
                        if let coms = xxxColor.cgColor.components {
                            let r = (CGFloat(coms[0]) + 0) / 2.0
                            let g = (CGFloat(coms[1]) + 0) / 2.0
                            let b = (CGFloat(coms[2]) + 0) / 2.0
                            let a = (CGFloat(coms[3]) + 1) / 2.0
                            xxxColor = UIColor(red: r, green: g, blue: b, alpha: a)
                        }
                        strongSelf.frontColor = xxxColor
                        strongSelf.refresh()
                    }
                })
            )
        }
        for color in colorList {
            alert.addAction(
                UIAlertAction(title: color.name, style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.frontColor = color.color
                        strongSelf.refresh()
                    }
                })
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseIcon() {
        let alert = UIAlertController(
            title: "Icon",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        alert.addAction(
            UIAlertAction(title: "nil", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.icon = nil
                    strongSelf.refresh()
                }
            })
        )
        #if os(iOS)
            alert.addAction(
                UIAlertAction(title: "Select from system album", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.chooseImageFromAlbum(title: "icon")
                        strongSelf.refresh()
                    }
                })
            )
        #endif
        for icon in ["EyreFree", "GitHub", "LPD", "Pikachu", "Swift"] {
            alert.addAction(
                UIAlertAction(title: icon, style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.icon = UIImage(named: icon)
                        strongSelf.refresh()
                    }
                })
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseIconSize() {
        func customInput() {
            let alert = UIAlertController(
                title: "IconSize", message: nil, preferredStyle: .alert
            )
            alert.addTextField {
                [weak self] (textField) in
                if let strongSelf = self {
                    textField.placeholder = "Width"
                    textField.text = strongSelf.iconSize == nil ? "" : "\(strongSelf.iconSize?.width ?? 0)"
                }
            }
            alert.addTextField {
                [weak self] (textField) in
                if let strongSelf = self {
                    textField.placeholder = "Height"
                    textField.text = strongSelf.iconSize == nil ? "" : "\(strongSelf.iconSize?.height ?? 0)"
                }
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
                if let strongSelf = self {
                    if let widthString = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                        let heightString = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                        if let width = Int(widthString), let height = Int(heightString), 0 < width, 0 < height {
                            strongSelf.iconSize = EFIntSize(width: width, height: height)
                            strongSelf.refresh()
                            return
                        }
                    }
                    let alert = UIAlertController(
                        title: "Warning", message: "Illegal input iconSize!", preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }

        let alert = UIAlertController(
            title: "IconSize",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        alert.addAction(
            UIAlertAction(title: "nil", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.iconSize = nil
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "\(128)x\(128)", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.iconSize = EFIntSize(width: 128, height: 128)
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "custom", style: .default, handler: {
                [weak self] (action) -> Void in
                if let _ = self {
                    customInput()
                }
            })
        )
        popActionSheet(alert: alert)
    }

    func chooseWatermark() {
        let alert = UIAlertController(
            title: "Watermark",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        alert.addAction(
            UIAlertAction(title: "nil", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermark = nil
                    strongSelf.refresh()
                }
            })
        )
        #if os(iOS)
            alert.addAction(
                UIAlertAction(title: "Select from system album", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.chooseImageFromAlbum(title: "watermark")
                        strongSelf.refresh()
                    }
                })
            )
        #endif
        for watermark in ["Beethoven", "Jobs", "Miku", "Wille", "WWF"] {
            alert.addAction(
                UIAlertAction(title: watermark, style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.watermark = EFImage(UIImage(named: watermark))
                        strongSelf.refresh()
                    }
                })
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseWatermarkMode() {
        let alert = UIAlertController(
            title: "WatermarkMode",
            message: nil,
            preferredStyle: .actionSheet
        )

        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )

        let modeNameArray = [
            "scaleToFill", "scaleAspectFit", "scaleAspectFill", "center",
            "top", "bottom", "left", "right",
            "topLeft", "topRight", "bottomLeft", "bottomRight"
        ]
        for (index, modeName) in modeNameArray.enumerated() {
            alert.addAction(
                UIAlertAction(title: modeName, style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        if let mode = EFWatermarkMode(rawValue: index) {
                            strongSelf.watermarkMode = mode
                        }
                        strongSelf.refresh()
                    }
                })
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseForegroundPointOffset() {
        let alert = UIAlertController(
            title: "ForegroundPointOffset",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        alert.addAction(
            UIAlertAction(title: "nil", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.magnification = nil
                    strongSelf.refresh()
                }
            })
        )
        for foregroundPointOffset in [-0.5, -0.25, CGFloat(0), 0.25, 0.5] {
            alert.addAction(
                UIAlertAction(title: "\(foregroundPointOffset)", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.foregroundPointOffset = foregroundPointOffset
                        strongSelf.refresh()
                    }
                })
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseBinarizationThreshold() {
        let alert = UIAlertController(
            title: "binarizationThreshold",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        for binarizationThreshold in [CGFloat(0), 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0] {
            alert.addAction(
                UIAlertAction(title: "\(binarizationThreshold)", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.binarizationThreshold = binarizationThreshold
                        strongSelf.refresh()
                    }
                })
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseMode() {
        let alert = UIAlertController(
            title: "mode",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )

        let modeNameArray = [
            "none", "grayscale", "binarization"
        ]
        for (index, modeName) in modeNameArray.enumerated() {
            alert.addAction(
                UIAlertAction(title: modeName, style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        if let mode = EFQRCodeMode(rawValue: index) {
                            strongSelf.mode = mode
                        }
                        strongSelf.refresh()
                    }
                })
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseShape() {
        let alert = UIAlertController(
            title: "pointShape",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )

        let shapeNameArray = [
            "square", "circle"
        ]
        for (index, shapeName) in shapeNameArray.enumerated() {
            alert.addAction(
                UIAlertAction(title: shapeName, style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        if let shape = EFPointShape(rawValue: index) {
                            strongSelf.pointShape = shape
                        }
                        strongSelf.refresh()
                    }
                })
            )
        }
        popActionSheet(alert: alert)
    }

    func popActionSheet(alert: UIAlertController) {
        //阻止 iPad Crash
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(
            x: self.view.bounds.size.width / 2.0,
            y: self.view.bounds.size.height / 2.0,
            width: 1.0, height: 1.0
        )
        self.present(alert, animated: true, completion: nil)
    }

    func chooseAllowTransparent() {
        let alert = UIAlertController(
            title: "AllowTransparent",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        alert.addAction(
            UIAlertAction(title: "True", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.allowTransparent = true
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "False", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.allowTransparent = false
                    strongSelf.refresh()
                }
            })
        )
        self.present(alert, animated: true, completion: nil)
    }

    // UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        [chooseInputCorrectionLevel, chooseMode, chooseSize, chooseMagnification,
         chooseBackColor, chooseFrontColor, chooseIcon, chooseIconSize,
         chooseWatermark, chooseWatermarkMode, chooseForegroundPointOffset, chooseAllowTransparent,
         chooseBinarizationThreshold, chooseShape][indexPath.row]()

        if 8 == indexPath.row {
            self.refresh()
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if 8 == indexPath.row {
            self.refresh()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.zeroHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.zeroHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleArray = [
            "inputCorrectionLevel", "mode", "size", "magnification",
            "backgroundColor", "foregroundColor", "icon", "iconSize",
            "watermark", "watermarkMode", "foregroundPointOffset", "allowTransparent", "binarizationThreshold",
            "pointShape"
        ]
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

        let cell = UITableViewCell(style: detailArray[indexPath.row] == "" ? .default : .value1, reuseIdentifier: nil)
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.detailTextLabel?.text = detailArray[indexPath.row]
        let backView = UIView()
        backView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.64)
        cell.selectedBackgroundView = backView

        if detailArray[indexPath.row] == "" {
            let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            rightImageView.contentMode = .scaleAspectFit
            rightImageView.layer.borderColor = UIColor.white.cgColor
            rightImageView.layer.borderWidth = 0.5
            cell.contentView.addSubview(rightImageView)
            cell.accessoryView = rightImageView

            switch indexPath.row {
            case 4:
                rightImageView.backgroundColor = backColor
            case 5:
                rightImageView.backgroundColor = frontColor
            case 6:
                rightImageView.image = icon
            case 8:
                rightImageView.stopAnimating()
                if watermark?.isGIF == true {
                    if let dataGIF = watermark?.data as? Data {
                        if let source = CGImageSourceCreateWithData(dataGIF as CFData, nil) {
                            var images = [UIImage]()
                            for cgImage in source.toCGImages() {
                                images.append(UIImage(cgImage: cgImage))
                            }
                            rightImageView.animationImages = images
                            rightImageView.startAnimating()
                        }
                    }
                } else {
                    rightImageView.image = watermark?.data as? UIImage
                }
            default:
                break
            }
        }
        return cell
    }
}

#if os(iOS)
    // EFColorPicker
    extension GeneratorController: UIPopoverPresentationControllerDelegate, EFColorSelectionViewControllerDelegate {

        struct EFColorPicker {
            static var isFront = false
        }

        func customColor(_ isFront: Int) {

            EFColorPicker.isFront = isFront == 1

            let colorSelectionController = EFColorSelectionViewController()
            let navCtrl = UINavigationController(rootViewController: colorSelectionController)
            navCtrl.navigationBar.backgroundColor = UIColor.white
            navCtrl.navigationBar.isTranslucent = false
            navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
            navCtrl.popoverPresentationController?.delegate = self
            navCtrl.popoverPresentationController?.sourceView = tableView
            navCtrl.popoverPresentationController?.sourceRect = tableView.bounds
            navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
                UILayoutFittingCompressedSize
            )

            colorSelectionController.isColorTextFieldHidden = false
            colorSelectionController.delegate = self
            colorSelectionController.color = EFColorPicker.isFront ?  self.frontColor : self.backColor

            if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
                let doneBtn: UIBarButtonItem = UIBarButtonItem(
                    title: NSLocalizedString("Done", comment: ""),
                    style: UIBarButtonItemStyle.done,
                    target: self,
                    action: #selector(ef_dismissViewController(sender:))
                )
                colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
            }
            self.present(navCtrl, animated: true, completion: nil)
        }

        // EFColorViewDelegate
        func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
            if EFColorPicker.isFront {
                self.frontColor = color
            } else {
                self.backColor = color
            }
            self.refresh()
        }

        // Private
        @objc private func ef_dismissViewController(sender: UIBarButtonItem) {
            self.dismiss(animated: true, completion: nil)
            self.refresh()
        }
    }
#endif

#if os(iOS)
    extension GeneratorController: UIImagePickerControllerDelegate {

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

            var finalImage: UIImage?
            if let tryImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                finalImage = tryImage
            } else if let tryImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                finalImage = tryImage
            } else{
                print("Something wrong")
            }

            switch titleCurrent {
            case "watermark":
                self.watermark = EFImage(finalImage)

                var images = [EFImage]()
                if let imageUrl = info[UIImagePickerControllerReferenceURL] as? URL {
                    if let asset = PHAsset.fetchAssets(withALAssetURLs: [imageUrl], options: nil).lastObject {
                        images = selectedAlbumPhotosIncludingGifWithPHAssets(assets: [asset])
                    }
                }
                if let tryGIF = images.first {
                    if tryGIF.isGIF == true {
                        watermark = tryGIF
                    }
                }
            case "icon":
                self.icon = finalImage
            default:
                break
            }
            self.refresh()

            picker.dismiss(animated: true, completion: nil)
        }


        // 选择相册图片（包括 GIF 图片）
        // http://www.jianshu.com/p/ad391f4d0bcb
        func selectedAlbumPhotosIncludingGifWithPHAssets(assets: [PHAsset]) -> [EFImage] {
            var imageArray = [EFImage]()

            let targetSize: CGSize = CGSize(width: 1024, height: 1024)

            let options: PHImageRequestOptions = PHImageRequestOptions()
            options.resizeMode = PHImageRequestOptionsResizeMode.fast
            options.isSynchronous = true

            let imageManager: PHCachingImageManager = PHCachingImageManager()
            for asset in assets {
                imageManager.requestImageData(for: asset, options: options, resultHandler: {
                    [weak self] (imageData, dataUTI, orientation, info) in
                    if let _ = self {
                        print("dataUTI: \(dataUTI ?? "")")

                        let imageElement = EFImage()

                        // GIF
                        if kUTTypeGIF as String == dataUTI {
                            imageElement.isGIF = true

                            if nil != imageData {
                                imageElement.data = imageData
                            }
                        } else {
                            imageElement.isGIF = false

                            // 其他格式的图片，直接请求压缩后的图片
                            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: {
                                [weak self] (result, info) in
                                if let _ = self {
                                    // 得到一张 UIImage，展示到界面上
                                    if let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool {
                                        if !isDegraded {
                                            imageElement.data = result
                                        }
                                    }
                                }
                            })
                        }

                        imageArray.append(imageElement)
                    }
                })
            }
            return imageArray
        }

        func chooseImageFromAlbum(title: String) {
            titleCurrent = title

            if let tryPicker = imagePicker {
                self.present(tryPicker, animated: true, completion: nil)
            } else {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = false
                imagePicker = picker

                self.present(picker, animated: true, completion: nil)
            }
        }
    }
#endif

class ShowController: UIViewController {

    var image: EFImage?

    init(image: EFImage?) {
        super.init(nibName: nil, bundle: nil)

        self.image = image
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)
        setupViews()
    }

    func setupViews() {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.64)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        self.view.addSubview(imageView)
        if self.image?.isGIF == true {
            if let dataGIF = self.image?.data as? Data {
                if let source = CGImageSourceCreateWithData(dataGIF as CFData, nil) {
                    var images = [UIImage]()
                    for cgImage in source.toCGImages() {
                        images.append(UIImage(cgImage: cgImage))
                    }
                    imageView.animationImages = images
                    imageView.startAnimating()
                }
            }
        } else {
            imageView.image = self.image?.data as? UIImage
        }

        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 5
        backButton.layer.masksToBounds = true
        self.view.addSubview(backButton)

        #if os(iOS)
            let saveButton = UIButton(type: .system)
            saveButton.setTitle("Save", for: .normal)
            saveButton.setTitleColor(UIColor.white, for: .normal)
            saveButton.layer.borderColor = UIColor.white.cgColor
            saveButton.layer.borderWidth = 1
            saveButton.layer.cornerRadius = 5
            saveButton.layer.masksToBounds = true
            self.view.addSubview(saveButton)

            imageView.snp.makeConstraints {
                (make) in
                make.left.equalTo(10)
                make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 15)
                make.width.equalTo(self.view).offset(-20)
                make.height.lessThanOrEqualTo(self.view.snp.width).offset(-20)
                make.height.lessThanOrEqualTo(self.view.snp.height).offset(-20-46-46-60)
            }

            saveButton.addTarget(self, action: #selector(ShowController.saveToAlbum), for: .touchDown)
            saveButton.snp.makeConstraints {
                (make) in
                make.left.equalTo(10)
                make.top.equalTo(imageView.snp.bottom).offset(10)
                make.width.equalTo(self.view).offset(-20)
                make.height.equalTo(46)
            }

            backButton.addTarget(self, action: #selector(ShowController.back), for: .touchDown)
            backButton.snp.makeConstraints {
                (make) in
                make.left.equalTo(10)
                make.top.equalTo(saveButton.snp.bottom).offset(10)
                make.width.equalTo(self.view).offset(-20)
                make.height.equalTo(46)
            }
        #else
            imageView.snp.makeConstraints {
                (make) in
                make.left.equalTo(10)
                make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 15)
                make.width.equalTo(self.view).offset(-20)
                make.height.lessThanOrEqualTo(self.view.snp.width).offset(-20)
                make.height.lessThanOrEqualTo(self.view.snp.height).offset(-20-46-60)
            }

            backButton.addTarget(self, action: #selector(ShowController.back), for: .primaryActionTriggered)
            backButton.snp.makeConstraints {
                (make) in
                make.left.equalTo(10)
                make.top.equalTo(imageView.snp.bottom).offset(10)
                make.width.equalTo(self.view).offset(-20)
                make.height.equalTo(46)
            }
        #endif
    }

    #if os(iOS)
    @objc func saveToAlbum() {
        if let tryImage = image {
            CustomPhotoAlbum.sharedInstance.save(image: tryImage) {
                [weak self] (result) in
                if let strongSelf = self {
                    let alert = UIAlertController(
                        title: result == nil ? "Success" : "Error",
                        message: result ?? "Save finished.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    #endif

    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
}

#if os(iOS)
    // http://stackoverflow.com/questions/28708846/how-to-save-image-to-custom-album
    class CustomPhotoAlbum: NSObject {

        static let albumName = "EFQRCode"
        static let sharedInstance = CustomPhotoAlbum()

        var assetCollection: PHAssetCollection!

        override init() {
            super.init()

            if let assetCollection = fetchAssetCollectionForAlbum() {
                self.assetCollection = assetCollection
                return
            }

            if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
                PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                    ()
                })
            }

            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
                self.createAlbum()
            } else {
                PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
            }
        }

        func requestAuthorizationHandler(status: PHAuthorizationStatus) {
            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
                // Ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
                print("Trying again to create the album")
                self.createAlbum()
            } else {
                print("Should really prompt the user to let them know it's failed")
            }
        }

        func createAlbum() {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)
                // Create an asset collection with the album name
            }) { success, error in
                if success {
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                } else {
                    if let tryError = error {
                        print("Error: \(tryError)")
                    }
                }
            }
        }

        func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title=%@", CustomPhotoAlbum.albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

            if let _: AnyObject = collection.firstObject {
                return collection.firstObject
            }
            return nil
        }

        func save(image: EFImage, finish: ((String?) -> Void)? = nil) {
            if assetCollection == nil {
                // If there was an error upstream, skip the save
                finish?("AssetCollection is nil!")
                return
            }

            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                if let strongSelf = self {
                    var assetChangeRequest: PHAssetChangeRequest?
                    if image.isGIF == true {
                        guard let fileURL = EFQRCode.tempResultPath else {
                            finish?("EFQRCode.tempResultPath is nil!")
                            return
                        }
                        assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                    } else {
                        if let image = image.data as? UIImage {
                            assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                        }
                    }
                    if let assetPlaceHolder = assetChangeRequest?.placeholderForCreatedAsset {
                        let albumChangeRequest = PHAssetCollectionChangeRequest(for: strongSelf.assetCollection)
                        let enumeration: NSArray = [assetPlaceHolder]
                        albumChangeRequest?.addAssets(enumeration)
                    } else {
                        finish?("PlaceholderForCreatedAsset is nil!")
                    }
                }
            }, completionHandler: {
                [weak self] (result, error) in
                if let _ = self {
                    if result {
                        finish?(nil)
                    } else {
                        finish?(error?.localizedDescription ?? "")
                    }
                }
            })
        }
    }
#endif
