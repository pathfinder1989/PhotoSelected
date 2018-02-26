#
# Be sure to run `pod lib lint MSPhotoSelecting.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MSPhotoSelecting'
  s.version          = '0.1.0'
  s.summary          = 'photo selecting '

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
photo selecting when your app needs photo
                       DESC

  s.homepage         = 'https://gitee.com/pathfinder1989/MSPhotosSelecting'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lala.kang1989@gmail.com' => 'lala.kang1989@gmail.com' }
  s.source           = { :git => 'https://gitee.com/pathfinder1989/MSPhotosSelecting.git', :tag => "0.1.0" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MSPhotoSelecting/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MSPhotoSelecting' => ['MSPhotoSelecting/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
