//
//  KeyBoardSettingViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/17.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class KeyBoardSettingViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private let holdVolumeUpCell = KeyBoardSettingCell()
  private let holdVolumeDownCell = KeyBoardSettingCell()
  private let clickVolumeUpCell = KeyBoardSettingCell()
  private let clickVolumeDownCell = KeyBoardSettingCell()
  
  private lazy var volumeActionList: [String] = {
    let volumeActionList = [
      "弹出选择",
      "脚本启/停",
      "无动作"
    ]
    return volumeActionList
  }()
  
  private lazy var volumeInfoList: [String] = {
    let volumeInfoList = [
      "该方法会弹出一个窗选择需要的动作",
      "该方法会切换脚本启动/停止状态",
      "该方法不会有任何动作"
    ]
    return volumeInfoList
  }()
  
  private lazy var volumePromptList: [String] = {
    let volumePromptList = [
      "长按 [音量加]",
      "长按 [音量减]",
      "按一下 [音量加]",
      "按一下 [音量减]"
    ]
    return volumePromptList
  }()
  
  enum VolumePrompt {
    case LongUpVolume
    case LongDownVolume
    case ClickUpVolume
    case ClickDownVolume
  }
  var volumePrompt = VolumePrompt.LongUpVolume
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    getVolumeActionConf()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "按键设置"
    
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

extension KeyBoardSettingViewController {
  private func getVolumeActionConf() {
    if !KVNProgress.isVisible() {
      KVNProgress.showWithStatus(Constants.Text.reloading)
    }
    let request = Network.sharedManager.post(url: ServiceURL.Url.getVolumeActionConf, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        KVNProgress.dismiss()
        switch json["code"].intValue {
        case 0:
          let holdVolumeUpIndex = json["data"]["hold_volume_up"].intValue
          self.holdVolumeUpCell.bind(self.volumeActionList[holdVolumeUpIndex], info: self.volumeInfoList[holdVolumeUpIndex])
          let holdVolumeDownIndex = json["data"]["hold_volume_down"].intValue
          self.holdVolumeDownCell.bind(self.volumeActionList[holdVolumeDownIndex], info: self.volumeInfoList[holdVolumeDownIndex])
          let clickVolumeUpIndex = json["data"]["click_volume_up"].intValue
          self.clickVolumeUpCell.bind(self.volumeActionList[clickVolumeUpIndex], info: self.volumeInfoList[clickVolumeUpIndex])
          let clickVolumeDownIndex = json["data"]["click_volume_down"].intValue
          self.clickVolumeDownCell.bind(self.volumeActionList[clickVolumeDownIndex], info: self.volumeInfoList[clickVolumeDownIndex])
        default:
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: json["message"].stringValue, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          return
        }
      }
      if error != nil {
        KVNProgress.updateStatus(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getVolumeActionConf()
        }
      }
    }
    task.resume()
  }
}

extension KeyBoardSettingViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return holdVolumeUpCell
    case 1: return holdVolumeDownCell
    case 2: return clickVolumeUpCell
    case 3: return clickVolumeDownCell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    /// ActionSheet
    let actionSheet = UIActionSheet()
    actionSheet.title = volumePromptList[indexPath.section]
    actionSheet.delegate = self
    actionSheet.cancelButtonIndex = 3
    actionSheet.addButtonWithTitle(volumeActionList[0])
    actionSheet.addButtonWithTitle(volumeActionList[1])
    actionSheet.addButtonWithTitle(volumeActionList[2])
    actionSheet.addButtonWithTitle(Constants.Text.cancel)
    actionSheet.showInView(view)
    
    switch indexPath.section {
    case 0: volumePrompt = .LongUpVolume
    case 1: volumePrompt = .LongDownVolume
    case 2: volumePrompt = .ClickUpVolume
    case 3: volumePrompt = .ClickDownVolume
    default:break
    }
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return volumePromptList[section]
  }
  
  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    switch section {
    case 3: return CustomHeaderOrFooter(title: "*设置 [无动作] 表示不拦截音量键事件\n*如安装了Activator则这里设置不生效", textColor: UIColor.redColor(), font: UIFont.systemFontOfSize(15))
    default: return nil
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}

extension KeyBoardSettingViewController: UIActionSheetDelegate {
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    guard buttonIndex != actionSheet.cancelButtonIndex else { return }
    switch volumePrompt {
    case .LongUpVolume: setVolumeAction(ServiceURL.Url.setHoldVolumeUpAction, index: buttonIndex)
    case .LongDownVolume: setVolumeAction(ServiceURL.Url.setHoldVolumeDownAction, index: buttonIndex)
    case .ClickUpVolume: setVolumeAction(ServiceURL.Url.setClickVolumeUpAction, index: buttonIndex)
    case .ClickDownVolume: setVolumeAction(ServiceURL.Url.setClickVolumeDownAction, index: buttonIndex)
    }
  }
  
  func setVolumeAction(url: String, index: Int) {
    let request = Network.sharedManager.post(url: url, timeout:Constants.Timeout.request, value: String(index))
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.getVolumeActionConf()
        default:
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: json["message"].stringValue, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          KVNProgress.dismiss()
          return
        }
      }
      if error != nil {
        KVNProgress.showWithStatus(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.setVolumeAction(url, index: index)
        }
      }
    }
    task.resume()
  }
}

// 自定义SectionHeader
class CustomHeaderOrFooter: UITableViewHeaderFooterView {
  let titleLabel = UILabel()
  var top: Int
  
  init(title: String, textColor: UIColor, font: UIFont, top: Int = 15) {
    titleLabel.text = title
    titleLabel.font = font
    titleLabel.textColor = textColor
    self.top = top
    super.init(reuseIdentifier: nil)
    setupUI()
    makeConstraints()
  }
  
  private func setupUI() {
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .Center
    self.addSubview(titleLabel)
  }
  
  private func makeConstraints() {
    titleLabel.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(self).inset(15)
      make.top.equalTo(self).offset(self.top)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}