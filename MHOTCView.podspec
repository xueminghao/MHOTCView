#
# Be sure to run `pod lib lint MHOTCView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MHOTCView'
  s.version          = '0.1.0'
  s.summary          = 'A view that used to input OTP(One time password) or OTC(One time code)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
We want a opt input view which can take full control of what it looks like and we also want it is compatibility with system such as the autofill feature. So we subclass UIView, it is drawn by CoreGraphics and we implement the UITextInput protocol to make it compatibility with ios system
                       DESC

  s.homepage         = 'https://github.com/xueminghao/MHOTCView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xueminghao' => 'minghaoxue@clubfactory.com' }
  s.source           = { :git => 'https://github.com/xueminghao/MHOTCView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MHOTCView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MHOTCView' => ['MHOTCView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
