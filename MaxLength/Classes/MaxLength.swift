//
//  MaxLength.swift
//  MaxLength
//
//  Created by fuyoufang on 2021/8/19.
//

import UIKit

public protocol MaxLengthCompatible: AnyObject { }

private var maxLengthKey: Void?
private var observerKey: Void?

public protocol MaxLengthType { }

extension UITextView: MaxLengthType { }

extension UITextField: MaxLengthType { }

extension MaxLengthType where Self: UITextInput  {
    
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
                                            self?.checkTextForMaxLength()
                                        })
                }
                checkTextForMaxLength()
            } else {
                observer = nil
            }
        }
    }
    
    func checkTextForMaxLength() {
        // 高亮部分为空时，并且 maxLength 存在时，再判断字符长度
        guard self.markedTextRange == nil,
              let maxLength = maxLength else {
            return
        }
        
        if let base = self as? UITextField {
            guard let text = base.text,
                  maxLength > text.count else {
                return
            }
            let endIndex = text.index(text.startIndex, offsetBy: maxLength)
            base.text = String(text[text.startIndex..<endIndex])
        } else if let base = self as? UITextView {
            guard let text = base.text,
                  maxLength > text.count else {
                return
            }
            let endIndex = text.index(text.startIndex, offsetBy: maxLength)
            base.text = String(text[text.startIndex..<endIndex])
        }
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
