//
//  RecordSettingInfoViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/19.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

protocol RecordSettingInfoViewControllerDelegate: NSObjectProtocol {
  func setRecordVolumeUpOnOrOff(index: Int)
  func setRecordVolumeDownOnOrOff(index: Int)
}

enum RecordActionType: Int {
  case RecordVolumeUp
  case RecordVolumeDown
}

class RecordSettingInfoViewController: UIViewController {
  private enum UpSection: Int, Countable {
    case RecordUp
    case NotRecordUp
  }
  
  private enum DownSection: Int, Countable {
    case RecordDown
    case NotRecordDown
  }
  
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private let infoTitle: String
  private let type: RecordActionType
  private let recordVolumeUpCell = CustomLabelCell(title: "录制音量加")
  private let notRecordVolumeUpCell = CustomLabelCell(title: "不录制音量加")
  private let recordVolumeDownCell = CustomLabelCell(title: "录制音量减")
  private let notRecordVolumeDownCell = CustomLabelCell(title: "不录制音量减")
  weak var delegate: RecordSettingInfoViewControllerDelegate?
  
  init(infoTitle: String, type: RecordActionType) {
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

extension RecordSettingInfoViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return UpSection.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch self.type {
    case .RecordVolumeUp:
      switch UpSection(rawValue: indexPath.section)! {
      case .RecordUp: return recordVolumeUpCell
      case .NotRecordUp: return notRecordVolumeUpCell
      }
    case .RecordVolumeDown:
      switch DownSection(rawValue: indexPath.section)! {
      case .RecordDown: return recordVolumeDownCell
      case .NotRecordDown: return notRecordVolumeDownCell
      }
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch self.type {
    case .RecordVolumeUp: self.delegate?.setRecordVolumeUpOnOrOff(indexPath.section)
    case .RecordVolumeDown: self.delegate?.setRecordVolumeDownOnOrOff(indexPath.section)
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
