//
//  CustomLabelCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/13.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class CustomLabelCell: UITableViewCell {
  private let titleLabel = UILabel()
  private let leftLine = UIView()
  private let rightLine = UIView()
  
  init(title: String, backgroundColor: UIColor = UIColor.clearColor(), titleColor: UIColor = UIColor.blackColor()) {
    super.init(style: .Default, reuseIdentifier: nil)
    self.titleLabel.text = title
    self.titleLabel.backgroundColor = backgroundColor
    self.titleLabel.textColor = titleColor
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    titleLabel.textAlignment = .Center
    titleLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 19))
    
    leftLine.backgroundColor = ThemeManager.Theme.separatorColor
    rightLine.backgroundColor = ThemeManager.Theme.separatorColor
    contentView.addSubview(titleLabel)
    contentView.addSubview(leftLine)
    contentView.addSubview(rightLine)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.edges.equalTo(contentView)
    }
    
    leftLine.snp_makeConstraints { (make) in
      make.top.leading.height.equalTo(contentView)
      make.width.equalTo(0.5)
    }
    
    rightLine.snp_makeConstraints { (make) in
      make.top.trailing.height.equalTo(contentView)
      make.width.equalTo(0.5)
    }
  }
  
}
