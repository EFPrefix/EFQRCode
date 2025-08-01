// swift-tools-version:5.9
//
//  Package.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/4/1.
//
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

import PackageDescription

let package = Package(
    name: "EFQRCode",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "EFQRCode", targets: ["EFQRCode"])
    ],
    dependencies: [
        .package(url: "https://github.com/EFPrefix/swift_qrcodejs.git",
                 .upToNextMinor(from: "2.3.1")),
        .package(url: "https://github.com/swhitty/SwiftDraw.git", 
                 .upToNextMinor(from: "0.22.0")),
    ],
    targets: [
        .target(name: "EFQRCode",
                dependencies: [
                    .product(name: "QRCodeSwift", package: "swift_qrcodejs"),
                    "SwiftDraw"
                ],
                path: "Source",
                exclude: ["Info.plist", "Info-tvOS.plist"],
                resources: [
                     .process("PrivacyInfo.xcprivacy")
                ]),
        .testTarget(name: "EFQRCodeSwiftTests",
                    dependencies: ["EFQRCode"],
                    path: "Tests",
                    exclude: ["Info.plist"],
                    resources: [.process("Resources")]),
    ],
    swiftLanguageVersions: [.v5]
)
