![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/EFQRCode.jpg)

<p align="center">
    <a href="https://github.com/Carthage/Carthage/">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat">
    </a>
    <a href="https://swift.org/package-manager/">
        <img src="https://img.shields.io/badge/SPM-ready-orange.svg">
    </a>
    <a href="http://cocoapods.org/pods/EFQRCode">
        <img src="https://img.shields.io/cocoapods/v/EFQRCode.svg?style=flat">
    </a>
    <a href="https://swiftpackageindex.com/EFPrefix/EFQRCode">
        <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FEFPrefix%2FEFQRCode%2Fbadge%3Ftype%3Dplatforms" alt="支持所有平台">
    </a>
    <a href="https://raw.githubusercontent.com/EFPrefix/EFQRCode/main/LICENSE">
        <img src="https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat">
    </a>
</p>

EFQRCode 是一个轻量级的、用来生成和识别二维码的纯 Swift 库，可根据输入的水印图和图标产生艺术二维码，基于 `CoreGraphics`、`CoreImage` 和 `ImageIO` 进行开发，受 [qrcode](https://github.com/sylnsfar/qrcode) 和 [react-qrbtf](https://github.com/CPunisher/react-qrbtf) 启发。EFQRCode 为你提供了一种更好的在你的 App 中操作二维码的方式，它能够运行于 iOS、macOS、watchOS、tvOS 和 visionOS 平台，并且支持通过 CocoaPods、Carthage 和 Swift Package Manager 获取。

> [English Introduction](https://github.com/EFPrefix/EFQRCode/blob/main/README.md)

## 概述

![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode5.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode6.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode7.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode8.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF1.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF2.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF7.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF8.gif)  

## 示例

### 应用商店

你可以点击下方的 App Store 按钮从应用商店下载示例程序，支持 iOS、tvOS 和 watchOS：

<a target='_blank' href='https://itunes.apple.com/cn/app/EFQRCode/id1242337058?mt=8'>
    <img src='https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/icon/AppStore.jpeg' width='144' height='49'/>
</a>

你也可以点击下方的 Mac App Store 按钮下载 macOS 示例程序：

<a target='_blank' href='https://itunes.apple.com/cn/app/EFQRCode/id1306793539?mt=8'>
	<img src='https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/icon/AppStoreMac.png' width='168.5' height='49'/>
</a>

### 手动

1. 利用 `git clone` 命令下载本仓库；
2. 切换到仓库根目录下，执行 `sh Startup.sh` 命令获取所有依赖；
3. `EFQRCode.xcworkspace` 工程中包含了所有的示例程序，用 Xcode 打开它，选择对应平台 target 编译即可。

或执行以下命令：

```bash
git clone git@github.com:EFPrefix/EFQRCode.git; cd EFQRCode; sh Startup.sh; open 'EFQRCode.xcworkspace'
```

## 环境

iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+ / visionOS 1.0+

## 安装

### CocoaPods

EFQRCode 可以通过 [CocoaPods](http://cocoapods.org) 进行获取。只需要在你的 Podfile 中添加如下代码就能实现引入：

```ruby
pod 'EFQRCode', '~> 7.0.2'
```

然后，执行如下命令即可：

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) 是一个去中心化的依赖管理器，它为我们构建依赖并通过提供二进制 Frameworks 的方式供我们使用。

你可以通过 [Homebrew](http://brew.sh/) 使用如下命令来安装 Carthage：

```bash
$ brew update
$ brew install carthage
```

通过在你的 `Cartfile` 添加如下语句可以将 EFQRCode 引入你的项目：

```ogdl
github "EFPrefix/EFQRCode" ~> 7.0.2
```

接下来执行 `carthage update` 命令生成 Framework 并且将生成的 `EFQRCode.framework` 拖入工程即可。

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) 是一个集成在 Swift 编译器中的用来进行 Swift 代码自动化发布的工具。

如果你已经建立了你的 Swift 包，将 EFQRCode 加入依赖是十分容易的，只需要将其添加到你的 `Package.swift` 文件的 `dependencies` 项中即可：

```swift
dependencies: [
    .package(url: "https://github.com/EFPrefix/EFQRCode.git", .upToNextMinor(from: "7.0.2"))
]
```

## 快速使用

#### 1. 导入 EFQRCode

在你需要使用的地方添加如下代码引入 EFQRCode 模块：

```swift
import EFQRCode
```

#### 2. 二维码识别

获取图片中所包含的二维码，同一张图片中可能包含多个二维码，所以返回值是一个字符串数组：

```swift
if let testImage = UIImage(named: "test.png")?.cgImage {
    let codes = EFQRCode.Recognizer(image: testImage).recognize()
    if !codes.isEmpty {
        print("There are \(codes.count) codes")
        for (index, code) in codes.enumerated() {
            print("The content of QR Code \(index) is \(code).")
        }
    } else {
        print("There is no QR Codes in testImage.")
    }
}
```

#### 3. 二维码生成

##### 3.1 静态二维码

根据所输入参数创建各种艺术二维码图片，快速使用方式如下:

```swift
let generator = try? EFQRCode.Generator("https://github.com/EFPrefix/EFQRCode", style: .image(
    params: .init(image: .init(image: .static(image: UIImage(named: "WWF")?.cgImage!), allowTransparent: true)))
)
if let image = try? generator?.toImage(width: 180).cgImage {
    print("Create QRCode image success \(image)")
} else {
    print("Create QRCode image failed!")
}
```

结果：

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/sample1.jpg" width = "36%"/>

##### 3.2. 动态二维码

可通过 animated image 传入动图序列来创建动态二维码，使用方式如下：

```swift
let generator = try? EFQRCode.Generator("https://github.com/EFPrefix/EFQRCode", style: .image(
    params: .init(image: .init(image: .animated(images: cgImages, imageDelays: cgImageDelays))))
)
if let imageData = try? generator?.toGIFData(width: 512) {
    print("Create QRCode image success \(imageData)")
} else {
    print("Create QRCode image failed!")
}
```

你可以通过查看 Demo 代码的方式来获取更多信息，结果预览：

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF6.gif" width = "36%"/>

##### 3.3 可导出类型

- 静态: NSImage, UIImage, PDF, PNG, JPEG
- 动态: APNG, GIF, SVG, MOV, MP4, M4V

#### 4. 接下来

查看 [DeepWiki](https://deepwiki.com/EFPrefix/EFQRCode) 了解更多细节（没错，我偷懒了没写文档，QWQ

## 备注

1. 请选用对比度较高的前景色和背景色组合；
2. 想要提高生成二维码的清晰度可以适当提高它的生成、导出尺寸；
3. 生成尺寸过大、二维码内容过多、导入媒体过大可能会导致生成失败；
4. 建议对生成的二维码进行测试后投入使用，例如微信能够扫描成功并不代表支付宝也能成功扫描，请务必根据您的具体业务需要做有针对性的测试；
5. 文档与演示项目中部分图片来源于网络，如侵犯您的合法权益，请联系我们删除；
6. 若有任何问题，期待得到您的反馈，`Issue` 和 `Pull request` 都是受欢迎的。
7. 好用的话希望可以点下 `Star`，QWQ

## 贡献者

<a href="https://opencollective.com/efqrcode#contributors">
    <img src="https://opencollective.com/efqrcode/contributors.svg?width=890"/>
</a>

## 捐赠

<a href="https://opencollective.com/efqrcode#backers" target="_blank">
    <img src="https://opencollective.com/efqrcode/backers.svg?width=890">
</a>

## 赞助商

- 感谢 MacStadium 的 [开源计划](https://www.macstadium.com/opensource?from=EFQRCode) 对本项目的帮助。

<a href="https://macstadium.com/?from=EFQRCode">
    <img src="https://uploads-ssl.webflow.com/5ac3c046c82724970fc60918/5c019d917bba312af7553b49_MacStadium-developerlogo.png" width = "46%">
</a>

- 感谢 JetBrains 的 [开源支持计划](https://www.jetbrains.com/community/opensource/?from=EFQRCode) 对本项目的帮助。

<a href="https://www.jetbrains.com/?from=EFQRCode">
    <img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/ce8982e1858d62ac8b9fecec96f5369d8b1b62c3/logo/jetbrains.svg?sanitize=true" width = "20%">
</a>

## 联系

邮箱：[eyrefree@eyrefree.org](mailto:eyrefree@eyrefree.org)

## 协议

<a href="https://github.com/EFPrefix/EFQRCode/blob/main/LICENSE">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/License_icon-mit-88x31-2.svg/128px-License_icon-mit-88x31-2.svg.png">
</a>

EFQRCode 基于 MIT 协议进行分发和使用，更多信息参见协议文件。
