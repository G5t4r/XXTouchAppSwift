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
  lazy var operationButton: RFToolbarButton = {
    let button = RFToolbarButton(title: "  ")
    button.backgroundColor = UIColor.clearColor()
    button.layer.borderColor = UIColor.clearColor().CGColor
    button.setImage(UIImage(named: "pan_normal"), forState: .Normal)
    button.setImage(UIImage(named: "pan_highlight"), forState: .Highlighted)
    return button
  }()
  let indentationButton = RFToolbarButton(title: "Tab")
  let moreSymbolButton = RFToolbarButton(title: "符")
  var textView = LineNumberTextView()
  
  let parenthesesButton = XXTSymbolButton(title: "( )")
  let bracketsButton = XXTSymbolButton(title: "[ ]")
  let curlyBracesButton = XXTSymbolButton(title: "{ }")
  let doubleQuotesButton = XXTSymbolButton(title: "\" \"")
  let commaButton = XXTSymbolButton(title: " , ")
  let endButton = XXTSymbolButton(title: " . ")
  let equalButton = XXTSymbolButton(title: " =")
  
  //  private lazy var codeSmartTipsView: CodeSmartTipsView = {
  //    let view = CodeSmartTipsView()
  //    view.frame.size = CGSizeMake(200, 80)
  //    view.layer.cornerRadius = 2
  //    view.layer.shadowOffset = CGSizeMake(0, 3)
  //    view.layer.shadowRadius = 3.0
  //    view.layer.shadowColor = UIColor.blackColor().CGColor
  //    view.layer.shadowOpacity = 0.8
  //    view.hidden = true
  //    return view
  //  }()
  
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
    
//    textView.highlightDefinition = [
//      "number" : "[0-9]+", // 所有数字
//      "symbol" : "((\"|\").*?(\"))",
//      "lua" : "function[ ]++[a-zA-Z]*)"
//    ]
//    textView.highlightTheme = [
//      "number" : UIColor(rgb: 0xff0000),
//      "symbol" : UIColor(rgb: 0x0ad00a),
//      "lua" : UIColor(rgb: 0x9900ff)
//    ]
    
    self.addSubview(textView)
    //    self.addSubview(codeSmartTipsView)
  }
  
  private func makeConstriants() {
    
  }
  
  private func setupAction() {
    // 函数类
    
    let toolBar = RFKeyboardToolbar(
      buttons: [
        extensionButton,
        basisButton,
        operationButton,
        indentationButton,
        moreSymbolButton
      ]
    )
    
    // 常用符号类
    let symbolToolBar = XXTSymbolKeyboardToolbar(
      width: frame.width,
      buttons: [
        parenthesesButton,
        bracketsButton,
        curlyBracesButton,
        doubleQuotesButton,
        commaButton,
        endButton,
        equalButton
      ]
    )
    
    let inputCustomAccessoryView = UIView(frame: CGRectMake(0, 0, self.frame.width, 80))
    inputCustomAccessoryView.addSubview(toolBar)
    inputCustomAccessoryView.addSubview(symbolToolBar)
    self.textView.inputAccessoryView = inputCustomAccessoryView
  }
}

//extension XXTTextView: UITextViewDelegate {
//  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//    let str = textView.text as NSString
//    let sizeOfText = str.sizeWithAttributes([NSFontAttributeName : UIFont(name: "Menlo-Regular", size: Sizer.valueForDevice(phone: 11, pad: 15))!])
//    codeSmartTipsView.frame.origin = CGPointMake(50, sizeOfText.height+codeSmartTipsView.frame.height)
//    codeSmartTipsView.updateCodeList(text)
//    return true
//  }
//}
