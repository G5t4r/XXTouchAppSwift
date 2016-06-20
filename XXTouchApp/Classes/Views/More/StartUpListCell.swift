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
    self.selectionStyle = .None
    scriptTime.textColor = ThemeManager.Theme.lightTextColor
    scriptTime.font = UIFont.systemFontOfSize(10)
    scriptSelectedImage.hidden = true
    
    scriptImage.contentMode = .ScaleAspectFit
    
    contentView.addSubview(scriptImage)
    contentView.addSubview(nameLabel)
    contentView.addSubview(scriptTime)
    contentView.addSubview(scriptSelectedImage)
  }
  
  private func makeConstriants() {
    scriptImage.snp_makeConstraints { (make) in
      make.top.leading.equalTo(contentView).inset(10)
    }
    
    nameLabel.snp_makeConstraints { (make) in
      make.top.equalTo(contentView).offset(7)
      make.trailing.equalTo(contentView).offset(-100)
      make.leading.equalTo(contentView).offset(50)
    }
    
    scriptTime.snp_makeConstraints { (make) in
      make.top.equalTo(nameLabel.snp_bottom).offset(5)
      make.leading.equalTo(nameLabel)
    }
    
    scriptSelectedImage.snp_makeConstraints { (make) in
      make.trailing.equalTo(contentView).offset(-20)
      make.centerY.equalTo(contentView)
      make.width.height.equalTo(22)
    }
  }
  
  func bind(model: ScriptModel) {
    if Suffix.haveSuffix(model.name) == Suffix.Section.Lua.title {
      scriptImage.image = UIImage(named: "lua")
    } else {
      scriptImage.image = UIImage(named: "txt")
    }
    
    nameLabel.text = model.name
    scriptTime.text = Formatter.formatDate(model.time)
  }
  
  func scriptSelectedHidden(hidden: Bool) {
    scriptSelectedImage.hidden = hidden
  }
}
