//
//  MoreViewController.swift
//  iOS Example
//
//  Created by EyreFree on 2023/6/22.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("More", comment: "Title on about")
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.8117647059, blue: 0.7803921569, alpha: 1)
        
        setupControls()
    }
    
    func setupControls() {
        let iconImageViewSize: CGFloat = 120
        let iconImageView: UIImageView = UIImageView()
        iconImageView.contentMode = UIView.ContentMode.scaleAspectFit
        iconImageView.image = UIImage(named: "EFQRCoder")
        iconImageView.layer.borderColor = UIColor.white.cgColor
        iconImageView.layer.borderWidth = 0.5
        iconImageView.layer.cornerRadius = 180.0 / 1024.0 * iconImageViewSize
        iconImageView.clipsToBounds = true
        self.view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(iconImageViewSize)
            make.centerX.equalTo(self.view)
            make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 36)
        }
        
        let labelTitle: UILabel = UILabel()
        labelTitle.text = "EFQRCoder"
        labelTitle.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        labelTitle.textColor = UIColor.white
        labelTitle.numberOfLines = 2
        labelTitle.textAlignment = .center
        self.view.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (make) in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
        }
        
        let downloadButtonHeight: CGFloat = 56
        let downloadButton: UIButton = UIButton(type: .custom)
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(UIColor.white, for: .normal)
        downloadButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        downloadButton.addTarget(self, action: #selector(openDownload), for: .touchUpInside)
        downloadButton.layer.borderColor = UIColor.white.cgColor
        downloadButton.layer.borderWidth = 1
        downloadButton.layer.cornerRadius = downloadButtonHeight / 2
        self.view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { (make) in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.bottom.equalTo(-CGFloat.bottomSafeArea())
            make.height.equalTo(downloadButtonHeight)
        }
        
        let labelTip: UITextView = UITextView()
        labelTip.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        labelTip.textColor = UIColor.white
        labelTip.textAlignment = .left
        labelTip.backgroundColor = UIColor.clear
        labelTip.alwaysBounceVertical = true
        labelTip.isEditable = false
        labelTip.text = "We recommend you to try our pro version - EFQRCoder, you can get the following:\n\n- Support more kinds of barcode & 2D code;\n- More user-friendly scanner;\n- Support recognition history;\n- More beautiful user interface;\n- Multi-language adaptation;\n- More recognition and generation options;\n- More timely customer support;\n- Support the development of EFQRCode;\n- Etc.\n\nAnyway, thank you very much for using our products!"
        self.view.addSubview(labelTip)
        labelTip.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(labelTitle.snp.bottom).offset(20)
            make.bottom.equalTo(downloadButton.snp.top).offset(-20)
        }
    }
    
    @objc func openDownload() {
        if let tryUrl = URL(string: "https://apps.apple.com/app/id1242936516") {
            if #available(iOS 10.0, tvOS 10.0, *) {
                UIApplication.shared.open(tryUrl)
            } else {
                UIApplication.shared.openURL(tryUrl)
            }
        }
    }
}
