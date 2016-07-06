//
//  XXTextView.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/6.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class XXTextView: CYRTextView {
  override init(frame: CGRect) { 
    super.init(frame: frame)
    self.backgroundColor = UIColor(rgb: 0x434343)
    self.textColor = UIColor.whiteColor()
    self.gutterLineColor = UIColor.blackColor()
    self.lineCursorEnabled = false
    self.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 13, pad: 17))
    self.autocorrectionType = .No // 关闭自动更正
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
