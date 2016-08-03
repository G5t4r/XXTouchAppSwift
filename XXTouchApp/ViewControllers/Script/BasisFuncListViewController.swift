//
//  BasisFuncListViewController.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/28.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class BasisFuncListViewController: UIViewController {
  var funcCompletionHandler = FuncCompletionHandler()
  weak var delegate: ExtensionFuncListViewControllerDelegate?
  
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private var list = [JSON]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    bind()
  }
  
  private func setupUI() {
    navigationItem.title = "代码片段"
    view.backgroundColor = UIColor.whiteColor()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(dismiss))
    
    tableView.delegate  = self
    tableView.dataSource = self
    tableView.showsVerticalScrollIndicator = false
    tableView.registerClass(CustomOneLabelCell.self, forCellReuseIdentifier: NSStringFromClass(CustomOneLabelCell))
    
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
    self.list = JsManager.sharedManager.getSnippetList()
  }
  
  @objc private func dismiss() {
    delegate?.becomeFirstResponderToTextView()
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension BasisFuncListViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.list.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(CustomOneLabelCell), forIndexPath: indexPath) as! CustomOneLabelCell
    cell.bind(self.list[indexPath.section])
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let code = self.list[indexPath.section]["content"].stringValue
    self.funcCompletionHandler.completionHandler?(code)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 5
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Sizer.valueForDevice(phone: 45, pad: 55)
  }
}
