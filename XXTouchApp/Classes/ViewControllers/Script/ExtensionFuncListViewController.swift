//
//  ExtensionFuncListViewController.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/25.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit
import CoreLocation
import MobileCoreServices

protocol ExtensionFuncListViewControllerDelegate: NSObjectProtocol {
  func becomeFirstResponderToTextView()
}

class ExtensionFuncListViewController: UIViewController {
  var funcCompletionHandler = FuncCompletionHandler()
  weak var delegate: ExtensionFuncListViewControllerDelegate?
  
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private var list = [JSON]()
  
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
    bind()
  }
  
  private func setupUI() {
    navigationItem.title = "扩展函数"
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
    self.list = JsManager.sharedManager.getFuncList()
  }
  
  @objc private func dismiss() {
    delegate?.becomeFirstResponderToTextView()
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension ExtensionFuncListViewController: UITableViewDelegate, UITableViewDataSource {
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
    self.funcCompletionHandler.titleNames.removeAll()
    let type = self.list[indexPath.section]["args"][0]["type"].stringValue
    self.funcCompletionHandler.id = self.list[indexPath.section]["id"].stringValue
    for args in self.list[indexPath.section]["args"].arrayValue {
      self.funcCompletionHandler.titleNames.append(args["title"].stringValue)
    }
    switch type {
    case FuncListType.Pos.title:
      let viewController = PhotoBrowsingViewController(funcCompletionHandler: self.funcCompletionHandler)
      self.navigationController?.pushViewController(viewController, animated: true)
    case FuncListType.Bid.title:
      let viewController = ApplicationListViewController(type: .Bid, funcCompletionHandler: self.funcCompletionHandler)
      self.navigationController?.pushViewController(viewController, animated: true)
    case FuncListType.Key.title:
      let viewController = KeyFuncListViewController(funcCompletionHandler: self.funcCompletionHandler)
      self.navigationController?.pushViewController(viewController, animated: true)
      
    //    case FuncListType.MPos.title:
    default: break
    }
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
