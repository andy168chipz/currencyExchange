//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by Andy Chou on 4/9/19.
//  Copyright © 2019 Andy Chou. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var ratesCollection: UICollectionView!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var inputTextView: UITextView!
    
    let reuseIdentifier = "reuse"
    var currencies = [String: Currency]()
    var currencyKeys = [String]()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var managedContext : NSManagedObjectContext?
    var currencySelected : Currency?
    var rates = [Rate]()
    
    let formatter :NumberFormatter = {
        let format = NumberFormatter()
        format.groupingSeparator = "."
        format.numberStyle = .decimal
        return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate?.persistentContainer.viewContext
        self.currencyPicker.delegate = self
        self.currencyPicker.dataSource = self
        self.inputTextView.delegate = self
        hideKeyboardWhenTappedAround()
        inputTextView.keyboardType = .numberPad
        inputTextView.text = "Enter amount"
        inputTextView.textColor = UIColor.lightGray
        inputTextView.layer.borderColor = UIColor.black.cgColor
        ratesCollection.delegate = self
        ratesCollection.dataSource = self
        fetchCurrencyList()
    }
    
    
    
    // MARK: Go Pressed
    @IBAction func goPressed(_ sender: Any) {
        //check timestamp first
        let row = currencyPicker.selectedRow(inComponent: 0)
        if let currency = currencies[currencyKeys[row]] {
            if let created = currency.created as Date?{
                //check if its over 30min old
                let startDate = Date()
                let date = startDate.addingTimeInterval(TimeInterval(-30 * 60))
                if date > created{
                    //its over 30mins old
                    fetchExchanges(currency)
                }
            } else {
                //nothing fetched yet
                fetchExchanges(currency)
            }
        } else {
            Utils.alertViewBuilder(message: "Critical app error").show()
        }
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
        let row = currencyPicker.selectedRow(inComponent: 0)
        let currency = currencies[currencyKeys[row]]
        if let rates = currency?.rate?.array as? [Rate]{
            self.rates = rates
            self.rates.sort(by: {$0.currencyCode!.compare($1.currencyCode!) == .orderedAscending})
            ratesCollection.reloadData()
        }
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
        } else {
            ratesCollection.reloadData()
        }
    }
    
    // MARK: Collectionview stuff
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RateCell
        let rate = rates[indexPath.item]
        cell.countryLabel.text = rate.currencyCode
        if inputTextView.text != "Enter amount"{
            cell.rateLabel.text = String(rate.rate * Double(inputTextView.text)!)
        } else {
            cell.rateLabel.text = String(rate.rate)
        }
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    // MARK: get methods
    func fetchExchanges(_ currency: Currency){
        Alamofire.request(Strings.APIRequestBuilder(endpoint: Strings.Live)).responseJSON{
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let context = self.managedContext!
                    let result = json as! [String : Any]
                    let currencies = result["quotes"] as! [String: Double]
                    currency.created = NSDate()
                    currency.mutableOrderedSetValue(forKey: "rate").removeAllObjects()
                    //update timestamp
                    for (k, v) in currencies{
                        let rate = Rate(context: context)
                        rate.currencyCode = String(k.dropFirst(3))
                        rate.rate = v
                        rate.currency = currency
                        currency.addToRate(rate)
                    }
                    do {
                        try context.save()
                        self.currencyPicker.delegate?.pickerView?(self.currencyPicker, didSelectRow: self.currencyPicker.selectedRow(inComponent: 0), inComponent: 0)
                    } catch(let error) {
                        Utils.alertViewBuilder(message: error.localizedDescription).show()
                    }
                    
                }
            case .failure(let error):
                Utils.alertViewBuilder(message: error.localizedDescription).show()
            }
        }
    }
    
    func retrieveCurrencies(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
        do {
            let result = try managedContext?.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                currencies[data.value(forKey:"currency") as! String] = (data as! Currency)
            }
            currencyKeys = Array(currencies.keys)
            currencyKeys.sort()
            currencyPicker.reloadAllComponents()
            currencyPicker.delegate?.pickerView?(self.currencyPicker, didSelectRow: 0, inComponent: 0)
        } catch(let error) {
            Utils.alertViewBuilder(message: error.localizedDescription).show()
        }
    }
    
    
    // get list of possible currency and save it to CoreData if it's not already saved
    func fetchCurrencyList() {
        if !UserDefaults.standard.bool(forKey: Strings.HasSaved){
            Alamofire.request(Strings.APIRequestBuilder(endpoint: Strings.CurrencyList)).responseJSON{
                response in
                switch response.result {
                case .success:
                    if let json = response.result.value {
                        let context = self.managedContext!
                        let result = json as! [String : Any]
                        let currencies = result["currencies"] as! [String: String]
                        for (k, v) in currencies{
                            let currencyEntity = NSEntityDescription.entity(forEntityName: "Currency", in: context)!
                            let currency = NSManagedObject(entity: currencyEntity, insertInto: context)
                            currency.setValue(k, forKey: "currency")
                            currency.setValue(v, forKey: "country")
                        }
                        do {
                            try context.save()
                            UserDefaults.standard.set(true, forKey: Strings.HasSaved)
                        } catch(let error) {
                            UserDefaults.standard.set(false, forKey: Strings.HasSaved)
                            Utils.alertViewBuilder(message: error.localizedDescription).show()
                        }
                        self.retrieveCurrencies()
                    }
                case .failure(let error):
                    Utils.alertViewBuilder(message: error.localizedDescription).show()
                }
            }
        }
        else {
            retrieveCurrencies()
        }
    }
}


