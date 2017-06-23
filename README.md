# HyperioniOS

[![CI Status](http://img.shields.io/travis/chrsmys/HyperioniOS.svg?style=flat)](https://travis-ci.org/willowtreeapps/HyperioniOS)
[![Version](https://img.shields.io/cocoapods/v/HyperioniOS.svg?style=flat)](http://cocoapods.org/pods/HyperioniOS)
[![License](https://img.shields.io/cocoapods/l/HyperioniOS.svg?style=flat)](http://cocoapods.org/pods/HyperioniOS)
[![Platform](https://img.shields.io/cocoapods/p/HyperioniOS.svg?style=flat)](http://cocoapods.org/pods/HyperioniOS)

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 9+

## Installation
HyperioniOS is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HyperioniOS/Core"

#Optional Hyperion Tools
pod 'HyperioniOS/AttributesInspector'
pod 'HyperioniOS/Measurements'
pod 'HyperioniOS/SlowAnimations'
```

## Adding Tools
Hyperion automatically finds every class that conforms to HYPPlugin and adds it to the drawer. If you want to customize what tools show up in your drawer you can add a special plist file called `HyperionDependencies.plist` that lists all of the plugins that should be added. Below is an example of the contents:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
	<string>HYPAttributesInspectorPlugin</string>
	<string>HYPSlowAnimationsPlugin</string>
	<string>HYPMeasurementsPlugin</string>
</array>
</plist>
```

## Author
WillowTree, Inc.
chris.mays@willowtreeapps.com

## License
HyperioniOS is available under the MIT license. See the LICENSE file for more info.
