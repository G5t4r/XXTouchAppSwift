//
//  KeyBoardSettingInfoViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/13.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

protocol KeyBoardSettingInfoViewControllerDelegate: NSObjectProtocol {
  func setHoldVolumeUpAction(index: Int)
  func setHoldVolumeDownAction(index: Int)
  func setClickVolumeUpAction(index: Int)
  func setClickVolumeDownAction(index: Int)
}

enum KeyBoardActionType: Int {
  case HoldVolumeUp
  case HoldVolumeDown
  case ClickVolumeUp
  case ClickVolumeDown
}

class KeyBoardSettingInfoViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private let infoTitle: String
  private let type: KeyBoardActionType
  private let popSelectedCell = CustomLabelCell(title: "弹出选择")
  private let runAndStopCell = CustomLabelCell(title: "脚本启/停")
  private let nothingCell = CustomLabelCell(title: "无动作")
  weak var delegate: KeyBoardSettingInfoViewControllerDelegate?
  
  init(infoTitle: String, type: KeyBoardActionType) {
    self.infoTitle = infoTitle
    self.type = type
    super.init(nibName: nil, bundle: nil)
    self.contentSizeInPopup = CGSize(width: view.frame.width/1.05, height: Sizer.valueForDevice(phone: 155, pad: 178))
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

extension KeyBoardSettingInfoViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return popSelectedCell
    case 1: return runAndStopCell
    case 2: return nothingCell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch self.type {
    case .HoldVolumeUp: self.delegate?.setHoldVolumeUpAction(indexPath.section)
    case .HoldVolumeDown: self.delegate?.setHoldVolumeDownAction(indexPath.section)
    case .ClickVolumeUp: self.delegate?.setClickVolumeUpAction(indexPath.section)
    case .ClickVolumeDown: self.delegate?.setClickVolumeDownAction(indexPath.section)
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
