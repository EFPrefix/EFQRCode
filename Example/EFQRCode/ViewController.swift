//
//  ViewController.swift
//  EFQRCode
//
//  Created by EyreFree on 01/24/2017.
//  Copyright (c) 2017 EyreFree. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white

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
        let screenSize = UIScreen.main.bounds.size

        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.text = "EFQRCode"
        self.view.addSubview(titleLabel)
        titleLabel.frame = CGRect(
            x: 0, y: 0, width: screenSize.width, height: screenSize.height / 3.0
        )

        let tableView = UITableView()
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        self.view.addSubview(tableView)
        tableView.frame = CGRect(
            x: 0, y: titleLabel.frame.maxY, width: screenSize.width, height: screenSize.height / 3.0
        )

        let bottomLabel = UIButton()
        bottomLabel.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        bottomLabel.setTitleColor(UIColor.black, for: .normal)
        bottomLabel.setTitle("https://www.eyrefree.org/", for: .normal)
        bottomLabel.addTarget(self, action: #selector(ViewController.openBlog), for: .touchDown)
        self.view.addSubview(bottomLabel)
        bottomLabel.frame = CGRect(
            x: 0, y: screenSize.height - 40, width: screenSize.width, height: 20
        )
    }

    func openBlog() {
        if let tryUrl = URL(string: "https://www.eyrefree.org/") {
            UIApplication.shared.openURL(tryUrl)
        }
    }

    // UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(ScanController(), animated: true)
            break
        default:
            self.navigationController?.pushViewController(CreateController(), animated: true)
            break
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0000001
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000001
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = ["Scan QRCode from Image", "Create QRCode image"][indexPath.row]
        return cell
    }
}
