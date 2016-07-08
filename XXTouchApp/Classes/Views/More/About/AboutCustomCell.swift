//
//  AboutCustomCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/7.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class AboutCustomCell: UITableViewCell {
  let button = UIButton(type: .Custom)
  
  init(buttonTitle: String, backgroundColor: UIColor) {
    super.init(style: .Default, reuseIdentifier: nil)
    button.setTitle(buttonTitle, forState: .Normal)
    button.backgroundColor = backgroundColor
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    button.titleLabel?.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 22))
    button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    
    contentView.addSubview(button)
  }
  
  private func makeConstriants() {
    button.snp_makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(contentView)
    }
  }
}