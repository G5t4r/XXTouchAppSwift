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
  private let appNameCell = ApplicationDetailCell()
  private let appPackageNameCell = ApplicationDetailCell()
  private let appDataPathCell = ApplicationDetailCell()
  private let appBundlePathCell = ApplicationDetailCell()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
  }
  
  init(model: ApplicationListModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "应用详情"
    
    tableView.delegate  = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 45
    
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

extension ApplicationDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 4
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
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    case 0: UIPasteboard.generalPasteboard().string = model.name
    case 1: UIPasteboard.generalPasteboard().string = model.packageName
    case 2: UIPasteboard.generalPasteboard().string = model.bundlePath
    case 3: UIPasteboard.generalPasteboard().string = model.dataPath
    default: break
    }
    self.view.showHUD(.Message, text: Constants.Text.copy, autoHide: true, autoHideDelay: 0.7)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 2:
      return 80
    case 3:
      return 80
    default: return 45
    }
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0: return "应用名称"
    case 1: return "应用包名"
    case 2: return "应用包路径"
    case 3: return "应用数据路径"
    default: return nil
    }
  }
}
