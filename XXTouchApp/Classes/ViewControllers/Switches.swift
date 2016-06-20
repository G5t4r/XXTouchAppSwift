//
//  Switches.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/20.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class Switches: UISwitch {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    onTintColor = ThemeManager.Theme.tintColor
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
