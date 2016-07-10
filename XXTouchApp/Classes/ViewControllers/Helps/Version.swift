//
//  Version.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/10.
//  Copyright © 2016年 mcy. All rights reserved.
//

class Version {
  class func getiOS() -> Bool {
    switch  UIDevice.currentDevice().systemVersion.compare( "8.0.0" , options: NSStringCompareOptions.NumericSearch) {
    case  .OrderedSame, .OrderedDescending:
      return true
    case  .OrderedAscending:
      return false
    }
  }
}
