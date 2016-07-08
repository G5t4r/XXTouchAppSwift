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
    self.view.showHUD(text: Constants.Text.reloading)
    Service.getUserConf { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
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
          AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
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
    if UIDevice.isPad {
      return nil
    } else {
      return userSettingList[section]
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if UIDevice.isPad {
      return CustomHeaderOrFooter(title: userSettingList[section], textColor: UIColor.grayColor(), font: UIFont.systemFontOfSize(18), alignment: .Left)
    } else {
      return nil
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Sizer.valueForDevice(phone: 45, pad: 65)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Sizer.valueForDevice(phone: 30, pad: 50)
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
      case 0: setUserConf("setNosimAlertOff")
      case 1: setUserConf("setNosimAlertOn")
      default: break
      }
    case .NoSimStatusbar:
      switch buttonIndex {
      case 0: setUserConf("setNosimStatusbarOff")
      case 1: setUserConf("setNosimStatusbarOn")
      default: break
      }
    case .NoLowPowerAlert:
      switch buttonIndex {
      case 0: setUserConf("setNoLowPowerAlertOff")
      case 1: setUserConf("setNoLowPowerAlertOn")
      default: break
      }
    case .NoNeedPushidAlert:
      switch buttonIndex {
      case 0: setUserConf("setNoNeedPushidAlertOff")
      case 1: setUserConf("setNoNeedPushidAlertOn")
      default: break
      }
    }
  }
  
  private func setUserConf(type: String) {
    Service.setUserConf(type: type) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.getUserConf()
        default:
          AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.showHUD(text: Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.setUserConf(type)
        }
      }
    }
  }
}