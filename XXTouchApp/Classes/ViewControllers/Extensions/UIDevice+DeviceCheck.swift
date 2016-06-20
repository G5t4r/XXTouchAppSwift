//
//  UIDevice+DeviceCheck.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/17.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

extension UIDevice {
  class var isPad: Bool {
    return UI_USER_INTERFACE_IDIOM() == .Pad
  }
  
  class var isPhone: Bool {
    return UI_USER_INTERFACE_IDIOM() == .Phone
  }
}
