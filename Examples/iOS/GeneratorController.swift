//
//  GeneratorController.swift
//  EFQRCode
//
//  Created by EyreFree on 17/1/25.
//  Copyright (c) 2017 EyreFree. All rights reserved.
//

import UIKit
import Photos
import EFQRCode

class GeneratorController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var textView: UITextView!
    var tableView: UITableView!
    var createButton: UIButton!

    var imagePicker: UIImagePickerController?
    var titleCurrent: String = ""

    // Param
    var inputCorrectionLevel = EFInputCorrectionLevel.h
    var size: EFIntSize = EFIntSize(width: 256, height: 256)
    var magnification: EFIntSize? = nil
    var backColor = UIColor.white
    var frontColor = UIColor.black
    var icon: UIImage? = nil
    var iconSize: EFIntSize? = nil
    var iconColorful = true
    var watermark: UIImage? = nil
    var watermarkMode = EFWatermarkMode.scaleAspectFill
    var watermarkColorful = true

    // MARK:- Not commonly used
    var foregroundPointOffset: CGFloat = 0
    var allowTransparent: Bool = true

    // Test data
    struct colorData {
        var color: UIColor
        var name: String
    }
    var colorList = [colorData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Create"
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)

        setupViews()
    }

    func setupViews() {
        let screenSize = UIScreen.main.bounds.size
        let buttonHeight: CGFloat = 46

        // Add test data
        let colorNameArray = [
            "Black", "White", "Gray", "Red", "Blue", "LPD", "Miku", "Wille", "Hearth Stone", "Pikachu Red", "3 Red"
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
        textView.frame = CGRect(
            x: 10, y: 80, width: screenSize.width - 20, height: screenSize.height - 90 - (buttonHeight + 10) * 6
        )

        // tableView
        tableView = UITableView()
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.separatorColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.view.addSubview(tableView)
        tableView.frame = CGRect(
            x: 0, y: screenSize.height - 56 * 6, width: screenSize.width, height: 4 * (buttonHeight + 10) + buttonHeight
        )

        createButton = UIButton(type: .system)
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(UIColor(red: 246.0 / 255.0, green: 137.0 / 255.0, blue: 222.0 / 255.0, alpha: 1), for: .normal)
        createButton.layer.borderColor = UIColor.white.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.cornerRadius = 5
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(GeneratorController.createCode), for: .touchDown)
        self.view.addSubview(createButton)
        createButton.frame = CGRect(
            x: 10, y: screenSize.height - 56, width: screenSize.width - 20, height: buttonHeight
        )
    }

    func refresh() {
        tableView.reloadData()
    }

    func createCode() {
        var content = ""
        if !(nil == textView.text || textView.text == "") {
            content = textView.text
        }

        if let tryCGImage = EFQRCode.generate(
            content: content,
            inputCorrectionLevel: inputCorrectionLevel,
            size: size,
            magnification: magnification,
            backgroundColor: CIColor(color: backColor),
            foregroundColor: CIColor(color: frontColor),
            icon: EFIcon(image: UIImage2CGimage(icon), size: iconSize, isColorful: iconColorful),
            watermark: EFWatermark(image: UIImage2CGimage(watermark), mode: watermarkMode, isColorful: watermarkColorful),
            extra: EFExtra(foregroundPointOffset: foregroundPointOffset, allowTransparent: allowTransparent)
            ) {
            let tryImage = UIImage(cgImage: tryCGImage)
            self.present(ShowController(image: tryImage), animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "Create QRCode failed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
            title: "Size",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        for width in [Int(1), 32, 64, 128, 256, 512, 1024, 2048] {
            alert.addAction(
                UIAlertAction(title: "\(width)x\(width)", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.size = EFIntSize(width: width, height: width)
                        strongSelf.refresh()
                    }
                })
            )
            if 512 == width {
                alert.addAction(
                    UIAlertAction(title: "\(512)x\(640)", style: .default, handler: {
                        [weak self] (action) -> Void in
                        if let strongSelf = self {
                            strongSelf.size = EFIntSize(width: 512, height: 640)
                            strongSelf.refresh()
                        }
                    })
                )
            }
        }
        popActionSheet(alert: alert)
    }

    func chooseMagnification() {
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
        for magnification in [Int(1), 3, 6, 9, 12, 15, 18, 21, 23, 25, 27, 30] {
            alert.addAction(
                UIAlertAction(title: "\(magnification)x\(magnification)", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.magnification = EFIntSize(width: magnification, height: magnification)
                        strongSelf.refresh()
                    }
                })
            )
            if magnification == 9 {
                alert.addAction(
                    UIAlertAction(title: "\(12)x\(9)", style: .default, handler: {
                        [weak self] (action) -> Void in
                        if let strongSelf = self {
                            strongSelf.magnification = EFIntSize(width: 12, height: 9)
                            strongSelf.refresh()
                        }
                    })
                )
            }
        }
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
        if let tryWaterMark = watermark {
            alert.addAction(
                UIAlertAction(title: "Average of watermark", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.frontColor = tryWaterMark.avarageColor() ?? UIColor.clear
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
        alert.addAction(
            UIAlertAction(title: "Select from system album", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.chooseImageFromAlbum(title: "icon")
                    strongSelf.refresh()
                }
            })
        )
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
        for width in [Int(1), 32, 64, 128, 256, 512, 1024, 2048] {
            alert.addAction(
                UIAlertAction(title: "\(width)x\(width)", style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.iconSize = EFIntSize(width: width, height: width)
                        strongSelf.refresh()
                    }
                })
            )
            if 512 == width {
                alert.addAction(
                    UIAlertAction(title: "\(512)x\(640)", style: .default, handler: {
                        [weak self] (action) -> Void in
                        if let strongSelf = self {
                            strongSelf.iconSize = EFIntSize(width: 512, height: 640)
                            strongSelf.refresh()
                        }
                    })
                )
            }
        }
        popActionSheet(alert: alert)
    }

    func chooseIconColorful() {
        let alert = UIAlertController(
            title: "IconColorful",
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
                    strongSelf.iconColorful = true
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "False", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.iconColorful = false
                    strongSelf.refresh()
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
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
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
        alert.addAction(
            UIAlertAction(title: "Select from system album", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.chooseImageFromAlbum(title: "watermark")
                    strongSelf.refresh()
                }
            })
        )
        for watermark in ["Beethoven", "Jobs", "Miku", "Wille", "WWF"] {
            alert.addAction(
                UIAlertAction(title: watermark, style: .default, handler: {
                    [weak self] (action) -> Void in
                    if let strongSelf = self {
                        strongSelf.watermark = UIImage(named: watermark)
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
        alert.addAction(
            UIAlertAction(title: "scaleToFill", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .scaleToFill
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "scaleAspectFit", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .scaleAspectFit
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "scaleAspectFill", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .scaleAspectFill
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "center", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .center
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "top", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .top
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "bottom", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .bottom
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "left", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .left
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "right", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .right
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "topLeft", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .topLeft
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "topRight", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .topRight
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "bottomLeft", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .bottomLeft
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "bottomRight", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkMode = .bottomRight
                    strongSelf.refresh()
                }
            })
        )
        popActionSheet(alert: alert)
    }

    func chooseWatermarkColorful() {
        let alert = UIAlertController(
            title: "WatermarkColorful",
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
                    strongSelf.watermarkColorful = true
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "False", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermarkColorful = false
                    strongSelf.refresh()
                }
            })
        )
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

        switch indexPath.row {
        case 0:
            chooseInputCorrectionLevel()
            break
        case 1:
            chooseSize()
            break
        case 2:
            chooseMagnification()
            break
        case 3:
            chooseBackColor()
            break
        case 4:
            chooseFrontColor()
            break
        case 5:
            chooseIcon()
            break
        case 6:
            chooseIconSize()
            break
        case 7:
            chooseIconColorful()
            break
        case 8:
            chooseWatermark()
            break
        case 9:
            chooseWatermarkMode()
            break
        case 10:
            chooseWatermarkColorful()
            break
        case 11:
            chooseForegroundPointOffset()
            break
        case 12:
            chooseAllowTransparent()
            break
        default:
            break
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0000001
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000001
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleArray = [
            "inputCorrectionLevel",
            "size",
            "magnification",
            "backgroundColor",
            "foregroundColor",
            "icon",
            "iconSize",
            "isIconColorful",
            "watermark",
            "watermarkMode",
            "isWatermarkColorful",
            "foregroundPointOffset",
            "allowTransparent"
        ]
        let magnificationString = "\(nil == magnification ? "nil" : "\(magnification?.width ?? 0)x\(magnification?.height ?? 0)")"
        let iconSizeString = "\(nil == iconSize ? "nil" : "\(iconSize?.width ?? 0)x\(iconSize?.height ?? 0)")"
        let watermarkModeString = "\(["scaleToFill", "scaleAspectFit", "scaleAspectFill", "center", "top", "bottom", "left", "right", "topLeft", "topRight", "bottomLeft", "bottomRight"][watermarkMode.rawValue])"
        let detailArray = [
            "\(["L", "M", "Q", "H"][inputCorrectionLevel.rawValue])",
            "\(size.width)x\(size.height)",
            magnificationString,
            "", // backgroundColor
            "", // foregroundColor
            "", // icon
            iconSizeString,
            "\(iconColorful)",
            "", // watermark
            watermarkModeString,
            "\(watermarkColorful)",
            "\(foregroundPointOffset)",
            "\(allowTransparent)"
        ]

        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.detailTextLabel?.text = detailArray[indexPath.row]
        let backView = UIView()
        backView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.64)
        cell.selectedBackgroundView = backView

        if detailArray[indexPath.row] == "" {
            let rightImageView = UIImageView(
                frame: CGRect(x: UIScreen.main.bounds.size.width - 45.0, y: 8.0, width: 30.0, height: 30.0)
            )
            rightImageView.contentMode = .scaleAspectFit
            rightImageView.layer.borderColor = UIColor.white.cgColor
            rightImageView.layer.borderWidth = 0.5
            cell.addSubview(rightImageView)

            switch indexPath.row {
            case 3:
                rightImageView.backgroundColor = backColor
                break
            case 4:
                rightImageView.backgroundColor = frontColor
                break
            case 5:
                rightImageView.image = icon
                break
            case 8:
                rightImageView.image = watermark
                break
            default:
                break
            }
        }
        return cell
    }

    // MARK:- UIImagePickerControllerDelegate
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
            print("Something went wrong")
        }
        switch titleCurrent {
        case "watermark":
            self.watermark = finalImage
            break
        case "icon":
            self.icon = finalImage
            break
        default:
            break
        }
        self.refresh()

        picker.dismiss(animated: true, completion: nil)
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

