//
//  ShowController.swift
//  iOS Example
//
//  Created by EyreFree on 2023/7/6.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import UIKit
import Photos

// MARK: - QRCode Display

extension ShowController {
    convenience init(image: EFImage?) {
        self.init()
        self.image = image
    }
}

class ShowController: UIViewController {

    private(set) var image: EFImage?
    var svgString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.8117647059, blue: 0.7803921569, alpha: 1)
        setupViews()
        
        if let image = image {
            switch image {
            case .gif(let dataGIF):
                imageView.loadGif(data: dataGIF)
            case .normal(let uiImage):
                imageView.image = uiImage
            }
        }
    }

    let imageView = UIImageView()
    let backButton = UIButton(type: .system)
    #if os(iOS)
    let saveButton = UIButton(type: .system)
    let copyButton = UIButton(type: .system)
    #endif
    
    func setupViews() {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "transparentHolder")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        view.addSubview(backgroundImageView)
        
        #if os(iOS)
        if #available(iOS 11.0, *) {
            imageView.accessibilityIgnoresInvertColors = true
        }
        #endif
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.64)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.clear
        view.addSubview(imageView)
        backgroundImageView.snp.makeConstraints {
            (make) in
            make.left.right.top.bottom.equalTo(imageView)
        }
        
        backButton.setTitle(Localized.back, for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 5
        backButton.layer.masksToBounds = true
        view.addSubview(backButton)

        #if os(iOS)
        copyButton.setTitle(Localized.copy, for: .normal)
        copyButton.setTitleColor(UIColor.white, for: .normal)
        copyButton.layer.borderColor = UIColor.white.cgColor
        copyButton.layer.borderWidth = 1
        copyButton.layer.cornerRadius = 5
        copyButton.layer.masksToBounds = true
        copyButton.addTarget(self, action: #selector(copyAction), for: .primaryActionTriggered)
        view.addSubview(copyButton)
        copyButton.snp.makeConstraints {
            (make) in
            make.leading.width.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.height.equalTo(46)
        }
        
        saveButton.setTitle(Localized.save, for: .normal)
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
            make.top.equalTo(copyButton.snp.bottom).offset(10)
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
                var height: CGFloat = -max(20, view.safeAreaInsets.bottom)
                height = height - 46 - 10 - 46 - 10 - top
                make.height.lessThanOrEqualTo(view.snp.height).offset(height)
            }
        }
        super.viewWillLayoutSubviews()
    }

    @objc func saveToAlbum() {
        guard let tryImage = image else { return }
        CustomPhotoAlbum.save(image: tryImage) {
            [weak self] (issue) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: issue == nil ? Localized.success : Localized.error,
                    message: issue ?? NSLocalizedString("Save finished.", comment: "Image successfuly saved to photos"),
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: Localized.ok, style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }
    #endif

    @objc func back() {
        dismiss(animated: true)
    }
    
#if os(iOS)
    @objc func copyAction() {
        UIPasteboard.general.string = svgString
    }
#endif
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
        case .authorized, .limited:
            if let assetCollection = fetchAssetCollectionForAlbum() {
                save(image: image, to: assetCollection, finish: finish)
            } else {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                }, completionHandler: { (success, error) in
                    if success {
                        save(image: image, finish: finish)
                    } else {
                        finish(error?.localizedDescription ??
                            NSLocalizedString("Can't create photo album", comment: ""))
                    }
                })
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { _ in
                save(image: image, finish: finish)
            }
        case .restricted:
            finish(NSLocalizedString("You can't grant access to the photo library.", comment: ""))
        case .denied:
            finish(NSLocalizedString("You didn't grant access to the photo library.", comment: ""))
        @unknown default:
            finish(Localized.errored)
        }
    }
    
    private static func save(image: EFImage, to assetCollection: PHAssetCollection,
                             finish: @escaping ((_ error: String?) -> Void)) {
        var errored = false
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest: PHAssetChangeRequest?
            switch image {
            case .gif(let data):
                guard let documentsDirectoryURL = try? FileManager.default
                        .url(for: .documentDirectory, in: .userDomainMask,
                             appropriateFor: nil, create: true)
                else {
                        finish(NSLocalizedString("Can't create a temporary gif file for export",
                                                 comment: "FileURL is nil"))
                        errored = true
                        return
                }
                let fileURL = documentsDirectoryURL.appendingPathComponent("EFQRCode_temp.gif")
                try? data.write(to: fileURL)
                assetChangeRequest = .creationRequestForAssetFromImage(atFileURL: fileURL)
            case .normal(let image):
                assetChangeRequest = .creationRequestForAsset(from: image)
            }
            if let assetPlaceHolder = assetChangeRequest?.placeholderForCreatedAsset {
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                albumChangeRequest?.addAssets([assetPlaceHolder] as NSFastEnumeration)
            } else {
                finish(NSLocalizedString("Can't create a placeholder to export gif to", comment: "PlaceholderForCreatedAsset is nil!"))
                errored = true
            }
        }, completionHandler: { (success, error) in
            if errored { return }
            if success {
                finish(nil)
            } else {
                finish(error?.localizedDescription ?? Localized.error)
            }
        })
    }
}
#endif
