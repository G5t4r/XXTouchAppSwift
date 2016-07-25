//
//  ExtensionFuncListViewController.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/25.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ExtensionFuncListViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private var list = [JSON]()
  
  enum FuncListType {
    case Pos
    case Bid
    case MPos
    case Key
    
    var title: String {
      switch self {
      case .Pos: return "pos"
      case .Bid: return "bid"
      case .MPos: return "mpos"
      case .Key: return "key"
      }
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
    navigationItem.title = "扩展函数列表"
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
    //    print(JsManager.sharedManager.getCustomFunction("touch.on", colorList: PosColorListModel(x: 100, y: 200, color: 0xffffff)))
  }
  
  @objc private func dismiss() {
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
    let args = self.list[indexPath.section]["args"].arrayValue
    let type = self.list[indexPath.section]["args"][0]["type"].stringValue
    switch type {
      //    case FuncListType.Pos.title:
      //    case FuncListType.Bid.title:
      
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
