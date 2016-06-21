//
//  ApplicationDetailCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ApplicationDetailCell: UITableViewCell {
  private let appNameLabel = UILabel()
  private let appPackageNameLabel = UILabel()
  private let appBundlePathLabel = UILabel()
  private let appDataPathLabel = UILabel()
  
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
    
    appNameLabel.text = "应用名称："
    appPackageNameLabel.text = "应用包名："
    appBundlePathLabel.text = "应用包路径："
    appDataPathLabel.text = "应用数据路径："
    
    contentView.addSubview(appNameLabel)
    contentView.addSubview(appPackageNameLabel)
    contentView.addSubview(appBundlePathLabel)
    contentView.addSubview(appDataPathLabel)
  }
  
  private func makeConstriants() {
    appNameLabel.snp_makeConstraints { (make) in
      make.top.equalTo(contentView).offset(15)
      make.leading.equalTo(contentView).offset(20)
    }
    
    appPackageNameLabel.snp_makeConstraints { (make) in
      make.top.equalTo(appNameLabel.snp_bottom).offset(10)
      make.leading.equalTo(appNameLabel)
    }
    
    appBundlePathLabel.snp_makeConstraints { (make) in
      make.top.equalTo(appPackageNameLabel.snp_bottom).offset(10)
      make.leading.equalTo(appNameLabel)
    }
    
    appDataPathLabel.snp_makeConstraints { (make) in
      make.top.equalTo(appBundlePathLabel.snp_bottom).offset(10)
      make.leading.equalTo(appNameLabel)
    }
  }
  
  func bind(model: ApplicationListModel) {
    
  }
  
  
}
