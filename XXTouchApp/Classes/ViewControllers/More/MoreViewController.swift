//
//  MoreViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/6.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private lazy var serviceList: [String] = {
    let serviceList = [
      "重启服务"
    ]
    return serviceList
  }()
  
  private lazy var iconServiceList: [String] = {
    let iconServiceList = [
      "restar_01"
    ]
    return iconServiceList
  }()
  
  private lazy var authorizationList: [String] = {
    let authorizationList = [
      "授权"
    ]
    return authorizationList
  }()
  
  private lazy var iconAuthorizationList: [String] = {
    let iconAuthorizationList = [
      "authorization"
    ]
    return iconAuthorizationList
  }()
  
  private lazy var settingList: [String] = {
    let settingList = [
      "按键设置",
      "录制设置",
      "开机启动设置",
      "用户偏好设置"
    ]
    return settingList
  }()
  
  private lazy var iconSettingList: [String] = {
    let iconSettingList = [
      "keysettings",
      "recording",
      "startup",
      "user"
    ]
    return iconSettingList
  }()
  
  private lazy var systemList: [String] = {
    let systemList = [
      "应用列表",
      "清空GPS伪装信息",
      "清理UI缓存",
      "全清设备",
      "注销设备",
      "重启设备"
    ]
    return systemList
  }()
  
  private lazy var iconSystemList: [String] = {
    let iconSystemList = [
      "application",
      "gps",
      "uicache",
      "equipment",
      "cancellation",
      "restar_02"
    ]
    return iconSystemList
  }()
  
  private lazy var helpList: [String] = {
    let helpList = [
      "开发文档",
      "关于"
    ]
    return helpList
  }()
  
  private lazy var iconHelpList: [String] = {
    let iconHelpList = [
      "document",
      "about"
    ]
    return iconHelpList
  }()
  
  private lazy var titleList: [String] = {
    let titleList = [
      "服务",
      "授权",
      "设置",
      "系统",
      "帮助"
    ]
    return titleList
  }()
  private var host = ""
  private var deviceId = ""
  private let moreRemoteServiceCell = MoreRemoteServiceCell()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    getDeviceinfo()
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "更多"
    
    tableView.delegate = self
    tableView.dataSource = self
    
    view.addSubview(tableView)
  }
  
  private func makeConstriants() {
    tableView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    moreRemoteServiceCell.switchs.addTarget(self, action: #selector(remoteClick(_:)), forControlEvents: .ValueChanged)
  }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return titleList.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 2
    case 1: return 1
    case 2: return settingList.count
    case 3: return systemList.count
    case 4: return helpList.count
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        return Sizer.valueForDevice(phone: 55, pad: 95)
      } else {
        return Sizer.valueForDevice(phone: 45, pad: 80)
      }
    default: return Sizer.valueForDevice(phone: 45, pad: 80)
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        return moreRemoteServiceCell
      } else {
        return MoreCustomCell(icon: iconServiceList[0], title: serviceList[0])
      }
    case 1: return MoreCustomCell(icon: iconAuthorizationList[indexPath.row], title: authorizationList[indexPath.row])
    case 2: return MoreCustomCell(icon: iconSettingList[indexPath.row], title: settingList[indexPath.row])
    case 3: return MoreCustomCell(icon: iconSystemList[indexPath.row], title: systemList[indexPath.row])
    case 4: return MoreCustomCell(icon: iconHelpList[indexPath.row], title: helpList[indexPath.row])
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    /// 服务
    case 0: return service(indexPath.row)
    /// 授权
    case 1: return authorization(indexPath.row)
    /// 设置
    case 2: return key(indexPath.row)
    /// 系统
    case 3: return system(indexPath)
    /// 帮助
    case 4: return help(indexPath.row)
    default:break
    }
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if UIDevice.isPad {
      return nil
    } else {
      return titleList[section]
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if UIDevice.isPad {
      return CustomHeaderOrFooter(title: titleList[section], textColor: UIColor.grayColor(), font: UIFont.systemFontOfSize(18), alignment: .Left)
    } else {
      return nil
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Sizer.valueForDevice(phone: 30, pad: 50)
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}

// MARK: - 服务
extension MoreViewController {
  func titleLabelAnimation(switchs: Bool) {
    if switchs {
      self.moreRemoteServiceCell.bind("远程服务已打开", host: self.host)
      self.moreRemoteServiceCell.hostLabelHidden(!switchs)
      self.moreRemoteServiceCell.titleLabel.snp_remakeConstraints { (make) in
        make.top.equalTo(self.moreRemoteServiceCell.contentView).offset(Sizer.valueForDevice(phone: 9, pad: 24))
        make.leading.equalTo(self.moreRemoteServiceCell.icon.snp_trailing).offset(15)
      }
      self.moreRemoteServiceCell.hostLabelHidden(!switchs)
    } else {
      self.moreRemoteServiceCell.bind("远程服务已关闭", host: "")
      self.moreRemoteServiceCell.hostLabelHidden(!switchs)
      self.moreRemoteServiceCell.titleLabel.snp_makeConstraints { (make) in
        make.centerY.equalTo(self.moreRemoteServiceCell.contentView)
        make.leading.equalTo(self.moreRemoteServiceCell.icon.snp_trailing).offset(15)
      }
    }
  }
  
  private func fetchRemoteAccessStatus() {
    Service.isRemoteAccessOpened { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0:
          let opened = json["data"]["opened"].boolValue
          self.moreRemoteServiceCell.switchs.on = opened
          self.titleLabelAnimation(opened)
        default:
          self.alert(message: json["message"].stringValue)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getDeviceinfo()
        }
      }
    }
  }
  
  @objc private func remoteClick(switchState: UISwitch) {
    if switchState.on {
      // 打开远程服务
      openAndCloseRemoteAccess("openRemoteAccess")
    } else {
      // 关闭远程服务
      openAndCloseRemoteAccess("closeRemoteAccess")
    }
  }
  
  private func openAndCloseRemoteAccess(type: String) {
    Service.openOrCloseRemoteAccess(type: type) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.getDeviceinfo()
        default:
          self.alert(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.showHUD(text: Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.openAndCloseRemoteAccess(type)
        }
      }
    }
  }
  
  private func service(rowIndex: Int) {
    switch rowIndex {
    /// 重启服务
    case 1:
      self.alertAction(message: "确定要重启XXTouch服务么？", completeAlertViewFunc: { (buttonIndex) in
        switch buttonIndex {
        case 1: self.restart()
        default: break
        }
      })
    default:break
    }
  }
}

