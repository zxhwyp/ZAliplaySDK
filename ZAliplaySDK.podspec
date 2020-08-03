#
# Be sure to run `pod lib lint ZAliplaySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZAliplaySDK'
  s.version          = '0.1.1'
  s.summary          = 'A short description of ZAliplaySDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/周小华/ZAliplaySDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '周小华' => 'zxhworkmail@163.com' }
  s.source           = { :git => 'https://github.com/zxhwyp/ZAliplaySDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.prefix_header_contents = '#import "AlivcMacro.h"','#import "AlivcImage.h"','#import "AVC_ShortVideo_Config.h"','#import "AlivcMacro.h"','#import "AlivcImage.h"','#import "AlivcMacro.h"','#import "AlivcImage.h"'


  s.ios.deployment_target = '8.0'

  s.source_files = 'ZAliplaySDK/Classes/**/*'
  

  s.static_framework = true

  s.dependency 'AFNetworking'

  s.dependency 'FMDB'

  s.dependency 'JSONModel'

  s.dependency  'ZipArchive'

  s.dependency  'MBProgressHUD'

  s.dependency  'SDWebImage'

  s.dependency 'IQKeyboardManager'
  
  s.dependency 'MJRefresh', '~> 3.1.15.7'
  s.dependency 'MRDLNA'

  s.dependency 'AliPlayerSDK_iOS', '5.1.4'
  s.dependency 'AliPlayerSDK_iOS_ARTP', '5.1.4'
  s.dependency 'AliPlayerSDK_iOS_ARTC', '5.1.4'

   s.resource_bundles = {
     'ZAliplaySDK' => ['ZAliplaySDK/Assets/**/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
