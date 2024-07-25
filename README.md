# LVModalQueue

This fixes 'NSInternalInconsistencyException's when _presentViewController:_ and _dismissViewController:_ are called, while a transition is already in progress. Transitions are queued for later execution.

[![Build Status](https://travis-ci.org/lovoo/LVModalQueue.svg?branch=master)](https://travis-ci.org/lovoo/LVModalQueue) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Quick start
### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/lovoo/LVModalQueue.git", .upToNextMajor(from: "0.3.0"))
]
```

### Cocoapods
```ruby
pod 'LVModalQueue', :git => 'https://github.com/Lovoo/LVModalQueue'
```

__Done! You don't have to import anything or change your existing code!__

## Sample

![Sample image](Example/example.gif "Sample")

## Motivation

If a presentation or dismissal is currently in progress, when starting another one, a _NSInternalInconsistencyException_ is thrown because a transition is already in progress.

Having a big app with a lot of external frameworks comes with a lot of challenges.

One of them is, that most of this frameworks tend to present their UIViewControllers on _[UIApplication sharedApplication].keyWindow.rootViewController_.
Having truly interactive UIViewController transitions could also lead to multiple concurrent presentations as the user can start a transition, while an old one is still running.

## Implementation

LVModalQueue hooks into presentations and dismissals by swizzling into UIViewControllers _presentViewController:animated:completion:_ and _dismissViewControllerAnimated:completion:_ methods. If a transition is currently animating, it is queued for later execution when the transition is finished.

## Supported iOS Versions

LVModalQueue was tested on iOS 7 and above in the [LOVOO App](http://lovoo.com) with millions of users and reduced our crashes with concurrent transitions to zero.
