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
  private let copyrightLabel = UILabel()
  
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
    copyrightLabel.text = "该软件版权归 xxtouch.com 所有；对于任何破解、修改行为 xxtouch.com 持有追究法律责任的权利；最终解释权归 xxtouch.com 所有。"
    copyrightLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 21))
    copyrightLabel.textAlignment = .Center
    copyrightLabel.numberOfLines = 0
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(copyrightLabel)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.top.equalTo(contentView).offset(Sizer.valueForDevice(phone: 15, pad: 25))
      make.leading.trailing.equalTo(contentView).inset(10)
    }
    
    copyrightLabel.snp_makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp_bottom).offset(Sizer.valueForDevice(phone: 10, pad: 20))
      make.leading.trailing.equalTo(titleLabel)
//      make.bottom.equalTo(contentView).offset(-15)
    }
  }
  
}
