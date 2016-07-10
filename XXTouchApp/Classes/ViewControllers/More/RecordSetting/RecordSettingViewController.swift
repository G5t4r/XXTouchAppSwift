//
//  RecordSettingViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/17.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class RecordSettingViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  
  private lazy var recordVolumeUpCell: CustomSettingCell = {
    let recordVolumeUpCell = CustomSettingCell(title: "录制也包括 [音量加]")
    recordVolumeUpCell.switches.tag = 0
    return recordVolumeUpCell
  }()
  
  private lazy var recordVolumeDownCell: CustomSettingCell = {
    let recordVolumeDownCell = CustomSettingCell(title: "录制也包括 [音量减]")
    recordVolumeDownCell.switches.tag = 1
    return recordVolumeDownCell
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    getRecordConf()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "录制设置"
    
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
    recordVolumeUpCell.switches.addTarget(self, action: #selector(recordVolumeValueChanged(_:)), forControlEvents: .ValueChanged)
    recordVolumeDownCell.switches.addTarget(self, action: #selector(recordVolumeValueChanged(_:)), forControlEvents: .ValueChanged)
  }
}

extension RecordSettingViewController {
  private func getRecordConf() {
    self.view.showHUD(text: Constants.Text.reloading)
    Service.getRecordConf { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0:
          self.recordVolumeUpCell.switches.on = json["data"]["record_volume_up"].boolValue
          self.recordVolumeDownCell.switches.on = json["data"]["record_volume_down"].boolValue
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getRecordConf()
        }
      }
    }
  }
}

extension RecordSettingViewController {
  @objc private func recordVolumeValueChanged(switchState: UISwitch) {
    switch switchState.tag {
    case 0:
      if switchState.on {
        setRecordVolume("setRecordVolumeUpOn")
      } else {
        setRecordVolume("setRecordVolumeUpOff")
      }
    case 1:
      if switchState.on {
        setRecordVolume("setRecordVolumeDownOn")
      } else {
        setRecordVolume("setRecordVolumeDownOff")
      }
    default:break
    }
  }
  
  private func setRecordVolume(type: String) {
    self.view.showHUD(text: Constants.Text.reloading)
    Service.setRecordConf(type: type) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0:break
          
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.setRecordVolume(type)
        }
      }
    }
  }
}

extension RecordSettingViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return recordVolumeUpCell
    case 1: return recordVolumeDownCell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Sizer.valueForDevice(phone: 50, pad: 70)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch section {
    case 0: return Sizer.valueForDevice(phone: 10, pad: 15)
    default: return 0.01
    }
  }
  
}
