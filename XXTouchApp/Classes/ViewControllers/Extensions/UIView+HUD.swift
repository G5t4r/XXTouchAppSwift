//
//  UIView+HUD.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/8.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

enum HUDType {
  case Loading
  case Error
  case Success
}

var isShow = false

extension UIView {
  
  func showHUD(type: HUDType = .Loading, text: String? = nil, completionBlock: (Bool)->() = {_ in }) {
    guard !isShow else { return }
    
    var options: TAOverlayOptions
    switch type {
    case .Loading:
      options = [.OverlayShadow, .OverlayTypeActivitySquare, .OverlaySizeRoundedRect]
    case .Success:
      options = [.OverlayShadow, .OverlayTypeSuccess, .OverlaySizeRoundedRect, .AutoHide]
    //      TAOverlay.setOverlayIconColor(UIColor(rgb: 0x1dbd1d))
    case .Error:
      options = [.OverlayShadow, .OverlayTypeError, .OverlaySizeRoundedRect, .AutoHide]
    }
    TAOverlay.showOverlayWithLabel(text, options: options)
    TAOverlay.setOverlayLabelTextColor(UIColor(rgb: 0x434343))
    TAOverlay.setOverlayIconColor(UIColor.grayColor())
    TAOverlay.setOverlayShadowColor(UIColor.blackColor().colorWithAlphaComponent(0.65))
    TAOverlay.setCompletionBlock(completionBlock)
  }
  
  func updateHUD(text: String, showStatus: Bool = true) {
    TAOverlay.setOverlayLabelText(text)
    isShow = showStatus
  }
  
  func dismissHUD(showStatus: Bool = false, completionBlock: (Bool)->() = {_ in}) {
    isShow = showStatus
    TAOverlay.hideOverlayWithCompletionBlock(completionBlock)
  }
}
