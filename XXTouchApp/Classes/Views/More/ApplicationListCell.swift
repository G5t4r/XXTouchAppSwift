//
//  ApplicationListCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ApplicationListCell: UITableViewCell {
  private let packageNameLabel = UILabel()
  private let bottomLine = UIView()
  private let iconImageView = UIImageView()
  
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
    self.selectionStyle = .None
    packageNameLabel.textAlignment = .Center
    packageNameLabel.textColor = UIColor(rgb: 0x3d85c6)
    
    bottomLine.backgroundColor = ThemeManager.Theme.lightBackgroundColor
    
    contentView.addSubview(iconImageView)
    contentView.addSubview(packageNameLabel)
    contentView.addSubview(bottomLine)
  }
  
  private func makeConstriants() {
    iconImageView.snp_makeConstraints { (make) in
      make.leading.equalTo(contentView).offset(10)
      make.centerY.equalTo(contentView)
      make.width.height.equalTo(36)
    }
    
    packageNameLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.leading.equalTo(iconImageView.snp_trailing).offset(10)
    }
    
    bottomLine.snp_makeConstraints { (make) in
      make.bottom.leading.trailing.equalTo(contentView)
      make.height.equalTo(0.5)
    }
  }
  
  func bind(model: ApplicationListModel) {
    iconImageView.image = Base64.base64StringToUIImage(model.iconBase64)
    packageNameLabel.text = model.name
  }
}
