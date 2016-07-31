//
//  KeyFuncListViewController.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/28.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class KeyFuncListViewController: UIViewController {
  var funcCompletionHandler = FuncCompletionHandler()
  
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private var list = [JSON]()
  
  init(funcCompletionHandler: FuncCompletionHandler) {
    self.funcCompletionHandler = funcCompletionHandler
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    bind()
  }
  
  private func setupUI() {
    navigationItem.title = "按键选择"
    view.backgroundColor = UIColor.whiteColor()
    
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
    self.list = JsManager.sharedManager.getKeyList()
  }
}

extension KeyFuncListViewController: UITableViewDelegate, UITableViewDataSource {
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
    let id = self.list[indexPath.section]["id"].stringValue
    let code = JsManager.sharedManager.getCustomFunction(self.funcCompletionHandler.id, models: [[:]], keyid: id)
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
