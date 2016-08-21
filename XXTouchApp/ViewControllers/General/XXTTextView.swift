//
//  XXTTextView.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/8.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class XXTTextView: CYRTextView {
  private let defaultFont: UIFont = UIFont(name: "Menlo-Regular", size: Sizer.valueForDevice(phone: 11, pad: 15))!
  private let italicFont: UIFont = UIFont(name: "HelveticaNeue-Italic", size: Sizer.valueForDevice(phone: 11, pad: 15))!
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
  //  var textView = LineNumberTextView()
  
  let parenthesesButton = XXTSymbolButton(title: "( )")
  let bracketsButton = XXTSymbolButton(title: "[ ]")
  let curlyBracesButton = XXTSymbolButton(title: "{ }")
  let doubleQuotesButton = XXTSymbolButton(title: "\" \"")
  let commaButton = XXTSymbolButton(title: " , ")
  let endButton = XXTSymbolButton(title: " . ")
  let equalButton = XXTSymbolButton(title: " =")
  
  override init!(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    makeConstriants()
    setupAction()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
//    self.backgroundColor = UIColor(rgb: 0x272822)
//    self.textColor = UIColor.whiteColor()
    self.backgroundColor = UIColor.whiteColor()
    self.textColor = UIColor.blackColor()
    self.font = defaultFont
    self.autocorrectionType = .No // 关闭自动更正
    self.tokens = solverTokens()
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
    self.inputAccessoryView = inputCustomAccessoryView
  }
  
  func solverTokens() -> [CYRToken] {
    let tokens: [CYRToken] = [
//      //      CYRToken(name: "special_numbers", expression: "[ʝ]", attributes: [NSForegroundColorAttributeName : UIColor.redColor()]),
//      
//      
//      
//      // 字符串
//        CYRToken(name: "string", expression: "\".*?(\"|$)", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xe7dc74)]),
//        CYRToken(name: "string1", expression: "\'.*?(\'|$)", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xe7dc74)]),
//      
//      // 16进制
//      CYRToken(name: "hex", expression: "[\\s\\{\\}\\[\\]\\(\\)/\\*,\\;:=<>\\+\\-\\^!·≤≥](0x[0-9 a-f]+)[\\s\\{\\}\\[\\]\\(\\)/\\*,\\;:=<>\\+\\-\\^!·≤≥]", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xae81ff)]),
//      
////      // 8进制
////      CYRToken(name: "octal", expression: "0o[0-7]+", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xae81ff)]),
////      
////      // 2进制
////      CYRToken(name: "binary", expression: "0b[01]+", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xae81ff)]),
//      
//      // 浮点
//      CYRToken(name: "float", expression: "[\\s\\{\\}\\[\\]\\(\\)/\\*,\\;:=<>\\+\\-\\^!·≤≥]\\d+\\.?\\d+e[\\+\\-]?\\d+|\\d+\\.\\d+|∞[\\s\\{\\}\\[\\]\\(\\)/\\*,\\;:=<>\\+\\-\\^!·≤≥]", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xae81ff)]),
//      
//      // 整形
//      CYRToken(name: "integer", expression: "[\\s\\{\\}\\[\\]\\(\\)/\\*,\\;:=<>\\+\\-\\^!·≤≥](\\d+)[\\s\\{\\}\\[\\]\\(\\)/\\*,\\;:=<>\\+\\-\\^!·≤≥]", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xae81ff)]),
//      
//      // 操作符
//      CYRToken(name: "operator", expression: "[\\{\\}\\[\\]\\(\\)/\\*,\\;:=<>\\+\\-\\^!·≤≥]", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xf92673)]),
//      
//      // 圆括号
//      //      CYRToken(name: "round_brackets", expression: "[\\(\\)]", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xf92673)]),
//      
//      // 方括号
//            CYRToken(name: "square_brackets", expression: "[\\[\\]]", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xf92673)]),
//      
//        // 花括号
//        CYRToken(name: "flower_brackets", expression: "[\\{\\}]", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xf92673)]),
//      
//      // 逻辑
//      //      CYRToken(name: "absolute_brackets", expression: "[|]", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xf92673)]),
//      
//      // 系统方法
//      CYRToken(name: "reserved_words", expression: "print|string.format|abs|string.char|math.pi|math.sin|string.upper|string.gsub|string.byte", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0x67daf0)]),
//      
//      // 关键词
//      CYRToken(name: "key_words", expression: "(function|local|return|end|for|do|continue|goto)", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xf92673)]),
//      
//      // 参数
//      //      CYRToken(name: "chart_parameters", expression: "color|width", attributes: [NSForegroundColorAttributeName : UIColor(rgb: 0xe2871d)]),
//        
//        // 注释
//        CYRToken(name: "comment", expression: "--\\[\\[.*\\]\\]", attributes: [
//            NSForegroundColorAttributeName : UIColor(rgb: 0x1f8300),
//            NSFontAttributeName : self.italicFont
//            ]
//        ),
//        // 注释
//        CYRToken(name: "comment1", expression: "--.*", attributes: [
//            NSForegroundColorAttributeName : UIColor(rgb: 0x1f8300),
//            NSFontAttributeName : self.italicFont
//            ]
//        ),
      
    ]
    
    return tokens
  }
}
