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

    var imageView: UIImageView!
    var chooseButton: UIButton!
    var scanButton: UIButton!
    var imagePicker: UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Scan"
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)

        setupViews()
    }

    func setupViews() {
        imageView = UIImageView()
        if #available(iOS 11.0, *) {
            imageView.accessibilityIgnoresInvertColors = true
        }
        imageView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.32)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(view).offset(-10)
            make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 15)
        }

        chooseButton = UIButton(type: .system)
        chooseButton.setTitle("Choose image", for: .normal)
        chooseButton.setTitleColor(.white, for: .normal)
        chooseButton.layer.borderColor = UIColor.white.cgColor
        chooseButton.layer.borderWidth = 1
        chooseButton.layer.cornerRadius = 5
        chooseButton.layer.masksToBounds = true
        chooseButton.addTarget(self, action: #selector(chooseImage), for: .touchDown)
        view.addSubview(chooseButton)
        chooseButton.snp.makeConstraints {
            (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalTo(imageView)
            make.bottom.equalTo(-10)
            make.height.equalTo(46)
        }

        scanButton = UIButton(type: .system)
        scanButton.isEnabled = false
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setTitleColor(
            UIColor(red: 246.0 / 255.0, green: 137.0 / 255.0, blue: 222.0 / 255.0, alpha: 1), for: .normal
        )
        scanButton.setTitleColor(
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.32), for: .disabled
        )
        scanButton.layer.borderColor = UIColor.white.cgColor
        scanButton.layer.borderWidth = 1
        scanButton.layer.cornerRadius = 5
        scanButton.layer.masksToBounds = true
        scanButton.addTarget(self, action: #selector(scanQRCode), for: .touchDown)
        view.addSubview(scanButton)
        scanButton.snp.makeConstraints {
            (make) in
            make.leading.equalTo(chooseButton.snp.trailing).offset(10)
            make.trailing.equalTo(imageView)
            make.width.bottom.height.equalTo(chooseButton)
        }
    }
    
    override func viewWillLayoutSubviews() {
        imageView.snp.updateConstraints {
            (make) in
            make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 15)
            if #available(iOS 11.0, *) {
                make.leading.equalTo(max(view.safeAreaInsets.left, 10))
                make.trailing.equalTo(view).offset(-max(view.safeAreaInsets.right, 10))
            }
        }
        if #available(iOS 11.0, *) {
            chooseButton.snp.updateConstraints {
                (make) in
                make.bottom.equalTo(-max(view.safeAreaInsets.bottom, 10))
            }
        }
        super.viewWillLayoutSubviews()
    }

    @objc func chooseImage() {
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

    @objc func scanQRCode() {
        if let tryImage = UIImage2CGimage(imageView.image) {
            let codes = EFQRCodeRecognizer(image: tryImage).recognize() ?? []
            let title = codes.isEmpty ? "Error" : "Success"
            let result = codes.first ?? "Get QRCode from image failed!"
            // for (index, code) in codes.enumerated() {
            //     result += "\(index): \(code)\n"
            // }
            let alert = UIAlertController(title: title, message: result, preferredStyle: .alert)
            if !codes.isEmpty {
                alert.addAction(UIAlertAction(title: "Copy", style: .default) { [weak self] (action) in
                    if self != nil {
                        UIPasteboard.general.string = result
                    }
                })
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(
                title: "Warning", message: "Please choose image first!", preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let tryImage = info[.editedImage] as? UIImage {
            imageView.image = tryImage
        } else if let tryImage = info[.originalImage] as? UIImage {
            imageView.image = tryImage
        } else {
            print("Something went wrong")
        }
        scanButton.isEnabled = nil != imageView.image
        scanButton.backgroundColor = scanButton.isEnabled
            ? UIColor(red: 1, green: 1, blue: 1, alpha: 0.32)
            : .clear
        
        picker.dismiss(animated: true)
    }
}
