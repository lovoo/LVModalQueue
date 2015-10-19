# LVModalQueue

This fixes 'NSInternalInconsistencyException's when presentViewController: and dismissViewController: are called, while a transition is already in progress. Transitions are queued for later execution.

[![CI Status](http://img.shields.io/travis/Lovoo/LVModalQueue.svg?style=flat)](https://travis-ci.org/Lovoo/LVModalQueue)
[![Version](https://img.shields.io/cocoapods/v/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)
[![License](https://img.shields.io/cocoapods/l/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)
[![Platform](https://img.shields.io/cocoapods/p/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)

## Installation

LVModalQueue is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LVModalQueue"
```

## Usage

1. Install.
2. Thats it!

LVModalQueue hooks into each call to presentViewController:animated:completion: and dismissViewController:animated:completion and recognizes, if any previous transition is not finished yet.

## License

LVModalQueue is available under the LOVOO license. See the LICENSE file for more info.
