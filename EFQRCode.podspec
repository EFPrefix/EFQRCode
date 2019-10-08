Pod::Spec.new do |s|
	s.name             = 'EFQRCode'
	s.version          = '5.1.0'
	s.summary          = 'A better way to operate quick response code in Swift.'

	s.description      = <<-DESC
	EFQRCode is a lightweight, pure-Swift library for generating pretty QRCode image with input watermark or icon and recognizing QRCode from image, it is based on CoreGraphics, CoreImage and ImageIO. EFQRCode provides you a better way to operate QRCode in your app, it works on iOS, macOS, tvOS and watchOS, and it is available through CocoaPods, Carthage and Swift Package Manager.
	DESC

	s.homepage         = 'https://github.com/EFPrefix/EFQRCode'
	s.screenshots      = 'https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/EFQRCode.jpg'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'EyreFree' => 'eyrefree@eyrefree.org' }
	s.source           = { :git => 'https://github.com/EFPrefix/EFQRCode.git', :tag => s.version.to_s }
	s.social_media_url = 'https://twitter.com/EyreFree777'

	s.swift_version = '5.0'

	s.ios.deployment_target = '8.0'
	s.osx.deployment_target = '10.11'
	s.tvos.deployment_target = '9.0'

	s.requires_arc = true
	s.source_files = 'Source/**/*.{h,swift}'
	
	s.frameworks = 'ImageIO', 'CoreGraphics', 'Foundation'
    s.dependency 'EFFoundation', '~> 1.0.0'
	
	s.default_subspec = 'Core'

	s.subspec 'Core' do |core|
		
  	end

  	s.subspec 'watchOS' do |watchos|
  		watchos.watchos.deployment_target = '2.0'

  		watchos.dependency 'swift_qrcodejs', '~> 1.1.1'
  	end
end
