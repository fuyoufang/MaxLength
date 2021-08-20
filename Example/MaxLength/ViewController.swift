//
//  ViewController.swift
//  MaxLength
//
//  Created by fuyoufang on 08/19/2021.
//  Copyright (c) 2021 fuyoufang. All rights reserved.
//

import UIKit
import MaxLength

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.maxLength = 3
        
        
    }


}

