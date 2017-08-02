# PoliteReview
A Polite Way to Request Reviews for iOS

<img src="/screenshots/screencap-1.png" width="188" height="334" />

# Features
Polite Review is an elegant way to request ratings and reviews from your users.

* Automatically grabs your localized app name and uses "this app" as a default.
* Localized, curently English, Chinese Simplied, and Chinese Traditional.

* For 10.3 and above, uses `StoreKit` to request reviews, in compliance with store guidelines.
* For below 10.3, falls back to a simple alert which will open the App Store to the review page.

<img src="/screenshots/screencap-3.png" width="188" height="334" />

## Coming Soon

* Swift 4
* Tests

# Getting Started

The best way to get started with PoliteReview is with Carthage(coming soon) and CocoaPods.

## Installation with CocoaPods
```swift
pod 'PoliteReview'
```

## Installation with Carthage
```swift
github "kevinchau/PoliteReview"

```

## Usage

Add PoliteReview to `AppDelegate`

```swift
import PoliteReview

...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    PoliteReview.main.setup(itunesID: <your itunes id>, contactURL: <a link to a website contact page>, contactEmail: <your contact email>, triggerCount: <a launch count>)
    return true
}
```
* Your iTunes App ID is a string of numbers, found in iTunes connect.
* Trigger count is the minimum number of times your app has been launched before any alerts are shown. If no value is specified, it will default to 5.

In any ViewController, you can request a review by calling `requestPoliteReview()`. PoliteReview will determine if an alert will be shown.

Example:

```swift
class ViewController: UIViewController {
...

    func methodCalledByUser() {
    ...
    requestPoliteReview()
    }
}    
```

## Notifications
PoliteReview supports KVO. You can use these to trigger analytics events, or for other things. They will report with `userInfo` for the result of the action, with yes as `true` and no as `false`

`Notification.Name` is extended, and you may observe the following.
* `.politeReviewLoveAlert` with `userInfo`: `PoliteReviewNotification.loveAlert`
* `.politeReviewLegacyRequest` with `userInfo`: `PoliteReviewNotification.legacyReview`
* `.politeReviewContactAction` with `userInfo`: `PoliteReviewNotification.contactAction`

`.politeReviewLegacyRequest` is only posted when a user is below `10.3`.

Usage:
```swift
// Register your observer
NotificationCenter.default.addObserver(self, selector: #selector(observedMethod(_:)), name: .politeReviewLoveAlert, object: nil)

// Method to handle your observer
@objc private func observedMethod(_ notification: Notification) {
    if let action = notification.userInfo?[PoliteReviewNotification.loveAlert] as? Bool {
        if action == true {
            // Do stuff when user likes your app - they may have left a rating
        } else {
            // Do stuff when user did not like your app
        }
}
```



