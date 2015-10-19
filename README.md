# LVModalQueue

This fixes 'NSInternalInconsistencyException's when presentViewController: and dismissViewController: are called, while a transition is already in progress. Transitions are queued for later execution.

[![CI Status](http://img.shields.io/travis/Lovoo/LVModalQueue.svg?style=flat)](https://travis-ci.org/Lovoo/LVModalQueue)
[![Version](https://img.shields.io/cocoapods/v/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)
[![License](https://img.shields.io/cocoapods/l/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)
[![Platform](https://img.shields.io/cocoapods/p/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)

## Sample

![Sample image](Example/example.gif "Sample")

## Installation

LVModalQueue is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LVModalQueue"
```

## Usage

1. Install.
2. __Thats it!__

LVModalQueue hooks into each call to _presentViewController:animated:completion:_ and _dismissViewController:animated:completion:_ and recognizes, if any previous transition has not finished yet.

## License

LVModalQueue is available under the LOVOO license. See the LICENSE file for more info.
