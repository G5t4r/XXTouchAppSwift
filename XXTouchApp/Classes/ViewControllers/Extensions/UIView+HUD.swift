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

var hudIsShow = false
var hudIsNotDelay = false
var hudTimer: NSTimer!
var hudTimeInterval: NSTimeInterval = 0.5
var hudType: HUDType = .Loading
var hudText: String? = nil
var hudCompletionBlock: (Bool)->() = {_ in }

extension UIView {
  
  func delay() {
    guard !hudIsNotDelay else {
      hudTimer.invalidate()
      hudTimer = nil
      return
    }
    
    var options: TAOverlayOptions
    switch hudType {
    case .Loading:
      options = [.OverlayShadow, .OverlayTypeActivitySquare, .OverlaySizeRoundedRect]
    case .Success:
      options = [.OverlayShadow, .OverlayTypeSuccess, .OverlaySizeRoundedRect, .AutoHide]
    case .Error:
      options = [.OverlayShadow, .OverlayTypeError, .OverlaySizeRoundedRect, .AutoHide]
    }
    TAOverlay.showOverlayWithLabel(hudText, options: options)
    TAOverlay.setOverlayLabelTextColor(UIColor(rgb: 0x434343))
    TAOverlay.setOverlayIconColor(UIColor.grayColor())
    TAOverlay.setOverlayShadowColor(UIColor.blackColor().colorWithAlphaComponent(0.65))
    TAOverlay.setCompletionBlock(hudCompletionBlock)
  }
  
  func showHUD(type: HUDType = .Loading, text: String? = nil, completionBlock: (Bool)->() = {_ in }) {
    guard !hudIsShow else { return }
    hudIsNotDelay = false
    hudType = type
    hudText = text
    hudCompletionBlock = completionBlock
    if type == .Loading {
      hudTimer = NSTimer.scheduledTimerWithTimeInterval(hudTimeInterval, target: self, selector: #selector(delay), userInfo: nil, repeats: false)
    } else {
      delay()
    }
  }
  
  func updateHUD(text: String, showStatus: Bool = true) {
    TAOverlay.setOverlayLabelText(text)
    hudIsShow = showStatus
  }
  
  func dismissHUD(showStatus: Bool = false, completionBlock: (Bool)->() = {_ in}) {
    hudIsShow = showStatus
    if hudType == .Loading {
      hudIsNotDelay = true
    }
    TAOverlay.hideOverlayWithCompletionBlock(completionBlock)
  }
}
