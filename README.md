# Hyperion

[![Platform](https://img.shields.io/cocoapods/p/HyperioniOS.svg?style=flat)](http://cocoapods.org/pods/HyperioniOS)
[![License](https://img.shields.io/cocoapods/l/HyperioniOS.svg?style=flat)](http://cocoapods.org/pods/HyperioniOS)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/HyperioniOS.svg?style=flat)](http://cocoapods.org/pods/HyperioniOS)
[![CI Status](https://circleci.com/gh/willowtreeapps/Hyperion-iOS.svg?style=shield)](https://circleci.com/gh/willowtreeapps/Hyperion-iOS)
![Hyperion Logo](https://github.com/willowtreeapps/Hyperion-ios/raw/master/Img/Hyperion-Logo.png)

# Hyperion - In App Design Review Tool

## What is it?

<p align="center" id="Hyperion Drawer">
  <img src="https://media.giphy.com/media/l4Ep2JJ27OngKOrmM/giphy.gif" />
</p>

Hyperion is a hidden plugin drawer that can easily be integrated into any app. The drawer sits discreetly 🙊 under the app so that it is there when you need it and out of the way when you don't. Hyperion plugins are designed to make inspection of your app quick and simple. For example, check out this plugin that allows you to measure distances between views:

<p align="center" id="Example Measurements">
  <img src="https://media.giphy.com/media/3ohjUPP3qnZ5l5osAE/giphy.gif" />
</p>

If you like what you see, there's more where that came from.

## First-Party Plugins

### View Inspector
The View Inspector plugin allows you to inspect the properties of any view live within the app.

<p align="center" id="View Inspector Example">
  <img src="https://media.giphy.com/media/l4EoNOILr5Ofvgysw/giphy.gif" />
</p>

Have a tiny view you want to inspect? No problem, you can zoom in on any portion of the app while the plugin is active.

<p align="center" id="Zoom Example">
  <img src="https://media.giphy.com/media/xT1R9Hf9383WjucomI/giphy.gif" />
</p>

### Measurements
The Measurements plugin allows you to measure the distance between any two views on the screen. No more guessing whether padding is correct-this plugin has you covered.

<p align="center" id="Example Measurements2">
  <img src="https://media.giphy.com/media/3ohjUPP3qnZ5l5osAE/giphy.gif" />
</p>

### Slow Animations
Having trouble verifying an animation matches design? The Slow Animations plugin allows you to slow down all animations within the app to 75%, 50% or 25% the normal speed.

<p align="center" id="Slow Animations">
  <img src="https://media.giphy.com/media/26FeZcNF9Dbq89MBi/giphy.gif" />
</p>

## Third-Party Plugins
Calling all developers!!! Be one of the first to create a third-party plugin. The plugin creation guide is a work in progress, but if you are feeling ambitious you can reference the plugins we have already created along with our [documentation](https://willowtreeapps.github.io/Hyperion-iOS/).

## How To Show Hyperion Plugin List
Once Hyperion is integrated into your app, simply shake your phone.

## Customizing Hyperion
Hyperion was designed as a drag and drop framework that requires 0 code to integrate. If you want to customize Hyperion you can create a configuration file (called HyperionConfiguration.plist). Use [this file](https://github.com/willowtreeapps/Hyperion-iOS/raw/master/Core/HyperionDefaultConfiguration.plist) as an example. For now you can only configure what gestures trigger the Hyperion drawer, but there are plans to add theming and plugin ordering.

## Example App
Want to learn how to use Hyperion? The example app will teach you!

Build the example project by cloning the repo, run `pod install` from the Example directory, then open in Xcode and run.

## Requirements
iOS 9+

## Installation
Since Hyperion is primarily a debugging library and should never be included in production, the steps below will outline how to install Hyperion in a way that keeps it out of production builds. There is also a guide below explaining how to verify which builds have Hyperion and which ones do not. Note: Hyperion doesn't require any code to integrate, so it should just work once added.

### CocoaPods

**Important you must specify `use_frameworks!` if this does not work for your project, then refer to the Carthage or manual guide.**

HyperioniOS is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!

pod "HyperioniOS/Core", :configurations => ['Debug']

#"Configurations => Debug" ensures it is only included in debug builds. Add any configurations you would like Hyperion to be included in.
pod 'HyperioniOS/AttributesInspector', :configurations => ['Debug'] # Optional plugin
pod 'HyperioniOS/Measurements', :configurations => ['Debug'] # Optional plugin
pod 'HyperioniOS/SlowAnimations', :configurations => ['Debug'] # Optional plugin
```

CocoaPods automatically handles ensuring that Hyperion will only be included in the configurations you have specified for the pods. For more information please reference [CooaPods Documentation](https://guides.cocoapods.org/syntax/podfile.html#pod).

### Carthage
To install through Carthage add `github "willowtreeapps/Hyperion-iOS"` to your cartfile. Then run `carthage update`. Drag and drop the created frameworks into your Xcode project. ***Important*** Make sure that Hyperion and any of it's frameworks are ***not*** included as embedded frameworks (Settings should be available in General project settings). Once you ensure that Hyperion is not included in the embedded frameworks change the status of the Hyperion frameworks under "Linked Frameworks and Libraries" section to optional. At this point your project settings should look something like this.
![Hyperion Frameworks Section](https://github.com/willowtreeapps/Hyperion-iOS/raw/master/Img/FrameworksSettings.png)

Next hop on over to the build phases section and add a custom run script. Make sure it is inserted right above the "Linked Frameworks and Libraries" build phase. Make this your custom run script:
```
#Add the configurations you want to include Hyperion in below.
if [ "$CONFIGURATION" == "Debug" ]; then
    /usr/local/bin/carthage copy-frameworks
fi
```
Next you are going to want to add each Hyperion framework path to the "Input Files" section of your build script. Your build script should look something like this:
![Hyperion Custom Build Script](https://github.com/willowtreeapps/Hyperion-iOS/raw/master/Img/CarthageIncludeScript.png)

For more information on this custom build script please refer to the [Carthage Documentation](https://github.com/Carthage/Carthage).

### Manual
You can download the latest frameworks [here](https://github.com/willowtreeapps/Hyperion-iOS/releases). There will be a zip file under the latest release called `HyperionCore.framework.Plugins.zip`. If you want to learn how to integrate into specific build configurations; follow the Carthage guide above.

Or if you want to manually build the frameworks:

Clone the git repo. In the root directory run `sh build.sh`. Once complete, the script will have generated the HyperionCore framework along with all of the first-party plugins. The only required framework is HyperionCore, but you should add at least one of the plugins that was generated. Follow the Carthage installation guide above to ensure that Hyperion does not get included in production.

### Verifying A Build Does Not Include Hyperion
***Note:*** This only works if you are using Hyperion Frameworks. If you are using Cocoapods ensure that you have specified "use_frameworks!".
#### Opening the IPA
1. Right click your IPA file and open it with Archive Utility. This should unzip your IPA.
2. Inside the unzipped IPA there should be an Application file. Depending on how the IPA was built it might be in a Payload folder. Once found, right click the Application file and select "Show Package Contents".
3. Inside the package there should be a folder called "Frameworks". Ensure that Hyperion and it's plugins are not included in that folder. If Hyperion is in that folder then that means Hyperion is included in that build.
4. As an extra step you can ensure that your apps executable is not attempting to load Hyperion. Inside your app package find your app's executable (It should be a unix executable in the root of the package). Run this:

```
otool -L {Unix Executable Path Here}
```

Verify the output does not contain any references to Hyperion or it's plugins

#### While Running The App
1. Ensure that none of the Hyperion triggers (shake, etc.) you have set activate Hyperion.
2. If attached to the debugger you can pause the process and run:
 ```
 image list -b
 ```
This will show all of the shared libraries that are currently loaded in the app. Make sure that Hyperion and it's frameworks are not listed.

## Adding Plugins
Hyperion plugins need to be added into the app at build time.
By default, Hyperion automatically finds every plugin that is available in the project. A feature is currently in progress that allows for specifying plugins in a plist for further customization.

## Contributing to Hyperion
Contributions are welcome. Please see the [Contributing guidelines](CONTRIBUTING.md).

Hyperion has adopted a [code of conduct](CODE_OF_CONDUCT.md) defined by the [Contributor Covenant](http://contributor-covenant.org), the same used by the [Swift language](https://swift.org) and countless other open source software teams.

## Troubleshooting
I'm getting this error after pod installing:
```
Unable to run command 'StripNIB HYPKeyValueTableViewCell.nib' - this target might include its own product.
```
This likely means you have not specified `use_frameworks!` in your podfile. If turning your pods into frameworks does not work for your project configuration, then please reference the Carthage or manual installation guide.

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
