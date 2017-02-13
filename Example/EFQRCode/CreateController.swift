//
//  CreateController.swift
//  EFQRCode
//
//  Created by EyreFree on 17/1/25.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import EFQRCode

import Photos

class CreateController: UIViewController, UITextViewDelegate {

    var textView: UITextView!
    var chooseInputCorrectionLevelButton: UIButton!
    var chooseSizeButton: UIButton!
    var chooseMinButton: UIButton!
    var chooseBackColorButton: UIButton!
    var choosefrontColorButton: UIButton!
    var chooseIconButton: UIButton!
    var chooseIconSizeButton: UIButton!
    var chooseIconColorfulButton: UIButton!
    var chooseWatermarkButton: UIButton!
    var chooseWatermarkModeButton: UIButton!
    var chooseWatermarkColorfulButton: UIButton!
    var createButton: UIButton!

    // Param
    var inputCorrectionLevel = EFInputCorrectionLevel.h
    var size: CGFloat? = UIScreen.main.bounds.size.width * 2
    var quality = EFQuality.min
    var backColor = UIColor.white
    var frontColor = UIColor.black
    var icon: UIImage? = nil
    var iconSize: CGFloat? = nil
    var iconColorful = true
    var watermark: UIImage? = nil
    var watermarkMode = EFWatermarkMode.scaleAspectFill
    var watermarkColorful = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Create"
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white

