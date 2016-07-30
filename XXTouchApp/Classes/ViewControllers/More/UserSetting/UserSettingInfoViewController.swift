//
//  UserSettingInfoViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/13.
//  Copyright © 2016年 mcy. All rights reserved.
//

protocol UserSettingInfoViewControllerDelegate: NSObjectProtocol {
  func setNoIdleOnOrOff(index: Int)
  func setScriptOnDaemonOnOrOff(index: Int)
  func setScriptEndHintOnOrOff(index: Int)
  func setNoSimAlertOnOrOff(index: Int)
  func setNosimStatusbarOnOrOff(index: Int)
  func setLowPowerAlertOnOrOff(index: Int)
  func setNeedPushidAlertOnOrOff(index: Int)
}

enum UserActionType: Int {
  case NoIdle
  case ScriptOnDaemon
  case ScriptEndHint
  case NoSimAlert
  case NoSimStatusbar
  case LowPowerAlert
  case NeedPushidAlert
}

class UserSettingInfoViewController: UIViewController {
  private enum IdleSection: Int, Countable {
    case Idle
    case NotIdle
  }
  
  private enum HintSection: Int, Countable {
    case Hint
    case NotHint
  }
  
  private enum DaemonSection: Int, Countable {
    case Daemon
    case StopDaemon
  }
  
  private enum PopSection: Int, Countable {
    case Pop
    case NotPop
  }
  
  private enum ShowSection: Int, Countable {
    case Show
    case NotShow
  }
  
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private let infoTitle: String
  private let type: UserActionType
  private let idleCell = CustomLabelCell(title: "正常休眠")
  private let notIdleCell = CustomLabelCell(title: "锁屏不掉线")
  private let hintCell = CustomLabelCell(title: "有提示")
  private let notHintCell = CustomLabelCell(title: "无提示")
  private let daemonCell = CustomLabelCell(title: "会守护")
  private let stopDaemonCell = CustomLabelCell(title: "不守护")
  private let popCell = CustomLabelCell(title: "会弹出")
  private let notPopCell = CustomLabelCell(title: "不弹出")
  private let showCell = CustomLabelCell(title: "会显示")
  private let notShowCell = CustomLabelCell(title: "不显示")
  weak var delegate: UserSettingInfoViewControllerDelegate?
  
  init(infoTitle: String, type: UserActionType) {
    self.infoTitle = infoTitle
    self.type = type
    super.init(nibName: nil, bundle: nil)
    self.contentSizeInPopup = CGSize(width: view.frame.width/1.05, height: Sizer.valueForDevice(phone: 105, pad: 121))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    bind()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor(rgb: 0xefeff4)
    
    tableView.delegate  = self
    tableView.dataSource = self
    tableView.showsVerticalScrollIndicator = false
    
    view.addSubview(tableView)
  }
  
  private func makeConstriants() {
    tableView.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(view).inset(Sizer.valueForDevice(phone: 5, pad: 7))
      make.top.bottom.equalTo(view)
    }
  }
  
  private func bind() {
    navigationItem.title = self.infoTitle
  }
}

extension UserSettingInfoViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return IdleSection.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch self.type {
    case .NoSimStatusbar:
      switch ShowSection(rawValue: indexPath.section)! {
      case .Show: return showCell
      case .NotShow: return notShowCell
      }
    case .NoIdle:
      switch IdleSection(rawValue: indexPath.section)! {
      case .Idle: return idleCell
      case .NotIdle: return notIdleCell
      }
    case .ScriptEndHint:
      switch HintSection(rawValue: indexPath.section)! {
      case .Hint: return hintCell
      case .NotHint: return notHintCell
      }
    case .ScriptOnDaemon:
      switch DaemonSection(rawValue: indexPath.section)! {
      case .Daemon: return stopDaemonCell
      case .StopDaemon: return daemonCell
      }
    default:
      switch PopSection(rawValue: indexPath.section)! {
      case .Pop: return popCell
      case .NotPop: return notPopCell
      }
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch self.type {
    case .NoIdle: self.delegate?.setNoIdleOnOrOff(indexPath.section)
    case .ScriptOnDaemon: self.delegate?.setScriptOnDaemonOnOrOff(indexPath.section)
    case .ScriptEndHint: self.delegate?.setScriptEndHintOnOrOff(indexPath.section)
    case .NoSimAlert: self.delegate?.setNoSimAlertOnOrOff(indexPath.section)
    case .NoSimStatusbar: self.delegate?.setNosimStatusbarOnOrOff(indexPath.section)
    case .LowPowerAlert: self.delegate?.setLowPowerAlertOnOrOff(indexPath.section)
    case .NeedPushidAlert: self.delegate?.setNeedPushidAlertOnOrOff(indexPath.section)
    }
    self.popupController.popViewControllerAnimated(true)
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Sizer.valueForDevice(phone: 45, pad: 50)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Sizer.valueForDevice(phone: 5, pad: 7)
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}
