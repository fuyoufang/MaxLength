//
//  MaxLength.swift
//  MaxLength
//
//  Created by fuyoufang on 2021/8/19.
//

import UIKit

// public protocol MaxLengthCompatible: AnyObject { }

public protocol MaxLengthType: UITextInput {

    /// 需要判断输入最大长度的字符串
    ///
    /// UITextField 中 text 的定义为：
    /// open var text: String? // default is nil
    ///
    /// UITextView 中 text 的定义为：
    /// open var text: String!
    ///
    /// 所有通过 userInput 将两处不同的定义进行统一
    var userInput: String? { get set }
}

extension UITextView: MaxLengthType {
    public var userInput: String? {
        get {
            return self.text
        }
        set {
            self.text = newValue
        }
    }
}

extension UITextField: MaxLengthType {
    public var userInput: String? {
        get {
            return self.text
        }
        set {
            self.text = newValue
        }
    }
}

private var maxLengthKey: Void?
private var observerKey: Void?

extension MaxLengthType  {
    
    /// 文本限制的最大长度
    /// 为 nil 是表示不限制
    public var maxLength: Int? {
        get {
            return getAssociatedObject(self, &maxLengthKey)
        }
        set {
            setRetainedAssociatedObject(self, &maxLengthKey, newValue)
            if newValue != nil {
                if observer == nil {
                    observer = Observer(textInput: self,
                                        textDidChange: { [weak self] (notification) in
                                            self?.checkUserInputForMaxLength()
                                        })
                }
                checkUserInputForMaxLength()
            } else {
                observer = nil
            }
        }
    }
    
    func checkUserInputForMaxLength() {
        // 高亮部分为空时，并且 maxLength 存在时，再判断字符长度
        guard self.markedTextRange == nil,
              let maxLength = maxLength else {
            return
        }
        
        guard let text = self.userInput,
              text.count > maxLength else {
            return
        }
        let endIndex = text.index(text.startIndex, offsetBy: maxLength)
        userInput = String(text[text.startIndex..<endIndex])
    }
    
    var observer: Observer? {
        get {
            return getAssociatedObject(self, &observerKey)
        }
        set {
            setRetainedAssociatedObject(self, &observerKey, newValue)
        }
    }
}


class Observer {
    var textDidChange: (Notification) -> Void
    
    init(textInput: UITextInput, textDidChange: @escaping (Notification) -> Void) {
        self.textDidChange = textDidChange
        if textInput is UITextField {
            NotificationCenter.default
                .addObserver(self, selector: #selector(textDidChange(notification:)),
                             name: .UITextFieldTextDidChange,
                             object: textInput)
        } else if textInput is UITextView {
            NotificationCenter.default
                .addObserver(self,
                             selector: #selector(textDidChange(notification:)),
                             name: .UITextViewTextDidChange,
                             object: textInput)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textDidChange(notification: Notification) {
        textDidChange(notification)
    }
}

func getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

func setRetainedAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}
