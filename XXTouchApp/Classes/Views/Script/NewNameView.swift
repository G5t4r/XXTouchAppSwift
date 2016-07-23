//
//  NewNameView.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/16.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class NewNameView: UIView {
  let newNameTextField = BaseTextField()
  let submitButton = UIButton(type: .Custom)
  let luaButton = UIButton(type: .Custom)
  let txtButton = UIButton(type: .Custom)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
    
    newNameTextField.placeholder = "请输入文件名"
    newNameTextField.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 19))
    newNameTextField.showsBorderWhileEditing = true
    
    submitButton.setTitle("创建", forState: .Normal)
    submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    submitButton.backgroundColor = ThemeManager.Theme.tintColor
    submitButton.layer.cornerRadius = 5
    submitButton.enabled = false
    submitButton.backgroundColor = ThemeManager.Theme.lightTextColor
    submitButton.titleLabel?.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 19))
    
    luaButton.setTitle(".lua", forState: .Normal)
    luaButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    luaButton.layer.cornerRadius = 3
    luaButton.contentEdgeInsets = UIEdgeInsetsMake(1, Sizer.valueForDevice(phone: 12, pad: 14), 1, Sizer.valueForDevice(phone: 12, pad: 14))
    luaButton.backgroundColor = ThemeManager.Theme.redBackgroundColor
    luaButton.titleLabel?.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 19))
    
    txtButton.setTitle(".txt", forState: .Normal)
    txtButton.setTitleColor(ThemeManager.Theme.lightTextColor, forState: .Normal)
    txtButton.layer.cornerRadius = 3
    txtButton.contentEdgeInsets = UIEdgeInsetsMake(1, Sizer.valueForDevice(phone: 12, pad: 14), 1, Sizer.valueForDevice(phone: 12, pad: 14))
    txtButton.backgroundColor = ThemeManager.Theme.separatorColor
    txtButton.titleLabel?.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 19))
    
    self.addSubview(newNameTextField)
    self.addSubview(submitButton)
    self.addSubview(luaButton)
    self.addSubview(txtButton)
  }
  
  private func makeConstriants() {
    newNameTextField.snp_makeConstraints { (make) in
      make.top.leading.equalTo(self).inset(10)
      make.trailing.equalTo(submitButton.snp_leading).offset(-10)
      make.height.equalTo(Sizer.valueForDevice(phone: 40, pad: 45))
    }
    
    submitButton.snp_makeConstraints { (make) in
      make.top.equalTo(newNameTextField)
      make.trailing.equalTo(self).offset(-10)
      make.width.equalTo(Sizer.valueForDevice(phone: 70, pad: 75))
      make.height.equalTo(Sizer.valueForDevice(phone: 40, pad: 45))
    }
    
    luaButton.snp_makeConstraints { (make) in
      make.top.equalTo(newNameTextField.snp_bottom).offset(10)
      make.leading.equalTo(newNameTextField)
      make.height.equalTo(Sizer.valueForDevice(phone: 30, pad: 35))
    }
    
    txtButton.snp_makeConstraints { (make) in
      make.top.equalTo(luaButton)
      make.leading.equalTo(luaButton.snp_trailing).offset(15)
      make.height.equalTo(Sizer.valueForDevice(phone: 30, pad: 35))
    }
  }
}
