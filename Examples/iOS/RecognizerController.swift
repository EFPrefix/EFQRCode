//
//  RecognizerController.swift
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
        iamgeView = UIImageView()
        iamgeView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.32)
        iamgeView.contentMode = .scaleAspectFit
        iamgeView.layer.borderColor = UIColor.white.cgColor
        iamgeView.layer.borderWidth = 1
        iamgeView.layer.cornerRadius = 5
        iamgeView.layer.masksToBounds = true
        self.view.addSubview(iamgeView)
        iamgeView.snp.makeConstraints {
            (make) in
            make.left.equalTo(10)
            make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 15)
            make.width.equalTo(self.view).offset(-20)
            make.height.equalTo(self.view).offset(-146)
        }

        let chooseButton = UIButton(type: .system)
        chooseButton.setTitle("Choose image", for: .normal)
        chooseButton.setTitleColor(UIColor.white, for: .normal)
        chooseButton.layer.borderColor = UIColor.white.cgColor
        chooseButton.layer.borderWidth = 1
        chooseButton.layer.cornerRadius = 5
        chooseButton.layer.masksToBounds = true
        chooseButton.addTarget(self, action: #selector(RecognizerController.chooseImage), for: .touchDown)
        self.view.addSubview(chooseButton)
        chooseButton.snp.makeConstraints {
            (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(self.view).dividedBy(2).offset(-15)
            make.height.equalTo(46)
        }

        let scanButton = UIButton(type: .system)
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setTitleColor(
            UIColor(red: 246.0 / 255.0, green: 137.0 / 255.0, blue: 222.0 / 255.0, alpha: 1), for: .normal
        )
        scanButton.layer.borderColor = UIColor.white.cgColor
        scanButton.layer.borderWidth = 1
        scanButton.layer.cornerRadius = 5
        scanButton.layer.masksToBounds = true
        scanButton.addTarget(self, action: #selector(RecognizerController.scanQRCode), for: .touchDown)
        self.view.addSubview(scanButton)
        scanButton.snp.makeConstraints {
            (make) in
            make.left.equalTo(chooseButton.snp.right).offset(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(chooseButton)
            make.height.equalTo(46)
        }
    }

    @objc func chooseImage() {
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

    @objc func scanQRCode() {
        if let tryImage = UIImage2CGimage(iamgeView.image) {
            var title = "Error"
            var result = "Get QRCode from image failed!"
            let codes = EFQRCodeRecognizer(image: tryImage).recognize() ?? [String]()
            if codes.count > 0 {
                title = "Success"
                result = codes[0]
                // for (index, code) in codes.enumerated() {
                //     result += "\(index): \(code)\n"
                // }
            }
            let alert = UIAlertController(title: title, message: result, preferredStyle: .alert)
            if codes.count > 0 {
                alert.addAction(UIAlertAction(title: "Copy", style: .default) { [weak self] (action) in
                    if let _ = self {
                        UIPasteboard.general.string = result
                    }
                })
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Warning", message: "Please choose image first!", preferredStyle: .alert
            )
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
