//
//  BasicGeneratorController.swift
//  iOS Example
//
//  Created by EyreFree on 2023/7/6.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import UIKit
import SnapKit
import EFColorPicker
import Photos
import EFQRCode
import MobileCoreServices

class BasicGeneratorController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

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
    var dataStyle: EFStyleBasicParamsDataStyle = .rectangle
    var dataColor: UIColor = UIColor.black
    var dataScale: CGFloat = 1
    var dataAlpha: CGFloat = 1
    var positionStyle: EFStyleParamsPositionStyle = .rectangle
    var positionThickness: CGFloat = 1
    var positionColor: UIColor = UIColor.black
    var positionAlpha: CGFloat = 1
    var alignStyle: EFStyleParamAlignStyle = .rectangle
    var alignSize: CGFloat = 1
    var alignColor: UIColor = UIColor.black
    var alignColorAlpha: CGFloat = 1
    var timingStyle: EFStyleParamTimingStyle = .rectangle
    var timingSize: CGFloat = 1
    var timingColor: UIColor = UIColor.black
    var timingColorAlpha: CGFloat = 1
    var icon: EFStyleParamImage? = nil
    var iconScale: CGFloat = 0.22
    var iconAlpha: CGFloat = 1
    var iconBorderColor: UIColor = UIColor.white
    var iconBorderAlpha: CGFloat = 1
}

