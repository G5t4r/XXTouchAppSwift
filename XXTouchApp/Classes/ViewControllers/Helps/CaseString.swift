//
//  CaseString.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/6.
//  Copyright © 2016年 mcy. All rights reserved.
//

class CaseString {
  // 将扩展名转换为小写
  class func lowercase(string: String) -> String{
    let s1 = string as NSString
    let s2 = s1.substringFromIndex(s1.length-4)
    let lowercaseString = s2.lowercaseString
    return lowercaseString
  }
}
