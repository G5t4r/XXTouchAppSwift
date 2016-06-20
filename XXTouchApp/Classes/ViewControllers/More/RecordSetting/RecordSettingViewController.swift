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
    let request = Network.sharedManager.post(url: ServiceURL.Url.getRecordConf, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.recordVolumeUpCell.switches.on = json["data"]["record_volume_up"].boolValue
          self.recordVolumeDownCell.switches.on = json["data"]["record_volume_down"].boolValue
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

extension RecordSettingViewController {
  @objc private func recordVolumeValueChanged(switchState: UISwitch) {
    switch switchState.tag {
    case 0:
      if switchState.on {
        setRecordVolume(ServiceURL.Url.setRecordVolumeUpOn)
      } else {
        setRecordVolume(ServiceURL.Url.setRecordVolumeUpOff)
      }
    case 1:
      if switchState.on {
        setRecordVolume(ServiceURL.Url.setRecordVolumeDownOn)
      } else {
        setRecordVolume(ServiceURL.Url.setRecordVolumeDownOff)
      }
    default:break
    }
  }
  
  private func setRecordVolume(url: String) {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: url, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:break
          
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
    return 50
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch section {
    case 0: return 10
    default: return 0.01
    }
  }
  
}
