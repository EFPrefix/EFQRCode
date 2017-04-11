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
