//
//  Tests.swift
//  watchOS Example Extension
//
//  Created by Apollo Zhu on 12/27/17.
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
import EFQRCode

extension Optional where Wrapped == String {
    static let passed: String? = nil
}

typealias Testcase = () -> String?

final class Tests {
    private init() { }
    public static let shared = Tests()
    static let allTests: [(String, Testcase)] = [
        ("testExample1", shared.testExample1),
        ("testExample2", shared.testExample2),
        ("testExample3", shared.testExample3),
        ("testExample4", shared.testExample4),
        ("testExampleCGColorExtension", shared.testExampleCGColorExtension),
        ("testExampleCGSizeExtension", shared.testExampleCGSizeExtension),
        ("testExampleEFQRCode", shared.testExampleEFQRCode)
    ]

    func getImage(name: String) -> CGImage? {
        return UIImage(named: "eyrefree")?.ef.cgImage
    }

    func testExample1() -> String? {
        // This is an example of EFQRCodeGenerator test case.
        let content = "https://github.com/EFPrefix/EFQRCode"
        let generator = EFQRCodeGenerator(
            content: content,
            size: EFIntSize(width: 256, height: 256)
        )
        generator.withMode(nil)
        generator.withColors(backgroundColor: CGColor.EF.white()!,
                             foregroundColor: CGColor.EF.black()!)
        generator.withInputCorrectionLevel(.h)
        generator.withMagnification(EFIntSize(width: 6, height: 6))
        return generator.generate() == nil ? Localized.errored : .passed

        // EFQRCodeRecognizer test case not included.
    }

    func testExample2() -> String? {
        // This is an example of EFQRCodeGenerator test case.
        let content = ""
        let generator = EFQRCodeGenerator(
            content: content,
            size: EFIntSize(width: 999, height: 999)
        )
        generator.withMode(nil)
        generator.withColors(backgroundColor: CGColor.EF.white()!,
                             foregroundColor: CGColor.EF.black()!)
        generator.withInputCorrectionLevel(.l)
        generator.withMagnification(nil)
        return generator.generate() == nil ? Localized.errored : .passed

        // EFQRCodeRecognizer test case not included.
    }

    func testExample3() -> String? {
        // This is an example of EFQRCodeGenerator test case.
        let content = "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989"
        let generator = EFQRCodeGenerator(
            content: content,
            size: EFIntSize(width: 1024, height: 1024)
        )
        generator.withMode(nil)
        generator.withColors(backgroundColor: UIColor.gray.ef.cgColor,
                             foregroundColor: CGColor.EF.black()!)
        generator.withInputCorrectionLevel(.m)
        generator.withMagnification(nil)
        return generator.generate() == nil ? Localized.errored : .passed

        // EFQRCodeRecognizer test case not included.
    }

    func testExample4() -> String? {
        // This is an example of EFQRCodeGenerator test case.
        let content = "https://github.com/EFPrefix/EFQRCode"
        let generator = EFQRCodeGenerator(
            content: content,
            size: EFIntSize(width: 15, height: 15)
        )
        generator.withMode(nil)
        generator.withColors(backgroundColor: UIColor.red.ef.cgColor,
                             foregroundColor: CGColor.EF.black()!)
        generator.withInputCorrectionLevel(.q)
        generator.withMagnification(nil)
        generator.withIcon(getImage(name: "eyrefree"), size: nil)
        generator.withWatermark(getImage(name: "eyrefree"), mode: .bottom)
        generator.withPointOffset(0)
        generator.withTransparentWatermark(true)
        let testResult = generator.generate()
        return testResult == nil ? Localized.errored : .passed
    }

    // CGColor
    func testExampleCGColorExtension() -> String? {
        guard CGColor.EF.white() != nil else { return "CGColor.EFWhite() should not be nil!" }
        guard CGColor.EF.black() != nil else { return "CGColor.EFBlack() should not be nil!" }
        return .passed
    }

    // CGSize
    func testExampleCGSizeExtension() -> String? {
        let size = CGSize(width: 111.1, height: 888.8)
        guard size.width.ef.int == 111 else { return "size.widthInt() should be 111!" }
        guard size.height.ef.int == 888 else { return "size.heightInt() should be 888!" }
        return .passed
    }

    // EFQRCode
    func testExampleEFQRCode() -> String? {
        let testResult = EFQRCode.generate(for: "https://github.com/EFPrefix/EFQRCode")
        return testResult == nil ? Localized.errored : .passed
    }
}