extension BasicGeneratorController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Create Basic", comment: "Title on generator")
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
                    mode: .scaleAspectFill,
                    alpha: iconAlpha,
                    borderColor: iconBorderColor.withAlphaComponent(iconBorderAlpha).cgColor,
                    percentage: iconScale
                )
            }
            return nil
        }()
        
        do {
            let generator = try EFQRCode.Generator(
                content,
                encoding: .utf8,
                errorCorrectLevel: inputCorrectionLevel,
                style: EFQRCodeStyle.basic(
                    params: EFStyleBasicParams(
                        icon: paramIcon,
                        position: EFStyleBasicParamsPosition(
                            style: positionStyle,
                            size: positionThickness,
                            color: positionColor.withAlphaComponent(positionAlpha).cgColor
                        ),
                        data: EFStyleBasicParamsData(
                            style: dataStyle,
                            scale: dataScale,
                            color: dataColor.withAlphaComponent(dataAlpha).cgColor
                        ),
                        align: EFStyleBasicParamsAlign(
                            style: alignStyle,
                            size: alignSize,
                            color: alignColor.withAlphaComponent(alignColorAlpha).cgColor
                        ),
                        timing: EFStyleBasicParamsTiming(
                            style: timingStyle,
                            size: timingSize,
                            color: timingColor.withAlphaComponent(timingColorAlpha).cgColor
                        )
                    )
                )
            )
            let image: EFImage = {
                let imageWidth: CGFloat = ((generator.qrcode.model.moduleCount + 1) * 12).cgFloat
                if generator.isAnimated {
                    return EFImage.gif(try! generator.toGIFData(width: imageWidth))
                } else {
                    return EFImage.normal(try! generator.toImage(width: imageWidth))
                }
            }()
            let showVC = ShowController(image: image)
            showVC.svgString = (try? generator.toSVG()) ?? ""
            present(showVC, animated: true)
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

    func chooseDataStyle() {
        chooseFromEnum(title: Localized.Title.dataStyle, type: EFStyleBasicParamsDataStyle.self) { [weak self] result in
            guard let self = self else { return }
            
            self.dataStyle = result
            self.refresh()
        }
    }
    
    func chooseDataScale() {
        chooseFromList(title: Localized.Title.dataScale, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.dataScale = result
            self.refresh()
        }
    }
    
    func chooseDataAlpha() {
        chooseFromList(title: Localized.Title.dataAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.dataAlpha = result
            self.refresh()
        }
    }
    
    func chooseDataColor() {
        let alert = UIAlertController(
            title: Localized.Title.dataColor,
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
                    self.dataColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }

    func choosePositionStyle() {
        chooseFromEnum(title: Localized.Title.positionStyle, type: EFStyleParamsPositionStyle.self) { [weak self] result in
            guard let self = self else { return }
            
            self.positionStyle = result
            self.refresh()
        }
    }
    
    func choosePositionThickness() {
        chooseFromList(title: Localized.Title.positionThickness, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.positionThickness = result
            self.refresh()
        }
    }
    
    func choosePositionColor() {
        let alert = UIAlertController(
            title: Localized.Title.positionColor,
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
                    self.positionColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }
    
    func choosePositionAlpha() {
        chooseFromList(title: Localized.Title.positionColorAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.positionAlpha = result
            self.refresh()
        }
    }

    func chooseAlignStyle() {
        chooseFromEnum(title: Localized.Title.alignStyle, type: EFStyleParamAlignStyle.self) { [weak self] result in
            guard let self = self else { return }
            
            self.alignStyle = result
            self.refresh()
        }
    }
    
    func chooseAlignSize() {
        chooseFromList(title: Localized.Title.alignSize, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.alignSize = result
            self.refresh()
        }
    }
    
    func chooseAlignColor() {
        let alert = UIAlertController(
            title: Localized.Title.alignColor,
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
                    self.positionColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseAlignColorAlpha() {
        chooseFromList(title: Localized.Title.alignColorAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.positionAlpha = result
            self.refresh()
        }
    }
    
    func chooseTimingStyle() {
        chooseFromEnum(title: Localized.Title.timingStyle, type: EFStyleParamTimingStyle.self) { [weak self] result in
            guard let self = self else { return }
            
            self.timingStyle = result
            self.refresh()
        }
    }
    
    func chooseTimingSize() {
        chooseFromList(title: Localized.Title.timingSize, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.timingSize = result
            self.refresh()
        }
    }
    
    func chooseTimingColor() {
        let alert = UIAlertController(
            title: Localized.Title.timingColor,
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
                    self.timingColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseTimingColorAlpha() {
        chooseFromList(title: Localized.Title.timingColorAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.timingColorAlpha = result
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
                self?.customColor(4)
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

    // MARK: - UITableViewDelegate & UITableViewDataSource
    static let titles = [
        Localized.Title.inputCorrectionLevel,
        Localized.Title.dataStyle,
        Localized.Title.dataColor,
        Localized.Title.dataScale,
        Localized.Title.dataAlpha,
        Localized.Title.positionStyle,
        Localized.Title.positionThickness,
        Localized.Title.positionColor,
        Localized.Title.positionColorAlpha,
        Localized.Title.alignStyle,
        Localized.Title.alignSize,
        Localized.Title.alignColor,
        Localized.Title.alignColorAlpha,
        Localized.Title.timingStyle,
        Localized.Title.timingSize,
        Localized.Title.timingColor,
        Localized.Title.timingColorAlpha,
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
            chooseDataStyle,
            chooseDataColor,
            chooseDataScale,
            chooseDataAlpha,
            choosePositionStyle,
            choosePositionThickness,
            choosePositionColor,
            choosePositionAlpha,
            chooseAlignStyle,
            chooseAlignSize,
            chooseAlignColor,
            chooseAlignColorAlpha,
            chooseTimingStyle,
            chooseTimingSize,
            chooseTimingColor,
            chooseTimingColorAlpha,
            chooseIcon,
            chooseIconScale,
            chooseIconAlpha,
            chooseIconBorderColor,
            chooseIconBorderColorAlpha
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
            "\(dataStyle)",
            "", // dataColor
            "\(dataScale)",
            "\(dataAlpha)",
            "\(positionStyle)",
            "\(positionThickness)",
            "", // positionColor
            "\(positionAlpha)",
            "\(alignStyle)",
            "\(alignSize)",
            "", // alignColor
            "\(alignColorAlpha)",
            "\(timingStyle)",
            "\(timingSize)",
            "", // timingColor
            "\(timingColorAlpha)",
            "", // icon
            "\(iconScale)",
            "\(iconAlpha)",
            "", // iconBorderColor
            "\(iconBorderAlpha)"
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
            case 2:
                rightImageView.backgroundColor = dataColor.withAlphaComponent(dataAlpha)
            case 7:
                rightImageView.backgroundColor = positionColor.withAlphaComponent(positionAlpha)
            case 11:
                rightImageView.backgroundColor = alignColor.withAlphaComponent(alignColorAlpha)
            case 15:
                rightImageView.backgroundColor = timingColor.withAlphaComponent(timingColorAlpha)
            case 17:
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
            case 20:
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
extension BasicGeneratorController: UIColorPickerViewControllerDelegate {

    struct EFColorPicker {
        static var index: Int = 0
    }
    
    func customColor(_ index: Int) {
        EFColorPicker.index = index

        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = [dataColor, positionColor, alignColor, timingColor, iconBorderColor][EFColorPicker.index]
        colorPicker.supportsAlpha = false
        present(colorPicker, animated: true)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        dismiss(animated: true)
        refresh()
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        switch EFColorPicker.index {
        case 0:
            dataColor = color
            break
        case 1:
            positionColor = color
            break
        case 2:
            alignColor = color
            break
        case 3:
            timingColor = color
            break
        case 4:
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
extension BasicGeneratorController: UIImagePickerControllerDelegate {

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
                    let frameDelays = animatedImage.frameDelays.map({ $0.cgFloat })
                    self.icon = .animated(images: frames, imageDelays: frameDelays)
                }
            }
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
