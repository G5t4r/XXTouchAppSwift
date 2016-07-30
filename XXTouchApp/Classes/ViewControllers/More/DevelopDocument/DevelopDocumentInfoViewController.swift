//
//  DevelopDocumentInfoViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/13.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class DevelopDocumentInfoViewController: UIViewController {
  private enum Section: Int, Countable {
    case Safari
  }
  
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private let toSafariCell = CustomLabelCell(title: "跳转到Safari", backgroundColor: ThemeManager.Theme.redBackgroundColor, titleColor: UIColor.whiteColor())
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.contentSizeInPopup = CGSize(width: view.frame.width/1.05, height: Sizer.valueForDevice(phone: 55, pad: 64))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
  }
  
  private func setupUI() {
    navigationItem.title = "开发文档"
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
}

extension DevelopDocumentInfoViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return Section.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return toSafariCell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    UIApplication.sharedApplication().openURL(NSURL(string: Service.developDocument())!)
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
