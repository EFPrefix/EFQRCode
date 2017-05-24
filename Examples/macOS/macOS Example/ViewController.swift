//
//  ViewController.swift
//  macOS Example
//
//  Created by EyreFree on 2017/4/20.
//  Copyright © 2017年 EyreFree. All rights reserved.
//

import Cocoa
import EFQRCode

class ViewController: NSViewController {

    var imageView: NSImageView!
    var createButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear() {
        super.viewDidAppear()

        addControl()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func addControl() {
        imageView = NSImageView()
        imageView.imageAlignment = .alignCenter
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.wantsLayer = true
        imageView.layer?.borderColor = NSColor.black.cgColor
        imageView.layer?.borderWidth = 1.0
        self.view.addSubview(imageView)

        createButton = NSButton()
        createButton.title = "Create"
        createButton.target = self
        createButton.action = #selector(createButtonClicked)
        self.view.addSubview(createButton)

        resizeControl()
    }

    func resizeControl() {
        let controllerSize = self.view.frame.size

        imageView.frame = CGRect(x: 10, y: 10, width: controllerSize.width - 20, height: controllerSize.height - 70)
        createButton.frame = CGRect(x: 10, y: controllerSize.height - 50, width: controllerSize.width - 20, height: 40)
    }

    override func preferredContentSizeDidChange(for viewController: NSViewController) {
        super.preferredContentSizeDidChange(for: viewController)


    }

    override func viewWillTransition(to newSize: NSSize) {

        super.viewWillTransition(to: newSize)

        resizeControl()
    }

    func createButtonClicked() {
        if let testImage = EFQRCode.generate(
            content: "https://github.com/EyreFree/EFQRCode",
            size: EFIntSize(width: 1024, height: 1024),
            backgroundColor: CIColor.EFWhite(),
            foregroundColor: CIColor.EFBlack(),
            watermark: nil
            ) {
            imageView.image = NSImage(cgImage: testImage, size: NSSize(width: testImage.width, height: testImage.height))
        }
    }
}
