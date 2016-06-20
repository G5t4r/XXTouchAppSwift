//
//  MoreServiceCell.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/16.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class MoreServiceCell: UITableViewCell {
  private let titleLabel = UILabel()
  private let hostLabel = UILabel()
  let switches = Switches()
  
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
    titleLabel.text = "远程服务读取中"
    titleLabel.textColor = UIColor.blackColor()
    hostLabel.textColor = ThemeManager.Theme.tintColor
    hostLabel.font = UIFont.systemFontOfSize(13)
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(hostLabel)
    contentView.addSubview(switches)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.top.leading.equalTo(contentView).inset(10)
    }
    
    hostLabel.snp_makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp_bottom).offset(5)
      make.leading.equalTo(titleLabel)
    }
    
    switches.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.trailing.equalTo(contentView).offset(-20)
    }
  }
  
  func bind(title: String, host: String) {
    titleLabel.text = title
    hostLabel.text = host
  }
  
  
}
