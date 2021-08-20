# MaxLength

[![CI Status](https://img.shields.io/travis/fuyoufang/MaxLength.svg?style=flat)](https://travis-ci.org/fuyoufang/MaxLength)
[![Version](https://img.shields.io/cocoapods/v/MaxLength.svg?style=flat)](https://cocoapods.org/pods/MaxLength)
[![License](https://img.shields.io/cocoapods/l/MaxLength.svg?style=flat)](https://cocoapods.org/pods/MaxLength)
[![Platform](https://img.shields.io/cocoapods/p/MaxLength.svg?style=flat)](https://cocoapods.org/pods/MaxLength)

在输入电话号码，设置昵称时，App 一般会设置一个允许输入的最大长度，来提示用户输入的内容过长了。

当用户输入的是纯英文字母、数字时，只需要在 UITextField、UITextView 的代理中判断用户输入的字符长度就可以了。但是在输入中文时，有一个从输入的拼音字符到联想到的汉字，再到确认汉字的过程。整个过程，UITextField 和 UITextView 都会通知代理用户输入的字符产生了变化。但是，在用户输入拼音字符时，也就是还没有确实汉字之前，就判断字符长度就会出现差错。

当用户输入中文时，如何知道 UITextField 或者 UITextView 处于输入了拼音，还处于汉字联想阶段呢？

可以通过输入框当前是否有高亮部分进行判断，如果有高亮部分，则意味着当前正在输入，这时就不进行字数统计；反之没有高亮部分时，就代表用户已经确认了一个汉字或者词语，这时候就可以做字符长度的判断了。

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MaxLength is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MaxLength'
```

## Author

fuyoufang, fuyoufang@163.com

## License

MaxLength is available under the MIT license. See the LICENSE file for more info.