class ShowController: UIViewController {

    var image: UIImage?

    init(image: UIImage) {
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
        let screenSize = UIScreen.main.bounds.size

        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.64)
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.image
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        self.view.addSubview(imageView)
        imageView.frame = CGRect(
            x: 10, y: 30, width: screenSize.width - 20, height: screenSize.width - 20
        )

        let createButton = UIButton(type: .system)
        createButton.setTitle("Save", for: .normal)
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.layer.borderColor = UIColor.white.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.cornerRadius = 5
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(ShowController.saveToAlbum), for: .touchDown)
        self.view.addSubview(createButton)
        createButton.frame = CGRect(
            x: 10, y: imageView.frame.maxY + 10, width: screenSize.width - 20, height: 46
        )

        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 5
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(ShowController.back), for: .touchDown)
        self.view.addSubview(backButton)
        backButton.frame = CGRect(
            x: 10, y: imageView.frame.maxY + 10 + 56, width: screenSize.width - 20, height: 46
        )
    }

    func saveToAlbum() {
        if let tryImage = image {
            CustomPhotoAlbum.sharedInstance.save(image: tryImage)
        }
    }

    func back() {
        self.dismiss(animated: true, completion: nil)
    }
}

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

    func save(image: UIImage) {
        if assetCollection == nil {
            // If there was an error upstream, skip the save
            return
        }

        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)
            
        }, completionHandler: nil)
    }
}
