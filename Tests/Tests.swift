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

    func getImage(name: String) -> CGImage? {
        if let filePath = Bundle.init(for: self.classForCoder).path(forResource: "eyrefree", ofType: "png") {
            #if os(macOS)
                return NSImage(contentsOfFile: filePath)?.toCGImage()
            #else
                return UIImage(contentsOfFile: filePath)?.toCGImage()
            #endif
        }
        return nil
    }

    func testExample1() {
        // This is an example of EFQRCodeGenerator test case.
        let content = "https://github.com/EyreFree/EFQRCode"
        let testResult = EFQRCode.generate(
            content: content,
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
        XCTAssert(testResultArray![0] == content, "testResultArray is wrong!")
    }

    func testExample2() {
        // This is an example of EFQRCodeGenerator test case.
        let content = ""
        let testResult = EFQRCode.generate(
            content: content,
            inputCorrectionLevel: .l,
            size: EFIntSize(width: 999, height: 999),
            magnification: nil,
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
        XCTAssert(testResultArray![0] == content, "testResultArray is wrong!")
    }

    func testExample3() {
        // This is an example of EFQRCodeGenerator test case.
        let content = "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989"
        let testResult = EFQRCode.generate(
            content: content,
            inputCorrectionLevel: .m,
            size: EFIntSize(width: 1024, height: 1024),
            magnification: nil,
            backgroundColor: CIColor.EFWhite(),
            foregroundColor: {
                #if os(macOS)
                    return NSColor.gray.toCIColor()
                #else
                    return UIColor.gray.toCIColor()
                #endif
        }(),
            icon: nil,
            watermark: nil,
            extra: nil
        )
        XCTAssert(testResult != nil, "testResult is nil!")

        // This is an example of EFQRCodeRecognizer test case.
        let testResultArray = EFQRCode.recognize(image: testResult!)
        XCTAssert(testResultArray != nil, "testResultArray is nil!")
        XCTAssert(testResultArray!.count > 0, "testResultArray has no result!")
        XCTAssert(testResultArray![0] == content, "testResultArray is wrong!")
    }

    func testExample4() {
        // This is an example of EFQRCodeGenerator test case.
        let content = "https://github.com/EyreFree/EFQRCode"
        let generator = EFQRCodeGenerator(
            content: content,
            inputCorrectionLevel: .q,
            size: EFIntSize(width: 15, height: 15)
        )
        generator.setMode(mode: .none)
        generator.setColors(backgroundColor: {
            #if os(macOS)
                return NSColor.gray.toCIColor()
            #else
                return UIColor.red.toCIColor()
            #endif
        }(), foregroundColor: CIColor.EFBlack())
        generator.setMagnification(magnification: nil)
        generator.setIcon(icon: EFIcon(image: getImage(name: "eyrefree")))
        generator.setWatermark(watermark: EFWatermark(image: getImage(name: "eyrefree")))
        generator.setExtra(extra: EFExtra(foregroundPointOffset: 0, allowTransparent: true))
        generator.watermarkMode = .bottom
        let testResult = generator.image
        XCTAssert(testResult != nil, "testResult should be nil!")
    }
}
