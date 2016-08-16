#
# Be sure to run `pod lib lint WTCalendarController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WTCalendarController'
  s.version          = '0.1.2'
  s.summary          = 'A UI calendar controller for iOS.'

  s.description      = <<-DESC
   A fast, simple, and flexible calendar controller with multiple date selection functionality.
   WTACalendarController is perfect for having users select dates.
   WTACalendarController supports the Gregorian calendar.
                       DESC

  s.homepage         = 'https://github.com/sbishopwta/WTCalendarController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Steven Bishop' => 'sbishop@alumni.berklee.edu' }
  s.source           = { :git => 'https://github.com/sbishopwta/WTCalendarController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/stevenbishop'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WTCalendarController/Classes/*.m'
  s.public_header_files = 'WTCalendarController/Classes/*.h'
  s.resource_bundles = {
    'WTCalendarController' => ['WTCalendarController/Assets/*.xib', 'WTCalendarController/Assets/*.storyboard']
  }

  # s.public_header_files = 'WTCalendarController/Classes/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
