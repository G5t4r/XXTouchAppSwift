//
//  AuthorizationCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class AuthorizationCell: UITableViewCell {
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
    titleLabel.text = "正在获取设备授权信息.."
    titleLabel.textAlignment = .Center
    contentView.addSubview(titleLabel)
  }
  
  private func makeConstriants() {
    titleLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.leading.trailing.equalTo(contentView).inset(15)
    }
  }
  
  func bind(title: String) {
    titleLabel.text = title
  }
  
}
