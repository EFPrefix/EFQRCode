//
//  ScanController.swift
//  EFQRCode
//
//  Created by EyreFree on 17/1/25.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import EFQRCode

class ScanController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var iamgeView: UIImageView!
    var imagePicker: UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Scan"
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white

        setupViews()
    }

    func setupViews() {
        let screenSize = UIScreen.main.bounds.size

        iamgeView = UIImageView()
        iamgeView.contentMode = .scaleAspectFit
        iamgeView.layer.borderColor = UIColor.black.cgColor
        iamgeView.layer.borderWidth = 1
        iamgeView.layer.masksToBounds = true
        self.view.addSubview(iamgeView)
        iamgeView.frame = CGRect(
            x: 10, y: 80, width: screenSize.width - 20, height: screenSize.height - 146
        )

        let chooseButton = UIButton()
        chooseButton.setTitle("Choose image", for: .normal)
        chooseButton.setTitleColor(UIColor.black, for: .normal)
        chooseButton.layer.borderColor = UIColor.black.cgColor
        chooseButton.layer.borderWidth = 1
        chooseButton.layer.masksToBounds = true
        chooseButton.addTarget(self, action: #selector(ScanController.chooseImage), for: .touchDown)
        self.view.addSubview(chooseButton)
        chooseButton.frame = CGRect(
            x: 10, y: screenSize.height - 56, width: (screenSize.width - 30) / 2.0, height: 46
        )

        let scanButton = UIButton()
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setTitleColor(UIColor.black, for: .normal)
        scanButton.layer.borderColor = UIColor.black.cgColor
        scanButton.layer.borderWidth = 1
        scanButton.layer.masksToBounds = true
        scanButton.addTarget(self, action: #selector(ScanController.scanQRCode), for: .touchDown)
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
        if let tryImage = iamgeView.image {
            var title = "Error"
            var result = "Get QRCode from image failed!"
            let codes = EFQRCode.getQRString(From: tryImage)
            if codes.count > 0 {
                title = "Success"
                result = codes[0]
                //for (index, code) in codes.enumerated() {
                //    result += "\(index): \(code)\n"
                //}
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

    //MARK:- UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        self.iamgeView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
}
