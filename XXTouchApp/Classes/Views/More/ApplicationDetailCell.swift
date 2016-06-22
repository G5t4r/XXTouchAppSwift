//
//  ApplicationDetailCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ApplicationDetailCell: UITableViewCell {
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
    
    titleLabel.textColor = UIColor(rgb: 0x3d85c6)
    titleLabel.numberOfLines = 0
    
    contentView.addSubview(titleLabel)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.top.equalTo(contentView).offset(10)
      make.leading.trailing.equalTo(contentView).inset(20)
      make.bottom.equalTo(contentView).offset(-10)
    }
  }
  
  func bind(title: String) {
    titleLabel.text = title
  }
}