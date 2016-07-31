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
  
  private enum Header {
    case Title
    case Icon
  }
  
  private lazy var serviceList: [Header : String] = {
    let serviceList = [
      Header.Title : "重启服务",
      Header.Icon : "restar_01"
    ]
    return serviceList
  }()
  
  private lazy var authorizationList: [[Header : String]] = {
    let authorizationList = [
      [
        Header.Title : "授权",
        Header.Icon : "authorization"
      ]
    ]
    return authorizationList
  }()
  
  private lazy var settingList: [[Header : String]] = {
    let settingList = [
      [
        Header.Title : "按键设置",
        Header.Icon : "keysettings"
      ],
      [
        Header.Title : "录制设置",
        Header.Icon : "recording"
      ],
      [
        Header.Title : "开机启动设置",
        Header.Icon : "startup"
      ],
      [
        Header.Title : "用户偏好设置",
        Header.Icon : "user"
      ]
    ]
    return settingList
  }()
  
  private lazy var systemList: [[Header : String]] = {
    let systemList = [
      [
        Header.Title : "应用列表",
        Header.Icon : "application"
      ],
      [
        Header.Title : "清空GPS伪装信息",
        Header.Icon : "gps"
      ],
      [
        Header.Title : "清理UI缓存",
        Header.Icon : "uicache"
      ],
      [
        Header.Title : "全清设备",
        Header.Icon : "equipment"
      ],
      [
        Header.Title : "注销设备",
        Header.Icon : "cancellation"
      ],
      [
        Header.Title : "重启设备",
        Header.Icon : "restar_02"
      ]
    ]
    return systemList
  }()
  
  private lazy var helpList: [[Header : String]] = {
    let helpList = [
      [
        Header.Title : "开发文档",
        Header.Icon : "document"
      ],
      [
        Header.Title : "关于",
        Header.Icon : "about"
      ]
    ]
    return helpList
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
  
  private enum Section: Int, Countable {
    case Service
    case Authorization
    case Setting
    case System
    case Help
  }
  
  private enum ServiceRow: Int, Countable {
    case Remote
    case Reset
  }
  
  private enum AuthorizationRow: Int, Countable {
    case Auth
  }
  
  private enum SettingRow: Int, Countable {
    case KeyBoard
    case Record
    case StartUp
    case User
  }
  
  private enum SystemRow: Int, Countable {
    case List
    case GPS
    case Cache
    case ClearAll
    case Logout
    case Reboot
  }
  
  private enum HelpRow: Int, Countable {
    case Doc
    case About
  }
  
  private enum SetRemoteAction {
    case Open
    case Close
    
    var title: String {
      switch self {
      case .Open: return "open_remote_access"
      case .Close: return "close_remote_access"
      }
    }
  }
  
  private var host = ""
  private var deviceId = ""
  private let moreRemoteServiceCell = MoreRemoteServiceCell()
  private var remoteService = false
  
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
    return Section.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Section(rawValue: section)! {
    case .Service: return 2
    case .Authorization: return 1
    case .Setting: return settingList.count
    case .System: return systemList.count
    case .Help: return helpList.count
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch Section(rawValue: indexPath.section)! {
    case .Service:
      switch ServiceRow(rawValue: indexPath.row)! {
      case .Remote: return Sizer.valueForDevice(phone: 55, pad: 65)
      default: return Sizer.valueForDevice(phone: 45, pad: 55)
      }
    default: return Sizer.valueForDevice(phone: 45, pad: 55)
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch Section(rawValue: indexPath.section)! {
    case .Service:
      switch ServiceRow(rawValue: indexPath.row)! {
      case .Remote: return moreRemoteServiceCell
      default: return MoreCustomCell(icon: serviceList[.Icon]!, title: serviceList[.Title]!)
      }
    case .Authorization: return MoreCustomCell(icon: authorizationList[indexPath.row][.Icon]!, title: authorizationList[indexPath.row][.Title]!)
    case .Setting: return MoreCustomCell(icon: settingList[indexPath.row][.Icon]!, title: settingList[indexPath.row][.Title]!)
    case .System: return MoreCustomCell(icon: systemList[indexPath.row][.Icon]!, title: systemList[indexPath.row][.Title]!)
    case .Help: return MoreCustomCell(icon: helpList[indexPath.row][.Icon]!, title: helpList[indexPath.row][.Title]!)
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch Section(rawValue: indexPath.section)! {
    /// 服务
    case .Service: return service(indexPath)
    /// 授权
    case .Authorization: return authorization(indexPath)
    /// 设置
    case .Setting: return key(indexPath)
    /// 系统
    case .System: return system(indexPath)
    /// 帮助
    case .Help: return help(indexPath)
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
    }
    return nil
  }
  
  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    switch Section(rawValue: section)! {
    case .Help: return CustomHeaderOrFooter(title: "© XXTouch", textColor: UIColor.grayColor(), font: UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 14, pad: 18)), alignment: .Left, offset: -10)
    default: return nil
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Sizer.valueForDevice(phone: 30, pad: 50)
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch Section(rawValue: section)! {
    case .Help: return Sizer.valueForDevice(phone: 50, pad: 70)
    default: return 0.01
    }
  }
}