// MARK: - 授权
extension MoreViewController {
  private func authorization(rowIndex: Int) {
    switch rowIndex {
    /// 授权
    case 0: self.navigationController?.pushViewController(AuthorizationViewController(deviceId: self.deviceId), animated: true)
    default:break
    }
  }
}


// MARK: - 设置
extension MoreViewController {
  private func key(rowIndex: Int) {
    switch rowIndex {
    /// 按键设置
    case 0: self.navigationController?.pushViewController(KeyBoardSettingViewController(), animated: true)
    /// 录制设置
    case 1: self.navigationController?.pushViewController(RecordSettingViewController(), animated: true)
    /// 开机启动设置
    case 2: self.navigationController?.pushViewController(StartUpSettingViewController(), animated: true)
    /// 用户偏好设置
    case 3: self.navigationController?.pushViewController(UserSettingViewController(), animated: true)
    default:break
    }
  }
}

// MARK: - 系统
extension MoreViewController {
  private func system(indexPath: NSIndexPath) {
    switch indexPath.row {
    /// 应用列表
    case 0: self.navigationController?.pushViewController(ApplicationListViewController(), animated: true)
    /// 清空GPS伪装信息
    case 1:
      self.alertAction(message: "确定要清空GPS伪装信息么？", completeAlertViewFunc: { (buttonIndex) in
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch buttonIndex {
        case 1: self.clearGps()
        default: break
        }
      })
    /// 清理 UI 缓存
    case 2:
      self.alertAction(message: "确定要清理 UI 缓存么？\n(这个操作有可能引起注销或图标不见)", completeAlertViewFunc: { (buttonIndex) in
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch buttonIndex {
        case 1: self.clearUIcache()
        default: break
        }
      })
    /// 全清设备
    case 3:
      self.alertAction(message: "确定要全清设备么？\n(这个操作将会关闭所有应用并删除所有应用的资料及重置设备标识信息)", completeAlertViewFunc: { (buttonIndex) in
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch buttonIndex {
        case 1: self.clearAll()
        default: break
        }
      })
    /// 注销设备
    case 4:
      self.alertAction(message: "确定要注销设备么？", completeAlertViewFunc: { (buttonIndex) in
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch buttonIndex {
        case 1: MixC.sharedManager.logout()
        default: break
        }
      })
    /// 重启设备
    case 5:
      self.alertAction(message: "确定要重启设备么？", completeAlertViewFunc: { (buttonIndex) in
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch buttonIndex {
        case 1: self.reboot()
        default: break
        }
      })
    default: break
    }
  }
}

// MARK: - 帮助
extension MoreViewController {
  private func help(rowIndex: Int) {
    switch rowIndex {
    /// 开发文档
    case 0:
      let developDocumentViewController = DevelopDocumentViewController()
      developDocumentViewController.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(developDocumentViewController, animated: true)
    /// 关于
    case 1: self.navigationController?.pushViewController(AboutViewController(), animated: true)
    default: break
    }
  }
}

// 获取设备信息
extension MoreViewController {
  private func getDeviceinfo() {
    Service.getDeviceinfo { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.deviceId = json["data"]["deviceid"].stringValue
          if json["data"]["wifi_ip"].stringValue == Service.Local {
            self.host = "请连接到可用Wi-Fi"
          } else {
            self.host = "http://"+json["data"]["wifi_ip"].stringValue+":"+json["data"]["port"].stringValue
          }
          self.fetchRemoteAccessStatus()
        default:
          self.alert(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.showHUD(text: Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getDeviceinfo()
        }
      }
    }
  }
}

extension MoreViewController {
  private func restart() {
    self.view.showHUD(text: "正在重启服务")
    Service.restartService { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.view.showHUD(.Success, text: "重启成功", completionBlock: { (_) in
              self.getDeviceinfo()
            })
          })
        default:
          self.alert(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.restart()
        }
      }
    }
  }
  
  private func clearGps() {
    self.view.showHUD(text: "正在清空")
    Service.clearGPS { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.view.showHUD(.Success, text: "清空成功")
        default:
          self.alert(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.clearGps()
        }
      }
    }
  }
  
  private func clearUIcache() {
    self.view.showHUD(text: "正在清理")
    Service.clearUICache { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.view.showHUD(.Success, text: "清理成功")
        default:
          self.alert(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.clearUIcache()
        }
      }
    }
  }
  
  private func clearAll() {
    self.view.showHUD(text: "正在全清")
    Service.clearAll { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.view.showHUD(.Success, text: "全清成功")
        default:
          self.alert(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.clearAll()
        }
      }
    }
  }
  
  private func reboot() {
    self.view.showHUD(text: "正在重启设备")
    Service.reboot { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0: break
        default:
          self.alert(message: json["message"].stringValue)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.reboot()
        }
      }
    }
  }
}
