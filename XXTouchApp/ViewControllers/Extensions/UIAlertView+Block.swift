//
//  UIAlertView+Block.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/9.
//  Copyright © 2016年 mcy. All rights reserved.
//

import Foundation

typealias CompleteAlertViewFunc  = (buttonIndex: Int) -> Void

class CompleteAlertViewFuncClass: NSObject {
  var completeAlertViewFunc: CompleteAlertViewFunc?
  
  init(completeAlertViewFunc: CompleteAlertViewFunc?){
    self.completeAlertViewFunc = completeAlertViewFunc
  }
  
  func copyWithZone(zone: NSZone) -> AnyObject {
    return CompleteAlertViewFuncClass(completeAlertViewFunc: self.completeAlertViewFunc)
  }
}

extension UIAlertView: UIAlertViewDelegate{
  
  private static var key = "AlertViewComplete"
  
  func showAlertViewWithCompleteBlock(alertViewComplete: CompleteAlertViewFunc! ){
    if alertViewComplete != nil{
      objc_removeAssociatedObjects(self)
      objc_setAssociatedObject(self, &UIAlertView.key, CompleteAlertViewFuncClass(completeAlertViewFunc: alertViewComplete) as AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
      self.delegate = self
    }
    self.show()
  }
  
  public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    let completeAlertViewFuncObj: CompleteAlertViewFuncClass? = objc_getAssociatedObject(self, &UIAlertView.key) as? CompleteAlertViewFuncClass
    
    if completeAlertViewFuncObj != nil && completeAlertViewFuncObj?.completeAlertViewFunc != nil{
      completeAlertViewFuncObj!.completeAlertViewFunc!(buttonIndex: buttonIndex)
    }
  }
}
