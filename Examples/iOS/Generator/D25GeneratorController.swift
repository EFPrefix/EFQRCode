//
//  D25GeneratorController.swift
//  iOS Example
//
//  Created by EyreFree on 2023/7/9.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Photos
import EFQRCode
import EFColorPicker
import MobileCoreServices

class D25GeneratorController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    #if os(iOS)
    var imagePicker: UIImagePickerController?
    #endif

    var textView: UITextView!
    var tableView: UITableView!
    var createButton: UIButton!

    var titleCurrent: String = ""
    let lastContent = StorageUserDefaults<NSString>(key: "lastContent")

    // MARK: - Param
    var inputCorrectionLevel: EFCorrectionLevel = .h
    var topColor: UIColor = UIColor.black
    var topAlpha: CGFloat = 1
    var leftColor: UIColor = UIColor.lightGray
    var leftAlpha: CGFloat = 1
    var rightColor: UIColor = UIColor.white
    var rightAlpha: CGFloat = 1
    var dataHeight: CGFloat = 2
    var positionHeight: CGFloat = 2
    var icon: EFStyleParamImage? = nil
    var iconScale: CGFloat = 0.22
    var iconAlpha: CGFloat = 1
    var iconBorderColor: UIColor = UIColor.white
    var iconBorderAlpha: CGFloat = 1
}

