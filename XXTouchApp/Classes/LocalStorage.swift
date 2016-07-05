//
//  LocalStorage.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/5.
//  Copyright © 2016年 mcy. All rights reserved.
//

import Foundation

class LocalStorage {
  private struct Key {
    static let BaseURLString = "BaseURLString"
    static let BaseAuthURLString = "BaseAuthURLString"
  }
  
  private static let defaults = NSUserDefaults.standardUserDefaults()
}

extension LocalStorage {
  class func baseURLString() -> String? {
    return defaults.valueForKey(Key.BaseURLString) as? String
  }
  
  class func baseAuthURLString() -> String? {
    return defaults.valueForKey(Key.BaseAuthURLString) as? String
  }
  
//  class func saveBaseURLString(URLString : String) {
//    if !URLString.hasPrefix("http") {
//      print(URLString + " has no protocol")
//    }
//    
//    defaults.setValue(URLString, forKey: Key.BaseURLString)
//    defaults.synchronize()
//  }
}