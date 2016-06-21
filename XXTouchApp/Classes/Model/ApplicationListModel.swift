//
//  ApplicationListModel.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ApplicationListModel {
  let packageName: String
  let name: String
  let dataPath: String
  let bundlePath: String
  
  init(_ item : JSON, packageName: String) {
    self.packageName = packageName
    self.name = item["name"].stringValue
    self.dataPath = item["data_path"].stringValue
    self.bundlePath = item["bundle_path"].stringValue
  }
}
