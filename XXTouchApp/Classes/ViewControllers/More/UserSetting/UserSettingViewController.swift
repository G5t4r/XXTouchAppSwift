//
//  UserSettingViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/20.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  
  private lazy var alertValue: [String] = {
    let alertValue = [
      "会弹出",
      "不弹出"
    ]
    return alertValue
  }()
  
  private lazy var showValue: [String] = {
    let showValue = [
      "会显示",
      "不显示"
    ]
    return showValue
  }()
  
  private lazy var idleValue: [String] = {
    let idleValue = [
      "锁屏不掉线",
      "锁屏断网"
    ]
    return idleValue
  }()
  
  private lazy var daemonValue: [String] = {
    let daemonValue = [
      "自动启动非正常结束的脚本",
      "停用守护模式"
    ]
    return daemonValue
  }()
  
  private lazy var userSettingList: [String] = {
    let userSettingList = [
      "失眠模式",
      "脚本守护模式",
      "“无 SIM 卡” 弹窗",
      "“无 SIM 卡” 状态栏文字",
      "“低电量” 提示音及弹窗",
      "“使用推送通知来连接 iTunes” 弹窗"
    ]
    return userSettingList
  }()
  
  enum UserConfType {
    case NoIdle
    case ScriptOnDaemon
    case NoSimAlert
    case NoSimStatusbar
    case NoLowPowerAlert
    case NoNeedPushidAlert
    
    var title: String {
      switch self {
      case .NoIdle: return "no_idle"
      case .ScriptOnDaemon: return "script_on_daemon"
      case .NoSimAlert: return "no_nosim_alert"
      case .NoSimStatusbar: return "no_nosim_statusbar"
      case .NoLowPowerAlert: return "no_low_power_alert"
      case .NoNeedPushidAlert: return "no_need_pushid_alert"
      }
    }
  }
  
  private let noIdleCell = UserSettingCell()
  private let scriptOnDaemonCell = UserSettingCell()
  private let noSimAlertCell = UserSettingCell()
  private let noSimStatusbarCell = UserSettingCell()
  private let noLowPowerAlertCell = UserSettingCell()
  private let noNeedPushidAlertCell = UserSettingCell()
  private var userSettingInfoPopupController: STPopupController!
  private let remoteService: Bool
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }
  
  init(remoteService: Bool) {
    self.remoteService = remoteService
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    getUserConf()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "用户偏好设置"
    
    tableView.delegate  = self
    tableView.dataSource = self
    
    view.addSubview(tableView)
  }
  
  private func makeConstriants() {
    tableView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    
  }
}

/// 请求
extension UserSettingViewController {
  private func getUserConf() {
    self.view.showHUD(text: Constants.Text.reloading)
    Service.getUserConf { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0:
          let noIdle = json["data"][UserConfType.NoIdle.title].boolValue
          if self.remoteService {
            noIdle ? self.noIdleCell.bind(self.idleValue[1]) : self.noIdleCell.bind(self.idleValue[0])
          } else {
            self.noIdleCell.bind(self.idleValue[1])
          }
          
          let daemon = json["data"][UserConfType.ScriptOnDaemon.title].boolValue
          daemon ? self.scriptOnDaemonCell.bind(self.daemonValue[1]) : self.scriptOnDaemonCell.bind(self.daemonValue[0])
          
          let noSimAlert = json["data"][UserConfType.NoSimAlert.title].boolValue
          noSimAlert ? self.noSimAlertCell.bind(self.alertValue[1]) : self.noSimAlertCell.bind(self.alertValue[0])
          
          let noSimStatusbar = json["data"][UserConfType.NoSimStatusbar.title].boolValue
          noSimStatusbar ? self.noSimStatusbarCell.bind(self.showValue[1]) : self.noSimStatusbarCell.bind(self.showValue[0])
          
          let noLowPowerAlert = json["data"][UserConfType.NoLowPowerAlert.title].boolValue
          noLowPowerAlert ? self.noLowPowerAlertCell.bind(self.alertValue[1]) : self.noLowPowerAlertCell.bind(self.alertValue[0])
          
          let noNeedPushidAlert = json["data"][UserConfType.NoNeedPushidAlert.title].boolValue
          noNeedPushidAlert ? self.noNeedPushidAlertCell.bind(self.alertValue[1]) : self.noNeedPushidAlertCell.bind(self.alertValue[0])
          
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getUserConf()
        }
      }
    }
  }
}

