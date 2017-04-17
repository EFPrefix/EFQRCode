#
# Be sure to run `pod lib lint EFQRCode.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'EFQRCode'
s.version          = '1.2.2'
s.summary          = 'A better way to operate quick response code in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
EFQRCode is a tool to generate QRCode image or recognize QRCode from image, in Swift. It is based on CoreImage.
Generation: Create pretty two-dimensional code image with input watermark or icon;
Recognition: Recognition rate is higher than simply CIDetector.
DESC

s.homepage         = 'https://github.com/EyreFree/EFQRCode'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'EyreFree' => 'eyrefree@eyrefree.org' }
s.source           = { :git => 'https://github.com/EyreFree/EFQRCode.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/EyreFree777'

s.ios.deployment_target = '8.0'
s.requires_arc = true

s.source_files = 'Source/*.swift'

# s.resource_bundles = {
#   'EFQRCode' => ['EFQRCode/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end