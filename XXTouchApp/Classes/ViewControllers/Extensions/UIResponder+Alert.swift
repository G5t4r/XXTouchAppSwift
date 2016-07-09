//
//  UIResponder+Alert.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/9.
//  Copyright © 2016年 mcy. All rights reserved.
//

import Foundation

extension UIResponder {
  func alert(title title: String = Constants.Text.prompt, message: String, cancelButtonTitle: String = Constants.Text.ok) {
    let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
    alertView.show()
  }
  
  func alertAction(title title: String = Constants.Text.prompt, message: String, cancelButtonTitle: String = Constants.Text.no, otherButtonTitles: String = Constants.Text.yes, completeAlertViewFunc: (buttonIndex: Int) -> Void = {_ in }) {
    let alertView = UIAlertView()
    alertView.title = title
    alertView.message = message
    alertView.delegate = self
    alertView.addButtonWithTitle(cancelButtonTitle)
    alertView.addButtonWithTitle(otherButtonTitles)
    alertView.showAlertViewWithCompleteBlock(completeAlertViewFunc)
  }
  
  func actionSheetAction() {
    
  }
}
