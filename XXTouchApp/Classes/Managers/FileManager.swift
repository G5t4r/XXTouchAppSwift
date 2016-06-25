//
//  FileManager.swift
//  XXTouchApp
//
//  Created by 教主 on 16/6/25.
//  Copyright © 2016年 mcy. All rights reserved.
//

class FileManager {
  static let sharedManager = FileManager()
  private let fileManager = NSFileManager.defaultManager()
  private let respringPath = "/tmp/1ferver_need_respring"
}

extension FileManager {
  
  func fileExistsAtPath() -> Bool {
    let isExist = fileManager.fileExistsAtPath(respringPath)
    return isExist
  }
}
