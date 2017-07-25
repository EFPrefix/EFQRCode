#
# Be sure to run `pod lib lint EFQRCode.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'EFQRCode'
s.version          = '1.2.6'
s.summary          = 'A better way to operate quick response code in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
EFQRCode is a lightweight, pure-Swift library for generating pretty QRCode image with input watermark or icon and recognizing QRCode from image, it is based on CoreImage. It provides you a better way to operate QRCode in your app.
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

s.requires_arc = true

s.source_files = 'Source/*.swift'

# s.resource_bundles = {
#   'EFQRCode' => ['EFQRCode/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
