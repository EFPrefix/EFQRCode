Pod::Spec.new do |s|
    s.name             = 'EFQRCode'
    s.version          = '7.0.3'
    s.summary          = 'A better way to operate quick response code in Swift.'

    s.description      = <<-DESC
    EFQRCode is a lightweight, pure-Swift library for generating stylized QRCode images with watermark or icon, and for recognizing QRCode from images. Based on `CoreGraphics`, `CoreImage`, and `ImageIO`, EFQRCode provides you a better way to handle QRCode in your app, no matter if it is on iOS, macOS, watchOS, tvOS, and/or visionOS. You can integrate EFQRCode through CocoaPods, Carthage, and/or Swift Package Manager.
    DESC

    s.homepage         = 'https://github.com/EFPrefix/EFQRCode'
    s.screenshots      = 'https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/EFQRCode.jpg'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.authors          = { 'EyreFree' => 'eyrefree@eyrefree.org', 'ApolloZhu' => 'public-apollonian@outlook.com' }
    s.source           = { :git => 'https://github.com/EFPrefix/EFQRCode.git', :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/EyreFree777'
    s.documentation_url = 'https://efprefix.github.io/EFQRCode'

    s.ios.deployment_target = '13.0'
    s.tvos.deployment_target = '13.0'
    s.osx.deployment_target = '10.15'
    s.watchos.deployment_target = '6.0'
    s.visionos.deployment_target = "1.0"

    s.swift_version = '5.0'
    s.requires_arc = true

    s.frameworks = 'ImageIO', 'CoreGraphics', 'Foundation'
    s.ios.framework = 'CoreImage'
    s.tvos.framework = 'CoreImage'
    s.osx.framework = 'CoreImage'
    s.visionos.framework = 'CoreImage'
    
    s.dependency 'SwiftDraw', '~> 0.22.0'
    s.dependency 'ef_swift_qrcodejs', '~> 2.3.1'

    s.source_files = 'Source/**/*.{h,swift}'
end