// MARK: - 服务
extension MoreViewController {
  func titleLabelAnimation(switchs: Bool) {
    if switchs {
      self.moreRemoteServiceCell.bind("远程服务已打开", host: self.host)
      self.moreRemoteServiceCell.hostLabelHidden(!switchs)
      self.moreRemoteServiceCell.titleLabel.snp_remakeConstraints { (make) in
        make.top.equalTo(self.moreRemoteServiceCell.contentView).offset(Sizer.valueForDevice(phone: 9, pad: 11))
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
          self.remoteService = opened
          self.titleLabelAnimation(opened)
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
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
      openAndCloseRemoteAccess(SetRemoteAction.Open.title)
    } else {
      // 关闭远程服务
      openAndCloseRemoteAccess(SetRemoteAction.Close.title)
    }
  }
  
  private func openAndCloseRemoteAccess(action: String) {
    Service.openOrCloseRemoteAccess(action: action) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.getDeviceinfo()
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.showHUD(text: Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.openAndCloseRemoteAccess(action)
        }
      }
    }
  }
  
  private func service(indexPath: NSIndexPath) {
    switch ServiceRow(rawValue: indexPath.row)! {
    /// 重启服务
    case .Reset:
      self.alertShowTwoButton(message: "确定要重启XXTouch服务么？", cancelHandler: { [weak self] (_) in
        guard let `self` = self else { return }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }, otherHandler: { [weak self] (_) in
          guard let `self` = self else { return }
          self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
          self.restart()
        })
    default:break
    }
  }
}

// MARK: - 授权
extension MoreViewController {
  private func authorization(indexPath: NSIndexPath) {
    switch AuthorizationRow(rawValue: indexPath.row)! {
    /// 授权
    case .Auth: self.navigationController?.pushViewController(AuthorizationViewController(deviceId: self.deviceId), animated: true)
    }
  }
}


// MARK: - 设置
extension MoreViewController {
  private func key(indexPath: NSIndexPath) {
    switch SettingRow(rawValue: indexPath.row)! {
    /// 按键设置
    case .KeyBoard: self.navigationController?.pushViewController(KeyBoardSettingViewController(), animated: true)
    /// 录制设置
    case .Record: self.navigationController?.pushViewController(RecordSettingViewController(), animated: true)
    /// 开机启动设置
    case .StartUp: self.navigationController?.pushViewController(StartUpSettingViewController(), animated: true)
    /// 用户偏好设置
    case .User: self.navigationController?.pushViewController(UserSettingViewController(remoteService: self.remoteService), animated: true)
    }
  }
}

// MARK: - 系统
extension MoreViewController {
  private func system(indexPath: NSIndexPath) {
    switch SystemRow(rawValue: indexPath.row)! {
    /// 应用列表
    case .List: self.navigationController?.pushViewController(ApplicationListViewController(type: .Nothing), animated: true)
    /// 清空GPS伪装信息
    case .GPS:
      self.alertShowTwoButton(message: "确定要清空GPS伪装信息么？", cancelHandler: { [weak self] (_) in
        guard let `self` = self else { return }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }, otherHandler: { [weak self] (_) in
          guard let `self` = self else { return }
          self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
          self.clearGps()
        })
    /// 清理 UI 缓存
    case .Cache:
      self.alertShowTwoButton(message: "确定要清理 UI 缓存么？\n(这个操作有可能引起注销或图标不见)", cancelHandler: { [weak self] (_) in
        guard let `self` = self else { return }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }, otherHandler: { [weak self] (_) in
          guard let `self` = self else { return }
          self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
          self.clearUIcache()
        })
    /// 全清设备
    case .ClearAll:
      self.alertShowTwoButton(message: "确定要全清设备么？\n(这个操作将会关闭所有应用并删除所有应用的资料及重置设备标识信息)", cancelHandler: { [weak self] (_) in
        guard let `self` = self else { return }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }, otherHandler: { [weak self] (_) in
          guard let `self` = self else { return }
          self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
          self.clearAll()
        })
    /// 注销设备
    case .Logout:
      self.alertShowTwoButton(message: "确定要注销设备么？", cancelHandler: { [weak self] (_) in
        guard let `self` = self else { return }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }, otherHandler: { [weak self] (_) in
          guard let `self` = self else { return }
          self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
          MixC.sharedManager.logout()
        })
    /// 重启设备
    case .Reboot:
      self.alertShowTwoButton(message: "确定要重启设备么？", cancelHandler: { [weak self] (_) in
        guard let `self` = self else { return }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }, otherHandler: { [weak self] (_) in
          guard let `self` = self else { return }
          self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
          self.reboot()
        })
    }
  }
}

// MARK: - 帮助
extension MoreViewController {
  private func help(indexPath: NSIndexPath) {
    switch HelpRow(rawValue: indexPath.row)! {
    /// 开发文档
    case .Doc:
      let developDocumentViewController = DevelopDocumentViewController()
      developDocumentViewController.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(developDocumentViewController, animated: true)
    /// 关于
    case .About: self.navigationController?.pushViewController(AboutViewController(), animated: true)
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
          self.alertShowOneButton(message: json["message"].stringValue)
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
          self.alertShowOneButton(message: json["message"].stringValue)
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
          self.alertShowOneButton(message: json["message"].stringValue)
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
          self.alertShowOneButton(message: json["message"].stringValue)
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
          self.alertShowOneButton(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
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
          self.alertShowOneButton(message: json["message"].stringValue)
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
