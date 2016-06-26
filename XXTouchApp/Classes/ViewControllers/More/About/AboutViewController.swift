//
//  AboutViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/22.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private let aboutTitleCell = AboutTitleCell()
  
  // 服务程序版本
  private let zeVersionCell = AboutInfoCell(title: "软件版本")
  // 系统版本
  private let sysVersionCell = AboutInfoCell(title: "系统版本")
  // 设备类型
  private let devTypeCell = AboutInfoCell(title: "设备类型")
  // 设备名
  private let devNameCell = AboutInfoCell(title: "设备名")
  // 设备序列号
  private let devSNCell = AboutInfoCell(title: "序列号")
  // 设备MAC地址
  private let devMacCell = AboutInfoCell(title: "MAC地址")
  // 设备UDID
  private let deviceIdCell = AboutInfoCell(title: "设备号")
  
  private var deviceCellList = [AboutInfoCell]()
  
  private let aboutEmailCell = AboutEmailCell()
  
  private var deviceId = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    getDeviceinfo()
    bind()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "关于"
    
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
    aboutEmailCell.emailButton.addTarget(self, action: #selector(email), forControlEvents: .TouchUpInside)
  }
  
  private func bind() {
    deviceCellList = [
      zeVersionCell,
      sysVersionCell,
      devTypeCell,
      devNameCell,
      devSNCell,
      devMacCell,
      deviceIdCell
    ]
  }
}

extension AboutViewController {
  @objc private func email() {
    UIApplication.sharedApplication().openURL(NSURL(string: "mailto:info@xxtouch.com")!)
  }
}

// 请求
extension AboutViewController {
  private func getDeviceinfo() {
    if !KVNProgress.isVisible() {
      KVNProgress.showWithStatus(Constants.Text.reloading)
    }
    let request = Network.sharedManager.post(url: ServiceURL.Url.deviceinfo, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        KVNProgress.dismiss()
        switch json["code"].intValue {
        case 0:
          self.zeVersionCell.bind(json["data"]["zeversion"].stringValue)
          self.sysVersionCell.bind(json["data"]["sysversion"].stringValue)
          self.devTypeCell.bind(json["data"]["devtype"].stringValue)
          self.devNameCell.bind(json["data"]["devname"].stringValue)
          self.devSNCell.bind(json["data"]["devsn"].stringValue)
          self.devMacCell.bind(json["data"]["devmac"].stringValue)
          self.deviceIdCell.bind(json["data"]["deviceid"].stringValue)
          self.deviceId = json["data"]["deviceid"].stringValue
        default:
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: json["message"].stringValue, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          return
        }
      }
      if error != nil {
        KVNProgress.updateStatus(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getDeviceinfo()
        }
      }
    }
    task.resume()
  }
}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 1: return 7
    default: return 1
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return aboutTitleCell
    case 1: return deviceCellList[indexPath.row]
    case 2: return aboutEmailCell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    case 1:
      if indexPath.row == 6 {
        UIPasteboard.generalPasteboard().string = deviceId
        KVNProgress.showSuccessWithStatus(Constants.Text.copy)
      }
    default: break
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0: return 190
    case 1: return 55
    case 2: return 40
    default: return 0
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0: return 0.01
    default: return 15
    }
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}
