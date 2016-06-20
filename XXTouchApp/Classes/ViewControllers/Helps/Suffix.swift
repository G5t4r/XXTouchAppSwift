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
    
    var title: String {
      switch self {
      case .Lua: return ".lua"
      case .Txt: return ".txt"
      }
    }
  }
  
  /// 末尾是否包含.lua 或 .txt
  class func haveSuffix(string: String) -> String {
    let isLua = string.hasSuffix(".lua")
    //    let isTxt = string.hasSuffix(".txt")
    if isLua {
      return Section.Lua.title
    }
    return Section.Txt.title
  }
}
