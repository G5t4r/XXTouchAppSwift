//
//  ApplicationDetailViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ApplicationDetailViewController: UIViewController {
  private let model: ApplicationListModel
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  
  private lazy var appNameCell: ApplicationDetailCell = {
    let appNameCell = ApplicationDetailCell()
    appNameCell.contentView.tag = 0
    return appNameCell
  }()
  
  private lazy var appPackageNameCell: ApplicationDetailCell = {
    let appPackageNameCell = ApplicationDetailCell()
    appPackageNameCell.contentView.tag = 1
    return appPackageNameCell
  }()
  
  private lazy var appBundlePathCell: ApplicationDetailCell = {
    let appBundlePathCell = ApplicationDetailCell()
    appBundlePathCell.contentView.tag = 2
    return appBundlePathCell
  }()
  
  private lazy var appDataPathCell: ApplicationDetailCell = {
    let appDataPathCell = ApplicationDetailCell()
    appDataPathCell.contentView.tag = 3
    return appDataPathCell
  }()
  
  private lazy var headerTitleList: [String] = {
    let headerTitleList = [
      "应用名称",
      "应用包名",
      "应用包路径",
      "应用数据路径"
    ]
    return headerTitleList
  }()
  
  private var clearAppDataCell: CustomButtonCell = {
    let clearAppDataCell = CustomButtonCell(buttonTitle: "清理应用数据", titleColor: UIColor.whiteColor())
    clearAppDataCell.backgroundColor = ThemeManager.Theme.redBackgroundColor
    return clearAppDataCell
  }()
  
  
  override func viewDidLayoutSubviews() {
    appBundlePathCell.scrollView.contentSize.width = appBundlePathCell.titleLabel.mj_textWith()+40
    appDataPathCell.scrollView.contentSize.width = appDataPathCell.titleLabel.mj_textWith()+40
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
  }
  
  init(model: ApplicationListModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
    self.contentSizeInPopup = CGSizeMake(view.frame.width/1.05, view.frame.height/1.5)
    //    self.landscapeContentSizeInPopup = CGSizeMake(view.frame.height/1.5, view.frame.width/1.05)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "应用详情"
    
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
    appNameCell.tap.addTarget(self, action: #selector(pasteboard(_:)))
    appPackageNameCell.tap.addTarget(self, action: #selector(pasteboard(_:)))
    appDataPathCell.tap.addTarget(self, action: #selector(pasteboard(_:)))
    appBundlePathCell.tap.addTarget(self, action: #selector(pasteboard(_:)))
  }
  
  @objc private func pasteboard(tap: UITapGestureRecognizer) {
    let indexPath = NSIndexPath(forRow: 0, inSection: tap.view!.tag)
    tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
    switch indexPath.section {
    case 0: UIPasteboard.generalPasteboard().string = model.name
    case 1: UIPasteboard.generalPasteboard().string = model.packageName
    case 2: UIPasteboard.generalPasteboard().string = model.bundlePath
    case 3: UIPasteboard.generalPasteboard().string = model.dataPath
    default: return
    }
    self.view.showHUD(.Success, text: Constants.Text.copy) { (_) in
      self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }
}

extension ApplicationDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 5
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      appNameCell.bind(model.name)
      return appNameCell
    case 1:
      appPackageNameCell.bind(model.packageName)
      return appPackageNameCell
    case 2:
      appBundlePathCell.bind(model.bundlePath)
      return appBundlePathCell
    case 3:
      appDataPathCell.bind(model.dataPath)
      return appDataPathCell
    case 4: return clearAppDataCell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    case 4:
      self.alertShowTwoButton(message: "是否确定要清理？", cancelHandler: { [weak self] (_) in
        guard let `self` = self else { return }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }, otherHandler: { [weak self] (_) in
          guard let `self` = self else { return }
          self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
          self.clearAppData()
        })
    default: break
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Sizer.valueForDevice(phone: 30, pad: 50)
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Sizer.valueForDevice(phone: 45, pad: 65)
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if UIDevice.isPad {
      return nil
    } else {
      if section == 4 {
        return nil
      }
      return headerTitleList[section]
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if UIDevice.isPad {
      if section == 4 {
        return nil
      }
      return CustomHeaderOrFooter(title: headerTitleList[section], textColor: UIColor.grayColor(), font: UIFont.systemFontOfSize(18), alignment: .Left)
    } else {
      return nil
    }
  }
}

extension ApplicationDetailViewController {
  func clearAppData() {
    self.view.showHUD(text: "正在清除")
    Service.clearAppData(bid: model.packageName) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.view.showHUD(.Success, text: "清除成功")
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      //      if error != nil {
      //        self.view.updateHUD(Constants.Error.failure)
      //        MixC.sharedManager.restart { (_) in
      //          self.clearAppData()
      //        }
      //      }
    }
  }
}
