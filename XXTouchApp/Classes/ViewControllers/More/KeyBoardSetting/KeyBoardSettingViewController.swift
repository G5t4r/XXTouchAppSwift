//
//  KeyBoardSettingViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/17.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class KeyBoardSettingViewController: UIViewController {
  private enum Section: Int, Countable {
    case HoldUp
    case HoldDown
    case ClickUp
    case ClickDown
  }
  
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private let holdVolumeUpCell = KeyBoardSettingCell()
  private let holdVolumeDownCell = KeyBoardSettingCell()
  private let clickVolumeUpCell = KeyBoardSettingCell()
  private let clickVolumeDownCell = KeyBoardSettingCell()
  private var keyBoardSettingInfoPopupController: STPopupController!
  
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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }
  
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
    self.view.showHUD(text: Constants.Text.reloading)
    Service.getVolumeActionConf { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0:
          let activator = json["data"]["activator_installed"].boolValue
          if activator {
            self.holdVolumeUpCell.setStatus()
            self.holdVolumeDownCell.setStatus()
            self.clickVolumeUpCell.setStatus()
            self.clickVolumeDownCell.setStatus()
          }
          
          let holdVolumeUpIndex = json["data"]["hold_volume_up"].intValue
          self.holdVolumeUpCell.bind(self.volumeActionList[holdVolumeUpIndex], info: self.volumeInfoList[holdVolumeUpIndex])
          let holdVolumeDownIndex = json["data"]["hold_volume_down"].intValue
          self.holdVolumeDownCell.bind(self.volumeActionList[holdVolumeDownIndex], info: self.volumeInfoList[holdVolumeDownIndex])
          let clickVolumeUpIndex = json["data"]["click_volume_up"].intValue
          self.clickVolumeUpCell.bind(self.volumeActionList[clickVolumeUpIndex], info: self.volumeInfoList[clickVolumeUpIndex])
          let clickVolumeDownIndex = json["data"]["click_volume_down"].intValue
          self.clickVolumeDownCell.bind(self.volumeActionList[clickVolumeDownIndex], info: self.volumeInfoList[clickVolumeDownIndex])
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getVolumeActionConf()
        }
      }
    }
  }
}

extension KeyBoardSettingViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return Section.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch Section(rawValue: indexPath.section)! {
    case .HoldUp: return holdVolumeUpCell
    case .HoldDown: return holdVolumeDownCell
    case .ClickUp: return clickVolumeUpCell
    case .ClickDown: return clickVolumeDownCell
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let type = [
      KeyBoardActionType.HoldVolumeUp,
      KeyBoardActionType.HoldVolumeDown,
      KeyBoardActionType.ClickVolumeUp,
      KeyBoardActionType.ClickVolumeDown
    ]
    let viewController = KeyBoardSettingInfoViewController(infoTitle: volumePromptList[indexPath.section], type: type[indexPath.section])
    viewController.delegate = self
    keyBoardSettingInfoPopupController = STPopupController(rootViewController: viewController)
    keyBoardSettingInfoPopupController.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDismiss)))
    keyBoardSettingInfoPopupController.containerView.layer.cornerRadius = Sizer.valueForDevice(phone: 2, pad: 3)
    keyBoardSettingInfoPopupController.presentInViewController(self)
  }
  
  @objc private func backgroundDismiss() {
    keyBoardSettingInfoPopupController.dismiss()
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if UIDevice.isPad {
      return nil
    } else {
      return volumePromptList[section]
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if UIDevice.isPad {
      return CustomHeaderOrFooter(title: volumePromptList[section], textColor: UIColor.grayColor(), font: UIFont.systemFontOfSize(17), alignment: .Left)
    } else {
      return nil
    }
  }
  
  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    switch Section(rawValue: section)! {
    case .ClickDown: return CustomHeaderOrFooter(title: "*设置 [无动作] 表示不拦截音量键事件\n*如安装了Activator则这里设置不生效\n且屏蔽操作", textColor: UIColor.redColor(), font: UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 15, pad: 19)))
    default: return nil
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Sizer.valueForDevice(phone: 60, pad: 75)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Sizer.valueForDevice(phone: 30, pad: 40)
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch Section(rawValue: section)! {
    case .ClickDown: return Sizer.valueForDevice(phone: 65, pad: 85)
    default: return 0.01
    }
  }
}

extension KeyBoardSettingViewController: KeyBoardSettingInfoViewControllerDelegate {
  func setHoldVolumeUpAction(index: Int) {
    self.setVolumeAction(String(index),type: "setHoldVolumeUpAction")
  }
  
  func setHoldVolumeDownAction(index: Int) {
    self.setVolumeAction(String(index),type: "setHoldVolumeDownAction")
  }
  
  func setClickVolumeUpAction(index: Int) {
    self.setVolumeAction(String(index),type: "setClickVolumeUpAction")
  }
  
  func setClickVolumeDownAction(index: Int) {
    self.setVolumeAction(String(index),type: "setClickVolumeDownAction")
  }
}

extension KeyBoardSettingViewController {
  func setVolumeAction(value: String, type: String) {
    Service.setVolumeActionConf(value: value, type: type) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.getVolumeActionConf()
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.showHUD(text: Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.setVolumeAction(value, type: type)
        }
      }
    }
  }
}

// 自定义SectionHeader
class CustomHeaderOrFooter: UITableViewHeaderFooterView {
  let titleLabel = UILabel()
  let offset: CGFloat
  
  init(title: String, textColor: UIColor, font: UIFont, alignment: NSTextAlignment = .Center, offset: CGFloat = 0) {
    self.offset = offset
    titleLabel.text = title
    titleLabel.font = font
    titleLabel.textColor = textColor
    titleLabel.textAlignment = alignment
    super.init(reuseIdentifier: nil)
    setupUI()
    makeConstraints()
  }
  
  private func setupUI() {
    titleLabel.numberOfLines = 0
    self.addSubview(titleLabel)
  }
  
  private func makeConstraints() {
    titleLabel.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(self).inset(20)
      make.centerY.equalTo(self).offset(self.offset)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}