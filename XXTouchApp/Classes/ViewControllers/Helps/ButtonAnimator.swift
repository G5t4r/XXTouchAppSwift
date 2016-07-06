//
//  ButtonAnimator.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/6.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ButtonAnimator {
  class func buttonWithAnimation(button: UIButton, completion: ((Bool) -> Void)?) {
    UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 25, options: [], animations: {
      button.transform = CGAffineTransformScale(button.transform, 0.85, 0.85)
    }) { (_) in
      UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 25, options: [], animations: {
        button.transform = CGAffineTransformIdentity
        }, completion: completion)
    }
  }
}
