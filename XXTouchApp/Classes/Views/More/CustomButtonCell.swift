//
//  CustomButtonCell.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/9.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class CustomButtonCell: UITableViewCell {
  let button = UIButton(type: .Custom)
  
  init(buttonTitle: String, backgroundColor: UIColor = UIColor.clearColor(), titleColor: UIColor = UIColor.blackColor()) {
    super.init(style: .Default, reuseIdentifier: nil)
    button.setTitle(buttonTitle, forState: .Normal)
    button.backgroundColor = backgroundColor
    button.setTitleColor(titleColor, forState: .Normal)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    button.userInteractionEnabled = false
    button.titleLabel?.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 22))
    
    contentView.addSubview(button)
  }
  
  private func makeConstriants() {
    button.snp_makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(contentView)
    }
  }
}
