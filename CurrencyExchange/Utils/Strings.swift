//
//  BuildInfo.swift
//  CurrencyExchange
//
//  Created by Andy Chou on 4/9/19.
//  Copyright © 2019 Andy Chou. All rights reserved.
//

import Foundation

//For static string stuff
/**
    saving api_key like this is bad practice, but I'm gonna have it like this to focus on the core features
 **/
struct Strings{
    static var API_KEY = "9c5e9ca18f7483d205bc92dea8925997"
    
    static var ServerHost = "http://apilayer.net/api/"
    
    static var CurrencyList = "list"
    
    static var AccessKey = "?access_key=\(API_KEY)"
    
    static func APIRequestBuilder(endpoint: String, source: String = "") -> String{
        return ServerHost + endpoint + AccessKey + source
    }
    
    static var HasSaved = "HasSaved"
    
    static var Live = "live"
}
