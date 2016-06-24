//
//  MoreRemoteServiceCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/24.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class MoreRemoteServiceCell: UITableViewCell {
  let titleLabel = UILabel()
  private let hostLabel = UILabel()
  private let icon = UIImageView(image: UIImage(named: "remote"))
  let switchs = Switches()
  
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
    titleLabel.text = "正在读取远程服务.."
    hostLabel.textColor = ThemeManager.Theme.tintColor
    hostLabel.font = UIFont.systemFontOfSize(13)
    hostLabel.hidden = true
    
    contentView.addSubview(icon)
    contentView.addSubview(titleLabel)
    contentView.addSubview(hostLabel)
    contentView.addSubview(switchs)
  }
  
  private func makeConstriants() {
    icon.snp_makeConstraints { (make) in
      make.leading.equalTo(contentView).offset(20)
      make.centerY.equalTo(contentView)
      make.height.width.equalTo(36)
    }
    
    titleLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.leading.equalTo(icon.snp_trailing).offset(15)
    }
    
    hostLabel.snp_makeConstraints { (make) in
      make.bottom.equalTo(contentView).offset(-15)
      make.leading.equalTo(icon.snp_trailing).offset(15)
    }
    
    switchs.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.trailing.equalTo(contentView).offset(-15)
    }
  }
  
  func bind(title: String, host: String) {
    titleLabel.text = title
    hostLabel.text = host
  }
  
  func hostLabelHidden(hidden: Bool) {
    hostLabel.hidden = hidden
  }
}
