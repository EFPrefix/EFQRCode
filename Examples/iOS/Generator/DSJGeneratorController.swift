//
//  DSJGeneratorController.swift
//  iOS Example
//
//  Created by EyreFree on 2023/7/7.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Photos
import EFQRCode
import MobileCoreServices

class DSJGeneratorController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

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
    var dataThickness: CGFloat = 0.7
    var dataXThickness: CGFloat = 0.7
    var horizontalLineColor: UIColor = UIColor(hexRGB: 0xF6B506)
    var horizontalLineColorAlpha: CGFloat = 1
    var verticalLineColor: UIColor = UIColor(hexRGB: 0xE02020)
    var verticalLineColorAlpha: CGFloat = 1
    var xColor: UIColor = UIColor(hexRGB: 0x0B2D97)
    var xColorAlpha: CGFloat = 1
    var positionStyle: EFStyleParamsPositionStyle = .dsj
    var positionThickness: CGFloat = 0.9
    var positionColor: UIColor = UIColor(hexRGB: 0x0B2D97)
    var positionAlpha: CGFloat = 1
    var icon: EFStyleParamImage? = nil
    var iconScale: CGFloat = 0.22
    var iconAlpha: CGFloat = 1
    var iconBorderColor: UIColor = UIColor.white
    var iconBorderAlpha: CGFloat = 1
    // Backdrop
    var backdropCornerRadius: CGFloat = 0
    var backdropColor: UIColor = UIColor.white
    var backdropColorAlpha: CGFloat = 1
    var backdropImage: CGImage? = nil
    var backdropImageAlpha: CGFloat = 1
    var backdropImageMode: EFImageMode = .scaleAspectFill
    var backdropQuietzone: CGFloat? = nil
}

