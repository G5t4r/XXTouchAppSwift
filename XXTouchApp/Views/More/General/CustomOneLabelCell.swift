//
//  CustomOneLabelCell.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/25.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class CustomOneLabelCell: UITableViewCell {
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
    titleLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 19))
    titleLabel.textColor = UIColor(rgb: 0x003945)
    
    contentView.addSubview(titleLabel)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(contentView).inset(Sizer.valueForDevice(phone: 20, pad: 25))
      make.centerY.equalTo(contentView)
    }
  }
  
  func bind(item: JSON) {
    titleLabel.text = item["name"].stringValue
  }
}