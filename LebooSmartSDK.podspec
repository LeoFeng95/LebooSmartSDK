#
# Be sure to run `pod lib lint LebooSmartSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LebooSmartSDK'
  s.version          = '1.0.0'
  s.summary          = '智能牙刷'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  智能亚述SDK
                       DESC

  s.homepage         = 'https://github.com/LeoFeng95/LebooSmartSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LeoFeng' => 'fenglei@lebondsonic.com' }
  s.source           = { :git => 'https://github.com/LeoFeng95/LebooSmartSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'LebooSmartSDK/Classes/**/*'
  
  s.static_framework  =  true
  s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}
  # 依赖第三方
  s.dependency 'iOSDFULibrary'
  # 系统动态库(多个)
  s.frameworks = 'CoreBluetooth','Foundation'
  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.resource_bundles = {
  #   'LebooSmartSDK' => ['LebooSmartSDK/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
