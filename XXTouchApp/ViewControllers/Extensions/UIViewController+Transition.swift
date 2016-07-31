//
//  UIViewController+Transition.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/14.
//  Copyright © 2016年 mcy. All rights reserved.
//

import Foundation

extension UIViewController {
  func onef_navigationBack(animated: Bool) {
    navigationController?.popViewControllerAnimated(animated)
  }
  
  func onef_dismiss() {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
