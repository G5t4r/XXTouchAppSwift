//
//  MixC.swift
//  XXTouchApp
//
//  Created by 教主 on 16/6/25.
//  Copyright © 2016年 mcy. All rights reserved.
//

import Darwin

class MixC {
  static let sharedManager = MixC()
  typealias reload = (Void) -> ()
  var number = 0
}

extension MixC {
  
  //  命令行重启服务
  func restart(closure: reload) {
    if number == 0 {
      number+=1
      system("/var/mobile/Media/1ferver/bin/1ferver restart")
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
        closure()
      })
    } else if number == 10 {
      number = 0
    } else {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
        closure()
      })
    }
  }
  
  //  // 重启设备
  //    func reboot() {
  //    system("reboot")
  //  }
  
  //  注销设备
  func logout() {
    system("killall -9 backboardd")
  }
}
