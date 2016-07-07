//
//  XXTextView.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/6.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class XXTextView: CYRTextView {
  let extensionButton = RFToolbarButton(title: "扩展函数")
  let basisButton = RFToolbarButton(title: "基础函数")
  let indentationButton = RFToolbarButton(title: "代码缩进")
  let touchDown = RFToolbarButton(title: "touch.down(id, x, y)")
  let touchMove = RFToolbarButton(title: "touch.move(id, x, y)")
  
  override init(frame: CGRect) { 
    super.init(frame: frame)
    //    self.backgroundColor = UIColor(rgb: 0x434343)
    //    self.textColor = UIColor.whiteColor()
    //    self.gutterLineColor = UIColor.blackColor()
    //    self.lineCursorEnabled = false
    self.font = UIFont(name: "Menlo-Regular", size: Sizer.valueForDevice(phone: 12, pad: 16))
    self.autocorrectionType = .No // 关闭自动更正
    self.inputAccessoryView = RFKeyboardToolbar(
      buttons: [
        extensionButton,
        basisButton,
        indentationButton,
        touchDown,
        touchMove
      ]
    )
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