extension DSJGeneratorController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Create DSJ", comment: "Title on generator")
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
        
        let backdropImage: EFStyleParamBackdropImage? = {
            if let backdropImage = self.backdropImage {
                return EFStyleParamBackdropImage(image: backdropImage, alpha: backdropImageAlpha, mode: backdropImageMode)
            }
            return nil
        }()
        
        let backdropQuietzone: EFEdgeInsets? = {
            if let backdropQuietzone = self.backdropQuietzone {
                return EFEdgeInsets(top: backdropQuietzone, left: backdropQuietzone, bottom: backdropQuietzone, right: backdropQuietzone)
            }
            return nil
        }()
        
        do {
            let generator = try EFQRCode.Generator(
                content,
                encoding: .utf8,
                errorCorrectLevel: inputCorrectionLevel,
                style: EFQRCodeStyle.dsj(
                    params: EFStyleDSJParams(
                        icon: paramIcon,
                        backdrop: EFStyleParamBackdrop(
                            cornerRadius: backdropCornerRadius,
                            color: backdropColor.withAlphaComponent(backdropColorAlpha).cgColor,
                            image: backdropImage,
                            quietzone: backdropQuietzone
                        ),
                        position: EFStyleDSJParamsPosition(
                            style: positionStyle,
                            size: positionThickness,
                            color: positionColor.withAlphaComponent(positionAlpha).cgColor
                        ),
                        data: EFStyleDSJParamsData(
                            lineSize: dataThickness,
                            xSize: dataXThickness,
                            horizontalLineColor: horizontalLineColor.withAlphaComponent(horizontalLineColorAlpha).cgColor,
                            verticalLineColor: verticalLineColor.withAlphaComponent(verticalLineColorAlpha).cgColor,
                            xColor: xColor.withAlphaComponent(xColorAlpha).cgColor
                        )
                    )
                )
            )
            let image: EFImage = {
                let imageWidth: CGFloat = CGFloat((generator.qrcode.model.moduleCount + 1) * 12)
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
    
    func chooseDataThickness() {
        chooseFromList(title: Localized.Title.dataThickness, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.dataThickness = result
            self.refresh()
        }
    }
    
    func chooseDataXThickness() {
        chooseFromList(title: Localized.Title.dataXThickness, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.dataXThickness = result
            self.refresh()
        }
    }
    
    func chooseHorizontalLineColor() {
        let alert = UIAlertController(
            title: Localized.Title.horizontalLineColor,
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
                    self.horizontalLineColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseHorizontalLineColorAlpha() {
        chooseFromList(title: Localized.Title.horizontalLineColorAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.horizontalLineColorAlpha = result
            self.refresh()
        }
    }
    
    func chooseVerticalLineColor() {
        let alert = UIAlertController(
            title: Localized.Title.verticalLineColor,
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
                    self.verticalLineColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseVerticalLineColorAlpha() {
        chooseFromList(title: Localized.Title.verticalLineColorAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.verticalLineColorAlpha = result
            self.refresh()
        }
    }
    
    func chooseXColor() {
        let alert = UIAlertController(
            title: Localized.Title.xColor,
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
                    self.xColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }

    func chooseXColorAlpha() {
        chooseFromList(title: Localized.Title.xColorAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.xColorAlpha = result
            self.refresh()
        }
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
                self?.customColor(3)
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
    
    // Backdrop
    func chooseBackdropCornerRadius() {
        chooseFromList(title: Localized.Title.backdropCornerRadius, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.backdropCornerRadius = result
            self.refresh()
        }
    }
    
    func chooseBackdropColor() {
        let alert = UIAlertController(
            title: Localized.Title.backdropColor,
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
                self?.customColor(5)
            }
        )
        #endif
        for color in Localized.Parameters.colors {
            alert.addAction(
                UIAlertAction(title: color.name, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    self.backdropColor = color.color
                    self.refresh()
                }
            )
        }
        popActionSheet(alert: alert)
    }
    
    func chooseBackdropColorAlpha() {
        chooseFromList(title: Localized.Title.alignColorAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.backdropColorAlpha = result
            self.refresh()
        }
    }
    
    func chooseBackdropImage() {
        let alert = UIAlertController(
            title: Localized.Title.backdropImage,
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
                self.backdropImage = nil
                self.refresh()
            }
        )
        #if os(iOS)
        alert.addAction(
            UIAlertAction(title: Localized.chooseImage, style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.chooseImageFromAlbum(title: Localized.Title.backdropImage)
                self.refresh()
            }
        )
        #endif
        for (index, icon) in Localized.Parameters.watermarkNames.enumerated() {
            alert.addAction(
                UIAlertAction(title: icon, style: .default) {
                    [weak self] _ in
                    guard let self = self else { return }
                    
                    if let cgImage = UIImage(named: Localized.Parameters.watermarkNames[index])?.cgImage {
                        self.backdropImage = cgImage
                        self.refresh()
                    }
                }
            )
        }
        popActionSheet(alert: alert)
    }
    
    func chooseBackdropImageAlpha() {
        chooseFromList(title: Localized.Title.backdropImageAlpha, items: [0, 0.25, 0.5, 0.75, 1]) { [weak self] result in
            guard let self = self else { return }
            
            self.backdropImageAlpha = result
            self.refresh()
        }
    }
    
    func chooseBackdropImageMode() {
        chooseFromEnum(title: Localized.Title.backdropImageMode, type: EFImageMode.self) { [weak self] result in
            guard let self = self else { return }
            
            self.backdropImageMode = result
            self.refresh()
        }
    }
    
    func chooseBackdropQuietzone() {
        chooseFromList(title: Localized.Title.backdropQuietzone, items: ["nil", "0", "0.25", "0.5", "0.75", "1"]) { [weak self] result in
            guard let self = self else { return }
            
            if let double = Double(result) {
                self.backdropQuietzone = CGFloat(double)
            } else {
                self.backdropQuietzone = nil
            }
            self.refresh()
        }
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    static let titles = [
        Localized.Title.inputCorrectionLevel,
        Localized.Title.dataThickness,
        Localized.Title.dataXThickness,
        Localized.Title.horizontalLineColor,
        Localized.Title.horizontalLineColorAlpha,
        Localized.Title.verticalLineColor,
        Localized.Title.verticalLineColorAlpha,
        Localized.Title.xColor,
        Localized.Title.xColorAlpha,
        Localized.Title.positionStyle,
        Localized.Title.positionThickness,
        Localized.Title.positionColor,
        Localized.Title.positionColorAlpha,
        Localized.Title.icon,
        Localized.Title.iconScale,
        Localized.Title.iconAlpha,
        Localized.Title.iconBorderColor,
        Localized.Title.iconBorderAlpha,
        Localized.Title.backdropCornerRadius,
        Localized.Title.backdropColor,
        Localized.Title.backdropColorAlpha,
        Localized.Title.backdropImage,
        Localized.Title.backdropImageAlpha,
        Localized.Title.backdropImageMode,
        Localized.Title.backdropQuietzone
    ]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        [
            chooseInputCorrectionLevel,
            chooseDataThickness,
            chooseDataXThickness,
            chooseHorizontalLineColor,
            chooseHorizontalLineColorAlpha,
            chooseVerticalLineColor,
            chooseVerticalLineColorAlpha,
            chooseXColor,
            chooseXColorAlpha,
            choosePositionStyle,
            choosePositionThickness,
            choosePositionColor,
            choosePositionAlpha,
            chooseIcon,
            chooseIconScale,
            chooseIconAlpha,
            chooseIconBorderColor,
            chooseIconBorderColorAlpha,
            chooseBackdropCornerRadius,
            chooseBackdropColor,
            chooseBackdropColorAlpha,
            chooseBackdropImage,
            chooseBackdropImageAlpha,
            chooseBackdropImageMode,
            chooseBackdropQuietzone
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
            "\(dataThickness)",
            "\(dataXThickness)",
            "", // horizontalLineColor
            "\(horizontalLineColorAlpha)",
            "", // verticalLineColor
            "\(verticalLineColorAlpha)",
            "", // xColor
            "\(xColorAlpha)",
            "\(positionStyle)",
            "\(positionThickness)",
            "", // positionColor
            "\(positionAlpha)",
            "", // icon
            "\(iconScale)",
            "\(iconAlpha)",
            "", // iconBorderColor
            "\(iconBorderAlpha)",
            "\(backdropCornerRadius)",
            "", // backdropColor
            "\(backdropColorAlpha)",
            "", // backdropImage
            "\(backdropImageAlpha)",
            "\(backdropImageMode)",
            "\(String(describing: backdropQuietzone))"
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
            case 3:
                rightImageView.backgroundColor = horizontalLineColor.withAlphaComponent(horizontalLineColorAlpha)
            case 5:
                rightImageView.backgroundColor = verticalLineColor.withAlphaComponent(verticalLineColorAlpha)
            case 7:
                rightImageView.backgroundColor = xColor.withAlphaComponent(xColorAlpha)
            case 11:
                rightImageView.backgroundColor = positionColor.withAlphaComponent(positionAlpha)
            case 13:
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
            case 16:
                rightImageView.backgroundColor = iconBorderColor.withAlphaComponent(iconBorderAlpha)
            case 19:
                rightImageView.backgroundColor = backdropColor.withAlphaComponent(backdropColorAlpha)
            case 21:
                rightImageView.image = backdropImage.flatMap { UIImage(cgImage: $0) }
            default:
                break
            }
        }
        return cell
    }
}

#if os(iOS)
// MARK: - EFColorPicker
extension DSJGeneratorController: UIColorPickerViewControllerDelegate {
    
    struct EFColorPicker {
        static var index: Int = 0
    }

    func customColor(_ index: Int) {
        EFColorPicker.index = index

        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = [horizontalLineColor, verticalLineColor, xColor, positionColor, iconBorderColor, backdropColor][index]
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
            horizontalLineColor = color
            break
        case 1:
            verticalLineColor = color
            break
        case 2:
            xColor = color
            break
        case 3:
            positionColor = color
            break
        case 4:
            iconBorderColor = color
            break
        case 5:
            backdropColor = color
            break
        default:
            break
        }
        refresh()
    }
}
#endif

#if os(iOS)
extension DSJGeneratorController: UIImagePickerControllerDelegate {

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

        let imageContent: EFStyleParamImage? = {
            var content: EFStyleParamImage? = nil
            if let finalImage = finalImage?.cgImage {
                content = .static(image: finalImage)
            } else {
                content = nil
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
                        let frameDelays = animatedImage.frameDelays.map({ CGFloat($0) })
                        content = .animated(images: frames, imageDelays: frameDelays)
                    }
                }
            }
            return content
        }()
        
        switch titleCurrent {
        case Localized.Title.icon:
            icon = imageContent
        case Localized.Title.backdropImage:
            backdropImage = imageContent?.firstImage
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
