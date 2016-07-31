//
//  RecordSettingViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/17.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class RecordSettingViewController: UIViewController {
  private enum Section: Int, Countable {
    case RecordUp
    case RecordDown
  }
  
  private enum Index: Int, Countable {
    case On
    case Off
  }
  
  private enum SetAction {
    case RecordUpOn
    case RecordUpOff
    case RecordDownOn
    case RecordDownOff
    
    var title: String {
      switch self {
      case .RecordUpOn: return "set_record_volume_up_on"
      case .RecordUpOff: return "set_record_volume_up_off"
      case .RecordDownOn: return "set_record_volume_down_on"
      case .RecordDownOff: return "set_record_volume_down_off"
      }
    }
  }
  
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  
  private lazy var recordSettingList: [String] = {
    let recordSettingList = [
      "录制包含音量加键",
      "录制包含音量减键"
    ]
    return recordSettingList
  }()
  
  private lazy var recordUpValue: [String] = {
    let daemonValue = [
      "录制音量加",
      "不录制音量加"
    ]
    return daemonValue
  }()
  
  private lazy var recordDownValue: [String] = {
    let daemonValue = [
      "录制音量减",
      "不录制音量减"
    ]
    return daemonValue
  }()
  
  private let recordVolumeUpCell = CustomSettingCell()
  private let recordVolumeDownCell = CustomSettingCell()
  private var recordSettingInfoPopupController: STPopupController!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }
  
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
          let upValue = json["data"]["record_volume_up"].boolValue
          upValue ? self.recordVolumeUpCell.bind(self.recordUpValue[0]) : self.recordVolumeUpCell.bind(self.recordUpValue[1])
          let downValue = json["data"]["record_volume_down"].boolValue
          downValue ? self.recordVolumeDownCell.bind(self.recordDownValue[0]) : self.recordVolumeDownCell.bind(self.recordDownValue[1])
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
  private func setRecordVolume(action: String) {
    self.view.showHUD(text: Constants.Text.reloading)
    Service.setRecordConf(action: action) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0: self.getRecordConf()
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.setRecordVolume(action)
        }
      }
    }
  }
}

extension RecordSettingViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return Section.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch Section(rawValue: indexPath.section)! {
    case .RecordUp: return recordVolumeUpCell
    case .RecordDown: return recordVolumeDownCell
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let type = [
      RecordActionType.RecordVolumeUp,
      RecordActionType.RecordVolumeDown
    ]
    
    let viewController = RecordSettingInfoViewController(infoTitle: recordSettingList[indexPath.section], type: type[indexPath.section])
    viewController.delegate = self
    recordSettingInfoPopupController = STPopupController(rootViewController: viewController)
    recordSettingInfoPopupController.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDismiss)))
    recordSettingInfoPopupController.containerView.layer.cornerRadius = Sizer.valueForDevice(phone: 2, pad: 3)
    recordSettingInfoPopupController.presentInViewController(self)
  }
  
  @objc private func backgroundDismiss() {
    recordSettingInfoPopupController.dismiss()
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if UIDevice.isPad {
      return nil
    } else {
      return recordSettingList[section]
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if UIDevice.isPad {
      return CustomHeaderOrFooter(title: recordSettingList[section], textColor: UIColor.grayColor(), font: UIFont.systemFontOfSize(17), alignment: .Left)
    } else {
      return nil
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Sizer.valueForDevice(phone: 45, pad: 55)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Sizer.valueForDevice(phone: 30, pad: 40)
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}

extension RecordSettingViewController: RecordSettingInfoViewControllerDelegate {
  func setRecordVolumeUpOnOrOff(index: Int) {
    switch Index(rawValue: index)! {
    case .On: setRecordVolume(SetAction.RecordUpOn.title)
    case .Off: setRecordVolume(SetAction.RecordUpOff.title)
    }
  }
  
  func setRecordVolumeDownOnOrOff(index: Int) {
    switch Index(rawValue: index)! {
    case .On: setRecordVolume(SetAction.RecordDownOn.title)
    case .Off: setRecordVolume(SetAction.RecordDownOff.title)
    }
  }
}
