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
  func setNoSimAlertOnOrOff(index: Int)
  func setNosimStatusbarOnOrOff(index: Int)
  func setLowPowerAlertOnOrOff(index: Int)
  func setNeedPushidAlertOnOrOff(index: Int)
}

enum UserActionType: Int {
  case NoIdle
  case ScriptOnDaemon
  case NoSimAlert
  case NoSimStatusbar
  case LowPowerAlert
  case NeedPushidAlert
}

class UserSettingInfoViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private let infoTitle: String
  private let type: UserActionType
  private let idleCell = CustomLabelCell(title: "锁屏不掉线")
  private let notIdleCell = CustomLabelCell(title: "锁屏断网")
  private let autoLaunchCloseScriptCell = CustomLabelCell(title: "自动启动非正常结束的脚本")
  private let stopDaemonCell = CustomLabelCell(title: "停用守护模式")
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
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch self.type {
    case .NoSimStatusbar:
      switch indexPath.section {
      case 0: return showCell
      case 1: return notShowCell
      default: return UITableViewCell()
      }
    case .NoIdle:
      switch indexPath.section {
      case 0: return idleCell
      case 1: return notIdleCell
      default: return UITableViewCell()
      }
    case .ScriptOnDaemon:
      switch indexPath.section {
      case 0: return autoLaunchCloseScriptCell
      case 1: return stopDaemonCell
      default: return UITableViewCell()
      }
    default:
      switch indexPath.section {
      case 0: return popCell
      case 1: return notPopCell
      default: return UITableViewCell()
      }
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch self.type {
    case .NoIdle: self.delegate?.setNoIdleOnOrOff(indexPath.section)
    case .ScriptOnDaemon: self.delegate?.setScriptOnDaemonOnOrOff(indexPath.section)
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
