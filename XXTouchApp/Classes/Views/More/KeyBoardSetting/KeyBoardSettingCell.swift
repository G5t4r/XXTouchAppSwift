//
//  KeyBoardSettingCell.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/17.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class KeyBoardSettingCell: UITableViewCell {
  private let titleLabel = UILabel()
  private let infoLabel = UILabel()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.accessoryType = .DisclosureIndicator
    titleLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 21))
    infoLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 12, pad: 16))
    infoLabel.textColor = ThemeManager.Theme.lightTextColor
    infoLabel.numberOfLines = 0
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(infoLabel)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.top.equalTo(contentView).offset(Sizer.valueForDevice(phone: 10, pad: 12))
      make.leading.trailing.equalTo(contentView).inset(20)
    }
    
    infoLabel.snp_makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp_bottom).offset(5)
      make.leading.trailing.equalTo(titleLabel)
    }
  }
  
  func bind(title: String, info: String) {
    titleLabel.text = title
    infoLabel.text = info
  }
  
  func setStatus() {
    self.titleLabel.textColor = ThemeManager.Theme.lightTextColor
    self.userInteractionEnabled = false
    self.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
  }
}
