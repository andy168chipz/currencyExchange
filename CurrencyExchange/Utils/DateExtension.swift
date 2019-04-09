//
//  DateExtension.swift
//  CurrencyExchange
//
//  Created by Andy Chou on 4/10/19.
//  Copyright © 2019 Andy Chou. All rights reserved.
//

import Foundation

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
