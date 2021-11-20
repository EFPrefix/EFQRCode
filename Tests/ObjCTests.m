//
//  ObjCTests.m
//  EFQRCode
//
//  Created by Apollo Zhu on 11/25/20.
//  Copyright (c) 2017-2021 EyreFree <eyrefree@eyrefree.org>
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

@import XCTest;
@import EFQRCode;

#if TARGET_OS_OSX
@import AppKit;
#define EFColor NSColor
#define EFImage NSImage
@interface NSImage (EFQRCode)
-(CGImageRef) CGImage;
@end

@implementation NSImage (EFQRCode)
-(CGImageRef) CGImage {
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[self TIFFRepresentation], NULL);
    return CGImageSourceCreateImageAtIndex(source, 0, NULL);
}
@end
#else
@import UIKit;
#define EFColor UIColor
#define EFImage UIImage
#endif

@interface ObjCTests : XCTestCase

@end

@implementation ObjCTests
- (CGImageRef) getImage {
#if SWIFT_PACKAGE
    NSBundle *bundle = SWIFTPM_MODULE_BUNDLE;
#else
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
#endif
    NSString *path = [bundle pathForResource:@"eyrefree" ofType:@"png"];
    XCTAssertNotNil(path);
    EFImage *image = [[EFImage alloc] initWithContentsOfFile:path];
    return [image CGImage];
}

- (void)testGenerator {
    NSString *content = @"https://github.com/EFPrefix/EFQRCode";
    EFIntSize *size = [[EFIntSize alloc] initWithWidth:15 height:15];
    EFQRCodeGenerator *g = [[EFQRCodeGenerator alloc] initWithContent: content
                                                             encoding: NSUTF8StringEncoding
                                                                 size: size];
    [g withContent:content encoding: NSUTF8StringEncoding];
    [g withSize:size];
    [g withBinarizationModeWithThreshold:0.3];
    [g withGrayscaleMode];
    [g withNormalMode];
    [g withCGColorsForBackgroundColor:[EFColor grayColor].CGColor
                      foregroundColor:[EFColor blackColor].CGColor];
    [g withCIColorsForBackgroundColor:[CIColor whiteColor]
                      foregroundColor:[CIColor blackColor]];
    [g withInputCorrectionLevel:EFInputCorrectionLevelQ];
    [g withMagnification:nil];
    [g withIcon:[self getImage] size:nil];
    [g withWatermark:[self getImage] mode: EFWatermarkModeBottom];
    [g withOpaqueWatermark:YES];
    [g withTransparentWatermark:YES];
    [g withPointOffset: 0];
    [g withStaticTimingPoint:YES];
    [g withStyledTimingPoint:YES];
    [g withPointStyle:[EFDiamondPointStyle new]];
    CGImageRef testResult = [g generate];
    XCTAssertNotEqual(testResult, NULL);
}

- (void)testGeneratorGIF {
    NSString *content = @"https://github.com/EFPrefix/EFQRCode";
    EFIntSize *size = [[EFIntSize alloc] initWithWidth:15 height:15];
    EFQRCodeGenerator *g = [[EFQRCodeGenerator alloc] initWithContent: content
                                                             encoding: NSUTF8StringEncoding
                                                                 size: size];
    NSData *watermark = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [g generateGIFWithWatermarkGIF: watermark];
#warning TODO: Generate Actual GIF
    NSLog(@"%@", data);
}

- (void)testRecognizer {
    // This is an example of EFQRCodeGenerator test case.
    NSString *content = @"https://github.com/EFPrefix/EFQRCode";
    EFIntSize *size = [[EFIntSize alloc] initWithWidth:256 height:256];
    EFQRCodeGenerator *g = [[EFQRCodeGenerator alloc] initWithContent:content
                                                             encoding:NSUTF8StringEncoding
                                                                 size:size];
    CGImageRef testResult = [g generate];
    XCTAssertNotEqual(testResult, NULL, "testResult is nil!");

    // This is an example of EFQRCodeRecognizer test case.
    EFQRCodeRecognizer *r = [[EFQRCodeRecognizer alloc] initWithImage:testResult];
    r.image = testResult;
    NSArray<NSString *> *testResultArray = [r recognize];
    XCTAssertGreaterThan([testResultArray count], 0, "testResultArray has no result!");
    XCTAssertEqualObjects(testResultArray[0], content, "testResultArray is wrong!");
}

@end
