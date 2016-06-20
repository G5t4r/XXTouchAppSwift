//
//  UserSettingViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/20.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "用户偏好设置"
    
//    tableView.delegate  = self
//    tableView.dataSource = self
    
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

//extension UserSettingViewController: UITableViewDelegate, UITableViewDataSource {
//  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    return 4
//  }
//  
//  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 1
//  }
//  
//  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    
//  }
//  
//  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    
//  }
//  
//  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    return 40
//  }
//  
//  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return 30
//  }
//  
//  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//    return 0.01
//  }
//}
