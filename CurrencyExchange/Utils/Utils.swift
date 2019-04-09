//
//  Utils.swift
//  CurrencyExchange
//
//  Created by Andy Chou on 4/9/19.
//  Copyright © 2019 Andy Chou. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    static func alertViewBuilder(message: String) -> UIAlertView{
        return UIAlertView(title: "Error",message: message, delegate: nil, cancelButtonTitle: "OK")
    }
}
