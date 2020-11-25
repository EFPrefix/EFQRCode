//
//  ObjCTests.m
//  EFQRCode
//
//  Created by Apollo Zhu on 11/25/20.
//  Copyright © 2020 EyreFree. All rights reserved.
//

@import XCTest;
@import EFQRCode;

#if TARGET_OS_OSX
@import AppKit;
#define EFColor NSColor
#define EFImage NSImage
#else
@import UIKit;
#define EFColor UIColor
#define EFImage UIImage
#endif

@interface ObjCTests : XCTestCase

@end

@implementation ObjCTests

- (CGImageRef) getImage {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"eyrefree" ofType:@"png"];
    EFImage *image = [[EFImage alloc] initWithContentsOfFile:path];
#if TARGET_OS_OSX
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
    return CGImageSourceCreateImageAtIndex(source, 0, NULL);
#else
    return [image CGImage];
#endif
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
    [g withTransparentWatermark:YES];
    [g withPointOffset: 0];
    [g withStaticTiming: YES];
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
    NSData *data = [g generateGIFWithInputGIF: watermark];
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
    XCTAssertNotNil(testResultArray, "testResultArray is nil!");
    XCTAssertGreaterThan([testResultArray count], 0, "testResultArray has no result!");
    XCTAssertEqualObjects(testResultArray[0], content, "testResultArray is wrong!");
}

@end
