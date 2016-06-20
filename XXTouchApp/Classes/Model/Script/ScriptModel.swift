//
//  ScriptModel.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/6.
//  Copyright © 2016年 mcy. All rights reserved.
//

class ScriptModel {
  let size: Double
  let time: Int64
  var isSelected = false
  
  init(_ item : JSON) {
    size = item["size"].doubleValue
    time = item["change"].int64Value
  }
}
