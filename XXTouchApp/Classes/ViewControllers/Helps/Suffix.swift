//
//  Suffix.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/20.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class Suffix {
  enum Section: Int {
    case LUA
    case TXT
    case XXT
    case JPG
    case BMP
    case PNG
    
    var title: String {
      switch self {
      case .LUA: return ".lua"
      case .TXT: return ".txt"
      case .XXT: return ".xxt"
      case .JPG: return ".jpg"
      case .BMP: return ".bmp"
      case .PNG: return ".png"
      }
    }
  }
  
  /// 末尾是否包含.lua 或 .txt
  class func haveSuffix(string: String) -> String {
    let isLUA = string.hasSuffix(Section.LUA.title)
    let isXXT = string.hasSuffix(Section.XXT.title)
    let isTXT = string.hasSuffix(Section.TXT.title)
    let isJPG = string.hasSuffix(Section.JPG.title)
    let isBMP = string.hasSuffix(Section.BMP.title)
    let isPNG = string.hasSuffix(Section.PNG.title)
    if isLUA {
      return Section.LUA.title
    } else if isXXT {
      return Section.XXT.title
    } else if isTXT {
      return Section.TXT.title
    } else if isJPG {
      return Section.JPG.title
    } else if isBMP {
      return Section.BMP.title
    } else if isPNG {
      return Section.PNG.title
    } else {
      return ""
    }
  }
}
