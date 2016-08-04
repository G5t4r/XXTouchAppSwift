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
  let basisButton = RFToolbarButton(title: "代码片段")
  let indentationButton = RFToolbarButton(title: "Tab")
  let moreSymbolButton = RFToolbarButton(title: "符")
  var textView = LineNumberTextView()
  
  let parenthesesButton = XXTSymbolButton(title: "( )")
  let curlyBracesButton = XXTSymbolButton(title: "{ }")
  let bracketsButton = XXTSymbolButton(title: "[ ]")
  let doubleBracketsButton = XXTSymbolButton(title: "[ [ ] ]")
  let doubleQuotesButton = XXTSymbolButton(title: "\" \"")
  
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
    // 函数类
    
    let toolBar = RFKeyboardToolbar(
      buttons: [
        extensionButton,
        basisButton,
        indentationButton,
        moreSymbolButton
      ]
    )
    
    // 常用符号类
    let symbolToolBar = XXTSymbolKeyboardToolbar(
      width: frame.width,
      buttons: [
        parenthesesButton,
        curlyBracesButton,
        bracketsButton,
        doubleBracketsButton,
        doubleQuotesButton
      ]
    )
    
    let inputCustomAccessoryView = UIView(frame: CGRectMake(0, 0, self.frame.width, 80))
    inputCustomAccessoryView.addSubview(toolBar)
    inputCustomAccessoryView.addSubview(symbolToolBar)
    self.textView.inputAccessoryView = inputCustomAccessoryView
  }
}
