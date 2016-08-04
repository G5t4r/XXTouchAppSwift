//
//  XXTSymbolButton.swift
//  XXTouchApp
//
//  Created by 教主 on 16/8/3.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class XXTSymbolButton: Button {
  typealias eventHandlerBlock = String -> ()
  var buttonPressBlock: eventHandlerBlock?
  let title: String
  
  init(title: String) {
    self.title = title
    let text = self.title as NSString
    let sizeOfText = text.sizeWithAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(14)])
    super.init(frame: CGRectMake(0, 0, sizeOfText.width+18.104, sizeOfText.height+10.298))
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.backgroundColor = UIColor(white: 0.902, alpha: 1)
    self.layer.cornerRadius = 3
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
    self.setTitle(self.title, forState: .Normal)
    self.setTitleColor(UIColor(white: 0.500, alpha: 1), forState: .Normal)
    self.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
  }
  
  func addHandlerEvent(buttonPressBlock: eventHandlerBlock) {
    self.buttonPressBlock = buttonPressBlock
    self.addTarget(self, action: #selector(handlerAction), forControlEvents: .TouchUpInside)
  }
  
  @objc private func handlerAction() {
    let string = self.title.stringByReplacingOccurrencesOfString(" ", withString: "")
    buttonPressBlock?(string)
  }
  
}
