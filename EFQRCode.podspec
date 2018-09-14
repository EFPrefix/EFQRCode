Pod::Spec.new do |s|
	s.name             = 'EFQRCode'
	s.version          = '4.3.0'
	s.summary          = 'A better way to operate quick response code in Swift.'

	s.description      = <<-DESC
	EFQRCode is a lightweight, pure-Swift library for generating pretty QRCode image with input watermark or icon and recognizing QRCode from image, it is based on CoreGraphics, CoreImage and ImageIO. EFQRCode provides you a better way to operate QRCode in your app, it works on iOS, macOS, tvOS and watchOS, and it is available through CocoaPods, Carthage and Swift Package Manager.
	DESC

	s.homepage         = 'https://github.com/EyreFree/EFQRCode'
	s.screenshots      = 'https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/EFQRCode.jpg'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'EyreFree' => 'eyrefree@eyrefree.org' }
	s.source           = { :git => 'https://github.com/EyreFree/EFQRCode.git', :tag => s.version.to_s }
	s.social_media_url = 'https://twitter.com/EyreFree777'

	s.ios.deployment_target = '8.0'
	s.osx.deployment_target = '10.11'
	s.tvos.deployment_target = '9.0'
	s.watchos.deployment_target = '2.0'

	s.requires_arc = true

	s.source_files = 'Source/**/*.{h,swift}'

	s.frameworks = 'ImageIO'
end
