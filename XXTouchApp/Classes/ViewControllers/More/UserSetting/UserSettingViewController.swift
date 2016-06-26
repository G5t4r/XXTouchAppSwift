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
  
  private lazy var userSettingList: [String] = {
    let userSettingList = [
      "“无 SIM 卡” 弹窗",
      "“无 SIM 卡” 状态栏文字",
      "“低电量” 提示音及弹窗",
      "“使用推送通知来连接 iTunes” 弹窗"
    ]
    return userSettingList
  }()
  
  private let noSimAlertCell = UserSettingCell()
  private let noSimStatusbarCell = UserSettingCell()
  private let noLowPowerAlertCell = UserSettingCell()
  private let noNeedPushidAlertCell = UserSettingCell()
  
  enum UserPrompt {
    case NoSimAlert
    case NoSimStatusbar
    case NoLowPowerAlert
    case NoNeedPushidAlert
  }
  var userPrompt = UserPrompt.NoSimAlert
  
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
    if !KVNProgress.isVisible() {
      KVNProgress.showWithStatus(Constants.Text.reloading)
    }
    let request = Network.sharedManager.post(url: ServiceURL.Url.getUserConf, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        KVNProgress.dismiss()
        switch json["code"].intValue {
        case 0:
          let noSimAlert = json["data"]["no_nosim_alert"].boolValue
          noSimAlert ? self.noSimAlertCell.bind(self.alertValue[1]) : self.noSimAlertCell.bind(self.alertValue[0])
          
          let noSimStatusbar = json["data"]["no_nosim_statusbar"].boolValue
          noSimStatusbar ? self.noSimStatusbarCell.bind(self.showValue[1]) : self.noSimStatusbarCell.bind(self.showValue[0])
          
          let noLowPowerAlert = json["data"]["no_low_power_alert"].boolValue
          noLowPowerAlert ? self.noLowPowerAlertCell.bind(self.alertValue[1]) : self.noLowPowerAlertCell.bind(self.alertValue[0])
          
          let noNeedPushidAlert = json["data"]["no_need_pushid_alert"].boolValue
          noNeedPushidAlert ? self.noNeedPushidAlertCell.bind(self.alertValue[1]) : self.noNeedPushidAlertCell.bind(self.alertValue[0])
        default:
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: json["message"].stringValue, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          return
        }
      }
      if error != nil {
        KVNProgress.updateStatus(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getUserConf()
        }
      }
    }
    task.resume()
  }
}

extension UserSettingViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return noSimAlertCell
    case 1: return noSimStatusbarCell
    case 2: return noLowPowerAlertCell
    case 3: return noNeedPushidAlertCell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    /// ActionSheet
    let actionSheet = UIActionSheet()
    actionSheet.title = userSettingList[indexPath.section]
    actionSheet.delegate = self
    actionSheet.cancelButtonIndex = 2
    switch indexPath.section {
    case 1:
      actionSheet.addButtonWithTitle(showValue[0])
      actionSheet.addButtonWithTitle(showValue[1])
    default:
      actionSheet.addButtonWithTitle(alertValue[0])
      actionSheet.addButtonWithTitle(alertValue[1])
    }
    actionSheet.addButtonWithTitle(Constants.Text.cancel)
    actionSheet.showInView(view)
    
    switch indexPath.section {
    case 0: userPrompt = .NoSimAlert
    case 1: userPrompt = .NoSimStatusbar
    case 2: userPrompt = .NoLowPowerAlert
    case 3: userPrompt = .NoNeedPushidAlert
    default:break
    }
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return userSettingList[section]
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 45
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}

extension UserSettingViewController: UIActionSheetDelegate {
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    guard buttonIndex != actionSheet.cancelButtonIndex else { return }
    switch userPrompt {
    case .NoSimAlert:
      switch buttonIndex {
      case 0: setUserConf(ServiceURL.Url.setNosimAlertOff)
      case 1: setUserConf(ServiceURL.Url.setNosimAlertOn)
      default: break
      }
    case .NoSimStatusbar:
      switch buttonIndex {
      case 0: setUserConf(ServiceURL.Url.setNosimStatusbarOff)
      case 1: setUserConf(ServiceURL.Url.setNosimStatusbarOn)
      default: break
      }
    case .NoLowPowerAlert:
      switch buttonIndex {
      case 0: setUserConf(ServiceURL.Url.setNoLowPowerAlertOff)
      case 1: setUserConf(ServiceURL.Url.setNoLowPowerAlertOn)
      default: break
      }
    case .NoNeedPushidAlert:
      switch buttonIndex {
      case 0: setUserConf(ServiceURL.Url.setNoNeedPushidAlertOff)
      case 1: setUserConf(ServiceURL.Url.setNoNeedPushidAlertOn)
      default: break
      }
    }
  }
  
  private func setUserConf(url: String) {
    let request = Network.sharedManager.post(url: url, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.getUserConf()
        default:
          KVNProgress.dismiss()
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: json["message"].stringValue, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          return
        }
      }
      if error != nil {
        KVNProgress.showWithStatus(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.setUserConf(url)
        }
      }
    }
    task.resume()
  }
}