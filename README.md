# LVModalQueue

This fixes 'NSInternalInconsistencyException's when _presentViewController:_ and _dismissViewController:_ are called, while a transition is already in progress. Transitions are queued for later execution.

[![CI Status](http://img.shields.io/travis/Lovoo/LVModalQueue.svg?style=flat)](https://travis-ci.org/Lovoo/LVModalQueue/)
[![Version](https://img.shields.io/cocoapods/v/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)
[![License](https://img.shields.io/cocoapods/l/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)
[![Platform](https://img.shields.io/cocoapods/p/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)

## Sample

![Sample image](Example/example.gif "Sample")

## Quick start

LVModalQueue is available on CocoaPods.

Add the following to your Podfile:
```ruby
pod 'LVModalQueue', :git => 'https://github.com/Lovoo/LVModalQueue'
```
Done! You don't have to import anything or change your existing code!

## Motivation

If a presentation or dismissal is currently in progress, when starting another one, a _NSInternalInconsistencyException_ is thrown because a transition is already in progress.

Having a big app with a lot of external frameworks comes with a lot of challenges.

One of them is, that most of this frameworks tend to present their UIViewControllers on _[UIApplication sharedApplication].keyWindow.rootViewController_.
Having truly interactive UIViewController transitions could also lead to multiple concurrent presentations as the user can start a transition, while an old one is still running.

## Implementation

LVModalQueue hooks into presentations and dismissals by swizzling into UIViewControllers _presentViewController:animated:completion:_ and _dismissViewControllerAnimated:completion:_ methods. If a transition is currently animating, it is queued for later execution when the transition is finished.

## Supported iOS Versions

LVModalQueue was tested on iOS 7 and above in the [LOVOO App](http://lovoo.com) with millions of users and reduced our crashes with concurrent transitions to zero.
