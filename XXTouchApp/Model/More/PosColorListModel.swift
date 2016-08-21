//
//  PosColorListModel.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/25.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class PosColorListModel {
  let x: Int
  let y: Int
  let r: UInt8
  let g: UInt8
  let b: UInt8
  let c: UInt32
  let color: String
  
  init(x: Int = 0, y: Int = 0, c: UInt32 = 0, color: String = "") {
    self.x = x
    self.y = y
    self.r = UInt8((c & 0xFF0000) >> 16)
    self.g = UInt8((c & 0x00FF00) >> 8)
    self.b = UInt8((c & 0xFF))
    self.c = c
    self.color = color
  }
}
