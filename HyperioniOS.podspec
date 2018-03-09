#
# Be sure to run `pod lib lint HyperioniOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HyperioniOS'
  s.version          = '1.1.0'
  s.summary          = 'Hyperion is an app design review tool that allows you to inspect views and perform measurements live within your app.'
  s.module_name      = 'HyperionCore'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Hyperion is an app design review tool that allows you to inspect views and perform measurements live within your app. Hyperion is built on top of a plugin system so you can add and remove plugins as your workflow requires.
                       DESC

  s.homepage         = 'https://github.com/willowtreeapps/Hyperion-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chrsmys' => 'chris.mays@willowtreeapps.com' }
  s.source           = { :git => 'https://github.com/willowtreeapps/Hyperion-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.frameworks = ["UIKit"]

  s.subspec 'Core' do |core|
    core.source_files = 'Core/**/*.{h,m}'
    core.exclude_files = 'Core/**/*.md'
    core.resources = ['Core/**/*.png', 'Core/**/*.xib', 'Core/**/*.plist']
  end

  s.subspec 'AttributesInspector' do |attributes|
    attributes.dependency 'HyperioniOS/Core'
    attributes.source_files = 'AttributesInspector/**/*.{h,m}'
    attributes.exclude_files = 'AttributesInspector/**/*.md'
    attributes.resources = ['AttributesInspector/**/*.png', 'AttributesInspector/**/*.xib', 'AttributesInspector/**/*.plist']
  end

  s.subspec 'SlowAnimations' do |slowanimations|
    slowanimations.dependency 'HyperioniOS/Core'
    slowanimations.source_files = 'SlowAnimations/**/*.{h,m}'
    slowanimations.exclude_files = 'SlowAnimations/**/*.md'
    slowanimations.resources = ['SlowAnimations/**/*.png', 'SlowAnimations/**/*.xib', 'SlowAnimations/**/*.plist']
  end

  s.subspec 'Measurements' do |measurements|
    measurements.dependency 'HyperioniOS/Core'
    measurements.source_files = 'Measurements/**/*.{h,m}'
    measurements.exclude_files = 'Measurements/**/*.md'
    measurements.resources = ['Measurements/**/*.png', 'Measurements/**/*.xib', 'Measurements/**/*.plist']
  end

end
