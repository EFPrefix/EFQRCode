//
//  StyleViewController.swift
//  iOS Example
//
//  Created by EyreFree on 2023/7/6.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import UIKit
import SafariServices
import EFQRCode

enum EFImage {
    case normal(_ image: UIImage)
    case gif(_ data: Data)
    
    var isGIF: Bool {
        switch self {
        case .normal: return false
        case .gif: return true
        }
    }
}

final class Ref<Wrapped> {
    var value: Wrapped
    init(_ value: Wrapped) {
        self.value = value
    }
}

extension Ref: ExpressibleByNilLiteral where Wrapped: ExpressibleByNilLiteral {
    convenience init(nilLiteral: ()) {
        self.init(nil)
    }
}

class StyleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Style List", comment: "Title on style")
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.8117647059, blue: 0.7803921569, alpha: 1)

        setupViews()
    }

    func setupViews() {
        let tableView = UITableView()
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
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            (make) in
            make.leading.equalTo(0)
            make.top.equalTo(CGFloat.statusBar() + CGFloat.navigationBar(self))
            make.width.equalTo(view)
            make.bottom.equalTo(-CGFloat.bottomSafeArea())
        }
    }
    
    let titles: [String] = [
        "Basic",
        "Bubble",
        "DSJ",
        "Line",
        "Function",
        "RandomRectangle",
        "ResampleImage",
        "Image",
        "ImageFill",
        "2.5D"
    ]
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(
            [
                BasicGeneratorController.self,
                BubbleGeneratorController.self,
                DSJGeneratorController.self,
                LineGeneratorController.self,
                FunctionGeneratorController.self,
                RandomRectangleGeneratorController.self,
                ResampleImageGeneratorController.self,
                ImageGeneratorController.self,
                ImageFillGeneratorController.self,
                D25GeneratorController.self,
            ][indexPath.row].init(),
            animated: true
        )
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zeroHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zeroHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = titles[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.textLabel?.text = text
        let backView = UIView()
        backView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.64)
        cell.selectedBackgroundView = backView
        let imageView = UIImageView(image: UIImage(named: text))
        imageView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        imageView.contentMode = .scaleAspectFit
        cell.accessoryView = imageView
        return cell
    }

    #if os(iOS)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !UIDevice.current.model.contains("iPad") {
            if titles.count - 1 == indexPath.row {
                cell.separatorInset = UIEdgeInsets(
                    top: 15, left: 0, bottom: 0, right: max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
                )
            }
        }
    }
    #endif
}

extension UIViewController {
    
    func chooseFromEnum<T: CaseIterable>(title: String, type: T.Type, completion: ((T) -> Void)?) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: Localized.cancel, style: .cancel)
        )

        let allCases = Array(type.allCases)
        let names: [String] = allCases.map{ "\($0)" }
        for (index, modeName) in names.enumerated() {
            alert.addAction(
                UIAlertAction(title: modeName, style: .default) { [weak self] _ in
                    guard let _ = self else { return }

                    completion?(allCases[index])
                }
            )
        }
        popActionSheet(alert: alert)
    }
    
    func chooseFromList<T>(title: String, items: [T], completion: ((T) -> Void)?) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: Localized.cancel, style: .cancel)
        )

        let names: [String] = items.map{ "\($0)" }
        for (index, modeName) in names.enumerated() {
            alert.addAction(
                UIAlertAction(title: modeName, style: .default) { [weak self] _ in
                    guard let _ = self else { return }

                    completion?(items[index])
                }
            )
        }
        popActionSheet(alert: alert)
    }
    
    func popActionSheet(alert: UIAlertController) {
        // 阻止 iPad Crash
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = CGRect(
            x: view.bounds.midX,
            y: view.bounds.midY,
            width: 1.0, height: 1.0
        )
        present(alert, animated: true)
    }
}
