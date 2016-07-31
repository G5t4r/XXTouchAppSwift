//
//  Defaults.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/5.
//  Copyright © 2016年 mcy. All rights reserved.
//

import Foundation

class Defaults {
  class func configure() {
    if let defaultsPath = NSBundle.mainBundle().pathForResource("Defaults", ofType: "plist") {
      let defaults = NSDictionary(contentsOfFile: defaultsPath)! as! [String : AnyObject]
      NSUserDefaults.standardUserDefaults().registerDefaults(defaults)
    }
  }
}
