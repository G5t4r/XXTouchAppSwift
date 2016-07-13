//
//  MoreCustomCell.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/16.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class MoreCustomCell: UITableViewCell {
  private let titleLabel = UILabel()
  private let icon = UIImageView()
  
  init(icon: String, title: String, color: UIColor = UIColor.blackColor()) {
    super.init(style: .Default, reuseIdentifier: nil)
    self.titleLabel.text = title
    self.titleLabel.textColor = color
    self.icon.image = UIImage(named: icon)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.accessoryType = .DisclosureIndicator
    //    self.selectionStyle = .None
    titleLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 21))
    
    contentView.addSubview(icon)
    contentView.addSubview(titleLabel)
  }
  
  private func makeConstriants() {
    icon.snp_makeConstraints { (make) in
      make.leading.equalTo(contentView).offset(Sizer.valueForDevice(phone: 15, pad: 20))
      make.centerY.equalTo(contentView)
      make.height.width.equalTo(Sizer.valueForDevice(phone: 28, pad: 36))
    }
    
    titleLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(icon)
      make.leading.equalTo(icon.snp_trailing).offset(15)
    }
  }
}
