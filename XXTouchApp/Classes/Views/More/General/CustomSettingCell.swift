//
//  CustomSettingCell.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/20.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class CustomSettingCell: UITableViewCell {
  private let titleLabel = UILabel()
  let switches = Switches()
  
  init(title: String, color: UIColor = UIColor.blackColor()) {
    super.init(style: .Default, reuseIdentifier: nil)
    self.titleLabel.text = title
    self.titleLabel.textColor = color
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.selectionStyle = .None
    titleLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 21))
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(switches)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.leading.trailing.equalTo(contentView).inset(20)
    }
    
    switches.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.trailing.equalTo(contentView).offset(-20)
    }
  }
}
