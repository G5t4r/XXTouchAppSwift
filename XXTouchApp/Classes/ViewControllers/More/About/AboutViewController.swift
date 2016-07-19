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
  
  private let qqGroupCell = CustomButtonCell(buttonTitle: "开发者QQ群")
  
  private let webCell = CustomButtonCell(buttonTitle: "官方网站")
  
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
  
  private func qqGroup() {
    let url = NSURL(string: "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=40898074&card_type=group&source=external")
    if UIApplication.sharedApplication().canOpenURL(url!) {
      UIApplication.sharedApplication().openURL(url!)
    } else {
      self.alertShowOneButton(message: "QQ群号：40898074")
    }
  }
  
  private func web() {
    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.xxtouch.com")!)
  }
}

// 请求
extension AboutViewController {
  private func getDeviceinfo() {
    self.view.showHUD(text: Constants.Text.reloading)
    Service.getDeviceinfo { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
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
}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 4
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
    case 2: return qqGroupCell
    case 3: return webCell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    switch indexPath.section {
    case 1:
      if indexPath.row == 6 {
        UIPasteboard.generalPasteboard().string = deviceId
        self.view.showHUD(.Success, text: Constants.Text.copy)
      }
    case 2: qqGroup()
    case 3: web()
    default: break
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0: return Sizer.valueForDevice(phone: 70, pad: 75)
    case 1: return Sizer.valueForDevice(phone: 55, pad: 65)
    default: return Sizer.valueForDevice(phone: 40, pad: 50)
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0: return 0.01
    default: return Sizer.valueForDevice(phone: 10, pad: 15)
    }
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}
