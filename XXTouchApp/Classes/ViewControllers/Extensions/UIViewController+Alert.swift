//
//  UIViewController+Alert.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/15.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

//extension UIViewController {
//  func alert(title title: String?, message: String?, cancelButtonTitle: String?) {
//    let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
//    alertView.show()
//  }
//  
//  func alertOther(title title: String, message: String, delegate: UIAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String, tag: Int = 0) {
//    let alertView = UIAlertView()
//    alertView.tag = tag
//    alertView.title = title
//    alertView.message = message
//    alertView.delegate = delegate
//    alertView.addButtonWithTitle(otherButtonTitles)
//    alertView.addButtonWithTitle(cancelButtonTitle)
//    alertView.show()
//  }
//}

//typealias AlertBlock = (Void) -> ()
//var cancelButtonAction: AlertBlock!
//var otherButtonAction: AlertBlock!
//
//extension UIResponder {
//  func alertOtherApp(title title: String = Constants.Text.prompt, message: String, delegate: UIAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String, tag: Int = 0) {
//    let alertView = UIAlertView()
//    alertView.tag = tag
//    alertView.title = title
//    alertView.message = message
//    alertView.delegate = delegate
//    alertView.addButtonWithTitle(cancelButtonTitle)
//    alertView.addButtonWithTitle(otherButtonTitles)
//    alertView.show()
//  }
//}
//
//extension UIResponder: UIAlertViewDelegate {
//  public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//    switch buttonIndex {
//    case 0:
//      if cancelButtonAction != nil {
//        cancelButtonAction()
//      }
//    case 1:
//      if otherButtonAction != nil {
//        otherButtonAction()
//      }
//    default: break
//    }
//  }
//}
