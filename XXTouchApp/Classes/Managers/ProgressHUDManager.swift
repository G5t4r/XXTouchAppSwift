//
//  ProgressHUDManager.swift
//  XXTouchApp
//
//  Created by 教主 on 16/6/26.
//  Copyright © 2016年 mcy. All rights reserved.
//

class ProgressHUDManager {
  static let sharedManager = ProgressHUDManager()
  
  func startConfig() {
    let config = KVNProgressConfiguration.defaultConfiguration()
    config.minimumSuccessDisplayTime = 0.8
    config.minimumErrorDisplayTime = 0.8
    KVNProgress.setConfiguration(config)
  }
}