        setupViews()
    }

    func setupViews() {
        let screenSize = UIScreen.main.bounds.size

        let buttonHeight: CGFloat = 46
        let buttonWidth: CGFloat = (screenSize.width - 30) / 2.0

        //string: textView.text ?? "https://github.com/EyreFree/EFQRCode",
        textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.textColor = UIColor.black
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        textView.delegate = self
        textView.returnKeyType = .done
        self.view.addSubview(textView)
        textView.frame = CGRect(
            x: 10, y: 80, width: screenSize.width - 20, height: screenSize.height - 90 - (buttonHeight + 10) * 6
        )

        //inputCorrectionLevel: .h,
        chooseInputCorrectionLevelButton = UIButton(type: .system)
        chooseInputCorrectionLevelButton.setTitle("ICLevel: \(["L", "M", "Q", "H"][inputCorrectionLevel.rawValue])", for: .normal)
        chooseInputCorrectionLevelButton.setTitleColor(UIColor.black, for: .normal)
        chooseInputCorrectionLevelButton.layer.borderColor = UIColor.black.cgColor
        chooseInputCorrectionLevelButton.layer.borderWidth = 1
        chooseInputCorrectionLevelButton.layer.masksToBounds = true
        chooseInputCorrectionLevelButton.addTarget(self, action: #selector(CreateController.chooseInputCorrectionLevel), for: .touchDown)
        self.view.addSubview(chooseInputCorrectionLevelButton)
        chooseInputCorrectionLevelButton.frame = CGRect(
            x: 10, y: screenSize.height - 56 * 6, width: buttonWidth, height: 46
        )

        //size: UIScreen.main.bounds.size.width * 2,
        chooseSizeButton = UIButton(type: .system)
        chooseSizeButton.setTitle("size: \(size)", for: .normal)
        chooseSizeButton.setTitleColor(UIColor.black, for: .normal)
        chooseSizeButton.layer.borderColor = UIColor.black.cgColor
        chooseSizeButton.layer.borderWidth = 1
        chooseSizeButton.layer.masksToBounds = true
        chooseSizeButton.addTarget(self, action: #selector(CreateController.chooseSize), for: .touchDown)
        self.view.addSubview(chooseSizeButton)
        chooseSizeButton.frame = CGRect(
            x: 20 + buttonWidth, y: screenSize.height - 56 * 6, width: buttonWidth, height: buttonHeight
        )

        //quality: .min,
        chooseMinButton = UIButton(type: .system)
        chooseMinButton.setTitle("quality: \(["min", "low", "middle", "high", "max"][quality.rawValue])", for: .normal)
        chooseMinButton.setTitleColor(UIColor.black, for: .normal)
        chooseMinButton.layer.borderColor = UIColor.black.cgColor
        chooseMinButton.layer.borderWidth = 1
        chooseMinButton.layer.masksToBounds = true
        chooseMinButton.addTarget(self, action: #selector(CreateController.chooseQuality), for: .touchDown)
        self.view.addSubview(chooseMinButton)
        chooseMinButton.frame = CGRect(
            x: 10, y: screenSize.height - 56 * 5, width: buttonWidth, height: 46
        )

        //backColor: .white,
        chooseBackColorButton = UIButton(type: .system)
        chooseBackColorButton.setTitle("backColor", for: .normal)
        chooseBackColorButton.setTitleColor(UIColor.black, for: .normal)
        chooseBackColorButton.layer.borderColor = UIColor.black.cgColor
        chooseBackColorButton.layer.borderWidth = 1
        chooseBackColorButton.layer.masksToBounds = true
        chooseBackColorButton.addTarget(self, action: #selector(CreateController.chooseBackColor), for: .touchDown)
        self.view.addSubview(chooseBackColorButton)
        chooseBackColorButton.frame = CGRect(
            x: 20 + buttonWidth, y: screenSize.height - 56 * 5, width: buttonWidth, height: buttonHeight
        )

        //frontColor: .black,
        choosefrontColorButton = UIButton(type: .system)
        choosefrontColorButton.setTitle("frontColor", for: .normal)
        choosefrontColorButton.setTitleColor(UIColor.black, for: .normal)
        choosefrontColorButton.layer.borderColor = UIColor.black.cgColor
        choosefrontColorButton.layer.borderWidth = 1
        choosefrontColorButton.layer.masksToBounds = true
        choosefrontColorButton.addTarget(self, action: #selector(CreateController.chooseFrontColor), for: .touchDown)
        self.view.addSubview(choosefrontColorButton)
        choosefrontColorButton.frame = CGRect(
            x: 10, y: screenSize.height - 56 * 4, width: buttonWidth, height: 46
        )

        //icon: nil,
        chooseIconButton = UIButton(type: .system)
        chooseIconButton.setTitle("icon: \(icon)", for: .normal)
        chooseIconButton.setTitleColor(UIColor.black, for: .normal)
        chooseIconButton.layer.borderColor = UIColor.black.cgColor
        chooseIconButton.layer.borderWidth = 1
        chooseIconButton.layer.masksToBounds = true
        chooseIconButton.addTarget(self, action: #selector(CreateController.chooseIcon), for: .touchDown)
        self.view.addSubview(chooseIconButton)
        chooseIconButton.frame = CGRect(
            x: 20 + buttonWidth, y: screenSize.height - 56 * 4, width: buttonWidth, height: buttonHeight
        )

        //iconSize: nil,
        chooseIconSizeButton = UIButton(type: .system)
        chooseIconSizeButton.setTitle("iconSize: \(iconSize)", for: .normal)
        chooseIconSizeButton.setTitleColor(UIColor.black, for: .normal)
        chooseIconSizeButton.layer.borderColor = UIColor.black.cgColor
        chooseIconSizeButton.layer.borderWidth = 1
        chooseIconSizeButton.layer.masksToBounds = true
        chooseIconSizeButton.addTarget(self, action: #selector(CreateController.chooseIconSize), for: .touchDown)
        self.view.addSubview(chooseIconSizeButton)
        chooseIconSizeButton.frame = CGRect(
            x: 10, y: screenSize.height - 56 * 3, width: buttonWidth, height: 46
        )

        //iconColorful: false,
        chooseIconColorfulButton = UIButton(type: .system)
        chooseIconColorfulButton.setTitle("iColorful: \(iconColorful)", for: .normal)
        chooseIconColorfulButton.setTitleColor(UIColor.black, for: .normal)
        chooseIconColorfulButton.layer.borderColor = UIColor.black.cgColor
        chooseIconColorfulButton.layer.borderWidth = 1
        chooseIconColorfulButton.layer.masksToBounds = true
        chooseIconColorfulButton.addTarget(self, action: #selector(CreateController.chooseIconColorful), for: .touchDown)
        self.view.addSubview(chooseIconColorfulButton)
        chooseIconColorfulButton.frame = CGRect(
            x: 20 + buttonWidth, y: screenSize.height - 56 * 3, width: buttonWidth, height: buttonHeight
        )

        //watermark: watermarkImage,
        chooseWatermarkButton = UIButton(type: .system)
        chooseWatermarkButton.setTitle("watermark: \(watermark)", for: .normal)
        chooseWatermarkButton.setTitleColor(UIColor.black, for: .normal)
        chooseWatermarkButton.layer.borderColor = UIColor.black.cgColor
        chooseWatermarkButton.layer.borderWidth = 1
        chooseWatermarkButton.layer.masksToBounds = true
        chooseWatermarkButton.addTarget(self, action: #selector(CreateController.chooseWatermark), for: .touchDown)
        self.view.addSubview(chooseWatermarkButton)
        chooseWatermarkButton.frame = CGRect(
            x: 10, y: screenSize.height - 56 * 2, width: buttonWidth, height: 46
        )

        //watermarkMode: .scaleAspectFit,
        chooseWatermarkModeButton = UIButton(type: .system)
        chooseWatermarkModeButton.setTitle(
            "wMode: \(["scaleToFill", "scaleAspectFit", "scaleAspectFill", "center", "top", "bottom", "left", "right", "topLeft", "topRight", "bottomLeft", "bottomRight"][watermarkMode.rawValue])"
            , for: .normal)
        chooseWatermarkModeButton.setTitleColor(UIColor.black, for: .normal)
        chooseWatermarkModeButton.layer.borderColor = UIColor.black.cgColor
        chooseWatermarkModeButton.layer.borderWidth = 1
        chooseWatermarkModeButton.layer.masksToBounds = true
        chooseWatermarkModeButton.addTarget(self, action: #selector(CreateController.chooseWatermarkMode), for: .touchDown)
        self.view.addSubview(chooseWatermarkModeButton)
        chooseWatermarkModeButton.frame = CGRect(
            x: 20 + buttonWidth, y: screenSize.height - 56 * 2, width: buttonWidth, height: buttonHeight
        )

        //watermarkColorful: false
        chooseWatermarkColorfulButton = UIButton(type: .system)
        chooseWatermarkColorfulButton.setTitle("wColorful: \(watermarkColorful)", for: .normal)
        chooseWatermarkColorfulButton.setTitleColor(UIColor.black, for: .normal)
        chooseWatermarkColorfulButton.layer.borderColor = UIColor.black.cgColor
        chooseWatermarkColorfulButton.layer.borderWidth = 1
        chooseWatermarkColorfulButton.layer.masksToBounds = true
        chooseWatermarkColorfulButton.addTarget(self, action: #selector(CreateController.chooseWatermarkColorful), for: .touchDown)
        self.view.addSubview(chooseWatermarkColorfulButton)
        chooseWatermarkColorfulButton.frame = CGRect(
            x: 10, y: screenSize.height - 56, width: buttonWidth, height: 46
        )

        createButton = UIButton(type: .system)
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(UIColor.red, for: .normal)
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(CreateController.createCode), for: .touchDown)
        self.view.addSubview(createButton)
        createButton.frame = CGRect(
            x: 20 + buttonWidth, y: screenSize.height - 56, width: buttonWidth, height: buttonHeight
        )
    }

    func refresh() {
        chooseInputCorrectionLevelButton.setTitle("ICLevel: \(["L", "M", "Q", "H"][inputCorrectionLevel.rawValue])", for: .normal)
        chooseSizeButton.setTitle("size: \(size)", for: .normal)
        chooseMinButton.setTitle("quality: \(["min", "low", "middle", "high", "max"][quality.rawValue])", for: .normal)
        chooseBackColorButton.setTitle("backColor", for: .normal)
        choosefrontColorButton.setTitle("frontColor", for: .normal)
        chooseIconButton.setTitle("icon: \(icon)", for: .normal)
        chooseIconSizeButton.setTitle("iconSize: \(iconSize)", for: .normal)
        chooseIconColorfulButton.setTitle("iColorful: \(iconColorful)", for: .normal)
        chooseWatermarkButton.setTitle("watermark: \(watermark)", for: .normal)
        chooseWatermarkModeButton.setTitle(
            "wMode: \(["scaleToFill", "scaleAspectFit", "scaleAspectFill", "center", "top", "bottom", "left", "right", "topLeft", "topRight", "bottomLeft", "bottomRight"][watermarkMode.rawValue])"
            , for: .normal)
        chooseWatermarkColorfulButton.setTitle("wColorful: \(watermarkColorful)", for: .normal)
        createButton.setTitle("Create", for: .normal)
    }

    func createCode() {
        var content = "https://github.com/EyreFree/EFQRCode"
        if !(nil == textView.text || textView.text == "") {
            content = textView.text
        }

        if let tryImage = EFQRCode.createQRImage(
            string: content,
            inputCorrectionLevel: inputCorrectionLevel,
            size: size,
            quality: quality,
            backColor: backColor,
            frontColor: frontColor,
            icon: icon,
            iconSize: iconSize,
            iconColorful: iconColorful,
            watermark: watermark,
            watermarkMode: watermarkMode,
            watermarkColorful: watermarkColorful
            ) {
            self.present(ShowController(image: tryImage), animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "Create QRCode failed!", preferredStyle: .actionSheet)
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
        alert.addAction(
            UIAlertAction(title: "l", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.inputCorrectionLevel = .l
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "m", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.inputCorrectionLevel = .m
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "q", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.inputCorrectionLevel = .q
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "h", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.inputCorrectionLevel = .h
                    strongSelf.refresh()
                }
            })
        )
        self.present(alert, animated: true, completion: nil)
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
        alert.addAction(
            UIAlertAction(title: "nil", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.size = nil
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "\(UIScreen.main.bounds.size.width)", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.size = UIScreen.main.bounds.size.width
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "\(UIScreen.main.bounds.size.width * 2)", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.size = UIScreen.main.bounds.size.width * 2
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "256", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.size = 256
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "1024", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.size = 1024
                    strongSelf.refresh()
                }
            })
        )
        self.present(alert, animated: true, completion: nil)
    }

    func chooseQuality() {
        let alert = UIAlertController(
            title: "Quality",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) -> Void in
            })
        )
        alert.addAction(
            UIAlertAction(title: "min", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.quality = .min
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "low", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.quality = .low
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "middle", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.quality = .middle
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "high", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.quality = .high
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "max", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.quality = .max
                    strongSelf.refresh()
                }
            })
        )

        self.present(alert, animated: true, completion: nil)
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
        alert.addAction(
            UIAlertAction(title: "white", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.backColor = UIColor.white
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "gray", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.backColor = UIColor.gray
                    strongSelf.refresh()
                }
            })
        )
        self.present(alert, animated: true, completion: nil)
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
        alert.addAction(
            UIAlertAction(title: "black", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.frontColor = UIColor.black
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "red", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.frontColor = UIColor.red
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "blue", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.frontColor = UIColor.blue
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "miku", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.frontColor = UIColor(red: 57.0 / 255.0, green: 197.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "Pikachu", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.frontColor = UIColor(red: 255.0 / 255.0, green: 226.0 / 255.0, blue: 17.0 / 255.0, alpha: 1.0)
                    strongSelf.refresh()
                }
            })
        )
        self.present(alert, animated: true, completion: nil)
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
            UIAlertAction(title: "github", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.icon = UIImage(named: "github")
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "Swift", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.icon = UIImage(named: "Swift")
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "eyrefree", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.icon = UIImage(named: "eyrefree")
                    strongSelf.refresh()
                }
            })
        )
        self.present(alert, animated: true, completion: nil)
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
        alert.addAction(
            UIAlertAction(title: "\(UIScreen.main.bounds.size.width * 0.06)", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.iconSize = UIScreen.main.bounds.size.width * 0.06
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "\(UIScreen.main.bounds.size.width * 2 * 0.06)", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.iconSize = UIScreen.main.bounds.size.width * 2 * 0.06
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "64", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.iconSize = 64
                    strongSelf.refresh()
                }
            })
        )
        self.present(alert, animated: true, completion: nil)
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
        self.present(alert, animated: true, completion: nil)
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
            UIAlertAction(title: "Jobs", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermark = UIImage(named: "Jobs")
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "Miku", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermark = UIImage(named: "Miku")
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "Pikachu", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermark = UIImage(named: "Pikachu")
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "Kumamon", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermark = UIImage(named: "Kumamon")
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "ちゃまろ", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermark = UIImage(named: "ちゃまろ")
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "Teacher.Cang", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermark = UIImage(named: "Teacher.Cang")
                    strongSelf.refresh()
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: "eyrefree", style: .default, handler: {
                [weak self] (action) -> Void in
                if let strongSelf = self {
                    strongSelf.watermark = UIImage(named: "eyrefree")
                    strongSelf.refresh()
                }
            })
        )
        self.present(alert, animated: true, completion: nil)
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
        self.present(alert, animated: true, completion: nil)
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
        self.present(alert, animated: true, completion: nil)
    }
}

class ShowController: UIViewController {

    var image: UIImage?

    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)

        self.image = image
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        setupViews()
    }

    func setupViews() {
        let screenSize = UIScreen.main.bounds.size

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.image
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        self.view.addSubview(imageView)
        imageView.frame = CGRect(
            x: 10, y: 30, width: screenSize.width - 20, height: screenSize.width - 20
        )

        let createButton = UIButton(type: .system)
        createButton.setTitle("Save", for: .normal)
        createButton.setTitleColor(UIColor.black, for: .normal)
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(ShowController.saveToAlbum), for: .touchDown)
        self.view.addSubview(createButton)
        createButton.frame = CGRect(
            x: 10, y: imageView.frame.maxY + 10, width: screenSize.width - 20, height: 46
        )

        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderWidth = 1
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
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }

    func createAlbum() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)   // create an asset collection with the album name
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                print("error \(error)")
            }
        }
    }

    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }

    func save(image: UIImage) {
        if assetCollection == nil {
            return                          // if there was an error upstream, skip the save
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
