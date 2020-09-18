![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/EFQRCode.jpg)

<p align="center">
    <a href="https://travis-ci.org/EFPrefix/EFQRCode">
        <img src="http://img.shields.io/travis/EFPrefix/EFQRCode.svg">
    </a>
    <a href="https://codecov.io/gh/EFPrefix/EFQRCode">
        <img src="https://codecov.io/gh/EFPrefix/EFQRCode/branch/master/graph/badge.svg">
    </a>
    <a href="https://efprefix.github.io/EFQRCode/">
        <img src="https://efprefix.github.io/EFQRCode/badge.svg">
    </a>
    <a href="https://github.com/Carthage/Carthage/">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat">
    </a>
    <a href="https://swift.org/package-manager/">
        <img src="https://img.shields.io/badge/SPM-ready-orange.svg">
    </a>
    <a href="http://cocoapods.org/pods/EFQRCode">
        <img src="https://img.shields.io/cocoapods/v/EFQRCode.svg?style=flat">
    </a>
    <a href="http://cocoapods.org/pods/EFQRCode">
        <img src="https://img.shields.io/cocoapods/p/EFQRCode.svg?style=flat">
    </a>
    <a href="https://github.com/apple/swift">
        <img src="https://img.shields.io/badge/language-swift-orange.svg">
    </a>
    <a href="https://codebeat.co/projects/github-com-efprefix-efqrcode-master">
        <img src="https://codebeat.co/badges/c2ae977c-157a-4cb7-a476-76530e7f292b">
    </a>
    <a href="https://raw.githubusercontent.com/EFPrefix/EFQRCode/master/LICENSE">
        <img src="https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat">
    </a>
    <a href="https://gitter.im/EFQRCode/Lobby">
        <img src="https://img.shields.io/gitter/room/EFPrefix/EFQRCode.svg">
    </a>
    <a href="#backers" alt="sponsors on Open Collective">
        <img src="https://opencollective.com/EFQRCode/backers/badge.svg" />
    </a>
    <a href="#sponsors" alt="Sponsors on Open Collective">
        <img src="https://opencollective.com/EFQRCode/sponsors/badge.svg" />
    </a>
    <a href="https://twitter.com/EyreFree777">
        <img src="https://img.shields.io/badge/twitter-@EyreFree777-blue.svg?style=flat">
    </a>
    <a href="http://weibo.com/eyrefree777">
        <img src="https://img.shields.io/badge/weibo-@EyreFree-red.svg?style=flat">
    </a>
    <a href="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/icon/MadeWith%3C3.png">
        <img src="https://img.shields.io/badge/made%20with-%3C3-orange.svg">
    </a>
    <a href="http://shang.qq.com/wpa/qunwpa?idkey=d0f732585dcb0c6f2eb26bc9e0327f6305d18260eeba89ed26a201b520c572c0">
        <img src="https://img.shields.io/badge/Q群-769966374-32befc.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAQCAMAAAARSr4IAAAA4VBMVEUAAAAAAAAAAAD3rwgAAAAAAADpICBuTQNUDAwAAAAAAAAAAAAAAADnICAAAAAAAACbFRUAAAD5rgkfFgEAAADHGxu1GBhGOyQ6LhMPCgAAAAB0UQRbDAziHh7hHh5HRUEAAAAPAgIQCwEQEBAdBAQgICAvIQIvLy8+LAJAQEBJCgpWRBpbW1tfX19gYGBqZVptTARvb299VwSAgICEhISHh4ePhnGbbAWgoKCseAawsLC7gwbAwMDExMTFrKzLjgfoHx/powfqpAjvZGTw8PDxcnLxenrzj4/5rgj5x8f///9y6ONcAAAAIHRSTlMAECAgMEBQVlhggZGhobHBwdHR3eHh4+fp7/Hx9/f5+3tefS0AAACkSURBVHjaNc1FAsJAEAXRDj64BAv2IbgEd2s0gfsfiJkAtXurIpkWMQBd0K8O3KZfhWEeW9YB8LnUYY2Gi6WJqJIHwKo7GAMpRT/aV0d2BhRD/Xp7tt9OGs2yYoy5mpUxc0BOc/yvkiQSwJPZtu3XCdAoDtjMb5k8C9KN1utx+zFChsD97bYzRII0Ss2/7IUliILFjZKV8ZLM61xK+V6tsHbSRB+BYB6Vhuib7wAAAABJRU5ErkJggg==">
    </a>
</p>