extension UserSettingViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 6
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return noIdleCell
    case 1: return scriptOnDaemonCell
    case 2: return noSimAlertCell
    case 3: return noSimStatusbarCell
    case 4: return noLowPowerAlertCell
    case 5: return noNeedPushidAlertCell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let type = [
      UserActionType.NoIdle,
      UserActionType.ScriptOnDaemon,
      UserActionType.NoSimAlert,
      UserActionType.NoSimStatusbar,
      UserActionType.LowPowerAlert,
      UserActionType.NeedPushidAlert
    ]
    let viewController = UserSettingInfoViewController(infoTitle: userSettingList[indexPath.section], type: type[indexPath.section])
    viewController.delegate = self
    userSettingInfoPopupController = STPopupController(rootViewController: viewController)
    userSettingInfoPopupController.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDismiss)))
    userSettingInfoPopupController.containerView.layer.cornerRadius = Sizer.valueForDevice(phone: 2, pad: 3)
    userSettingInfoPopupController.presentInViewController(self)
  }
  
  @objc private func backgroundDismiss() {
    userSettingInfoPopupController.dismiss()
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if UIDevice.isPad {
      return nil
    } else {
      return userSettingList[section]
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if UIDevice.isPad {
      return CustomHeaderOrFooter(title: userSettingList[section], textColor: UIColor.grayColor(), font: UIFont.systemFontOfSize(17), alignment: .Left)
    } else {
      return nil
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Sizer.valueForDevice(phone: 45, pad: 55)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Sizer.valueForDevice(phone: 30, pad: 40)
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}

extension UserSettingViewController: UserSettingInfoViewControllerDelegate {
  func setNoIdleOnOrOff(index: Int) {
    switch index {
    case 0:
      guard self.remoteService else {
        self.alertShowOneButton(message: "此选项只有在远程服务为开启的状态生效")
        return
      }
      self.setUserConf(UserConfType.NoIdle.title, status: false)
    case 1: self.setUserConf(UserConfType.NoIdle.title, status: true)
    default: break
    }
  }
  
  func setScriptOnDaemonOnOrOff(index: Int) {
    switch index {
    case 0: self.setUserConf(UserConfType.ScriptOnDaemon.title, status: false)
    case 1: self.setUserConf(UserConfType.ScriptOnDaemon.title, status: true)
    default: break
    }
  }
  
  func setNoSimAlertOnOrOff(index: Int) {
    switch index {
    case 0: self.setUserConf(UserConfType.NoSimAlert.title, status: false)
    case 1: self.setUserConf(UserConfType.NoSimAlert.title, status: true)
    default: break
    }
  }
  
  func setNosimStatusbarOnOrOff(index: Int) {
    switch index {
    case 0: self.setUserConf(UserConfType.NoSimStatusbar.title, status: false)
    case 1: self.setUserConf(UserConfType.NoSimStatusbar.title, status: true)
    default: break
    }
  }
  
  func setLowPowerAlertOnOrOff(index: Int) {
    switch index {
    case 0: self.setUserConf(UserConfType.NoLowPowerAlert.title, status: false)
    case 1: self.setUserConf(UserConfType.NoLowPowerAlert.title, status: true)
    default: break
    }
  }
  
  func setNeedPushidAlertOnOrOff(index: Int) {
    switch index {
    case 0: self.setUserConf(UserConfType.NoNeedPushidAlert.title, status: false)
    case 1: self.setUserConf(UserConfType.NoNeedPushidAlert.title, status: true)
    default: break
    }
  }
}

extension UserSettingViewController {
  private func setUserConf(type: String, status: Bool) {
    Service.setUserConf(type: type, status: status) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.getUserConf()
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.showHUD(text: Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.setUserConf(type, status: status)
        }
      }
    }
  }
}