//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by Andy Chou on 4/9/19.
//  Copyright © 2019 Andy Chou. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var ratesCollection: UICollectionView!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var inputTextView: UITextView!
    
    let reuseIdentifier = "reuse"
    var currencies = [String: String]()
    var currencyKeys = [String]()
    
    let formatter :NumberFormatter = {
        let format = NumberFormatter()
        format.groupingSeparator = "."
        format.numberStyle = .decimal
        return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyPicker.delegate = self
        self.currencyPicker.dataSource = self
        self.inputTextView.delegate = self
        hideKeyboardWhenTappedAround()
        inputTextView.keyboardType = .numberPad
        retrieveCurrencies()
        inputTextView.text = "Enter amount"
        inputTextView.textColor = UIColor.lightGray
        inputTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    func retrieveCurrencies(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                currencies[data.value(forKey: "country") as! String] = (data.value(forKey: "currency") as! String)
            }
            currencyKeys = Array(currencies.keys).sorted()
            currencyPicker.reloadAllComponents()
        } catch(let error) {
            Utils.alertViewBuilder(message: error.localizedDescription).show()
        }
    }
    
    // MARK: Go Pressed
    @IBAction func goPressed(_ sender: Any) {
        
    }
    
    // MARK: picker view misc
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.capacity
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyKeys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyKeys[row])
    }
    
    // MARK: textview stuff
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter amount"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: Collectionview stuff
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .black
        
        return cell
    }
}

