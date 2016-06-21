//
//  StartUpSettingViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/20.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class StartUpSettingViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private var scriptList = [ScriptModel]()
  private var currentSelectedScriptName = ""
  
  private lazy var startUpCell: StartUpCell = {
    let startUpCell = StartUpCell(title: "开机启动", info: "开机启动脚本可能是一个危险的操作，例如脚本本身会重启设备，那么将会出现开机之后脚本将设备再次重启的情况，这种情况需要按音量键-键启动设备并删除自启动的脚本")
    return startUpCell
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    getStartupConf()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "开机启动设置"
    
    tableView.registerClass(StartUpListCell.self, forCellReuseIdentifier: NSStringFromClass(StartUpListCell))
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .None
    
    view.addSubview(tableView)
  }
  
  private func makeConstriants() {
    tableView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    startUpCell.switches.addTarget(self, action: #selector(startUpValueChanged(_:)), forControlEvents: .ValueChanged)
  }
}

/// Action
extension StartUpSettingViewController {
  @objc private func startUpValueChanged(switchState: UISwitch) {
    if switchState.on {
      setStartupRun(ServiceURL.Url.setStartupRunOn)
      startUpCell.updataInfoColor(UIColor.redColor())
    } else {
      setStartupRun(ServiceURL.Url.setStartupRunOff)
      startUpCell.updataInfoColor(ThemeManager.Theme.lightTextColor)
    }
  }
}

/// 请求
extension StartUpSettingViewController {
  private func getStartupConf() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.getStartupConf, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue { 
        case 0:
          self.startUpCell.switches.on = json["data"]["startup_run"].boolValue
          if self.startUpCell.switches.on {
            self.startUpCell.updataInfoColor(UIColor.redColor())
          }
          self.currentSelectedScriptName = json["data"]["startup_script"].stringValue
          self.fetchScriptList()
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  
  private func fetchScriptList() {
    let request = Network.sharedManager.post(url: ServiceURL.Url.getFileList, timeout:Constants.Timeout.dataRequest, parameters: ["directory":"lua/scripts/"])
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        self.scriptList.removeAll()
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          let list = json["data"]["list"]
          for item in list.dictionaryValue {
            if item.1["mode"].stringValue != "directory" {
              let model = ScriptModel(item.1, name: item.0)
              self.scriptList.append(model)
            }
          }
        default:break
        }
        self.scriptList.sortInPlace({ $0.time > $1.time })
        self.tableView.reloadData()
        
        for cell in self.tableView.visibleCells {
          if cell is StartUpListCell {
            let cell = cell as! StartUpListCell
            if let indexPath = self.tableView.indexPathForCell(cell) {
              if self.currentSelectedScriptName == self.scriptList[indexPath.row].name {
                self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Bottom)
                cell.scriptSelectedHidden(false)
                cell.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
                let model = self.scriptList[indexPath.row]
                model.isSelected = true
                break
              }
            }
          }
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func setStartupRun(url: String) {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: url, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:break
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func selectStartupScriptFile(name: String) {
    let request = Network.sharedManager.post(url: ServiceURL.Url.selectStartupScriptFile, timeout:Constants.Timeout.request, parameters: ["filename":name])
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:break
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
}

extension StartUpSettingViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:return 1
    default:return scriptList.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return startUpCell
    case 1:
      let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(StartUpListCell), forIndexPath: indexPath) as! StartUpListCell
      cell.bind(scriptList[indexPath.row])
      
      let isSelected = scriptList[indexPath.row].isSelected
      cell.scriptSelectedHidden(!isSelected)
      if isSelected {
        cell.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
      } else {
        cell.backgroundColor = UIColor.whiteColor()
      }
      return cell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    case 1:
      for cell in tableView.visibleCells {
        if cell is StartUpListCell {
          let cell = cell as! StartUpListCell
          cell.scriptSelectedHidden(true)
          cell.backgroundColor = UIColor.whiteColor()
        }
      }
      for model in scriptList {
        model.isSelected = false
      }
      
      let cell = tableView.cellForRowAtIndexPath(indexPath) as! StartUpListCell
      cell.scriptSelectedHidden(false)
      let model = scriptList[indexPath.row]
      model.isSelected = true
      cell.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
      selectStartupScriptFile(scriptList[indexPath.row].name)
      
    default:break
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0: return 120
    default: return 52
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 1: return 30
    default: return 0.01
    }
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 1: return "选择需要开机启动的脚本"
    default: return nil
    }
    
  }
}
