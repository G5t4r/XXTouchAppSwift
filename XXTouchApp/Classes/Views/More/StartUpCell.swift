//
//  StartUpCell.swift
//  XXTouchApp
//
//  Created by 教主 on 16/6/20.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class StartUpCell: UITableViewCell {
  private let titleLabel = UILabel()
  private let infoLabel = UILabel()
  let switches = Switches()
  
  init(title: String, info: String) {
    super.init(style: .Default, reuseIdentifier: nil)
    self.titleLabel.text = title
    self.infoLabel.text = info
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.selectionStyle = .None
    titleLabel.textColor = UIColor.blackColor()
    infoLabel.font = UIFont.systemFontOfSize(12.5)
    infoLabel.textColor = ThemeManager.Theme.lightTextColor
    infoLabel.numberOfLines = 0
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(infoLabel)
    contentView.addSubview(switches)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.top.equalTo(contentView).offset(10)
      make.leading.trailing.equalTo(contentView).inset(20)
    }
    
    infoLabel.snp_makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp_bottom).offset(5)
      make.leading.equalTo(contentView).offset(20)
      make.trailing.equalTo(contentView).offset(-85)
      make.bottom.equalTo(contentView).offset(-10)
    }
    
    switches.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.trailing.equalTo(contentView).offset(-20)
    }
  }
  
  func updataInfoColor(color: UIColor) {
    infoLabel.textColor = color
  }
}
