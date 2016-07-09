//
//  AboutInfoCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/22.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class AboutInfoCell: UITableViewCell {
  private let titleLabel = UILabel()
  let valueLabel = UILabel()
  
  init(title: String) {
    super.init(style: .Default, reuseIdentifier: nil)
    self.titleLabel.text = title
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    //    self.selectionStyle = .None
    valueLabel.textColor = ThemeManager.Theme.lightTextColor
    valueLabel.numberOfLines = 0
    valueLabel.textAlignment = .Right
    valueLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 22))
    titleLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 22))
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(valueLabel)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.leading.equalTo(contentView).offset(Sizer.valueForDevice(phone: 20, pad: 50))
    }
    
    valueLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.trailing.equalTo(contentView).offset(Sizer.valueForDevice(phone: -20, pad: -50))
      make.leading.equalTo(contentView).offset(90)
    }
  }
  
  func bind(value: String) {
    valueLabel.text = value
  }
}