EFQRCode 是一个轻量级的、用来生成和识别二维码的纯 Swift 库，可根据输入的水印图和图标产生艺术二维码，基于 `CoreGraphics`、`CoreImage` 和 `ImageIO` 进行开发。EFQRCode 为你提供了一种更好的在你的 App 中操作二维码的方式，它能够运行于 `iOS`、`macOS`、`watchOS` 和 `tvOS` 平台，并且支持通过 `CocoaPods`、`Carthage` 和 `Swift Package Manager` 获取。本项目受 [qrcode](https://github.com/sylnsfar/qrcode) 启发。

> [English Introduction](https://github.com/EFPrefix/EFQRCode/blob/master/README.md)

## 概述

![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode5.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode6.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode7.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode8.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF1.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF2.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF7.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF8.gif)  

## 示例

### 应用商店

你可以点击下方的 App Store 按钮从应用商店下载示例程序，支持 `iOS`、`tvOS` 和 `watchOS`：

<a target='_blank' href='https://itunes.apple.com/cn/app/EFQRCode/id1242337058?mt=8'>
	<img src='https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/icon/AppStore.jpeg' width='144' height='49'/>
</a>

你也可以点击下方的 Mac App Store 按钮下载 `macOS` 示例程序：

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

| 版本     | 需求                                                                           |
|:--------|:-------------------------------------------------------------------------------|
| 1.x     | Xcode 8.0+<br>Swift 3.0+<br>iOS 8.0+ / macOS 10.11+ / tvOS 9.0+                |
| 4.x     | Xcode 9.0+<br>Swift 4.0+<br>iOS 8.0+ / macOS 10.11+ / tvOS 9.0+ / watchOS 2.0+ |
| 5.x     | Xcode 11.1+<br>Swift 5.0+<br>iOS 8.0+ / macOS 10.11+ / tvOS 9.0+ / watchOS 2.0+|

## 安装

### CocoaPods

EFQRCode 可以通过 [CocoaPods](http://cocoapods.org) 进行获取。只需要在你的 Podfile 中添加如下代码就能实现引入：

```ruby
pod 'EFQRCode', '~> 5.1.8'
```

如果你需要在 watchOS 中使用的话，请使用 `pod 'EFQRCode/watchOS'`。

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
github "EFPrefix/EFQRCode" ~> 5.1.8
```

接下来执行 `carthage update` 命令生成 Framework 并且将生成的 `EFQRCode.framework` 拖入工程即可。

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) 是一个集成在 `swift` 编译器中的用来进行 Swift 代码自动化发布的工具。

如果你已经建立了你的 Swift 包，将 EFQRCode 加入依赖是十分容易的，只需要将其添加到你的 `Package.swift` 文件的 `dependencies` 项中即可：

```swift
dependencies: [
    .Package(url: "https://github.com/EFPrefix/EFQRCode.git", Version(5, 1, 8))
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
if let testImage = UIImage(named: "test.png")?.cgImage() {
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
//                    content: 二维码内容
//            size (Optional): 二维码宽高
// backgroundColor (Optional): 二维码背景色
// foregroundColor (Optional): 二维码前景色
//       watermark (Optional): 水印图
```

```swift
if let tryImage = EFQRCode.generate(
    content: "https://github.com/EFPrefix/EFQRCode",
    watermark: UIImage(named: "WWF")?.cgImage()
) {
    print("Create QRCode image success: \(tryImage)")
} else {
    print("Create QRCode image failed!")
}
```

结果：

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/sample1.jpg" width = "36%"/>

#### 4. 动态二维码

可通过 EFQRCode 的类方法 generateWithGIF 来创建 GIF 二维码，使用方式如下：

```swift
//                  data: 输入的 GIF 图片的数据
//             generator: 一个用来获取设置的 EFQRCodeGenerator 对象
// pathToSave (Optional): 用来存储 GIF 的路径，默认不填的话会存储在临时路径
//      delay (Optional): 输出的动态 QRCode 的帧间延时，默认不填的话从输入的 GIF 图片获取
//  loopCount (Optional): 输出的动态 QRCode 的循环次数，默认不填的话从输入的 GIF 图片获取
```

```swift
if let qrcodeData = EFQRCode.generateWithGIF(data: data, generator: generator) {
    print("Create QRCode image success.")
} else {
    print("Create QRCode image failed!")
}
```

你可以通过查看 Demo 代码的方式来获取更多信息，结果预览：

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF6.gif" width = "36%"/>

#### 5. 接下来

查看 [用户手册](https://github.com/EFPrefix/EFQRCode/blob/master/USERGUIDE_CN.md) 了解更多细节。

您也可以查看下列非官方的使用说明：

- [不用请设计师，你也能做出个性二维码：EFQRCode](https://sspai.com/post/43211)
- [想更优雅地分享 Wi-Fi 密码，只需一枚二维码](https://sspai.com/post/43097)

## 待办

- [x] 支持 GIF 动图
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
Objective-C|[https://github.com/z624821876/YSQRCode](https://github.com/z624821876/YSQRCode)
Java|[https://github.com/SumiMakito/AwesomeQRCode](https://github.com/SumiMakito/AwesomeQRCode)
JavaScript|[https://github.com/SumiMakito/Awesome-qr.js](https://github.com/SumiMakito/Awesome-qr.js)
Kotlin|[https://github.com/SumiMakito/AwesomeQRCode-Kotlin](https://github.com/SumiMakito/AwesomeQRCode-Kotlin)
Python|[https://github.com/sylnsfar/qrcode](https://github.com/sylnsfar/qrcode)

## 贡献者

这个项目的存在多亏了所有贡献的人。 [[Contribute](https://github.com/EFPrefix/EFQRCode/blob/master/CONTRIBUTING.md)]

<a href="https://opencollective.com/efqrcode#contributors">
    <img src="https://opencollective.com/efqrcode/contributors.svg?width=890" />
</a>

备注：`watchOS` 平台的的原始二维码生成代码基于 [swift_qrcodejs](https://github.com/ApolloZhu/swift_qrcodejs) 实现，在此对原作者 [ApolloZhu](https://github.com/ApolloZhu) 所做的工作表示感谢。

## 捐赠

如果你认为这个项目给你带来了帮助，你可以给我买杯咖啡。如果你喜欢这个项目，并愿意为它的发展提供进一步的支持，你可以选择在 [Open Collective](https://opencollective.com/efqrcode) 上成为 `支持者` 或 `赞助商`。

### 支持者

感谢所有的支持者！ 🙏 [[Become a backer](https://opencollective.com/efqrcode#backer)]

<a href="https://opencollective.com/efqrcode#backers" target="_blank">
    <img src="https://opencollective.com/efqrcode/backers.svg?width=890">
</a>

### 赞助商

通过成为赞助商来支持这个项目，您的徽标将显示在这里并且链接到您的网站。 [[Become a sponsor](https://opencollective.com/efqrcode#sponsor)]

<a href="https://opencollective.com/efqrcode/sponsor/0/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/0/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/1/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/1/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/2/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/2/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/3/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/3/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/4/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/4/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/5/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/5/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/6/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/6/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/7/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/7/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/8/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/8/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/9/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/9/avatar.svg">
</a>

感谢您的支援，🙏

## 感谢

- 感谢 JetBrains 的 [开源支持计划](https://www.jetbrains.com/community/opensource/?from=EFQRCode) 对本项目的帮助。

<a href="https://www.jetbrains.com/?from=EFQRCode">
    <img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/ce8982e1858d62ac8b9fecec96f5369d8b1b62c3/logo/jetbrains.svg?sanitize=true" width = "20%">
</a>

## 使用 EFQRCode 的应用

<table>
    <tr>
        <td>
            <a href='https://www.appsight.io/app/blizzard-battle-net' title='Blizzard Battle.net'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/000/863/841/media/small.png?1506955529'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/brushfire' title='Brushfire'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/349/312/media/small.png?1552274504'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/826953' title='Coinomi Wallet'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/154/094/media/small.png?1523038915'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/join' title='Join - Medical Communication'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/253/338/media/small.png?1530300113'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/mume-vpn' title='Mume VPN'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/000/880/440/media/small.png?1507339273'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/mymk' title='myMK'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/142/715/media/small.png?1522686154'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/pilot-speech-translator' title='Pilot Speech Translator'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/000/531/486/media/small.png?1491242852'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/promgirl-shop' title='PromGirl Shop'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/327/819/media/small.png?1547953350'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/wifi-ch%C3%B9a' title='WiFi Chùa'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/000/282/599/media/small.png?1479441667'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/yamibuy-food-drinks-beauty-health-li' title='Yamibuy-Food&amp; Drinks, Beauty, Health, Li'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/324/148/media/small.png?1546987889'>
            </a>
        </td>
    </tr>
    <tr>
        <td>
            <a href='https://www.appsight.io/app/%E5%85%B3%E5%85%AB-%E5%85%A8%E6%B0%91%E5%A8%B1%E4%B9%90%E6%98%8E%E6%98%9F%E5%85%AB%E5%8D%A6%E5%A4%B4%E6%9D%A1%E6%96%B0%E9%97%BB%E8%B5%84%E8%AE%AF%E8%A7%86%E9%A2%91%E7%A4%BE%E5%8C%BA' title='关八-最懂娱乐圈'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/000/613/969/media/small.png?1495232846'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/%E7%BA%A2%E8%A2%96%E8%AF%BB%E4%B9%A6' title='红袖读书'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/345/043/media/small.png?1551923326'>
            </a>
        </td>
    </tr>
</table>

## 其他

文档与演示项目中部分图片来源于网络，如侵犯您的合法权益，请联系我们删除。

## 联系

邮箱：[eyrefree@eyrefree.org](mailto:eyrefree@eyrefree.org)   
技术交流群：[769966374](http://shang.qq.com/wpa/qunwpa?idkey=d0f732585dcb0c6f2eb26bc9e0327f6305d18260eeba89ed26a201b520c572c0)

## 协议

<a href="https://github.com/EFPrefix/EFQRCode/blob/master/LICENSE">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/License_icon-mit-88x31-2.svg/128px-License_icon-mit-88x31-2.svg.png">
</a>

EFQRCode 基于 MIT 协议进行分发和使用，更多信息参见协议文件。
