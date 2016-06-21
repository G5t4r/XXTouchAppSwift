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
    
    contentView.addSubview(packageNameLabel)
    contentView.addSubview(bottomLine)
  }
  
  private func makeConstriants() {
    packageNameLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.leading.equalTo(contentView).offset(15)
    }
    
    bottomLine.snp_makeConstraints { (make) in
      make.bottom.leading.trailing.equalTo(contentView)
      make.height.equalTo(0.5)
    }
  }
  
  func bind(model: ApplicationListModel) {
    packageNameLabel.text = model.name
  }
}
