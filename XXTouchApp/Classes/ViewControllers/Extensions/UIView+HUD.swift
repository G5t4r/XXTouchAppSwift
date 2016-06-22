//
//  UIView+HUD.swift
//  OneFuncApp
//
//  Created by mcy on 16/5/31.
//  Copyright © 2016年 mcy. All rights reserved.
//

enum HUDType {
  case Message
  case Error
  case Completed
  case Loading
}

extension UIView {
  func showHUD(type: HUDType = .Loading, animated: Bool = true, text: String? = nil,
               autoHide: Bool = false, autoHideDelay: NSTimeInterval = 1.25, completionHandler: ()->() = {}) {
    let hud = MBProgressHUD.showHUDAddedTo(self, animated: animated)
    hud.animationType = .Zoom
    //    hud.userInteractionEnabled = false
    hud.opacity = 0.6
    
    switch type {
    case .Completed:
      hud.mode = .CustomView
      hud.customView = UIImageView(image: UIImage(named: "icon_success"))
    case .Error:
      hud.mode = .CustomView
      hud.customView = UIImageView(image: UIImage(named: "icon_error"))
    case .Message:
      hud.mode = .Text
    case .Loading:
      break
    }
    
    if let text = text {
      hud.labelText = text
    }
    
    // 自动隐藏
    if autoHide {
      hud.hide(animated, afterDelay: autoHideDelay)
    }
    
    hud.completionBlock = completionHandler
  }
  
  func hideHUD(animated: Bool = true) {
    MBProgressHUD.hideHUDForView(self, animated: animated)
  }
}
