//
//  Tests.swift
//  EFQRCode
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
@testable import EFQRCode

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
        let generator = EFQRCodeGenerator(
            content: content,
            size: EFIntSize(width: 256, height: 256)
        )
        generator.setMode(mode: .none)
        generator.setColors(backgroundColor: CIColor.EFWhite(), foregroundColor: CIColor.EFBlack())
        generator.setInputCorrectionLevel(inputCorrectionLevel: .h)
        generator.setMagnification(magnification: EFIntSize(width: 6, height: 6))
        let testResult = generator.generate()
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
        let generator = EFQRCodeGenerator(
            content: content,
            size: EFIntSize(width: 999, height: 999)
        )
        generator.setMode(mode: .none)
        generator.setColors(backgroundColor: CIColor.EFWhite(), foregroundColor: CIColor.EFBlack())
        generator.setInputCorrectionLevel(inputCorrectionLevel: .l)
        generator.setMagnification(magnification: nil)
        let testResult = generator.generate()
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
        let generator = EFQRCodeGenerator(
            content: content,
            size: EFIntSize(width: 1024, height: 1024)
        )
        generator.setMode(mode: .none)
        generator.setColors(backgroundColor: {
            #if os(macOS)
                return NSColor.gray.toCIColor()
            #else
                return UIColor.gray.toCIColor()
            #endif
        }(), foregroundColor: CIColor.EFBlack())
        generator.setInputCorrectionLevel(inputCorrectionLevel: .m)
        generator.setMagnification(magnification: nil)
        let testResult = generator.generate()
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
        generator.setInputCorrectionLevel(inputCorrectionLevel: .q)
        generator.setMagnification(magnification: nil)
        generator.setIcon(icon: getImage(name: "eyrefree"), size: nil)
        generator.setWatermark(watermark: getImage(name: "eyrefree"), mode: .bottom)
        generator.setForegroundPointOffset(foregroundPointOffset: 0)
        generator.setAllowTransparent(allowTransparent: true)
        let testResult = generator.generate()
        XCTAssert(testResult != nil, "testResult is nil!")
    }

    // UI/NSColor
    func testEFUIntPixelInitializer() {
        #if os(macOS)
        typealias Color = NSColor
        #else
        typealias Color = UIColor
        #endif
        let colors: [Color] = [
            .black, .blue, .brown, .clear, .cyan,
            .darkGray, .gray, .green, .lightGray, .magenta,
            .orange, .purple, .red, .white, .yellow
        ]
        for color in colors {
            XCTAssertNotNil(EFUIntPixel(color: color.cgColor),
                            "\(color) should not be nil!")
        }

        let hsb = Color(hue: 0.1, saturation: 0.4, brightness: 0.5, alpha: 1)
        XCTAssertNotNil(EFUIntPixel(color: hsb.cgColor), "HSB Failed")
        #if os(macOS)
        let cmyk = Color(deviceCyan: 0.2, magenta: 0.3, yellow: 0.6, black: 0.8, alpha: 1)
        XCTAssertNotNil(EFUIntPixel(color: cmyk.cgColor), "CMYK Failed")
        #endif
    }

    // CGColor
    func testExampleCGColorExtension() {
        XCTAssert(CGColor.EFWhite() != nil, "CGColor.EFWhite() should not be nil!")
        XCTAssert(CGColor.EFBlack() != nil, "CGColor.EFBlack() should not be nil!")
    }

    // CGSize
    func testExampleCGSizeExtension() {
        let size = CGSize(width: 111.1, height: 888.8)
        XCTAssert(size.widthInt() == 111, "size.widthInt() should be 111!")
        XCTAssert(size.heightInt() == 888, "size.heightInt() should be 888!")
    }

    // EFQRCode
    func testExampleEFQRCode() {
        let testResult = EFQRCode.generate(content: "https://github.com/EyreFree/EFQRCode")
        XCTAssert(testResult != nil, "testResult is nil!")
    }
}
