# LVModalQueue

[![CI Status](http://img.shields.io/travis/Michael Berg/LVModalQueue.svg?style=flat)](https://travis-ci.org/Michael Berg/LVModalQueue)
[![Version](https://img.shields.io/cocoapods/v/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)
[![License](https://img.shields.io/cocoapods/l/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)
[![Platform](https://img.shields.io/cocoapods/p/LVModalQueue.svg?style=flat)](http://cocoapods.org/pods/LVModalQueue)

This fixes 'NSInternalInconsistencyException's when presentViewController: and dismissViewController: are called, while a transition is already in progress. Transitions are queued for later execution.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LVModalQueue is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LVModalQueue"
```

## Author

Michael Berg, berg.micha@icloud.com

## License

LVModalQueue is available under the LOVOO license. See the LICENSE file for more info.
