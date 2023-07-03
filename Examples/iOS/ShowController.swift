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
#if os(tvOS)
import SDWebImage
#else
import WebKit
#endif

// MARK: - QRCode Display

extension ShowController {
    convenience init(image: EFImage?) {
        self.init()
        self.image = image
    }
    
    convenience init(svg: String?) {
        self.init()
        self.svg = svg
        
        // print(svg!)
    }
}

class ShowController: UIViewController {

    private(set) var image: EFImage?
    private(set) var svg: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.8117647059, blue: 0.7803921569, alpha: 1)
        setupViews()
        
        if let image = image {
            imageView.isHidden = false
            #if os(tvOS)

            #else
            webView.isHidden = true
            #endif
            
            switch image {
            case .gif(let dataGIF):
                imageView.ef.loadGif(data: dataGIF)
            case .normal(let uiImage):
                imageView.image = uiImage
            }
        } else if let svg = svg {
            #if os(tvOS)
            imageView.isHidden = false
            if let svgURL = saveSvgStringToTemporaryFile(svgString: svg) {
                let bitmapSize = CGSize(width: 512, height: 512)
                imageView.sd_setImage(with: svgURL, placeholderImage: nil, options: [], context: [.imageThumbnailPixelSize : bitmapSize])
            }
            #else
            imageView.isHidden = true
            webView.isHidden = false
            webView.loadHTMLString(svg, baseURL: nil)
            #endif
        }
    }

    #if os(tvOS)
    
    #else
    let webView = WKWebView()
    #endif
    let imageView = UIImageView()
    let backButton = UIButton(type: .system)
    #if os(iOS)
    let saveButton = UIButton(type: .system)
    #endif
    
    func setupViews() {
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
        imageView.backgroundColor = UIColor.white
        view.addSubview(imageView)
        
        #if os(tvOS)

        #else
        webView.scrollView.bounces = false
        webView.scrollView.bouncesZoom = false
        view.addSubview(webView)
        #endif
        
        backButton.setTitle(Localized.back, for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 5
        backButton.layer.masksToBounds = true
        view.addSubview(backButton)

        #if os(iOS)
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
        
        #if os(tvOS)

        #else
        webView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(imageView)
        }
        #endif

        saveButton.addTarget(self, action: #selector(saveToAlbum), for: .touchDown)
        saveButton.snp.makeConstraints {
            (make) in
            make.leading.width.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(10)
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
            let alert = UIAlertController(
                title: issue == nil ? Localized.success : Localized.error,
                message: issue ?? NSLocalizedString("Save finished.", comment: "Image successfuly saved to photos"),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: Localized.ok, style: .cancel))
            self.present(alert, animated: true)
        }
    }
    #endif

    @objc func back() {
        dismiss(animated: true)
    }
    
    func saveSvgStringToTemporaryFile(svgString: String) -> URL? {
        guard let data = svgString.data(using: .utf8) else {
            return nil
        }
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("svg")
        do {
            try data.write(to: temporaryFileURL, options: [])
            return temporaryFileURL
        } catch {
            print("Save SVG error: \(error)")
            return nil
        }
    }
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
