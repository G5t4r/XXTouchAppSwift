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
      "restart"
    ]
    return iconServiceList
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
      "key",
      "video",
      "time",
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
      "ap",
      "gps",
      "clear",
      "junk",
      "logout",
      "restart_02"
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
      "me"
    ]
    return iconHelpList
  }()
  
  private lazy var titleList: [String] = {
    let titleList = [
      "服务",
      "设置",
      "系统",
      "帮助"
    ]
    return titleList
  }()
  private let moreServiceCell = MoreServiceCell()
  private var host = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    getDeviceinfo()
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
    moreServiceCell.switches.addTarget(self, action: #selector(remoteValueChanged(_:)), forControlEvents: .ValueChanged)
  }
  
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return titleList.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:return 2
    case 1:return settingList.count
    case 2:return systemList.count
    case 3:return helpList.count
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:return 60
      default:return 40
      }
    default:
      return 40
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:return moreServiceCell
      default:return MoreCustomCell(icon: iconServiceList[0], title: serviceList[0])
      }
    case 1:return MoreCustomCell(icon: iconSettingList[indexPath.row], title: settingList[indexPath.row])
    case 2:return MoreCustomCell(icon: iconSystemList[indexPath.row], title: systemList[indexPath.row])
    case 3:return MoreCustomCell(icon: iconHelpList[indexPath.row], title: helpList[indexPath.row])
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    /// 服务
    case 0:return service(indexPath.row)
    /// 设置
    case 1:return key(indexPath.row)
    default:break
    }
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return titleList[section]
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}

// MARK: - 服务
extension MoreViewController {
  private func fetchRemoteAccessStatus() {
    //    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.isRemoteAccessOpened, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      //      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          var title: String
          if json["data"]["opened"].boolValue {
            self.moreServiceCell.switches.on = true
            title = "远程服务已打开"
          } else {
            title = "远程服务已关闭"
            self.moreServiceCell.switches.on = false
          }
          self.moreServiceCell.bind(title, host: self.host)
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  @objc private func remoteValueChanged(switchState: UISwitch) {
    if switchState.on {
      // 打开远程服务
      openAndCloseRemoteAccess(ServiceURL.Url.openRemoteAccess)
    } else {
      // 关闭远程服务
      openAndCloseRemoteAccess(ServiceURL.Url.closeRemoteAccess)
    }
  }
  
  private func openAndCloseRemoteAccess(url: String) {
    let request = Network.sharedManager.post(url: url, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          var title: String
          if self.moreServiceCell.switches.on {
            title = "远程服务已打开"
          } else {
            title = "远程服务已关闭"
          }
          self.moreServiceCell.bind(title, host: self.host)
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func service(rowIndex: Int) {
    switch rowIndex {
    /// 远程服务
    case 0:break
    /// 重启服务
    case 1:
      self.alertOther(title: Constants.Text.prompt, message: "确定重启XXTouch服务么？", delegate: self, cancelButtonTitle: Constants.Text.cancel, otherButtonTitles: Constants.Text.ok)
    default:break
    }
  }
  
  private func restart() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.restart, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Message, text: json["message"].stringValue, autoHide: true, autoHideDelay: 0.5, completionHandler: {
            
          })
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
}

// MARK: - 设置
extension MoreViewController {
  func key(rowIndex: Int) {
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

extension MoreViewController: UIAlertViewDelegate {
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    switch buttonIndex {
    case 0:restart()
    default:break
    }
  }
}

// 获取设备信息
extension MoreViewController {
  private func getDeviceinfo() {
    let request = Network.sharedManager.post(url: ServiceURL.Url.deviceinfo, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.host = "http://"+json["data"]["wifi_ip"].stringValue+":"+json["data"]["port"].stringValue
          self.fetchRemoteAccessStatus()
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
}
