//
//  ViewController.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/1/24.
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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.isHidden = false
    }

    func setupViews() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 48)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.text = "EFQRCode\(version == "" ? "" : "\n\(version)")"
        titleLabel.numberOfLines = 0
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            (make) in
            make.top.left.equalTo(0)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(2.5)
        }

        let tableView = UITableView()
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        #if os(iOS)
            tableView.separatorColor = UIColor.white
        #endif
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            (make) in
            make.left.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(3)
        }

        let bottomLabel = UIButton(type: .system)
        bottomLabel.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        bottomLabel.setTitleColor(UIColor.white, for: .normal)
        bottomLabel.setTitle("https://github.com/EyreFree/EFQRCode", for: .normal)
        #if os(iOS)
            bottomLabel.addTarget(self, action: #selector(ViewController.openBlog), for: .touchDown)
        #endif
        self.view.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints {
            (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(-20)
            make.height.equalTo(20)
            make.width.equalTo(self.view)
        }
    }

    @objc func openBlog() {
        if let tryUrl = URL(string: "https://github.com/EyreFree/EFQRCode") {
            UIApplication.shared.openURL(tryUrl)
        }
    }

    // UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        #if os(iOS)
            self.navigationController?.pushViewController(
                [RecognizerController.self, GeneratorController.self][indexPath.row].init(), animated: true
            )
        #else
            self.navigationController?.pushViewController(GeneratorController(), animated: true)
        #endif
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #if os(iOS)
            return 2
        #else
            return 1
        #endif
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.zeroHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.zeroHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        #if os(iOS)
            let text = ["Recognizer", "Generator"][indexPath.row]
        #else
            let text = "Generator"
        #endif
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
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
            if 1 == indexPath.row {
                cell.separatorInset = UIEdgeInsets(
                    top: 15, left: 0, bottom: 0, right: max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
                )
            }
        }
    }
    #endif
}
