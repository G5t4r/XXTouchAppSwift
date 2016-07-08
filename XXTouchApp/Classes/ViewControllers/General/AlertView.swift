//
//  AlertView.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/8.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class AlertView {
  class func show(title: String = Constants.Text.prompt, messgae: String, cancelButtonTitle: String = Constants.Text.ok, otherButtonTitle: String? = nil) -> DQAlertView{
    let alert = DQAlertView(title: title, message: messgae, cancelButtonTitle: cancelButtonTitle, otherButtonTitle: otherButtonTitle)
    alert.titleLabel.font = UIFont.boldSystemFontOfSize(17)
    alert.messageLabel.font = UIFont.systemFontOfSize(15)
    alert.cancelButton.titleLabel?.font = UIFont.systemFontOfSize(17)
    alert.otherButton.titleLabel?.font = UIFont.systemFontOfSize(17)
    alert.backgroundColor = UIColor.whiteColor()
    //    alert.appearAnimationType = DQAlertViewAnimationTypeZoomIn
    //    alert.disappearAnimationType = DQAlertViewAnimationTypeZoomOut
    alert.show()
    return alert
  }
  
  class func showApp(title title: String = Constants.Text.prompt, message: String, delegate: UIAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String, tag: Int = 0) {
    let alertView = UIAlertView()
    alertView.tag = tag
    alertView.title = title
    alertView.message = message
    alertView.delegate = delegate
    alertView.addButtonWithTitle(cancelButtonTitle)
    alertView.addButtonWithTitle(otherButtonTitles)
    alertView.show()
  }
}
