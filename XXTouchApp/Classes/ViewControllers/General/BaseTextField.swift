//
//  BaseTextField.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/23.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {
  var showsBorderWhileEditing = false
  
  private let borderColor: UIColor = ThemeManager.Theme.tintColor
  private let borderWidth: CGFloat = 2
  private let borderCornerRadius: CGFloat = 3
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.borderColor = borderColor.CGColor
    layer.cornerRadius = borderCornerRadius
    clearButtonMode = .WhileEditing
    borderStyle = .RoundedRect
    autocorrectionType = .No
    addTarget(self, action: #selector(showBorder), forControlEvents: .EditingDidBegin)
    addTarget(self, action: #selector(hideBorder), forControlEvents: .EditingDidEnd)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func showBorder() {
    layer.borderWidth = showsBorderWhileEditing ? borderWidth:0
  }
  
  @objc private func hideBorder() {
    layer.borderWidth = 0
  }
}
