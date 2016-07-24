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
  
  func initializeContext() {
    if let jsPath = NSBundle.mainBundle().pathForResource("customformats", ofType: "js") {
      context.evaluateScript(try? String(contentsOfFile: jsPath, encoding: NSUTF8StringEncoding))
      let listFunc = context.evaluateScript("formatList()")
      let dic = listFunc.callWithArguments(nil).toDictionary()
      print(dic)
    }
  }
  
  
  
  //  JSContext *context = [[JSContext alloc] init];
  //  [context evaluateScript:[NSString stringWithContentsOfFile:@"/User/customformats.js" encoding:NSUTF8StringEncoding error:nil]];
  //  JSValue *jsCustomFunctions = context[@"customFunction"];
  //  NSString *str = [[jsCustomFunctions callWithArguments:@"touch.on", @[
  //  @{
  //		@"x":@100,
  //		@"y":@100,
  //		@"color":@(0x000000),
  //  },
  //  ], @""] toString];
}
