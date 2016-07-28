//
//  JsManager.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/24.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit
import JavaScriptCore

class JsManager {
  static let sharedManager = JsManager()
  private let context = JSContext()
  private var colorList: PosColorListModel?
  private var bid: String?
  
  func initializeContext() {
    if let jsPath = NSBundle.mainBundle().pathForResource("customformats", ofType: "js"),
      script = try? String(contentsOfFile: jsPath, encoding: NSUTF8StringEncoding) {
      context.evaluateScript(script)
    }
  }
  
  func getFuncList() -> [JSON] {
    let listFunc = context.evaluateScript("formatList")
    let dic = listFunc.callWithArguments(nil).toDictionary()
    let json = JSON(dic)
    return json["func_list"].arrayValue
  }
  
  func getSnippetList() -> [JSON] {
    let listFunc = context.evaluateScript("formatList")
    let dic = listFunc.callWithArguments(nil).toDictionary()
    let json = JSON(dic)
    return json["snippet_list"].arrayValue
  }
  
  func getKeyList() -> [JSON] {
    let listFunc = context.evaluateScript("formatList")
    let dic = listFunc.callWithArguments(nil).toDictionary()
    let json = JSON(dic)
    return json["key_list"].arrayValue
  }
  
  func getCustomFunction(id: String, models: [[String : String]], bid: String = "", keyid: String = "") -> String {
    let customFunc = context.evaluateScript("customFunction")
    let string = customFunc.callWithArguments(
      [
        id,
        models,
        bid,
        keyid,
      ]
      ).toString()
    return string
  }
}