extension D25GeneratorController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Create 2.5D", comment: "Title on generator")
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.8117647059, blue: 0.7803921569, alpha: 1)

        setupViews()
    }

    func setupViews() {
        let buttonHeight: CGFloat = 46

        // MARK: Content
        textView = UITextView()
        textView.text = (lastContent.value as String?) ?? "https://github.com/EFPrefix/EFQRCode"
        textView.tintColor = #colorLiteral(red: 0.3803921569, green: 0.8117647059, blue: 0.7803921569, alpha: 1)
        textView.font = .systemFont(ofSize: 24)
        textView.textColor = .white
        textView.backgroundColor = UIColor.white.withAlphaComponent(0.32)
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.delegate = self
        textView.returnKeyType = .done
        view.addSubview(textView)
        textView.snp.makeConstraints {
            (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(view).offset(-10)
            make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 15)
            make.height.equalTo(view).dividedBy(3.0)
        }

        // MARK: tableView
        tableView = UITableView()
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        #if os(iOS)
        tableView.separatorColor = .white
        #endif
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            (make) in
            make.leading.equalTo(0)
            make.top.equalTo(textView.snp.bottom)
            make.width.equalTo(view)
        }

        createButton = UIButton(type: .system)
        createButton.setTitle(title, for: .normal)
        createButton.setTitleColor(#colorLiteral(red: 0.9647058824, green: 0.537254902, blue: 0.8705882353, alpha: 1), for: .normal)
        createButton.backgroundColor = UIColor.white.withAlphaComponent(0.32)
        createButton.layer.borderColor = UIColor.white.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.cornerRadius = 5
        createButton.layer.masksToBounds = true
        #if os(iOS)
        createButton.addTarget(self, action: #selector(createCode), for: .touchDown)
        #else
        createButton.addTarget(self, action: #selector(createCode), for: .primaryActionTriggered)
        #endif
        view.addSubview(createButton)
        createButton.snp.makeConstraints {
            (make) in
            make.leading.trailing.equalTo(textView)
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(-10)
        }
    }

    #if os(iOS)
    override func viewWillLayoutSubviews() {
        textView.snp.updateConstraints {
            (make) in
            make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self) + 15)
            if #available(iOS 11.0, *) {
                make.leading.equalTo(max(view.safeAreaInsets.left, 10))
                make.trailing.equalTo(view).offset(-max(view.safeAreaInsets.right, 10))
            }
        }
        if #available(iOS 11.0, *) {
            createButton.snp.updateConstraints {
                (make) in
                make.bottom.equalTo(-max(10, view.safeAreaInsets.bottom))
            }
        }
        super.viewWillLayoutSubviews()
    }
    #endif

    func refresh() {
        tableView.reloadData()
    }

    @objc func createCode() {
        // Lock user activity
        createButton.isEnabled = false
        // Recover user activity
        defer { createButton.isEnabled = true }

        let content = textView.text ?? ""
        lastContent.value = content as NSString

        let paramIcon: EFStyleParamIcon? = {
            if let icon = self.icon {
                return EFStyleParamIcon(
                    image: icon,
                    percentage: iconScale,
                    alpha: iconAlpha,
                    borderColor: iconBorderColor.withAlphaComponent(iconBorderAlpha).cgColor
                )
            }
            return nil
        }()
        
        do {
            let generator = try EFQRCode.Generator(
                content,
                encoding: .utf8,
                errorCorrectLevel: inputCorrectionLevel,
                style: EFQRCodeStyle.d25(
                    params: EFStyle25DParams(
                        icon: paramIcon,
                        dataHeight: dataHeight,
                        positionHeight: positionHeight,
                        topColor: topColor.cgColor,
                        leftColor: leftColor.cgColor,
                        rightColor: rightColor.cgColor
                    )
                )
            )
            let image: EFImage = {
                let imageSize = CGSize(length: 1024)
                if generator.isAnimated {
                    return EFImage.gif(try! generator.toGIFData(size: imageSize))
                } else {
                    return EFImage.normal(try! generator.toImage(size: imageSize))
                }
            }()
            present(ShowController(image: image), animated: true)
        } catch {
            let alert = UIAlertController(
                title: Localized.error,
                message: error.localizedDescription,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Localized.ok, style: .cancel))
            present(alert, animated: true)
        }
    }

    // UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 键盘提交
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func chooseInputCorrectionLevel() {
        chooseFromEnum(title: Localized.Title.inputCorrectionLevel, type: EFCorrectionLevel.self) { [weak self] result in
            guard let self = self else { return }
            
            self.inputCorrectionLevel = result
            self.refresh()
        }
    }
    
    func chooseTopColor() {
        let alert = UIAlertController(
            title: Localized.Title.topColor,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: Localized.cancel, style: .cancel)
        )
        #if os(iOS)
        alert.addAction(
            UIAlertAction(title: Localized.custom, style: .default) {
                [weak self] _ in
                self?.customColor(0)
            }
        )
        #endif
        for color in Localized.Parameters.colors {
            alert.addAction(
                UIAlertAction(title: color.name, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.topColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }
    
    func chooseLeftColor() {
        let alert = UIAlertController(
            title: Localized.Title.leftColor,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: Localized.cancel, style: .cancel)
        )
        #if os(iOS)
        alert.addAction(
            UIAlertAction(title: Localized.custom, style: .default) {
                [weak self] _ in
                self?.customColor(1)
            }
        )
        #endif
        for color in Localized.Parameters.colors {
            alert.addAction(
                UIAlertAction(title: color.name, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.leftColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }
    
    func chooseRightColor() {
        let alert = UIAlertController(
            title: Localized.Title.rightColor,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: Localized.cancel, style: .cancel)
        )
        #if os(iOS)
        alert.addAction(
            UIAlertAction(title: Localized.custom, style: .default) {
                [weak self] _ in
                self?.customColor(2)
            }
        )
        #endif
        for color in Localized.Parameters.colors {
            alert.addAction(
                UIAlertAction(title: color.name, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.rightColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseDataHeight() {
        chooseFromList(title: Localized.Title.dataHeight, items: [0, 1, 2, 3, 4, 5]) { [weak self] result in
            guard let self = self else { return }
            
            self.dataHeight = result
            self.refresh()
        }
    }
    
    func choosePositionHeight() {
        chooseFromList(title: Localized.Title.positionHeight, items: [0, 1, 2, 3, 4, 5]) { [weak self] result in
            guard let self = self else { return }
            
            self.positionHeight = result
            self.refresh()
        }
    }

    func chooseIcon() {
        let alert = UIAlertController(
            title: Localized.Title.icon,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: Localized.cancel, style: .cancel)
        )
        alert.addAction(
            UIAlertAction(title: Localized.none, style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.icon = nil
                self.refresh()
            }
        )
        #if os(iOS)
        alert.addAction(
            UIAlertAction(title: Localized.chooseImage, style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.chooseImageFromAlbum(title: Localized.Title.icon)
                self.refresh()
            }
        )
        #endif
        for (index, icon) in Localized.Parameters.iconNames.enumerated() {
            alert.addAction(
                UIAlertAction(title: icon, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    
                    if let cgImage = UIImage(named: ["EyreFree", "GitHub", "Pikachu", "Swift"][index])?.cgImage {
                        self.icon = EFStyleParamImage.static(image: cgImage)
                        self.refresh()
                    }
                }
            )
        }
        popActionSheet(alert: alert)
    }
    
    func chooseIconScale() {
        chooseFromList(title: Localized.Title.iconScale, items: [0, 0.11, 0.22, 0.33]) { [weak self] result in
            guard let self = self else { return }
            
            self.iconScale = result
            self.refresh()
        }
    }
    
    func chooseIconAlpha() {
        chooseFromList(title: Localized.Title.iconAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.iconAlpha = result
            self.refresh()
        }
    }
    
    func chooseIconBorderColor() {
        let alert = UIAlertController(
            title: Localized.Title.iconBorderColor,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: Localized.cancel, style: .cancel)
        )
        #if os(iOS)
        alert.addAction(
            UIAlertAction(title: Localized.custom, style: .default) {
                [weak self] _ in
                self?.customColor(3)
            }
        )
        #endif
        for color in Localized.Parameters.colors {
            alert.addAction(
                UIAlertAction(title: color.name, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.iconBorderColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }
    
    func chooseIconBorderColorAlpha() {
        chooseFromList(title: Localized.Title.iconBorderAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.iconBorderAlpha = result
            self.refresh()
        }
    }
    
    func chooseTopColorAlpha() {
        chooseFromList(title: Localized.Title.topColorAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.topAlpha = result
            self.refresh()
        }
    }
    
    func chooseLeftColorAlpha() {
        chooseFromList(title: Localized.Title.leftColorAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.leftAlpha = result
            self.refresh()
        }
    }
    
    func chooseRightColorAlpha() {
        chooseFromList(title: Localized.Title.rightColorAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.rightAlpha = result
            self.refresh()
        }
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    static let titles = [
        Localized.Title.inputCorrectionLevel,
        Localized.Title.topColor,
        Localized.Title.topColorAlpha,
        Localized.Title.leftColor,
        Localized.Title.leftColorAlpha,
        Localized.Title.rightColor,
        Localized.Title.rightColorAlpha,
        Localized.Title.dataHeight,
        Localized.Title.positionHeight,
        Localized.Title.icon,
        Localized.Title.iconScale,
        Localized.Title.iconAlpha,
        Localized.Title.iconBorderColor,
        Localized.Title.iconBorderAlpha,
    ]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        [
            chooseInputCorrectionLevel,
            chooseTopColor,
            chooseTopColor,
            chooseLeftColor,
            chooseLeftColor,
            chooseRightColor,
            chooseRightColor,
            chooseDataHeight,
            choosePositionHeight,
            chooseIcon,
            chooseIconScale,
            chooseIconAlpha,
            chooseIconBorderColor,
            chooseIconBorderColorAlpha,
        ][indexPath.row]()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Self.titles.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zeroHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zeroHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailArray = [
            "\(inputCorrectionLevel)",
            "", // topColor
            "\(topAlpha)",
            "", // leftColor
            "\(leftAlpha)",
            "", // rightColor
            "\(rightAlpha)",
            "\(dataHeight)",
            "\(positionHeight)",
            "", // icon
            "\(iconScale)",
            "\(iconAlpha)",
            "", // iconBorderColor
            "\(iconBorderAlpha)",
        ]

        let cell = UITableViewCell(style: detailArray[indexPath.row] == "" ? .default : .value1, reuseIdentifier: nil)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.textLabel?.text = Self.titles[indexPath.row]
        cell.detailTextLabel?.text = detailArray[indexPath.row]
        let backView = UIView()
        backView.backgroundColor = UIColor.white.withAlphaComponent(0.64)
        cell.selectedBackgroundView = backView

        if detailArray[indexPath.row] == "" {
            let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            #if os(iOS)
            if #available(iOS 11.0, *) {
                rightImageView.accessibilityIgnoresInvertColors = true
            }
            #endif
            rightImageView.contentMode = .scaleAspectFit
            rightImageView.layer.borderColor = UIColor.white.cgColor
            rightImageView.layer.borderWidth = 0.5
            cell.contentView.addSubview(rightImageView)
            cell.accessoryView = rightImageView

            switch indexPath.row {
            case 1:
                rightImageView.backgroundColor = topColor.withAlphaComponent(topAlpha)
            case 3:
                rightImageView.backgroundColor = leftColor.withAlphaComponent(leftAlpha)
            case 5:
                rightImageView.backgroundColor = rightColor.withAlphaComponent(rightAlpha)
            case 9:
                switch icon {
                case .static(let image):
                    rightImageView.image = UIImage(cgImage: image)
                    break
                case .animated(let images, _):
                    rightImageView.image = UIImage(cgImage: images[0])
                    break
                case .none:
                    rightImageView.image = nil
                    break
                }
            case 12:
                rightImageView.backgroundColor = iconBorderColor.withAlphaComponent(iconBorderAlpha)
            default:
                break
            }
        }
        return cell
    }
}

#if os(iOS)
// MARK: - EFColorPicker
extension D25GeneratorController: UIPopoverPresentationControllerDelegate, EFColorSelectionViewControllerDelegate {

    struct EFColorPicker {
        static var colorIndex = 0
    }

    func customColor(_ colorIndex: Int) {

        EFColorPicker.colorIndex = colorIndex

        let colorSelectionController = EFColorSelectionViewController()
        let navCtrl = UINavigationController(rootViewController: colorSelectionController)
        navCtrl.navigationBar.backgroundColor = .white
        navCtrl.navigationBar.isTranslucent = false
        navCtrl.modalPresentationStyle = .popover
        navCtrl.popoverPresentationController?.delegate = self
        navCtrl.popoverPresentationController?.sourceView = tableView
        navCtrl.popoverPresentationController?.sourceRect = tableView.bounds
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )

        colorSelectionController.isColorTextFieldHidden = false
        colorSelectionController.delegate = self
        colorSelectionController.color = [topColor, leftColor, rightColor, iconBorderColor][colorIndex]

        if .compact == traitCollection.horizontalSizeClass {
            let doneBtn = UIBarButtonItem(
                title: Localized.done,
                style: .done,
                target: self,
                action: #selector(ef_dismissViewController(sender:))
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }
        present(navCtrl, animated: true)
    }
    
    // Private
    @objc private func ef_dismissViewController(sender: UIBarButtonItem) {
        dismiss(animated: true)
        refresh()
    }

    // MARK: EFColorViewDelegate
    func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        switch EFColorPicker.colorIndex {
        case 0:
            topColor = color
            break
        case 1:
            leftColor = color
            break
        case 2:
            rightColor = color
            break
        case 3:
            iconBorderColor = color
            break
        default:
            break
        }
        refresh()
    }
}
#endif

#if os(iOS)
extension D25GeneratorController: UIImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var finalImage: UIImage?
        if let tryImage = info[.editedImage] as? UIImage {
            finalImage = tryImage
        } else if let tryImage = info[.originalImage] as? UIImage {
            finalImage = tryImage
        } else {
            print(Localized.errored)
        }

        switch titleCurrent {
        case Localized.Title.icon:
            if let finalImage = finalImage?.cgImage {
                icon = .static(image: finalImage)
            } else {
                icon = nil
            }
            
            var images = [Ref<EFImage?>]()
            if let imageUrl = info[.referenceURL] as? URL,
                let asset = PHAsset.fetchAssets(withALAssetURLs: [imageUrl], options: nil).lastObject {
                images = selectedAlbumPhotosIncludingGifWithPHAssets(assets: [asset])
            }
            if let tryGIF = images.first(where: { $0.value?.isGIF == true }) {
                if case .gif(let data) = tryGIF.value {
                    if let animatedImage = AnimatedImage(data: data, format: .gif) {
                        let frames = animatedImage.frames.compactMap { return $0 }
                        let duration = animatedImage.duration
                        self.icon = .animated(images: frames, duration: duration)
                    }
                }
            }
        default:
            break
        }
        refresh()

        picker.dismiss(animated: true)
    }

    /// 选择相册图片（包括 GIF 图片）
    /// http://www.jianshu.com/p/ad391f4d0bcb
    func selectedAlbumPhotosIncludingGifWithPHAssets(assets: [PHAsset]) -> [Ref<EFImage?>] {
        var imageArray = [Ref<EFImage?>]()

        let targetSize = CGSize(width: 1024, height: 1024)

        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.isSynchronous = true

        let imageManager = PHCachingImageManager()
        for asset in assets {
            imageManager.requestImageData(for: asset, options: options) {
                [weak self] (imageData, dataUTI, orientation, info) in
                guard self != nil else { return }
                print("dataUTI: \(dataUTI ?? Localized.none)")

                let imageElement: Ref<EFImage?> = nil

                if kUTTypeGIF as String == dataUTI {
                    // MARK: GIF
                    if let imageData = imageData {
                        imageElement.value = .gif(imageData)
                    }
                } else {
                    // MARK: 其他格式的图片，直接请求压缩后的图片
                    imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) {
                        [weak self] (result, info) in
                        guard self != nil,
                            let result = result,
                            let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool,
                            !isDegraded
                            else { return }
                        // 得到一张 UIImage，展示到界面上
                        imageElement.value = .normal(result)
                    }
                }

                imageArray.append(imageElement)
            }
        }
        return imageArray
    }

    func chooseImageFromAlbum(title: String) {
        titleCurrent = title

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
}
#endif
