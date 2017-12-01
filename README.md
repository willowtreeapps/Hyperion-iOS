# Hyperion

[![CI Status](http://img.shields.io/travis/chrsmys/HyperioniOS.svg?style=flat)](https://travis-ci.org/willowtreeapps/HyperioniOS)
[![Version](https://img.shields.io/cocoapods/v/HyperioniOS.svg?style=flat)](http://cocoapods.org/pods/HyperioniOS)
[![License](https://img.shields.io/cocoapods/l/HyperioniOS.svg?style=flat)](http://cocoapods.org/pods/HyperioniOS)
[![Platform](https://img.shields.io/cocoapods/p/HyperioniOS.svg?style=flat)](http://cocoapods.org/pods/HyperioniOS)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

![Hyperion Logo](https://github.com/willowtreeapps/Hyperion-ios/raw/master/Img/Hyperion-Logo.png)

# Hyperion - In App Design Review Tool

## What is it?

![Hyperion Drawer](https://media.giphy.com/media/l4Ep2JJ27OngKOrmM/giphy.gif)

Hyperion is a hidden plugin drawer that can easily be integrated into any app. The drawer sits discreetly 🙊 under the app so that it is there when you need it and out of the way when you don't. Hyperion plugins are designed to make inspection of your app quick and simple. For example, check out this plugin that allows you to measure distances between views:

![Example Measurements](https://media.giphy.com/media/3ohjUPP3qnZ5l5osAE/giphy.gif)

If you like what you see, there's more where that came from.

## First-Party Plugins

### View Inspector
The View Inspector plugin allows you to inspect the properties of any view live within the app.

![View Inspector Example](https://media.giphy.com/media/l4EoNOILr5Ofvgysw/giphy.gif)

Have a tiny view you want to inspect? No problem, you can zoom in on any portion of the app while the plugin is active.

![Zoom Example](https://media.giphy.com/media/xT1R9Hf9383WjucomI/giphy.gif)

### Measurements
The Measurements plugin allows you to measure the distance between any two views on the screen. No more guessing whether padding is correct-this plugin has you covered.

![Example Measurements](https://media.giphy.com/media/3ohjUPP3qnZ5l5osAE/giphy.gif)

### Slow Animations
Having trouble verifying an animation matches design? The Slow Animations plugin allows you to slow down all animations within the app to 75%, 50% or 25% the normal speed.

![Slow Animations](https://media.giphy.com/media/26FeZcNF9Dbq89MBi/giphy.gif)


## Third-Party Plugins
Calling all developers!!! Be one of the first to create a third-party plugin. Follow the plugin creation guide and let us know what you make!

## How To Show Hyperion Plugin List
Once Hyperion is integrated into your app, simply shake your phone.

## Customizing Hyperion
Hyperion was designed as a drag and drop framework that requires 0 code to integrate. If you want to customize Hyperion you can create a configuration file (called HyperionConfiguration.plist). Use [this file](https://github.com/willowtreeapps/Hyperion-ios/raw/master/core/HyperionDefaultConfiguration.plist) as an example. For now you can only configure what gestures trigger the Hyperion drawer, but there are plans to add theming and plugin ordering.

## Example App
Want to learn how to use Hyperion? The example app will teach you!

Build the example project by cloning the repo, run `pod install` from the Example directory, then open in Xcode and run.

## Requirements
iOS 9+

## Installation

#### CocoaPods

HyperioniOS is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HyperioniOS/Core"

#Optional Hyperion Plugins
pod 'HyperioniOS/AttributesInspector'
pod 'HyperioniOS/Measurements'
pod 'HyperioniOS/SlowAnimations'
```

#### Carthage
•Add `github "willowtreeapps/Hyperion-iOS"` to your cartfile.
<br>
•Run `carthage update`
<br>
•Drag and drop newly created frameworks into the project.

### Manual
Clone the git repo. In the root directory run `sh build.sh`. Once complete, the script will have generated the HyperionCore framework along with all of the first-party plugins. The only required framework is HyperionCore, but you should add at least one of the plugins that was generated.

Drag and drop HyperionCore along with any of the plugins you want into your Xcode project. While importing make sure to check `copy items if needed` checkbox. After importing add HyperionCore along with any plugins in to the embedded binaries section under your projects settings.

![Hyperion Integration](https://github.com/willowtreeapps/Hyperion-ios/raw/master/Img/Hyperion-Integration.gif)

## Adding Plugins
Hyperion plugins need to be added into the app at build time.
By default, Hyperion automatically finds every plugin that is available in the project. A feature is currently in progress that allows for specifying plugins in a plist for further customization.

## Contributors
[Chris Mays](https://github.com/chrsmys)
<br>[Matt Kauper](https://github.com/mhk4g)
<br>[Ben Humphries](https://github.com/imachumphries)
## License
Hyperion is available under the MIT license. See the LICENSE file for more info.

# About WillowTree!
![WillowTree Logo](https://github.com/willowtreeapps/spruce-ios/raw/master/imgs/willowtree_logo.png)

We build apps, responsive sites, bots—any digital product that lives on a screen—for the world’s leading companies. Our elite teams challenge themselves to build extraordinary experiences by bridging the latest strategy and design thinking with enterprise-grade software development.

Interested in working on more unique projects like Hyperion? Check out our [careers page](http://willowtreeapps.com/careers?utm_campaign=hyperion-gh).
