#
# Be sure to run `pod lib lint HyperioniOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HyperioniOS'
  s.version          = '0.1.0'
  s.summary          = 'Hyperion is a view debugging tool that allows you to inspect views attributes and measurements in app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Hyperion is a view debugging tool that allows you to inspect views attributes and measurements in app.
                       DESC

  s.homepage         = 'https://github.com/willowtreeapps/Hyperion-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chrsmys' => 'chris.mays@willowtreeapps.com' }
  s.source           = { :git => 'https://github.com/willowtreeapps/Hyperion-iOS', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HyperioniOS/Classes/View\ debugger/**/*'

  # s.resource_bundles = {
  #   'HyperioniOS' => ['HyperioniOS/Assets/*.png']
  # }

  s.public_header_files = '**/*.h'
  s.frameworks = 'UIKit'

  s.subspec 'Core' do |core|
    core.source_files = 'View\ debugger/**/*'
  end

  s.subspec 'AttributesInspector' do |attributes|
    attributes.source_files = 'AttributesInspector/**/*'
  end

  s.subspec 'SlowAnimations' do |slowanimations|
    slowanimations.source_files = 'SlowAnimations/**/*'
  end

  s.subspec 'Measurements' do |measurements|
    measurements.source_files = 'Measurements/**/*'
  end
      # s.dependency 'AFNetworking', '~> 2.3'
end
