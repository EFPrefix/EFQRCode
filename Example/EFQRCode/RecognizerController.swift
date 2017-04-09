//
//  RecognizerController.swift
//  EFQRCode
//
//  Created by EyreFree on 17/1/25.
//  Copyright (c) 2017 EyreFree. All rights reserved.
//

import Foundation
import EFQRCode

class RecognizerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var iamgeView: UIImageView!
    var imagePicker: UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Scan"
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)

        setupViews()
    }

    func setupViews() {
        let screenSize = UIScreen.main.bounds.size

        iamgeView = UIImageView()
        iamgeView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.32)
        iamgeView.contentMode = .scaleAspectFit
        iamgeView.layer.borderColor = UIColor.white.cgColor
        iamgeView.layer.borderWidth = 1
        iamgeView.layer.cornerRadius = 5
        iamgeView.layer.masksToBounds = true
        self.view.addSubview(iamgeView)
        iamgeView.frame = CGRect(
            x: 10, y: 80, width: screenSize.width - 20, height: screenSize.height - 146
        )

        let chooseButton = UIButton(type: .system)
        chooseButton.setTitle("Choose image", for: .normal)
        chooseButton.setTitleColor(UIColor.white, for: .normal)
        chooseButton.layer.borderColor = UIColor.white.cgColor
        chooseButton.layer.borderWidth = 1
        chooseButton.layer.cornerRadius = 5
        chooseButton.layer.masksToBounds = true
        chooseButton.addTarget(self, action: #selector(RecognizerController.chooseImage), for: .touchDown)
        self.view.addSubview(chooseButton)
        chooseButton.frame = CGRect(
            x: 10, y: screenSize.height - 56, width: (screenSize.width - 30) / 2.0, height: 46
        )

        let scanButton = UIButton(type: .system)
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setTitleColor(UIColor(red: 246.0 / 255.0, green: 137.0 / 255.0, blue: 222.0 / 255.0, alpha: 1), for: .normal)
        scanButton.layer.borderColor = UIColor.white.cgColor
        scanButton.layer.borderWidth = 1
        scanButton.layer.cornerRadius = 5
        scanButton.layer.masksToBounds = true
        scanButton.addTarget(self, action: #selector(RecognizerController.scanQRCode), for: .touchDown)
        self.view.addSubview(scanButton)
        scanButton.frame = CGRect(
            x: 20 + chooseButton.frame.width, y: screenSize.height - 56, width: chooseButton.frame.width, height: 46
        )
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

    func scanQRCode() {
        if let tryImage = iamgeView.image?.toCGImage() {
            var title = "Error"
            var result = "Get QRCode from image failed!"
            let codes = EFQRCode.recognize(image: tryImage) ?? [String]()
            if codes.count > 0 {
                title = "Success"
                result = codes[0]
                // for (index, code) in codes.enumerated() {
                //     result += "\(index): \(code)\n"
                // }
            }
            let alert = UIAlertController(title: title, message: result, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "Please choose image first!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK:- UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let tryImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.iamgeView.image = tryImage
        } else if let tryImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.iamgeView.image = tryImage
        } else{
            print("Something went wrong")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
