//
//  TextViewInputController.swift
//  MaxLength_Example
//
//  Created by fuyoufang on 2021/8/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import MaxLength

class TextViewInputController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.maxLength = 3
        
    }
}
