//
//  ScriptCell.swift
//  OneFuncApp
//
//  Created by mcy on 16/5/31.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ScriptCell: SWTableViewCell {
  private let scriptImage = UIImageView()
  private let scriptSelectedImage = UIImageView(image: UIImage(named: "selected"))
  private let nameLabel = UILabel()
  private let scriptTime = UILabel()
  let infoButton = Button(type: .Custom)
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    nameLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 21))
    scriptTime.textColor = ThemeManager.Theme.lightTextColor
    scriptTime.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 11, pad: 13))
    scriptSelectedImage.hidden = true
    
    infoButton.setImage(UIImage(named: "infoIcon"), forState: .Normal)
    
    scriptImage.contentMode = .ScaleAspectFit
    
    contentView.addSubview(scriptImage)
    contentView.addSubview(nameLabel)
    contentView.addSubview(scriptTime)
    contentView.addSubview(infoButton)
    contentView.addSubview(scriptSelectedImage)
  }
  
  private func makeConstriants() {
    scriptImage.snp_makeConstraints { (make) in
      make.leading.equalTo(contentView).offset(15)
      make.height.width.equalTo(Sizer.valueForDevice(phone: 32, pad: 40))
      make.centerY.equalTo(contentView)
    }
    
    nameLabel.snp_makeConstraints { (make) in
      make.top.equalTo(contentView).offset(Sizer.valueForDevice(phone: 11, pad: 12))
      make.trailing.equalTo(contentView).offset(Sizer.valueForDevice(phone: -100, pad: -120))
      make.leading.equalTo(contentView).offset(Sizer.valueForDevice(phone: 55, pad: 70))
    }
    
    scriptTime.snp_makeConstraints { (make) in
      make.top.equalTo(nameLabel.snp_bottom).offset(3)
      make.leading.equalTo(nameLabel)
    }
    
    infoButton.snp_makeConstraints { (make) in
      make.trailing.equalTo(contentView).offset(Sizer.valueForDevice(phone: -20, pad: -30))
      make.centerY.equalTo(contentView)
      make.width.height.equalTo(Sizer.valueForDevice(phone: 22, pad: 32))
    }
    
    scriptSelectedImage.snp_makeConstraints { (make) in
      make.trailing.equalTo(infoButton.snp_leading).offset(-20)
      make.centerY.equalTo(contentView)
      make.width.height.equalTo(Sizer.valueForDevice(phone: 22, pad: 30))
    }
  }
  
  func bind(model: ScriptModel) {
    switch Suffix.haveSuffix(model.name) {
    case Suffix.Section.LUA.title: scriptImage.image = UIImage(named: "lua")
    case Suffix.Section.XXT.title: scriptImage.image = UIImage(named: "xxt")
    case Suffix.Section.TXT.title: scriptImage.image = UIImage(named: "txt")
    case Suffix.Section.BMP.title: scriptImage.image = UIImage(named: "photo")
    case Suffix.Section.JPG.title: scriptImage.image = UIImage(named: "photo")
    case Suffix.Section.PNG.title: scriptImage.image = UIImage(named: "photo")
    default: scriptImage.image = UIImage(named: "unknown")
    }
    nameLabel.text = model.name
    scriptTime.text = Formatter.formatDate(model.time)
  }
  
  func scriptSelectedHidden(hidden: Bool) {
    scriptSelectedImage.hidden = hidden
  }
}
