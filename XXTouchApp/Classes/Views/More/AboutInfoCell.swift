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
  private let valueLabel = UILabel()
  
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
    self.selectionStyle = .None
    valueLabel.textColor = ThemeManager.Theme.lightTextColor
    valueLabel.numberOfLines = 0
    valueLabel.textAlignment = .Right
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(valueLabel)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.leading.equalTo(contentView).offset(20)
    }
    
    valueLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.trailing.equalTo(contentView).offset(-20)
      make.leading.equalTo(titleLabel.snp_trailing).offset(10)
      make.bottom.equalTo(titleLabel).offset(-10)
    }
  }
  
  func bind(value: String) {
    valueLabel.text = value
  }
}
