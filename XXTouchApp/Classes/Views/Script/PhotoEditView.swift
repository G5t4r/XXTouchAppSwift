//
//  PhotoEditView.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/1.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class PhotoEditView: UIView {
  private let colorTextFieldOne = UITextField()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
    colorTextFieldOne.userInteractionEnabled = false
    colorTextFieldOne.borderStyle = .RoundedRect
    colorTextFieldOne.clearButtonMode = .WhileEditing
    colorTextFieldOne.placeholder = "颜色值"
    
    self.addSubview(colorTextFieldOne)
  }
  
  private func makeConstriants() {
    colorTextFieldOne.snp_makeConstraints { (make) in
      make.top.leading.equalTo(self).inset(5)
      make.height.equalTo(25)
    }
  }
  
}
