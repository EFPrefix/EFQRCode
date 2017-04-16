//
//  Tests.swift
//  Pods
//
//  Created by EyreFree on 2017/4/11.
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
import XCTest
import EFQRCode

class Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of EFQRCodeGenerator test case.
        let testResult = EFQRCode.generate(
            content: "https://github.com/EyreFree/EFQRCode",
            inputCorrectionLevel: .h,
            size: EFIntSize(width: 256, height: 256),
            magnification: EFIntSize(width: 6, height: 6),
            backgroundColor: CIColor.EFWhite(),
            foregroundColor: CIColor.EFBlack(),
            icon: nil,
            watermark: nil,
            extra: nil
        )
        XCTAssert(testResult != nil, "testResult is nil!")

        // This is an example of EFQRCodeRecognizer test case.
        let testResultArray = EFQRCode.recognize(image: testResult!)
        XCTAssert(testResultArray != nil, "testResultArray is nil!")
        XCTAssert(testResultArray!.count > 0, "testResultArray has no result!")
        XCTAssert(testResultArray![0] == "https://github.com/EyreFree/EFQRCode", "testResultArray is wrong!")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
}
