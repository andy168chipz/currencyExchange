//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by Andy Chou on 4/9/19.
//  Copyright © 2019 Andy Chou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var inputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        inputTextView.keyboardType = .numberPad
    }


}

