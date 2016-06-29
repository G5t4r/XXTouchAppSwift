//
//  StartUpListCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/20.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class StartUpListCell: UITableViewCell {
  private let scriptImage = UIImageView()
  private let scriptSelectedImage = UIImageView(image: UIImage(named: "selected"))
  private let nameLabel = UILabel()
  private let scriptTime = UILabel()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    scriptTime.textColor = ThemeManager.Theme.lightTextColor
    scriptTime.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 11, pad: 14))
    nameLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 22))
    scriptSelectedImage.hidden = true
    
    scriptImage.contentMode = .ScaleAspectFit
    
    contentView.addSubview(scriptImage)
    contentView.addSubview(nameLabel)
    contentView.addSubview(scriptTime)
    contentView.addSubview(scriptSelectedImage)
  }
  
  private func makeConstriants() {
    scriptImage.snp_makeConstraints { (make) in
      make.leading.equalTo(contentView).inset(15)
      make.height.width.equalTo(Sizer.valueForDevice(phone: 40, pad: 60))
      make.centerY.equalTo(contentView)
    }
    
    nameLabel.snp_makeConstraints { (make) in
      make.top.equalTo(contentView).offset(Sizer.valueForDevice(phone: 10, pad: 15))
      make.trailing.equalTo(contentView).offset(Sizer.valueForDevice(phone: -100, pad: -120))
      make.leading.equalTo(contentView).offset(Sizer.valueForDevice(phone: 70, pad: 85))
    }
    
    scriptTime.snp_makeConstraints { (make) in
      make.top.equalTo(nameLabel.snp_bottom).offset(5)
      make.leading.equalTo(nameLabel)
    }
    
    scriptSelectedImage.snp_makeConstraints { (make) in
      make.trailing.equalTo(contentView).offset(-20)
      make.centerY.equalTo(contentView)
      make.width.height.equalTo(Sizer.valueForDevice(phone: 22, pad: 32))
    }
  }
  
  func bind(model: ScriptModel) {
    switch Suffix.haveSuffix(model.name) {
    case Suffix.Section.Lua.title: scriptImage.image = UIImage(named: "lua")
    case Suffix.Section.Xxt.title: scriptImage.image = UIImage(named: "xxt")
    default: scriptImage.image = UIImage(named: "unknown")
    }
    
    nameLabel.text = model.name
    scriptTime.text = Formatter.formatDate(model.time)
  }
  
  func scriptSelectedHidden(hidden: Bool) {
    scriptSelectedImage.hidden = hidden
  }
}
