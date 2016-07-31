//
//  Button.swift
//  XXTouchApp
//
//  Created by 教主 on 16/6/27.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class Button: UIButton {
  
  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    var bounds = self.bounds
    let widthDelta = 44.0 - bounds.size.width
    let heightDelta = 44.0 - bounds.size.height
    bounds = CGRectInset(bounds, -0.5*widthDelta, -0.5*heightDelta) //注意这里是负数，扩大了之前的bounds的范围
    return CGRectContainsPoint(bounds, point)
  }
  
}
