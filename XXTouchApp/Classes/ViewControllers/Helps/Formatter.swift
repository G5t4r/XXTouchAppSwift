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
  class func formatDateTime(unixTime: Int64) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyy-MM-dd HH:mm"
    let date = NSDate(timeIntervalSince1970: NSTimeInterval(unixTime))
    return formatter.stringFromDate(date)
  }
  
  class func formatDate(unixTime: Int64) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyy-MM-dd"
    let date = NSDate(timeIntervalSince1970: NSTimeInterval(unixTime))
    return formatter.stringFromDate(date)
  }
  
  class func formatDayTime(time: Int64) -> String {
    let day = time/86400
    let hour = time%86400/3600
    var currentPayTime: String
    if day > 0 && hour > 0 {
      currentPayTime = String(day) + " 天 " + String(hour) + " 小时"
    } else if day > 0 && hour <= 0 {
      currentPayTime = String(day) + " 天"
    } else {
      currentPayTime = String(hour) + " 小时"
    }
    return currentPayTime
  }
}
