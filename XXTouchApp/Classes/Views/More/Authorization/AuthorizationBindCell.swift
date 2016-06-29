//
//  AuthorizationBindCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class AuthorizationBindCell: UITableViewCell {
  let codeTextField = UITextField()
  let sumbitButton = UIButton(type: .Custom)
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.selectionStyle = .None
    codeTextField.clearButtonMode = .WhileEditing
    codeTextField.placeholder = "在这里填入授权码"
    codeTextField.borderStyle = .RoundedRect
    codeTextField.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 22))
    codeTextField.keyboardType = .ASCIICapable
    codeTextField.autocorrectionType = .No
    
    sumbitButton.setTitle("充值", forState: .Normal)
    sumbitButton.titleLabel?.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 22))
    sumbitButton.setTitleColor(ThemeManager.Theme.lightTextColor, forState: .Normal)
    sumbitButton.backgroundColor = ThemeManager.Theme.separatorColor
    sumbitButton.layer.cornerRadius = 5
    sumbitButton.enabled = false
    
    contentView.addSubview(codeTextField)
    contentView.addSubview(sumbitButton)
  }
  
  private func makeConstriants() {
    codeTextField.snp_makeConstraints { (make) in
      make.top.equalTo(contentView).offset(Sizer.valueForDevice(phone: 15, pad: 20))
      make.leading.trailing.equalTo(contentView).inset(Sizer.valueForDevice(phone: 20, pad: 30))
      make.height.equalTo(Sizer.valueForDevice(phone: 40, pad: 60))
    }
    
    sumbitButton.snp_makeConstraints { (make) in
      make.top.equalTo(codeTextField.snp_bottom).offset(Sizer.valueForDevice(phone: 15, pad: 20))
      make.leading.trailing.equalTo(codeTextField)
      make.height.equalTo(codeTextField)
    }
  }
  
}
