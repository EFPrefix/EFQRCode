//
//  CreateController.swift
//  EFQRCode
//
//  Created by EyreFree on 17/1/25.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import EFQRCode

class CreateController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var textView: UITextView!
    var imagePicker: UIImagePickerController?

    var watermarkImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Create"
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white

        setupViews()
    }

    func setupViews() {
        let screenSize = UIScreen.main.bounds.size

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
            x: 10, y: 80, width: screenSize.width - 20, height: screenSize.height - 146
        )

        let chooseButton = UIButton()
        chooseButton.setTitle("Choose watermark", for: .normal)
        chooseButton.setTitleColor(UIColor.black, for: .normal)
        chooseButton.layer.borderColor = UIColor.black.cgColor
        chooseButton.layer.borderWidth = 1
        chooseButton.layer.masksToBounds = true
        chooseButton.addTarget(self, action: #selector(ScanController.chooseImage), for: .touchDown)
        self.view.addSubview(chooseButton)
        chooseButton.frame = CGRect(
            x: 10, y: screenSize.height - 56, width: (screenSize.width - 30) / 2.0, height: 46
        )

        let createButton = UIButton()
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(UIColor.black, for: .normal)
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(CreateController.createCode), for: .touchDown)
        self.view.addSubview(createButton)
        createButton.frame = CGRect(
            x: 20 + chooseButton.frame.width, y: screenSize.height - 56, width: chooseButton.frame.width, height: 46
        )
    }

    func createCode() {
        if let tryImage = EFQRCode.createQRImage(
            string: textView.text ?? "https://github.com/EyreFree/EFQRCode",
            inputCorrectionLevel: .h,
            size: UIScreen.main.bounds.size.width * 2,
            quality: .high,
            backColor: .white,
            frontColor: .black,
            icon: nil,//UIImage(named: "Swift"),
            iconSize: nil,
            iconColorful: false,
            watermark: watermarkImage,
            watermarkMode: .scaleAspectFit,
            watermarkColorful: false
        ) {
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

    func chooseImage() {
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

    //MARK:- UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        self.watermarkImage = info[UIImagePickerControllerOriginalImage] as? UIImage
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

        let createButton = UIButton()
        createButton.setTitle("Back", for: .normal)
        createButton.setTitleColor(UIColor.black, for: .normal)
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(ShowController.back), for: .touchDown)
        self.view.addSubview(createButton)
        createButton.frame = CGRect(
            x: 10, y: imageView.frame.maxY + 10, width: screenSize.width - 20, height: 46
        )
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
}
