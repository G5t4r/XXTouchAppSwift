//
//  XXTAlertView.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/30.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class XXTAlertView: SIAlertView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  override init(title: String!, andMessage message: String!) {
    super.init(title: title, andMessage: message)
    self.viewBackgroundColor = UIColor.whiteColor()
    self.titleColor = UIColor.blackColor()
    self.messageColor = UIColor.darkGrayColor()
    self.titleFont = UIFont.boldSystemFontOfSize(18)
    self.messageFont = UIFont.systemFontOfSize(14)
    self.buttonFont = UIFont.systemFontOfSize(14)
    self.buttonColor = UIColor(white: 0.4, alpha: 1)
    self.cancelButtonColor = UIColor(white: 0.3, alpha: 1)
    self.destructiveButtonColor = UIColor.whiteColor()
    self.cornerRadius = 2
    self.shadowRadius = 8
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
