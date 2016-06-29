//
//  ApplicationDetailCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ApplicationDetailCell: UITableViewCell {
  //  let titleButton = UIButton(type: .Custom)
  let scrollView = UIScrollView()
  let tap = UITapGestureRecognizer()
  let titleLabel = UILabel()
  
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    titleLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 22))
    titleLabel.textColor = UIColor(rgb: 0x3d85c6)
    titleLabel.sizeToFit()
    
    scrollView.alwaysBounceHorizontal = true
    scrollView.showsHorizontalScrollIndicator = false
    
    scrollView.addSubview(titleLabel)
    contentView.addSubview(scrollView)
    contentView.addGestureRecognizer(tap)
  }
  
  private func makeConstriants() {
    scrollView.snp_makeConstraints { (make) in
      make.edges.equalTo(contentView)
    }
    
    titleLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(scrollView)
      make.leading.equalTo(scrollView).offset(20)
    }
  }
  
  func bind(title: String) {
    titleLabel.text = title
  }
}
