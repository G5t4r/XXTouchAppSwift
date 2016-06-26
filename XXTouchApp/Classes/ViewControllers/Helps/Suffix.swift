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
    case Lua
    case Txt
    case Xxt
    
    var title: String {
      switch self {
      case .Lua: return ".lua"
      case .Txt: return ".txt"
      case .Xxt: return ".xxt"
      }
    }
  }
  
  /// 末尾是否包含.lua 或 .txt
  class func haveSuffix(string: String) -> String {
    let isLua = string.hasSuffix(Section.Lua.title)
    let isXxt = string.hasSuffix(Section.Xxt.title)
    let isTxt = string.hasSuffix(Section.Txt.title)
    if isLua {
      return Section.Lua.title
    } else if isXxt {
      return Section.Xxt.title
    } else if isTxt {
      return Section.Txt.title
    } else {
      return ""
    }
  }
}
