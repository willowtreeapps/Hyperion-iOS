# Change Log
All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.2.0] Apr 30, 2021
### Fixed
* Removed strong reference to attachedWindow (#60)
* Fixed issue with Hyperion window attaching with UISceneDelegate (#67)
* Updated Xcode Build version to 12.4.0 (#68)

## [1.1.0] Mar 15, 2018
### Added
- Add accessibility identifiers to the main window

### Fixed
- Fixed an issue where carthage builds did not correctly include bitcode
- Podspec name change - HyperionCore (#50)
- Refactor core plugin / overlay modules to support simpler interface from Snapshot module

## [1.0.2] Jan 22, 2018
### Fixed
- Fixes a compatibility issue with older iOS versions. (#40)
- Fixes a resources issue when integrating with CocoPods. (#33)
- Fixes issue where the slow animations plugin menu item would get cut off in certain scenarios. (#35)
- Fixes an iOS 11 specific issue where sometimes the navigation controller would block selection of other views. (#31)
- Sets a reliable order for plugins in the plugin menu (alphabetical).

## [1.0.1] Dec 8, 2017
### Added
- Handle nil plugin modules by logging the error. (#17)
- Add empty state that appears when no plugins are added. (#13)

### Fixed
- Fixed umbrella headers in HyperionCore. (#18)

## [1.0.0] Dec 4, 2017
### Added
- Initial release of Hyperion
