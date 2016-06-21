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
  }
}

extension AuthorizationViewController {
  @objc private func editingChanged(textField: UITextField) {
    if textField.text?.characters.count <= 0 {
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
      bindCode(code)
    }
  }
  
  private func bindCode(code: String) {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.bindCode, timeout:Constants.Timeout.request, value: code)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Message, text: Constants.Text.paySuccessful, autoHide: true, autoHideDelay: 0.5,completionHandler: {
            self.getExpireDate()
          })
        case 1: self.alert(title: Constants.Text.prompt, message: Constants.Error.connectServerFail, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        case -1: self.alert(title: Constants.Text.prompt, message: Constants.Error.verificationFailure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        case -2: self.alert(title: Constants.Text.prompt, message: Constants.Error.invalidCode, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        case 112: self.alert(title: Constants.Text.prompt, message: Constants.Error.serverBusy, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        default: self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
}

// 请求
extension AuthorizationViewController {
  private func getExpireDate() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.expireDate, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          let time = json["data"]["expire_date"].doubleValue - (NSDate().timeIntervalSince1970*1000)
          if time < 60 {
            self.authorizationCell.bind("设备尚未获得授权")
          } else {
            self.authorizationCell.bind(Formatter.formatDate(json["data"]["expire_date"].int64Value))
          }
          self.getDeviceAuthInfo()
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func getDeviceAuthInfo() {
    let request = Network.sharedManager.post(url: ServiceURL.Url.deviceAuthInfo, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          let time = json["data"]["expireDate"].doubleValue - json["data"]["nowDate"].doubleValue
          if time <= 0 {
            self.authorizationCell.bind("设备尚未获得授权")
          } else {
            self.authorizationCell.bind(Formatter.formatDate(json["data"]["expireDate"].int64Value))
          }
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
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
    case 0: return 40
    case 1: return 120
    default: return 0.01
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0: return 30
    default: return 10
    }
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0: return "到期时间"
    default: return nil
    }
  }
}
