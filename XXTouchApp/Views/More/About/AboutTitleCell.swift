//
//  AboutTitleCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/22.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class AboutTitleCell: UITableViewCell {
  private let titleLabel = UILabel()
  
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
    titleLabel.text = "XXTouch"
    titleLabel.textColor = UIColor(rgb: 0x073763)
    titleLabel.font = UIFont.boldSystemFontOfSize(Sizer.valueForDevice(phone: 32, pad: 36))
    titleLabel.textAlignment = .Center
    
    contentView.addSubview(titleLabel)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.top.equalTo(contentView).offset(Sizer.valueForDevice(phone: 15, pad: 25))
      make.leading.trailing.equalTo(contentView).inset(10)
    }
  }
  
}
