Pod::Spec.new do |s|
	s.name             = 'EFQRCode'
	s.version          = '6.2.2'
	s.summary          = 'A better way to operate quick response code in Swift.'

	s.description      = <<-DESC
	EFQRCode is a lightweight, pure-Swift library for generating pretty QRCode image with input watermark or icon and recognizing QRCode from image, it is based on CoreGraphics, CoreImage and ImageIO. EFQRCode provides you a better way to operate QRCode in your app, it works on iOS, macOS, tvOS and watchOS, and it is available through CocoaPods, Carthage and Swift Package Manager.
	DESC

	s.homepage         = 'https://github.com/EFPrefix/EFQRCode'
	s.screenshots      = 'https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/EFQRCode.jpg'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.authors          = { 'EyreFree' => 'eyrefree@eyrefree.org', 'ApolloZhu' => 'public-apollonian@outlook.com' }
	s.source           = { :git => 'https://github.com/EFPrefix/EFQRCode.git', :tag => s.version.to_s }
	s.social_media_url = 'https://twitter.com/EyreFree777'
	s.documentation_url = 'https://efprefix.github.io/EFQRCode'

	s.ios.deployment_target = '9.0'
	s.osx.deployment_target = '10.10'
	s.tvos.deployment_target = '9.0'
	s.watchos.deployment_target = '4.0'

	s.swift_version = '5.0'
	s.requires_arc = true

	s.frameworks = 'ImageIO', 'CoreGraphics', 'Foundation'
	s.ios.framework = 'CoreImage'
	s.osx.framework = 'CoreImage'
	s.tvos.framework = 'CoreImage'
	s.watchos.dependency 'swift_qrcodejs', '~> 2.2.2'

	s.source_files = 'Source/**/*.{h,swift}'
end
