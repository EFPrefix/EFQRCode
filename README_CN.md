![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/EFQRCode.jpg)

<p align="center">
<a href="https://travis-ci.org/EyreFree/EFQRCode"><img src="http://img.shields.io/travis/EyreFree/EFQRCode.svg"></a>
<a href="https://codecov.io/gh/EyreFree/EFQRCode"><img src="https://codecov.io/gh/EyreFree/EFQRCode/branch/master/graph/badge.svg"></a>
<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-ready-orange.svg"></a>
<a href="http://cocoapods.org/pods/EFQRCode"><img src="https://img.shields.io/cocoapods/v/EFQRCode.svg?style=flat"></a>
<a href="http://cocoapods.org/pods/EFQRCode"><img src="https://img.shields.io/cocoapods/p/EFQRCode.svg?style=flat"></a>
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/language-swift-orange.svg"></a>
<a href="https://codebeat.co/projects/github-com-eyrefree-efqrcode-master"><img src="https://codebeat.co/badges/01f53e9d-542c-4c22-adc7-d1dbff0d2a6f"></a>
<a href="https://raw.githubusercontent.com/EyreFree/EFQRCode/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat"></a>
<a href="https://gitter.im/EFQRCode/Lobby"><img src="https://img.shields.io/gitter/room/EyreFree/EFQRCode.svg"></a>
<a href="https://twitter.com/EyreFree777"><img src="https://img.shields.io/badge/twitter-@EyreFree777-blue.svg?style=flat"></a>
<a href="http://weibo.com/eyrefree777"><img src="https://img.shields.io/badge/weibo-@EyreFree-red.svg?style=flat"></a>
<img src="https://img.shields.io/badge/made%20with-%3C3-orange.svg">
</p>

EFQRCode 是一个轻量级的、用来生成和识别二维码的纯 Swift 库，可根据输入的水印图和图标产生艺术二维码，基于 CoreImage 进行开发。受 [qrcode](https://github.com/sylnsfar/qrcode) 启发。EFQRCode 为你提供了一种更好的在你的 App 中操作二维码的方式，1.2.7 及后续版本支持通过 Objective-C 调用。

> [English Introduction](https://github.com/EyreFree/EFQRCode/blob/master/README.md)

## 概述

![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode2.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode3.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode4.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode5.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode6.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode7.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode8.jpg)  

## 示例

### AppStore

你可以点击下方的 AppStore 按钮从应用商店下载示例程序，支持 iOS 和 tvOS。

<a target='_blank' href='https://itunes.apple.com/cn/app/EFQRCode/id1242337058?mt=8'>
	<img src='http://ww2.sinaimg.cn/large/0060lm7Tgw1f1hgrs1ebwj308102q0sp.jpg' width='144' height='49'/>
</a>

### 手动

1. 利用 `git clone` 命令下载本仓库, `Examples` 目录包含了所有的示例程序；
2. 用 XCode 打开对应项目编译即可。

或执行以下命令：

```bash
git clone git@github.com:EyreFree/EFQRCode.git; cd EFQRCode/Examples/iOS; open 'iOS Example.xcodeproj'
```

## 环境

- XCode 8.0+
- Swift 3.0+
- iOS 8.0+ / macOS 10.11+ / tvOS 9.0+

## 安装

### CocoaPods

EFQRCode 可以通过 [CocoaPods](http://cocoapods.org) 进行获取。只需要在你的 Podfile 中添加如下代码就能实现引入：

```ruby
pod "EFQRCode", '~> 1.2.5'
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
github "EyreFree/EFQRCode" ~> 1.2.5
```

接下来执行 `carthage update` 命令生成 Framework 并且将生成的 `EFQRCode.framework` 拖入工程即可。

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) 是一个集成在 `swift` 编译器中的用来进行 Swift 代码自动化发布的工具。

如果你已经建立了你的 Swift 包，将 EFQRCode 加入依赖是十分容易的，只需要将其添加到你的 `Package.swift` 文件的 `dependencies` 项中即可：

```swift
dependencies: [
    .Package(url: "https://github.com/EyreFree/EFQRCode.git", Version(1, 2, 5))
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
if let testImage = UIImage(named: "test.png")?.toCGImage() {
    if let tryCodes = EFQRCode.recognize(image: testImage) {
        if tryCodes.count > 0 {
            print("There are \(tryCodes.count) codes in testImage.")
            for (index, code) in tryCodes.enumerated() {
                print("The content of \(index) QR Code is: \(code).")
            }
        } else {
            print("There is no QR Codes in testImage.")
        }
    } else {
        print("Recognize failed, check your input image!")
    }
}
```

#### 3. 二维码生成

根据所输入参数创建各种艺术二维码图片，快速使用方式如下:

```swift
//                    content: Content of QR Code
//            size (Optional): Width and height of image
// backgroundColor (Optional): Background color of QRCode
// foregroundColor (Optional): Foreground color of QRCode
//       watermark (Optional): Background image of QRCode
```

```swift
if let tryImage = EFQRCode.generate(
    content: "https://github.com/EyreFree/EFQRCode",
    watermark: UIImage(named: "WWF")?.toCGImage()
) {
    print("Create QRCode image success: \(tryImage)")
} else {
    print("Create QRCode image failed!")
}
```

结果：

<img src="https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/sample1.jpg" width = "36%"/>

#### 4. 接下来

查看 [用户手册](https://github.com/EyreFree/EFQRCode/blob/master/USERGUIDE_CN.md) 了解更多细节。

## 待办

- [ ] 支持 GIF 动图
- [ ] 支持更多样式

## 备注

1. 请选用对比度较高的前景色和背景色组合；
2. 想要提高生成二维码的清晰度可以选择使用 `magnificatio` 替代 `size`，或适当提高它们的数值；
3. 放大倍数过高／边长过大／二维码内容过多可能会导致生成失败；
4. 建议对生成的二维码进行测试后投入使用，例如微信能够扫描成功并不代表支付宝也能成功扫描，请务必根据您的具体业务需要做有针对性的测试；
5. 若有任何问题，期待得到您的反馈，`Issue` 和 `Pull request` 都是受欢迎的。

备注的备注：好用的话可以给个`星星`，蟹蟹，QAQ...

## 其它平台／语言

平台／语言|链接
:-------------------------|:-------------------------
Java|[https://github.com/SumiMakito/AwesomeQRCode](https://github.com/SumiMakito/AwesomeQRCode)
JavaScript|[https://github.com/SumiMakito/Awesome-qr.js](https://github.com/SumiMakito/Awesome-qr.js)
Kotlin|[https://github.com/SumiMakito/AwesomeQRCode-Kotlin](https://github.com/SumiMakito/AwesomeQRCode-Kotlin)
Python|[https://github.com/sylnsfar/qrcode](https://github.com/sylnsfar/qrcode)

## 联系

Email: [eyrefree@eyrefree.org](mailto:eyrefree@eyrefree.org)   
Weibo: [@EyreFree](http://weibo.com/eyrefree777)   
Twitter: [@EyreFree777](https://twitter.com/EyreFree777)   

## 协议

![](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/License_icon-mit-88x31-2.svg/128px-License_icon-mit-88x31-2.svg.png)

EFQRCode 基于 MIT 协议进行分发和使用，更多信息参见协议文件。
