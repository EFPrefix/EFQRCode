//
//  CreateController.swift
//  EFQRCode
//
//  Created by EyreFree on 17/1/25.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import EFQRCode

class CreateController: UIViewController, UITextViewDelegate {

    var textView: UITextView!

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

        let createButton = UIButton()
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(UIColor.black, for: .normal)
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(CreateController.createCode), for: .touchDown)
        self.view.addSubview(createButton)
        createButton.frame = CGRect(
            x: 10, y: screenSize.height - 56, width: screenSize.width - 20, height: 46
        )
    }

    func createCode() {
        if let tryImage = UIImage(
            QRCodeString: textView.text ?? "",
            size: UIScreen.main.bounds.size.width,
            iconImage: UIImage(named: "eyrefree")
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
        createButton.setTitle("返回", for: .normal)
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
