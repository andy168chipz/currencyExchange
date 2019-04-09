//
//  UIViewControllerExtension.swift
//  CurrencyExchange
//
//  Created by Andy Chou on 4/9/19.
//  Copyright © 2019 Andy Chou. All rights reserved.
//

import Foundation
import UIKit

//Some useful util methods I used in other projects
extension UIViewController: UITextFieldDelegate {
    
    func hideKeyboardWhenTappedAround() {
        hideKeyboardWhenTappedAround(view)
    }
    
    func hideKeyboardWhenTappedAround(_ view: UIView) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
