#
# Be sure to run `pod lib lint WTCalendarController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WTCalendarController'
  s.version          = '0.1.0'
  s.summary          = 'A fast, simple, and flexible calendar controller with multiple date selection functionality.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a test description to explain what this library does. A fast, simple, and flexible calendar controller with multiple date selection functionality.
                       DESC

  s.homepage         = 'https://github.com/sbishopwta/WTCalendarController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Steven Bishop' => 'sbishop@alumni.berklee.edu' }
  s.source           = { :git => 'https://github.com/sbishopwta/WTCalendarController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/stevenbishop'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WTCalendarController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WTCalendarController' => ['WTCalendarController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
