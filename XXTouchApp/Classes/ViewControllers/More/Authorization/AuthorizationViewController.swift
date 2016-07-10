//
//  AuthorizationViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private let authorizationCell = AuthorizationCell()
  private let authorizationBindCell = AuthorizationBindCell()
  private let deviceId: String
  private var bindCodeCell: CustomButtonCell = {
    let bindCodeCell = CustomButtonCell(buttonTitle: "充值", titleColor: ThemeManager.Theme.lightTextColor)
    bindCodeCell.backgroundColor = ThemeManager.Theme.separatorColor
    bindCodeCell.userInteractionEnabled = false
    return bindCodeCell
  }()
  
  init(deviceId: String) {
    self.deviceId = deviceId
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
    getExpireDate()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "授权续费"
    
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
    authorizationBindCell.codeTextField.addTarget(self, action: #selector(editingChanged(_:)), forControlEvents: .EditingChanged)
  }
}

extension AuthorizationViewController {
  @objc private func editingChanged(textField: UITextField) {
    let string = textField.text! as NSString
    let zero = string.rangeOfString("0")
    let one = string.rangeOfString("1")
    let two = string.rangeOfString("2")
    if zero.length > 0 || one.length > 0 || two.length > 0 || textField.text?.characters.count != 16{
      bindCodeUpdate(titleColor: ThemeManager.Theme.lightTextColor, backgroundColor: ThemeManager.Theme.separatorColor, enabled: false)
    } else {
      bindCodeUpdate(titleColor: UIColor.whiteColor(), backgroundColor: ThemeManager.Theme.redBackgroundColor, enabled: true)
    }
  }
  
  private func bindCodeUpdate(titleColor titleColor: UIColor, backgroundColor: UIColor, enabled: Bool) {
    bindCodeCell.button.setTitleColor(titleColor, forState: .Normal)
    bindCodeCell.button.backgroundColor = backgroundColor
    bindCodeCell.userInteractionEnabled = enabled
  }
  
  private func bindCode(code: String, indexPath: NSIndexPath) {
    self.view.showHUD(text: "正在充值")
    Service.bindCode(code: code) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          let time = json["data"]["expireDate"].int64Value - json["data"]["nowDate"].int64Value
          var message: String
          if time == 0 {
            message = "测试充值成功\n本次为测试授权，不会增加授权时间"
          } else {
            message = "充值成功\n本次充值时间：\(Formatter.formatDayTime(time))"
          }
          self.alertShowOneButton(message: message, cancelHandler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
          self.view.dismissHUD()
          self.authorizationCell.iconVip()
          self.authorizationBindCell.codeTextField.text?.removeAll()
          self.bindCodeUpdate(titleColor: ThemeManager.Theme.lightTextColor, backgroundColor: ThemeManager.Theme.separatorColor, enabled: false)
          self.getExpireDate()
        case 1:
          self.alertShowOneButton(message: Constants.Error.connectServerFail, cancelHandler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
          self.view.dismissHUD()
          return
        case -1:
          self.alertShowOneButton(message: Constants.Error.verificationFailure, cancelHandler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
          self.view.dismissHUD()
          return
        case -2:
          self.alertShowOneButton(message: Constants.Error.invalidCode, cancelHandler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
          self.view.dismissHUD()
          return
        case 112:
          self.alertShowOneButton(message: Constants.Error.serverBusy, cancelHandler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
          self.view.dismissHUD()
          return
        default:
          self.alertShowOneButton(message: json["message"].stringValue, cancelHandler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.bindCode(code, indexPath: indexPath)
        }
      }
    }
  }
}

// 请求
extension AuthorizationViewController {
  private func getExpireDate() {
    self.view.showHUD(text: Constants.Text.reloading)
    Service.getExpireDate { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0:
          let time = json["data"]["expire_date"].doubleValue - NSDate().timeIntervalSince1970
          if time < 60 {
            self.authorizationCell.bind("设备尚未获得授权")
            self.authorizationCell.iconNoVip()
          } else {
            self.authorizationCell.bind(Formatter.formatDateTime(json["data"]["expire_date"].int64Value))
            self.authorizationCell.iconVip()
          }
          self.getDeviceAuthInfo()
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getExpireDate()
        }
      }
    }
  }
  
  private func getDeviceAuthInfo() {
    Service.getDeviceAuthInfo(deviceId: self.deviceId) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0:
          let time = json["data"]["expireDate"].doubleValue - json["data"]["nowDate"].doubleValue
          if time <= 0 {
            self.authorizationCell.bind("设备尚未获得授权")
            self.authorizationCell.iconNoVip()
          } else {
            self.authorizationCell.bind(Formatter.formatDateTime(json["data"]["expireDate"].int64Value))
            self.authorizationCell.iconVip()
          }
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          return
        }
      }
      if error != nil {
        self.view.showHUD(text: Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getDeviceAuthInfo()
        }
      }
    }
  }
}

extension AuthorizationViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return authorizationCell
    case 1: return authorizationBindCell
    case 2: return bindCodeCell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    case 2:
      authorizationBindCell.codeTextField.resignFirstResponder()
      if let code = authorizationBindCell.codeTextField.text {
        bindCode(code, indexPath: indexPath)
      }
    default: break
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 1: return Sizer.valueForDevice(phone: 70, pad: 130)
    default: return Sizer.valueForDevice(phone: 45, pad: 65)
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0: return Sizer.valueForDevice(phone: 30, pad: 50)
    case 1: return Sizer.valueForDevice(phone: 10, pad: 15)
    default: return 0.01
    }
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if UIDevice.isPad {
      return nil
    } else {
      switch section {
      case 0: return "到期时间"
      default: return nil
      }
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if UIDevice.isPad {
      switch section {
      case 0:
        return CustomHeaderOrFooter(title: "到期时间", textColor: UIColor.grayColor(), font: UIFont.systemFontOfSize(18), alignment: .Left)
      default: return nil
      }
    } else {
      return nil
    }
  }
}
