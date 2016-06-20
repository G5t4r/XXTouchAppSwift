//
//  ServiceURL.swift
//  OneFuncApp
//
//  Created by mcy on 16/5/31.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ServiceURL {
  static var baseURLString: String {
    return "http://soze.synology.me:46952"
  }
  static let scriptsPath = "lua/scripts/"
}

extension ServiceURL {
  class Url {
    /// 获取设备信息
    static let deviceinfo = baseURLString + "/deviceinfo"
    
    
    /// 获取脚本列表
    static let getFileList = baseURLString + "/get_file_list"
    /// 读取脚本文件
    static let readScriptFile = baseURLString + "/read_script_file"
    /// 写入内容到脚本文件
    static let writeScriptFile = baseURLString + "/write_script_file"
    /// 新建一个脚本文件
    static let newScriptFile = baseURLString + "/new_script_file"
    /// 选择一个脚本文件
    static let selectScriptFile = baseURLString + "/select_script_file"
    /// 删除一个文件
    static let removeFile = baseURLString + "/remove_script_file"
    /// 重命名一个文件或目录
    static let renameFile = baseURLString + "/rename_file"
    
    
    /// 获取远程服务开启状态
    static let isRemoteAccessOpened = baseURLString + "/is_remote_access_opened"
    /// 打开远程访问
    static let openRemoteAccess = baseURLString + "/open_remote_access"
    /// 关闭远程访问
    static let closeRemoteAccess = baseURLString + "/close_remote_access"
    /// 重启服务
    static let restart = baseURLString + "/restart"
    
    
    /// 获取音量键事件设置
    static let getVolumeActionConf = baseURLString + "/get_volume_action_conf"
    /// 设置长按音量加键的动作
    static let setHoldVolumeUpAction = baseURLString + "/set_hold_volume_up_action"
    /// 设置长按音量减键的动作
    static let setHoldVolumeDownAction = baseURLString + "/set_hold_volume_down_action"
    /// 设置按一下音量加键的动作
    static let setClickVolumeUpAction = baseURLString + "/set_click_volume_up_action"
    /// 设置按一下音量减键的动作
    static let setClickVolumeDownAction = baseURLString + "/set_click_volume_down_action"
    
    
    /// 获取录制设置
    static let getRecordConf = baseURLString + "/get_record_conf"
    /// 设置录制包含音量加键
    static let setRecordVolumeUpOn = baseURLString + "/set_record_volume_up_on"
    /// 设置录制不包含音量加键
    static let setRecordVolumeUpOff = baseURLString + "/set_record_volume_up_off"
    /// 设置录制包含音量减键
    static let setRecordVolumeDownOn = baseURLString + "/set_record_volume_down_on"
    /// 设置录制不包含音量减键
    static let setRecordVolumeDownOff = baseURLString + "/set_record_volume_down_off"
  }
}
