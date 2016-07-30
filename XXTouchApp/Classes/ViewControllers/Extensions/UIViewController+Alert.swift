//
//  UIViewController+Alert.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/30.
//  Copyright © 2016年 mcy. All rights reserved.
//

import Foundation

extension UIViewController {
  //  func alert(title title: String = Constants.Text.prompt, message: String, cancelButtonTitle: String = Constants.Text.ok) {
  //    let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
  //    alertView.show()
  //  }
  //
  //  func alertAction(title title: String = Constants.Text.prompt, message: String, cancelButtonTitle: String = Constants.Text.no, otherButtonTitles: String = Constants.Text.yes, completeAlertViewFunc: ((buttonIndex: Int) -> Void)?) {
  //    let alertView = UIAlertView()
  //    alertView.title = title
  //    alertView.message = message
  //    alertView.delegate = self
  //    alertView.addButtonWithTitle(cancelButtonTitle)
  //    alertView.addButtonWithTitle(otherButtonTitles)
  //    alertView.showAlertViewWithCompleteBlock(completeAlertViewFunc)
  //  }
  
  func alertShowOneButton(title title: String = Constants.Text.prompt, message: String, cancelButtonTitle: String = Constants.Text.ok, cancelHandler: SIAlertViewHandler = { _ in }) {
    SIAlertView.appearance()
    let alertView = XXTAlertView(title: title, andMessage: message)
    alertView.addButtonWithTitle(cancelButtonTitle, type: .Destructive, handler: cancelHandler)
    alertView.transitionStyle = .Bounce
    alertView.show()
  }
  
  func alertShowTwoButton(title title: String = Constants.Text.prompt, message: String, cancelButtonTitle: String = Constants.Text.no, cancelHandler:  SIAlertViewHandler = {_ in }, otherButtonTitles: String = Constants.Text.yes, otherHandler: SIAlertViewHandler = {_ in }) {
    let alertView = XXTAlertView(title: title, andMessage: message)
    alertView.addButtonWithTitle(cancelButtonTitle, type: .Cancel, handler: cancelHandler)
    alertView.addButtonWithTitle(otherButtonTitles, type: .Destructive, handler: otherHandler)
    alertView.transitionStyle = .Bounce
    alertView.show()
  }
}
