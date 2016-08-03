//
//  XXTTextView.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/8.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class XXTTextView: UIView {
  let extensionButton = RFToolbarButton(title: "扩展函数")
  let basisButton = RFToolbarButton(title: "语法片段")
  let indentationButton = RFToolbarButton(title: "Tab")
  var textView = LineNumberTextView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    makeConstriants()
    setupAction()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    textView = LineNumberTextView(frame: self.bounds)
    textView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    textView.lineBackgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
    textView.font = UIFont(name: "Menlo-Regular", size: Sizer.valueForDevice(phone: 11, pad: 15))
    textView.autocorrectionType = .No // 关闭自动更正
    
    self.addSubview(textView)
  }
  
  private func makeConstriants() {
    
  }
  
  private func setupAction() {
    self.textView.inputAccessoryView = RFKeyboardToolbar(
      buttons: [
        extensionButton,
        basisButton,
        indentationButton
      ]
    )
  }
}
