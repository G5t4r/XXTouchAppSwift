//
//  ApplicationListViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ApplicationListViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Plain)
  private var appList = [ApplicationListModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    fetchBundles()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "应用列表"
    
    tableView.delegate  = self
    tableView.dataSource = self
    tableView.registerClass(ApplicationListCell.self, forCellReuseIdentifier: NSStringFromClass(ApplicationListCell))
    tableView.separatorStyle = .None
    
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

// 请求
extension ApplicationListViewController {
  private func fetchBundles() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.bundles, timeout:Constants.Timeout.dataRequest)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          let list = json["data"]
          for item in list.dictionaryValue {
            let model = ApplicationListModel(item.1, packageName: item.0)
            self.appList.append(model)
          }
        default:break
        }
        self.tableView.reloadData()
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
}

extension ApplicationListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return appList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ApplicationListCell), forIndexPath: indexPath) as! ApplicationListCell
    cell.bind(appList[indexPath.row])
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let applicationDetailViewController = ApplicationDetailViewController(model: appList[indexPath.row])
    self.navigationController?.pushViewController(applicationDetailViewController, animated: true)
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }
}
