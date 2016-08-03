//
//  XXTSymbolKeyboardToolbar.swift
//  XXTouchApp
//
//  Created by 教主 on 16/8/3.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class XXTSymbolKeyboardToolbar: UIView {
  let buttons: [XXTSymbolButton]
  let scrollView = UIScrollView()
  let toolbarView = UIView()
  let topBorder = UIView()
  
  init(width: CGFloat, buttons: [XXTSymbolButton]) {
    self.buttons = buttons
    super.init(frame: CGRectMake(0, 40, width, 40))
    setupUI()
    //    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //  override func layoutSubviews() {
  //    topBorder.frame.size.height = 0.5
  //  }
  
  private func setupUI() {
    //    self.addSubview(self.inputAccessoryView!)
    self.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    self.addSubview(inputAccessoryView())
    self.addSubview(topBorder)
    
    topBorder.snp_makeConstraints { (make) in
      make.top.leading.trailing.equalTo(self)
      make.height.equalTo(0.5)
    }
  }
  
  //  private func makeConstriants() {
  //    toolbarView.snp_makeConstraints { (make) in
  //      make.edges.equalTo(self)
  //    }
  //    
  //    topBorder.snp_makeConstraints { (make) in
  //      make.top.equalTo(toolbarView)
  //      make.leading.trailing.equalTo(toolbarView)
  //      make.height.equalTo(0.5)
  //    }
  //    
  //    scrollView.snp_makeConstraints { (make) in
  //      make.edges.equalTo(toolbarView)
  //    }
  //  }
  
  private func inputAccessoryView() -> UIView {
    toolbarView.frame = CGRectMake(0, 0, self.bounds.width, 40)
    toolbarView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    toolbarView.backgroundColor = UIColor(white: 0.973, alpha: 1)
    
    topBorder.backgroundColor = UIColor(white: 0.678, alpha: 1)
    
    scrollView.frame = CGRectMake(0, 0, self.bounds.width, 40)
    scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    scrollView.backgroundColor = UIColor.clearColor()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentInset = UIEdgeInsetsMake(6, 0, 8, 6)
    
    toolbarView.addSubview(scrollView)
    
    addButtons()
    
    return toolbarView
  }
  
  private func addButtons() {
    var originX: CGFloat = 8
    var index = 0
    for button in self.buttons {
      button.frame = CGRectMake(originX, 0, button.frame.width, button.frame.height)
      scrollView.addSubview(button)
      originX = originX + button.bounds.size.width + 8
      index += 1
    }
    scrollView.contentSize.width = originX - 8
  }
}
