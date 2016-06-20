//
//  NewNameView.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/16.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class NewNameView: UIView {
  let newNameTextField = UITextField()
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
    newNameTextField.clearButtonMode = .WhileEditing
    newNameTextField.borderStyle = .RoundedRect
    
    submitButton.setTitle("创建", forState: .Normal)
    submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    submitButton.backgroundColor = ThemeManager.Theme.tintColor
    submitButton.layer.cornerRadius = 5
    
    luaButton.setTitle(".lua", forState: .Normal)
    luaButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    luaButton.layer.cornerRadius = 3
    luaButton.contentEdgeInsets = UIEdgeInsetsMake(1, 8, 1, 8)
    luaButton.backgroundColor = ThemeManager.Theme.redBackgroundColor
    
    txtButton.setTitle(".txt", forState: .Normal)
    txtButton.setTitleColor(ThemeManager.Theme.tintColor, forState: .Normal)
    txtButton.layer.cornerRadius = 3
    txtButton.contentEdgeInsets = UIEdgeInsetsMake(1, 8, 1, 8)
    txtButton.backgroundColor = ThemeManager.Theme.separatorColor
    
    self.addSubview(newNameTextField)
    self.addSubview(submitButton)
    self.addSubview(luaButton)
    self.addSubview(txtButton)
  }
  
  private func makeConstriants() {
    newNameTextField.snp_makeConstraints { (make) in
      make.top.leading.equalTo(self).inset(5)
      make.width.equalTo(Sizer.valueForPhone(inch_3_5: 190, inch_4_0: 190, inch_4_7: 200, inch_5_5: 200))
      make.height.equalTo(40)
    }
    
    submitButton.snp_makeConstraints { (make) in
      make.top.equalTo(newNameTextField)
      make.leading.equalTo(newNameTextField.snp_trailing).offset(10)
      make.width.equalTo(70)
      make.height.equalTo(40)
    }
    
    luaButton.snp_makeConstraints { (make) in
      make.top.equalTo(newNameTextField.snp_bottom).offset(5)
      make.leading.equalTo(newNameTextField)
      make.height.equalTo(25)
    }
    
    txtButton.snp_makeConstraints { (make) in
      make.top.equalTo(luaButton)
      make.leading.equalTo(luaButton.snp_trailing).offset(15)
      make.height.equalTo(25)
    }
  }
}
