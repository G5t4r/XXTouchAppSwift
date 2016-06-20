//
//  Formatter.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/6.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class Formatter {
  /**
   格式化日期
   
   - parameter unixTime: unix 时间 since 1970.1.1 0:0:0
   
   - returns: 时间字符串
   */
  class func formatDate(unixTime: Int64) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = NSDate(timeIntervalSince1970: NSTimeInterval(unixTime))
    return formatter.stringFromDate(date)
  }
}
