//
//  ScriptModel.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/6.
//  Copyright © 2016年 mcy. All rights reserved.
//

class ScriptModel {
  let name: String
  let size: Double
  let time: Int64
  var isSelected = false
  
  init(_ item : JSON, name: String) {
    self.name = name
    self.size = item["size"].doubleValue
    self.time = item["change"].int64Value
  }
}
