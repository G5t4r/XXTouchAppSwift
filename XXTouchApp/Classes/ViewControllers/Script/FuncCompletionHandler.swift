//
//  FuncCompletionHandler.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/26.
//  Copyright © 2016年 mcy. All rights reserved.
//

import Foundation

struct FuncCompletionHandler {
  var id: String = ""
  var titleNames = [String]()
  var completionHandler: ((String)->Void)?
}