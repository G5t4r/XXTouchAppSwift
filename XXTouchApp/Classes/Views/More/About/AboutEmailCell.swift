//
//  AboutEmailCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/22.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class AboutEmailCell: UITableViewCell {
  let emailButton = UIButton(type: .Custom)
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    emailButton.setTitle("联系我们", forState: .Normal)
    emailButton.titleLabel?.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 22))
    emailButton.backgroundColor = UIColor(rgb: 0x3d85c6)
    emailButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    
    contentView.addSubview(emailButton)
  }
  
  private func makeConstriants() {
    emailButton.snp_makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(contentView)
    }
  }
}
