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

enum EFImage {
    case normal(_ image: UIImage)
    case gif(_ data: Data)
    
    var isGIF: Bool {
        switch self {
        case .normal: return false
        case .gif: return true
        }
    }
}

final class Ref<Wrapped> {
    var value: Wrapped
    init(_ value: Wrapped) {
        self.value = value
    }
}

extension Ref: ExpressibleByNilLiteral where Wrapped: ExpressibleByNilLiteral {
    convenience init(nilLiteral: ()) {
        self.init(nil)
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
    let lastContent = StorageUserDefaults<NSString>(key: "lastContent")

    // MARK: - Param
    var inputCorrectionLevel = EFInputCorrectionLevel.h
    var size = EFIntSize(width: 1024, height: 1024)
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

    // MARK: Not commonly used
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

        title = "Create"
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)

        setupViews()
    }

    func setupViews() {
        let buttonHeight: CGFloat = 46

        // MARK: Add test data
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

        // MARK: Content
        textView = UITextView()
        textView.text = (lastContent.value as String?) ?? "https://github.com/EFPrefix/EFQRCode"
        textView.tintColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)
        textView.font = .systemFont(ofSize: 24)
        textView.textColor = .white
        textView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.32)
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.delegate = self
        textView.returnKeyType = .done
        view.addSubview(textView)
        textView.snp.makeConstraints {
            (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(view).offset(-10)
            make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 15)
            make.height.equalTo(view).dividedBy(3.0)
        }

        // MARK: tableView
        tableView = UITableView()
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        #if os(iOS)
        tableView.separatorColor = .white
        #endif
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            (make) in
            make.leading.equalTo(0)
            make.top.equalTo(textView.snp.bottom)
            make.width.equalTo(view)
        }

        createButton = UIButton(type: .system)
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(
            UIColor(red: 246.0 / 255.0, green: 137.0 / 255.0, blue: 222.0 / 255.0, alpha: 1), for: .normal
        )
        createButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.32)
        createButton.layer.borderColor = UIColor.white.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.cornerRadius = 5
        createButton.layer.masksToBounds = true
        #if os(iOS)
        createButton.addTarget(self, action: #selector(createCode), for: .touchDown)
        #else
        createButton.addTarget(self, action: #selector(createCode), for: .primaryActionTriggered)
        #endif
        view.addSubview(createButton)
        createButton.snp.makeConstraints {
            (make) in
            make.leading.trailing.equalTo(textView)
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(-10)
        }
    }

    #if os(iOS)
    override func viewWillLayoutSubviews() {
        textView.snp.updateConstraints {
            (make) in
            make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 15)
            if #available(iOS 11.0, *) {
                make.leading.equalTo(max(view.safeAreaInsets.left, 10))
                make.trailing.equalTo(view).offset(-max(view.safeAreaInsets.right, 10))
            }
        }
        if #available(iOS 11.0, *) {
            createButton.snp.updateConstraints {
                (make) in
                make.bottom.equalTo(-max(10, view.safeAreaInsets.bottom))
            }
        }
        super.viewWillLayoutSubviews()
    }
    #endif

    func refresh() {
        tableView.reloadData()
    }

    @objc func createCode() {
        // Lock user activity
        createButton.isEnabled = false
        // Recove user activity
        defer { createButton.isEnabled = true }

        let content = textView.text ?? ""
        lastContent.value = content as NSString

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

        switch watermark {
        case .gif(let data)?: // GIF
            generator.setWatermark(watermark: nil, mode: watermarkMode)
            
            if let afterData = EFQRCode.generateWithGIF(data: data, generator: generator) {
                present(ShowController(image: .gif(afterData)), animated: true)
            } else {
                let alert = UIAlertController(title: "Warning", message: "Create QRCode failed!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
            }
        case .normal(let image)?:
            generator.setWatermark(watermark: UIImage2CGimage(image), mode: watermarkMode)
            fallthrough // Other use UIImage
        case nil:
            if let tryCGImage = generator.generate() {
                let tryImage = UIImage(cgImage: tryCGImage)
                present(ShowController(image: .normal(tryImage)), animated: true)
            } else {
                let alert = UIAlertController(title: "Warning", message: "Create QRCode failed!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
            }
        }
    }

    // UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 键盘提交
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
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        for (index, level) in ["l", "m", "q", "h"].enumerated() {
            alert.addAction(
                UIAlertAction(title: level, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.inputCorrectionLevel = EFInputCorrectionLevel(rawValue: index)!
                    self.refresh()
                }
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
            guard let self = self else { return }
            textField.placeholder = "Width"
            textField.text = "\(self.size.width)"
        }
        alert.addTextField {
            [weak self] (textField) in
            guard let self = self else { return }
            textField.placeholder = "Height"
            textField.text = "\(self.size.height)"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self] _ in
            guard let self = self else { return }
            if let widthString = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                let heightString = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                let width = Int(widthString),
                let height = Int(heightString),
                0 < width, 0 < height {
                self.size = EFIntSize(width: width, height: height)
                self.refresh()
                return
            }
            let alert = UIAlertController(title: "Warning", message: "Illegal input size!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    func chooseMagnification() {
        func customInput() {
            let alert = UIAlertController(
                title: "Magnification", message: nil, preferredStyle: .alert
            )
            alert.addTextField {
                [weak self] (textField) in
                guard let self = self else { return }
                textField.placeholder = "Width"
                textField.text = self.magnification == nil ? "" : "\(self.magnification?.width ?? 0)"
            }
            alert.addTextField {
                [weak self] (textField) in
                guard let self = self else { return }
                textField.placeholder = "Height"
                textField.text = self.magnification == nil ? "" : "\(self.magnification?.height ?? 0)"
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                if let widthString = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                    let heightString = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                    let width = Int(widthString),
                    let height = Int(heightString),
                    0 < width, 0 < height {
                    self.magnification = EFIntSize(width: width, height: height)
                    self.refresh()
                    return
                }
                let alert = UIAlertController(
                    title: "Warning", message: "Illegal input magnification!", preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }

        let alert = UIAlertController(
            title: "Magnification",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        alert.addAction(
            UIAlertAction(title: "nil", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.magnification = nil
                self.refresh()
            }
        )
        alert.addAction(
            UIAlertAction(title: "\(9)x\(9)", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.magnification = EFIntSize(width: 9, height: 9)
                self.refresh()
            }
        )
        alert.addAction(
            UIAlertAction(title: "custom", style: .default) {
                [weak self] _ in
                if self != nil {
                    customInput()
                }
            }
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
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        #if os(iOS)
        alert.addAction(
            UIAlertAction(title: "Custom", style: .default) {
                [weak self] _ in
                self?.customColor(0)
            }
        )
        #endif
        for color in colorList {
            alert.addAction(
                UIAlertAction(title: color.name, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.backColor = color.color
                    self.refresh()
                }
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
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        #if os(iOS)
        alert.addAction(
            UIAlertAction(title: "Custom", style: .default) {
                [weak self] _ in
                self?.customColor(1)
            }
        )
        #endif
        if case let .normal(tryWaterMark)? = watermark {
            alert.addAction(
                UIAlertAction(title: "Average of watermark", style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.frontColor = tryWaterMark.avarageColor() ?? .black
                    self.refresh()
                }
            )
            alert.addAction(
                UIAlertAction(title: "Average of watermark (Dacker)", style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    var xxxColor = tryWaterMark.avarageColor() ?? .black
                    if let coms = xxxColor.cgColor.components {
                        let r = (CGFloat(coms[0]) + 0) / 2.0
                        let g = (CGFloat(coms[1]) + 0) / 2.0
                        let b = (CGFloat(coms[2]) + 0) / 2.0
                        let a = (CGFloat(coms[3]) + 1) / 2.0
                        xxxColor = UIColor(red: r, green: g, blue: b, alpha: a)
                    }
                    self.frontColor = xxxColor
                    self.refresh()
                }
            )
        }
        for color in colorList {
            alert.addAction(
                UIAlertAction(title: color.name, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.frontColor = color.color
                    self.refresh()
                }
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
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        alert.addAction(
            UIAlertAction(title: "nil", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.icon = nil
                self.refresh()
            }
        )
        #if os(iOS)
        alert.addAction(
            UIAlertAction(title: "Select from system album", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.chooseImageFromAlbum(title: "icon")
                self.refresh()
            }
        )
        #endif
        for icon in ["EyreFree", "GitHub", "LPD", "Pikachu", "Swift"] {
            alert.addAction(
                UIAlertAction(title: icon, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.icon = UIImage(named: icon)
                    self.refresh()
                }
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
                guard let self = self else { return }
                textField.placeholder = "Width"
                textField.text = self.iconSize == nil ? "" : "\(self.iconSize?.width ?? 0)"
            }
            alert.addTextField {
                [weak self] (textField) in
                guard let self = self else { return }
                textField.placeholder = "Height"
                textField.text = self.iconSize == nil ? "" : "\(self.iconSize?.height ?? 0)"
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                if let widthString = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                    let heightString = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                    let width = Int(widthString),
                    let height = Int(heightString),
                    0 < width, 0 < height {
                    self.iconSize = EFIntSize(width: width, height: height)
                    self.refresh()
                    return
                }
                let alert = UIAlertController(
                    title: "Warning", message: "Illegal input iconSize!", preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }

        let alert = UIAlertController(
            title: "IconSize",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        alert.addAction(
            UIAlertAction(title: "nil", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.iconSize = nil
                self.refresh()
            }
        )
        alert.addAction(
            UIAlertAction(title: "\(128)x\(128)", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.iconSize = EFIntSize(width: 128, height: 128)
                self.refresh()
            }
        )
        alert.addAction(
            UIAlertAction(title: "custom", style: .default) {
                [weak self] _ in
                if self != nil {
                    customInput()
                }
            }
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
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        alert.addAction(
            UIAlertAction(title: "nil", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.watermark = nil
                self.refresh()
            }
        )
        #if os(iOS)
        alert.addAction(
            UIAlertAction(title: "Select from system album", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.chooseImageFromAlbum(title: "watermark")
                self.refresh()
            }
        )
        #endif
        for watermark in ["Beethoven", "Jobs", "Miku", "Wille", "WWF"] {
            alert.addAction(
                UIAlertAction(title: watermark, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.watermark = .normal(UIImage(named: watermark)!)
                    self.refresh()
                }
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
            UIAlertAction(title: "Cancel", style: .cancel)
        )

        let modeNameArray = [
            "scaleToFill", "scaleAspectFit", "scaleAspectFill", "center",
            "top", "bottom", "left", "right",
            "topLeft", "topRight", "bottomLeft", "bottomRight"
        ]
        for (index, modeName) in modeNameArray.enumerated() {
            alert.addAction(
                UIAlertAction(title: modeName, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    if let mode = EFWatermarkMode(rawValue: index) {
                        self.watermarkMode = mode
                    }
                    self.refresh()
                }
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
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        alert.addAction(
            UIAlertAction(title: "nil", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.magnification = nil
                self.refresh()
            }
        )
        for foregroundPointOffset in [-0.5, -0.25, CGFloat(0), 0.25, 0.5] {
            alert.addAction(
                UIAlertAction(title: "\(foregroundPointOffset)", style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.foregroundPointOffset = foregroundPointOffset
                    self.refresh()
                }
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
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        for binarizationThreshold in [CGFloat(0), 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0] {
            alert.addAction(
                UIAlertAction(title: "\(binarizationThreshold)", style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.binarizationThreshold = binarizationThreshold
                    self.refresh()
                }
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
            UIAlertAction(title: "Cancel", style: .cancel)
        )

        let modeNameArray = [
            "none", "grayscale", "binarization"
        ]
        for (index, modeName) in modeNameArray.enumerated() {
            alert.addAction(
                UIAlertAction(title: modeName, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    if let mode = EFQRCodeMode(rawValue: index) {
                        self.mode = mode
                    }
                    self.refresh()
                }
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
            UIAlertAction(title: "Cancel", style: .cancel)
        )

        let shapeNameArray = [
            "square", "circle", "diamond"
        ]
        for (index, shapeName) in shapeNameArray.enumerated() {
            alert.addAction(
                UIAlertAction(title: shapeName, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    if let shape = EFPointShape(rawValue: index) {
                        self.pointShape = shape
                    }
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }

    func popActionSheet(alert: UIAlertController) {
        // 阻止 iPad Crash
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = CGRect(
            x: view.bounds.midX,
            y: view.bounds.midY,
            width: 1.0, height: 1.0
        )
        present(alert, animated: true)
    }

    func chooseAllowTransparent() {
        let alert = UIAlertController(
            title: "AllowTransparent",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        alert.addAction(
            UIAlertAction(title: "True", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.allowTransparent = true
                self.refresh()
            }
        )
        alert.addAction(
            UIAlertAction(title: "False", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.allowTransparent = false
                self.refresh()
            }
        )
        present(alert, animated: true)
    }

    // MARK: - UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        [chooseInputCorrectionLevel, chooseMode, chooseSize, chooseMagnification,
         chooseBackColor, chooseFrontColor, chooseIcon, chooseIconSize,
         chooseWatermark, chooseWatermarkMode, chooseForegroundPointOffset, chooseAllowTransparent,
         chooseBinarizationThreshold, chooseShape][indexPath.row]()

        if 8 == indexPath.row {
            refresh()
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if 8 == indexPath.row {
            refresh()
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
        return .zeroHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zeroHeight
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
            "\(["square", "circle", "diamond"][pointShape.rawValue])"
        ]

        let cell = UITableViewCell(style: detailArray[indexPath.row] == "" ? .default : .value1, reuseIdentifier: nil)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.detailTextLabel?.text = detailArray[indexPath.row]
        let backView = UIView()
        backView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.64)
        cell.selectedBackgroundView = backView

        if detailArray[indexPath.row] == "" {
            let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            #if os(iOS)
            if #available(iOS 11.0, *) {
                rightImageView.accessibilityIgnoresInvertColors = true
            }
            #endif
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
                switch watermark {
                case .gif(let dataGIF)?:
                    guard let source = CGImageSourceCreateWithData(dataGIF as CFData, nil)
                        else { break }
                    let images = source.toCGImages().map(UIImage.init(cgImage:))
                    rightImageView.animationImages = images
                    rightImageView.startAnimating()
                case .normal(let image)?:
                    rightImageView.image = image
                case nil:
                    rightImageView.image = nil
                }
            default:
                break
            }
        }
        return cell
    }
}

#if os(iOS)
// MARK: - EFColorPicker
extension GeneratorController: UIPopoverPresentationControllerDelegate, EFColorSelectionViewControllerDelegate {

    struct EFColorPicker {
        static var isFront = false
    }

    func customColor(_ isFront: Int) {

        EFColorPicker.isFront = isFront == 1

        let colorSelectionController = EFColorSelectionViewController()
        let navCtrl = UINavigationController(rootViewController: colorSelectionController)
        navCtrl.navigationBar.backgroundColor = .white
        navCtrl.navigationBar.isTranslucent = false
        navCtrl.modalPresentationStyle = .popover
        navCtrl.popoverPresentationController?.delegate = self
        navCtrl.popoverPresentationController?.sourceView = tableView
        navCtrl.popoverPresentationController?.sourceRect = tableView.bounds
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )

        colorSelectionController.isColorTextFieldHidden = false
        colorSelectionController.delegate = self
        colorSelectionController.color = EFColorPicker.isFront ? frontColor : backColor

        if .compact == traitCollection.horizontalSizeClass {
            let doneBtn = UIBarButtonItem(
                title: NSLocalizedString("Done", comment: ""),
                style: .done,
                target: self,
                action: #selector(ef_dismissViewController(sender:))
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }
        present(navCtrl, animated: true)
    }
    
    // Private
    @objc private func ef_dismissViewController(sender: UIBarButtonItem) {
        dismiss(animated: true)
        refresh()
    }

    // MARK: EFColorViewDelegate
    func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        if EFColorPicker.isFront {
            frontColor = color
        } else {
            backColor = color
        }
        refresh()
    }
}
#endif

#if os(iOS)
extension GeneratorController: UIImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var finalImage: UIImage?
        if let tryImage = info[.editedImage] as? UIImage {
            finalImage = tryImage
        } else if let tryImage = info[.originalImage] as? UIImage {
            finalImage = tryImage
        } else{
            print("Something wrong")
        }

        switch titleCurrent {
        case "watermark":
            if let finalImage = finalImage {
                watermark = .normal(finalImage)
            } else {
                watermark = nil
            }
            
            var images = [Ref<EFImage?>]()
            if let imageUrl = info[.referenceURL] as? URL,
                let asset = PHAsset.fetchAssets(withALAssetURLs: [imageUrl], options: nil).lastObject {
                images = selectedAlbumPhotosIncludingGifWithPHAssets(assets: [asset])
            }
            if let tryGIF = images.first(where: { $0.value?.isGIF == true }) {
                watermark = tryGIF.value!
            }
        case "icon":
            icon = finalImage
        default:
            break
        }
        refresh()

        picker.dismiss(animated: true)
    }

    /// 选择相册图片（包括 GIF 图片）
    /// http://www.jianshu.com/p/ad391f4d0bcb
    func selectedAlbumPhotosIncludingGifWithPHAssets(assets: [PHAsset]) -> [Ref<EFImage?>] {
        var imageArray = [Ref<EFImage?>]()

        let targetSize = CGSize(width: 1024, height: 1024)

        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.isSynchronous = true

        let imageManager = PHCachingImageManager()
        for asset in assets {
            imageManager.requestImageData(for: asset, options: options) {
                [weak self] (imageData, dataUTI, orientation, info) in
                guard self != nil else { return }
                print("dataUTI: \(dataUTI ?? "")")

                let imageElement: Ref<EFImage?> = nil

                if kUTTypeGIF as String == dataUTI {
                    // MARK: GIF
                    if let imageData = imageData {
                        imageElement.value = .gif(imageData)
                    }
                } else {
                    // MARK: 其他格式的图片，直接请求压缩后的图片
                    imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) {
                        [weak self] (result, info) in
                        guard self != nil,
                            let result = result,
                            let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool,
                            !isDegraded
                            else { return }
                        // 得到一张 UIImage，展示到界面上
                        imageElement.value = .normal(result)
                    }
                }

                imageArray.append(imageElement)
            }
        }
        return imageArray
    }

    func chooseImageFromAlbum(title: String) {
        titleCurrent = title

        if let tryPicker = imagePicker {
            present(tryPicker, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            imagePicker = picker

            present(picker, animated: true)
        }
    }
}
#endif

// MARK: - QRCode Display

extension ShowController {
    convenience init(image: EFImage?) {
        self.init()
        self.image = image
    }
}

class ShowController: UIViewController {

    var image: EFImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)
        setupViews()
    }

    let imageView = UIImageView()
    let backButton = UIButton(type: .system)
    #if os(iOS)
    let saveButton = UIButton(type: .system)
    #endif
    
    func setupViews() {
        #if os(iOS)
        if #available(iOS 11.0, *) {
            imageView.accessibilityIgnoresInvertColors = true
        }
        #endif
        imageView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.64)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        view.addSubview(imageView)
        switch image {
        case .gif(let dataGIF)?:
            guard let source = CGImageSourceCreateWithData(dataGIF as CFData, nil)
                else { break }
            let images = source.toCGImages().map(UIImage.init(cgImage:))
            imageView.animationImages = images
            imageView.startAnimating()
        case .normal(let uiImage)?:
            imageView.image = uiImage
        case nil:
            imageView.image = nil
        }
        
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 5
        backButton.layer.masksToBounds = true
        view.addSubview(backButton)

        #if os(iOS)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 5
        saveButton.layer.masksToBounds = true
        view.addSubview(saveButton)

        imageView.snp.makeConstraints {
            (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(view).offset(-10)
            let top = CGFloat.statusBar() + CGFloat.navigationBar(self) + 15
            make.top.equalTo(top)
            make.height.lessThanOrEqualTo(view.snp.width).offset(-20)
            make.height.lessThanOrEqualTo(view.snp.height).offset(-20-46-10-46-10-top)
        }

        saveButton.addTarget(self, action: #selector(saveToAlbum), for: .touchDown)
        saveButton.snp.makeConstraints {
            (make) in
            make.leading.width.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.height.equalTo(46)
        }

        backButton.addTarget(self, action: #selector(back), for: .touchDown)
        backButton.snp.makeConstraints {
            (make) in
            make.leading.width.height.equalTo(saveButton)
            make.top.equalTo(saveButton.snp.bottom).offset(10)
        }
        #else
        imageView.snp.makeConstraints {
            (make) in
            make.leading.equalTo(10)
            let top = CGFloat.statusBar() + CGFloat.navigationBar(self) + 15
            make.top.equalTo(top)
            make.width.equalTo(view).offset(-20)
            make.height.lessThanOrEqualTo(view.snp.width).offset(-20)
            make.height.lessThanOrEqualTo(view.snp.height).offset(-20-46-10-top)
        }

        backButton.addTarget(self, action: #selector(back), for: .primaryActionTriggered)
        backButton.snp.makeConstraints {
            (make) in
            make.leading.width.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.height.equalTo(46)
        }
        #endif
    }
    
    #if os(iOS)
    override func viewWillLayoutSubviews() {
        imageView.snp.updateConstraints {
            (make) in
            let top = CGFloat.statusBar() + CGFloat.navigationBar(self) + 15
            make.top.equalTo(top)
            if #available(iOS 11.0, *) {
                let left = max(view.safeAreaInsets.left, 10)
                let right = max(view.safeAreaInsets.right, 10)
                make.leading.equalTo(left)
                make.trailing.equalTo(view).offset(-right)
                let total = left + right
                make.height.lessThanOrEqualTo(view.snp.width).offset(-total)
                make.height.lessThanOrEqualTo(view.snp.height).offset(
                    -max(20, view.safeAreaInsets.bottom)-46-10-46-10-top
                )
            }
        }
        super.viewWillLayoutSubviews()
    }

    @objc func saveToAlbum() {
        guard let tryImage = image else { return }
        CustomPhotoAlbum.save(image: tryImage) {
            [weak self] (result) in
            guard let self = self else { return }
            let alert = UIAlertController(
                title: result == nil ? "Success" : "Error",
                message: result ?? "Save finished.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    #endif

    @objc func back() {
        dismiss(animated: true)
    }
}

#if os(iOS)
// http://stackoverflow.com/questions/28708846/how-to-save-image-to-custom-album
enum CustomPhotoAlbum {

    static let albumName = "EFQRCode"

    private static func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title=%@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collection.firstObject
    }

    static func save(image: EFImage, finish: @escaping ((_ error: String?) -> Void)) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            if let assetCollection = fetchAssetCollectionForAlbum() {
                save(image: image, to: assetCollection, finish: finish)
            } else {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                }, completionHandler: { (success, error) in
                    if success {
                        save(image: image, finish: finish)
                    } else {
                        finish(error?.localizedDescription ?? "Can't create photo album")
                    }
                })
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { _ in
                save(image: image, finish: finish)
            }
        case .restricted:
            finish("You can't grant access to the photo library.")
        case .denied:
            finish("You didn't grant access to the photo library.")
        @unknown default:
            finish("Unknown result.")
        }
    }
    
    private static func save(image: EFImage, to assetCollection: PHAssetCollection,
                             finish: @escaping ((_ error: String?) -> Void)) {
        var errored = false
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest: PHAssetChangeRequest?
            switch image {
            case .gif:
                guard let fileURL = EFQRCode.tempResultPath else {
                    finish("EFQRCode.tempResultPath is nil!")
                    errored = true
                    return
                }
                assetChangeRequest = .creationRequestForAssetFromImage(atFileURL: fileURL)
            case .normal(let image):
                assetChangeRequest = .creationRequestForAsset(from: image)
            }
            if let assetPlaceHolder = assetChangeRequest?.placeholderForCreatedAsset {
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                albumChangeRequest?.addAssets([assetPlaceHolder] as NSFastEnumeration)
            } else {
                finish("PlaceholderForCreatedAsset is nil!")
                errored = true
            }
        }, completionHandler: { (success, error) in
            if errored { return }
            if success {
                finish(nil)
            } else {
                finish(error?.localizedDescription ?? "Unknown error")
            }
        })
    }
}
#endif
