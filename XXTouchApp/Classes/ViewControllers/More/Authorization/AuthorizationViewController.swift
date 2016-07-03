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
    authorizationBindCell.sumbitButton.addTarget(self, action: #selector(sumbit), forControlEvents: .TouchUpInside)
    tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touch)))
  }
}

extension AuthorizationViewController {
  @objc private func editingChanged(textField: UITextField) {
    let string = textField.text! as NSString
    let zero = string.rangeOfString("0")
    let one = string.rangeOfString("1")
    let two = string.rangeOfString("2")
    if zero.length > 0 || one.length > 0 || two.length > 0 || textField.text?.characters.count != 16{
      submitUpdate(titleColor: ThemeManager.Theme.lightTextColor, backgroundColor: ThemeManager.Theme.separatorColor, enabled: false)
    } else {
      submitUpdate(titleColor: UIColor.whiteColor(), backgroundColor: ThemeManager.Theme.redBackgroundColor, enabled: true)
    }
  }
  
  private func submitUpdate(titleColor titleColor: UIColor, backgroundColor: UIColor, enabled: Bool) {
    authorizationBindCell.sumbitButton.setTitleColor(titleColor, forState: .Normal)
    authorizationBindCell.sumbitButton.backgroundColor = backgroundColor
    authorizationBindCell.sumbitButton.enabled = enabled
  }
  
  @objc private func sumbit() {
    if let code = authorizationBindCell.codeTextField.text {
      authorizationBindCell.codeTextField.resignFirstResponder()
      bindCode(code)
    }
  }
  
  private func bindCode(code: String) {
    if !KVNProgress.isVisible() {
      KVNProgress.showWithStatus("正在充值")
    }
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
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: message, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          KVNProgress.dismiss()
          self.authorizationCell.iconVip()
          self.authorizationBindCell.codeTextField.text?.removeAll()
          self.submitUpdate(titleColor: ThemeManager.Theme.lightTextColor, backgroundColor: ThemeManager.Theme.separatorColor, enabled: false)
          self.getExpireDate()
        case 1:
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: Constants.Error.connectServerFail, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          KVNProgress.dismiss()
          return
        case -1:
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: Constants.Error.verificationFailure, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          KVNProgress.dismiss()
          return
        case -2:
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: Constants.Error.invalidCode, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          KVNProgress.dismiss()
          return
        case 112:
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: Constants.Error.serverBusy, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          KVNProgress.dismiss()
          return
        default:
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: json["message"].stringValue, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          KVNProgress.dismiss()
          return
        }
      }
      if error != nil {
        KVNProgress.updateStatus(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.bindCode(code)
        }
      }
    }
  }
}

// 请求
extension AuthorizationViewController {
  private func getExpireDate() {
    if !KVNProgress.isVisible() {
      KVNProgress.showWithStatus(Constants.Text.reloading)
    }
    Service.getExpireDate { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        KVNProgress.dismiss()
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
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: json["message"].stringValue, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          return
        }
      }
      if error != nil {
        KVNProgress.updateStatus(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getExpireDate()
        }
      }
    }
  }
  
  private func getDeviceAuthInfo() {
    Service.getDeviceAuthInfo { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        KVNProgress.dismiss()
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
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: json["message"].stringValue, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          return
        }
      }
      if error != nil {
        KVNProgress.showWithStatus(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getDeviceAuthInfo()
        }
      }
    }
  }
}

extension AuthorizationViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return authorizationCell
    case 1: return authorizationBindCell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0: return Sizer.valueForDevice(phone: 45, pad: 65)
    case 1: return Sizer.valueForDevice(phone: 125, pad: 180)
    default: return 0.01
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0: return Sizer.valueForDevice(phone: 30, pad: 50)
    default: return Sizer.valueForDevice(phone: 10, pad: 15)
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

extension AuthorizationViewController {
  @objc private func touch() {
    authorizationBindCell.codeTextField.resignFirstResponder()
  }
}
