//
//  ViewController.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/4/20.
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

    @objc func createButtonClicked() {
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
