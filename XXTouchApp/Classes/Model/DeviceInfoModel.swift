//
//  DeviceInfoModel.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/22.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class DeviceInfoModel {
  let devSN: String // 设备序列号
  let zeVersion: String // 服务程序版本
  let sysVersion: String // 系统版本
  let devName: String // 设备名
  let devMac: String // 设备MAC地址
  let deviceId: String // 设备UDID
  let devType: String // 设备类型
  
  init(_ item : JSON) {
    self.devSN = item["devsn"].stringValue
    self.zeVersion = item["zeversion"].stringValue
    self.sysVersion = item["sysversion"].stringValue
    self.devName = item["devname"].stringValue
    self.devMac = item["devmac"].stringValue
    self.deviceId = item["deviceid"].stringValue
    self.devType = item["devtype"].stringValue
  }
}
