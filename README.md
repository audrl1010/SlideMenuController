# SlideMenuController

[![CI Status](http://img.shields.io/travis/audrl1010/SlideMenuController.svg?style=flat)](https://travis-ci.org/audrl1010/SlideMenuController)
[![Version](https://img.shields.io/cocoapods/v/SlideMenuController.svg?style=flat)](http://cocoapods.org/pods/SlideMenuController)
[![License](https://img.shields.io/cocoapods/l/SlideMenuController.svg?style=flat)](http://cocoapods.org/pods/SlideMenuController)
[![Platform](https://img.shields.io/cocoapods/p/SlideMenuController.svg?style=flat)](http://cocoapods.org/pods/SlideMenuController)

![alt text](https://github.com/audrl1010/SlideMenuController/blob/master/Example/SlideMenuController/gif.gif)

## Requirements
iOS 9+

## Installation

SlideMenuController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SlideMenuController'
```

## Usage

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    ...
    let slideMenuController = SlideMenuController(
      mainViewController: mainViewController,
      leftViewController: leftViewController,
      rightViewController: rightViewController
    )

    window?.rootViewController = slideMenuController
    return true
  }
}

```

### Properties
```swift
var animationDuration: TimeInterval

var leftVisibleWidthPercentage: CGFloat
var rightVisibleWidthPercentage: CGFloat

var allowedRightSwipe: Bool
var allowedLeftSwipe: Bool

var minimumMovePercentage: CGFloat
var panningLimitedToTopViewController: Bool

var mainNavigationBarLeftToggleButtonIcon: UIImage?
var mainNavigationBarRightToggleButtonIcon: UIImage?
```

### Methods
```swift
func setRight(viewController newRightViewController: UIViewController?)
func setLeft(viewController newLeftViewController: UIViewController?)
func setMain(viewController newMainViewController: UIViewController?)

func showMain()
func showRight()
func showLeft()

func toggleLeft()
func toggleRight()
```

## Author

🇰🇷Myung gi son, audrl1010@naver.com

## License

SlideMenuController is available under the MIT license. See the LICENSE file for more info.
