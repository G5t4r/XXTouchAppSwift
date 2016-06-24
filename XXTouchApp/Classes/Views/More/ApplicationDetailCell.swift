//
//  ApplicationDetailCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ApplicationDetailCell: UITableViewCell {
  let titleButton = UIButton(type: .Custom)
  let scrollView = UIScrollView()
  
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
    
    titleButton.setTitleColor(UIColor(rgb: 0x3d85c6), forState: .Normal)
    titleButton.sizeToFit()
    
    scrollView.alwaysBounceHorizontal = true
    scrollView.showsHorizontalScrollIndicator = false
    
    scrollView.addSubview(titleButton)
    contentView.addSubview(scrollView)
  }
  
  private func makeConstriants() {
    scrollView.snp_makeConstraints { (make) in
      make.edges.equalTo(contentView)
    }
    
    titleButton.snp_makeConstraints { (make) in
      make.centerY.equalTo(scrollView)
      make.leading.equalTo(scrollView).offset(20)
    }
  }
  
  func bind(title: String) {
    titleButton.setTitle(title, forState: .Normal)
  }
}
