//
//  ServiceURL.swift
//  OneFuncApp
//
//  Created by mcy on 16/5/31.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ServiceURL {
  enum Section: Int {
    case Localhost
    case Remotehost
    case Local
    
    var title: String {
      switch self {
      case .Localhost: return "http://127.0.0.1:46952"
      case .Remotehost: return "http://soze.synology.me:46952"
      case .Local: return "http://192.168.0.104:46952"
      }
    }
  }
  
  static var baseURLString: String {
    return Section.Localhost.title
  }
  
  static let scriptsPath = "lua/scripts/"
  static let Local = "127.0.0.1"
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
    /// 获取当前已经选择的脚本文件
    static let getSelectedScriptFile = baseURLString + "/get_selected_script_file"
    
    
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
    
    
    /// 获取开机启动设置
    static let getStartupConf = baseURLString + "/get_startup_conf"
    /// 启用开机启动
    static let setStartupRunOn = baseURLString + "/set_startup_run_on"
    /// 禁用开机启动
    static let setStartupRunOff = baseURLString + "/set_startup_run_off"
    /// 选择开机启动脚本
    static let selectStartupScriptFile = baseURLString + "/select_startup_script_file"
    
    
    /// 获得用户偏好配置
    static let getUserConf = baseURLString + "/get_user_conf"
    /// 禁止显示 “无 SIM 卡” 状态栏文字
    static let setNosimStatusbarOn = baseURLString + "/set_no_nosim_statusbar_on"
    /// 不禁止显示 “无 SIM 卡” 状态栏文字
    static let setNosimStatusbarOff = baseURLString + "/set_no_nosim_statusbar_off"
    /// 禁止 “无 SIM 卡” 弹窗弹出
    static let setNosimAlertOn = baseURLString + "/set_no_nosim_alert_on"
    /// 不禁止 “无 SIM 卡” 弹窗弹出
    static let setNosimAlertOff = baseURLString + "/set_no_nosim_alert_off"
    /// 禁止 “低电量” 弹窗弹出
    static let setNoLowPowerAlertOn = baseURLString + "/set_no_low_power_alert_on"
    /// 不禁止 “低电量” 弹窗弹出
    static let setNoLowPowerAlertOff = baseURLString + "/set_no_low_power_alert_off"
    /// 禁止 “使用推送通知来连接 iTunes” 弹窗弹出
    static let setNoNeedPushidAlertOn = baseURLString + "/set_no_need_pushid_alert_on"
    /// 不禁止 “使用推送通知来连接 iTunes” 弹窗弹出
    static let setNoNeedPushidAlertOff = baseURLString + "/set_no_need_pushid_alert_off"
    
    
    /// 获得当前设备的授权信息
    static let deviceAuthInfo = baseURLString + "/device_auth_info"
    /// 绑定一个授权码
    static let bindCode = baseURLString + "/bind_code"
    /// 获取本地缓存剩余时间戳
    static let expireDate = baseURLString + "/expire_date"
    
    
    /// 获取设备已安装应用程序信息
    static let bundles = baseURLString + "/bundles"
    
    
    /// 清空GPS伪装信息
    static let clearGps = baseURLString + "/clear_gps"
    /// 清理 UI 缓存
    static let clearUIcache = baseURLString + "/uicache"
    /// 全清设备
    static let clearAll = baseURLString + "/clear_all"
    /// 注销设备
    static let respring = baseURLString + "/respring"
    /// 重启设备
    static let reboot2 = baseURLString + "/reboot2"
    
    
    /// 开发文档
    static let developDocument = baseURLString + "/help.html"
    
    
    /// 扫一扫
    static let bindQrcode = baseURLString + "/bind_qrcode"
    
    
    /// 运行脚本
    static let launchScriptFile = baseURLString + "/launch_script_file"
    /// 停止脚本
    static let recycle = baseURLString + "/recycle"
    /// 判断脚本运行状态
    static let isRunning = baseURLString + "/is_running"
  }
}
